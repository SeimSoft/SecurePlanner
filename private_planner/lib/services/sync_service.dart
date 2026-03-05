import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:private_planner/data/database.dart';
import 'package:private_planner/services/auth_service.dart';
import 'package:private_planner/services/encryption_service.dart';
import 'package:private_planner/providers/database_provider.dart';

final syncServiceProvider = Provider((ref) => SyncService(ref));

class SyncService {
  final Ref _ref;

  SyncService(this._ref);

  AppDatabase get _db => _ref.read(databaseProvider);
  AuthService get _auth => _ref.read(authServiceProvider);
  EncryptionService get _encryption => _ref.read(encryptionServiceProvider);

  Future<void> sync() async {
    final baseUrl = _auth.baseUrl;
    if (baseUrl == null) return;

    // 1. Sync Categories (Local-only categories are not sent)
    await _syncCategories();

    // 2. Sync Todos
    await _syncTodos();

    // 3. Sync Comments
    await _syncComments();
  }

  Future<void> _syncCategories() async {
    // Get local categories that should sync
    final localCats = await _db.select(_db.categories).get();
    final toSync = localCats.where((c) => c.syncToServer).toList();

    // Push local
    for (var cat in toSync) {
      await _ref.read(dioProvider).post(
            '${_auth.baseUrl}/categories',
            data: cat.toJson(),
          );
    }

    // Pull remote
    final response =
        await _ref.read(dioProvider).get('${_auth.baseUrl}/categories');
    if (response.statusCode == 200) {
      final remoteCats =
          (response.data as List).map((e) => Category.fromJson(e)).toList();
      for (var remote in remoteCats) {
        // Upsert remote (always set syncToServer to true since it came from server)
        await _db
            .into(_db.categories)
            .insertOnConflictUpdate(remote.copyWith(syncToServer: true));
      }
    }
  }

  Future<void> _syncTodos() async {
    // Get categories to know which ones are local-only
    final cats = await _db.select(_db.categories).get();
    final localOnlyCatIds =
        cats.where((c) => !c.syncToServer).map((c) => c.id).toSet();

    // Pull remote first to resolve conflicts
    final response = await _ref.read(dioProvider).get('${_auth.baseUrl}/todos');
    if (response.statusCode == 200) {
      final remoteTodos =
          (response.data as List).map((e) => Todo.fromJson(e)).toList();
      for (var remote in remoteTodos) {
        // If it's remote, it shouldn't be associated with a local-only category
        // But we just upsert it.
        await _db.into(_db.todos).insertOnConflictUpdate(remote);
      }
    }

    // Push local (excluding local-only category todos)
    final allLocalTodos = await _db.select(_db.todos).get();
    final toPush = allLocalTodos.where((t) {
      if (t.categoryId != null && localOnlyCatIds.contains(t.categoryId!)) {
        return false;
      }
      return true;
    }).toList();

    if (toPush.isNotEmpty) {
      await _ref.read(dioProvider).post(
            '${_auth.baseUrl}/todos/sync',
            data: toPush.map((e) => e.toJson()).toList(),
          );
    }
  }

  Future<void> _syncComments() async {
    // Implementation for comments sync (similar pattern)
    // TODO: Implement comments sync filtering by local-only categories
  }
}

final dioProvider = Provider((ref) {
  final dio = Dio();
  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) async {
      final token = await ref.read(authServiceProvider).authToken;
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
      return handler.next(options);
    },
  ));
  return dio;
});
