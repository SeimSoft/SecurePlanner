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
    final cats = await _db.select(_db.categories).get();
    final localOnlyCatIds =
        cats.where((c) => !c.syncToServer).map((c) => c.id).toSet();

    // In a real app, retrieve user's encryption password from settings
    final encryptionKey = await _encryption.deriveKey(
        "test-password", _encryption.generateSalt("test-salt"));

    // Pull remote
    final pullResponse =
        await _ref.read(dioProvider).get('${_auth.baseUrl}/todos');
    if (pullResponse.statusCode == 200) {
      for (var data in (pullResponse.data as List)) {
        final encryptedBlob = data['encrypted_blob'] as String;
        final decrypted =
            await _encryption.decrypt(encryptedBlob, encryptionKey);

        if (decrypted != null) {
          final fields = Uri.splitQueryString(decrypted);
          await _db.into(_db.todos).insertOnConflictUpdate(Todo(
                id: data['id'],
                title: fields['title'],
                priority: int.tryParse(fields['priority'] ?? '0') ?? 0,
                timeEstimate: fields['time_estimate'],
                dueDate: fields['due_date'] != null
                    ? DateTime.tryParse(fields['due_date']!)
                    : null,
                encryptedBlob: encryptedBlob,
                version: data['version'],
                updatedAt: DateTime.parse(data['updated_at']),
                categoryId: data['category_id'],
                ownerId: data['owner_id'] ?? '',
                status: data['status'] ?? 'Backlog',
                deleted: data['deleted'] ?? false,
              ));
        }
      }
    }

    // Push local
    final allLocalTodos = await _db.select(_db.todos).get();
    final toPush = <Map<String, dynamic>>[];
    for (var t in allLocalTodos) {
      if (t.categoryId != null && localOnlyCatIds.contains(t.categoryId!))
        continue;

      final fields = {
        'title': t.title ?? '',
        'priority': t.priority.toString(),
        'time_estimate': t.timeEstimate ?? '',
        'due_date': t.dueDate?.toIso8601String() ?? '',
      };
      final plainText = fields.entries
          .map((e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');
      final encrypted = await _encryption.encrypt(plainText, encryptionKey);

      toPush.add({
        'id': t.id,
        'category_id': t.categoryId,
        'status': t.status,
        'encrypted_blob': encrypted,
        'version': t.version,
        'updated_at': t.updatedAt.toIso8601String(),
      });
    }

    if (toPush.isNotEmpty) {
      await _ref
          .read(dioProvider)
          .post('${_auth.baseUrl}/todos/sync', data: toPush); }
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
