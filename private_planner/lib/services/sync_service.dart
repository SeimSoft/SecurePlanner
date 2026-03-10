import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:private_planner/data/database.dart';
import 'package:private_planner/services/auth_service.dart';
import 'package:private_planner/services/encryption_service.dart';
import 'package:private_planner/services/security_service.dart';
import 'package:private_planner/services/api_provider.dart';
import 'package:private_planner/providers/database_provider.dart';
import 'package:cryptography/cryptography.dart';

final syncServiceProvider = Provider<SyncService>((ref) => SyncService(ref));

class SyncService {
  final Ref _ref;

  SyncService(this._ref);

  AppDatabase get _db => _ref.read(databaseProvider);
  AuthService get _auth => _ref.read(authServiceProvider);
  EncryptionService get _encryption => _ref.read(encryptionServiceProvider);
  SecurityService get _security => _ref.read(securityServiceProvider);
  Dio get _dio => _ref.read(authenticatedDioProvider);

  Future<void> sync() async {
    final baseUrl = _auth.baseUrl;
    if (baseUrl == null) return;

    await _syncHouseholdMembers();
    await _syncCategories();
    await _syncTodos();
    await _syncComments();
  }

  Future<void> _syncHouseholdMembers() async {
    final response = await _dio.get('${_auth.baseUrl}/household/members');
    if (response.statusCode == 200) {
      final members = response.data as List;
      for (var member in members) {
        await _db.into(_db.users).insertOnConflictUpdate(User(
              id: member['id'],
              username: member['username'],
              profilePicturePath: member['profile_picture_path'],
            ));
      }
    }
  }

  Future<void> _syncCategories() async {
    final localCats = await _db.select(_db.categories).get();
    final toSync = localCats.where((c) => c.syncToServer).toList();

    for (var cat in toSync) {
      await _dio.post(
        '${_auth.baseUrl}/categories',
        data: {
          'id': cat.id,
          'user_id': cat.ownerId ?? 0,
          'encrypted_name': cat.encryptedBlob ?? '',
          'shared_with_household': cat.sharedWithHousehold,
        },
      );
    }

    final response = await _dio.get('${_auth.baseUrl}/categories');
    if (response.statusCode == 200) {
      for (var remote in response.data as List) {
        await _db.into(_db.categories).insertOnConflictUpdate(Category(
              id: remote['id'],
              ownerId: remote['user_id'],
              encryptedBlob: remote['encrypted_name'],
              sharedWithHousehold: remote['shared_with_household'] ?? false,
              syncToServer: true,
              isShared: remote['shared_with_household'] ?? false,
              deleted: false,
              version: 1,
              updatedAt:
                  DateTime.tryParse(remote['created_at']) ?? DateTime.now(),
            ));
      }
    }
  }

  Future<void> _syncTodos() async {
    final cats = await _db.select(_db.categories).get();
    final localOnlyCatIds =
        cats.where((c) => !c.syncToServer).map((c) => c.id).toSet();

    final keyBytes = await _security.getMasterKey();
    if (keyBytes == null) return;
    final encryptionKey = SecretKey(keyBytes);

    final pullResponse = await _dio.get('${_auth.baseUrl}/todos');
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
                ownerId: data['owner_id'] ?? 0,
                status: data['status'] ?? 'Backlog',
                deleted: data['deleted'] ?? false,
              ));
        }
      }
    }

    final allLocalTodos = await _db.select(_db.todos).get();
    final toPush = <Map<String, dynamic>>[];
    for (var t in allLocalTodos) {
      if (t.categoryId != null && localOnlyCatIds.contains(t.categoryId!)) {
        continue;
      }

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
      await _dio.post('${_auth.baseUrl}/todos/sync', data: toPush);
    }
  }

  Future<void> _syncComments() async {
    // TODO: Implement
  }
}
