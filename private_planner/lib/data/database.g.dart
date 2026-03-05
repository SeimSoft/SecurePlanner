// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, Category> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
      'color', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _syncToServerMeta =
      const VerificationMeta('syncToServer');
  @override
  late final GeneratedColumn<bool> syncToServer = GeneratedColumn<bool>(
      'sync_to_server', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("sync_to_server" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _isSharedMeta =
      const VerificationMeta('isShared');
  @override
  late final GeneratedColumn<bool> isShared = GeneratedColumn<bool>(
      'is_shared', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_shared" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _ownerIdMeta =
      const VerificationMeta('ownerId');
  @override
  late final GeneratedColumn<int> ownerId = GeneratedColumn<int>(
      'owner_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _encryptedBlobMeta =
      const VerificationMeta('encryptedBlob');
  @override
  late final GeneratedColumn<String> encryptedBlob = GeneratedColumn<String>(
      'encrypted_blob', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _versionMeta =
      const VerificationMeta('version');
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
      'version', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _deletedMeta =
      const VerificationMeta('deleted');
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
      'deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        color,
        syncToServer,
        isShared,
        ownerId,
        encryptedBlob,
        version,
        deleted,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(Insertable<Category> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    }
    if (data.containsKey('color')) {
      context.handle(
          _colorMeta, color.isAcceptableOrUnknown(data['color']!, _colorMeta));
    }
    if (data.containsKey('sync_to_server')) {
      context.handle(
          _syncToServerMeta,
          syncToServer.isAcceptableOrUnknown(
              data['sync_to_server']!, _syncToServerMeta));
    }
    if (data.containsKey('is_shared')) {
      context.handle(_isSharedMeta,
          isShared.isAcceptableOrUnknown(data['is_shared']!, _isSharedMeta));
    }
    if (data.containsKey('owner_id')) {
      context.handle(_ownerIdMeta,
          ownerId.isAcceptableOrUnknown(data['owner_id']!, _ownerIdMeta));
    }
    if (data.containsKey('encrypted_blob')) {
      context.handle(
          _encryptedBlobMeta,
          encryptedBlob.isAcceptableOrUnknown(
              data['encrypted_blob']!, _encryptedBlobMeta));
    }
    if (data.containsKey('version')) {
      context.handle(_versionMeta,
          version.isAcceptableOrUnknown(data['version']!, _versionMeta));
    }
    if (data.containsKey('deleted')) {
      context.handle(_deletedMeta,
          deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Category map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Category(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name']),
      color: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}color']),
      syncToServer: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}sync_to_server'])!,
      isShared: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_shared'])!,
      ownerId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}owner_id']),
      encryptedBlob: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}encrypted_blob']),
      version: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}version'])!,
      deleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}deleted'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }
}

class Category extends DataClass implements Insertable<Category> {
  final String id;
  final String? name;
  final String? color;
  final bool syncToServer;
  final bool isShared;
  final int? ownerId;
  final String? encryptedBlob;
  final int version;
  final bool deleted;
  final DateTime updatedAt;
  const Category(
      {required this.id,
      this.name,
      this.color,
      required this.syncToServer,
      required this.isShared,
      this.ownerId,
      this.encryptedBlob,
      required this.version,
      required this.deleted,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || color != null) {
      map['color'] = Variable<String>(color);
    }
    map['sync_to_server'] = Variable<bool>(syncToServer);
    map['is_shared'] = Variable<bool>(isShared);
    if (!nullToAbsent || ownerId != null) {
      map['owner_id'] = Variable<int>(ownerId);
    }
    if (!nullToAbsent || encryptedBlob != null) {
      map['encrypted_blob'] = Variable<String>(encryptedBlob);
    }
    map['version'] = Variable<int>(version);
    map['deleted'] = Variable<bool>(deleted);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      color:
          color == null && nullToAbsent ? const Value.absent() : Value(color),
      syncToServer: Value(syncToServer),
      isShared: Value(isShared),
      ownerId: ownerId == null && nullToAbsent
          ? const Value.absent()
          : Value(ownerId),
      encryptedBlob: encryptedBlob == null && nullToAbsent
          ? const Value.absent()
          : Value(encryptedBlob),
      version: Value(version),
      deleted: Value(deleted),
      updatedAt: Value(updatedAt),
    );
  }

  factory Category.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Category(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String?>(json['name']),
      color: serializer.fromJson<String?>(json['color']),
      syncToServer: serializer.fromJson<bool>(json['syncToServer']),
      isShared: serializer.fromJson<bool>(json['isShared']),
      ownerId: serializer.fromJson<int?>(json['ownerId']),
      encryptedBlob: serializer.fromJson<String?>(json['encryptedBlob']),
      version: serializer.fromJson<int>(json['version']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String?>(name),
      'color': serializer.toJson<String?>(color),
      'syncToServer': serializer.toJson<bool>(syncToServer),
      'isShared': serializer.toJson<bool>(isShared),
      'ownerId': serializer.toJson<int?>(ownerId),
      'encryptedBlob': serializer.toJson<String?>(encryptedBlob),
      'version': serializer.toJson<int>(version),
      'deleted': serializer.toJson<bool>(deleted),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Category copyWith(
          {String? id,
          Value<String?> name = const Value.absent(),
          Value<String?> color = const Value.absent(),
          bool? syncToServer,
          bool? isShared,
          Value<int?> ownerId = const Value.absent(),
          Value<String?> encryptedBlob = const Value.absent(),
          int? version,
          bool? deleted,
          DateTime? updatedAt}) =>
      Category(
        id: id ?? this.id,
        name: name.present ? name.value : this.name,
        color: color.present ? color.value : this.color,
        syncToServer: syncToServer ?? this.syncToServer,
        isShared: isShared ?? this.isShared,
        ownerId: ownerId.present ? ownerId.value : this.ownerId,
        encryptedBlob:
            encryptedBlob.present ? encryptedBlob.value : this.encryptedBlob,
        version: version ?? this.version,
        deleted: deleted ?? this.deleted,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Category copyWithCompanion(CategoriesCompanion data) {
    return Category(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      color: data.color.present ? data.color.value : this.color,
      syncToServer: data.syncToServer.present
          ? data.syncToServer.value
          : this.syncToServer,
      isShared: data.isShared.present ? data.isShared.value : this.isShared,
      ownerId: data.ownerId.present ? data.ownerId.value : this.ownerId,
      encryptedBlob: data.encryptedBlob.present
          ? data.encryptedBlob.value
          : this.encryptedBlob,
      version: data.version.present ? data.version.value : this.version,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Category(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('color: $color, ')
          ..write('syncToServer: $syncToServer, ')
          ..write('isShared: $isShared, ')
          ..write('ownerId: $ownerId, ')
          ..write('encryptedBlob: $encryptedBlob, ')
          ..write('version: $version, ')
          ..write('deleted: $deleted, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, color, syncToServer, isShared,
      ownerId, encryptedBlob, version, deleted, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Category &&
          other.id == this.id &&
          other.name == this.name &&
          other.color == this.color &&
          other.syncToServer == this.syncToServer &&
          other.isShared == this.isShared &&
          other.ownerId == this.ownerId &&
          other.encryptedBlob == this.encryptedBlob &&
          other.version == this.version &&
          other.deleted == this.deleted &&
          other.updatedAt == this.updatedAt);
}

class CategoriesCompanion extends UpdateCompanion<Category> {
  final Value<String> id;
  final Value<String?> name;
  final Value<String?> color;
  final Value<bool> syncToServer;
  final Value<bool> isShared;
  final Value<int?> ownerId;
  final Value<String?> encryptedBlob;
  final Value<int> version;
  final Value<bool> deleted;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.color = const Value.absent(),
    this.syncToServer = const Value.absent(),
    this.isShared = const Value.absent(),
    this.ownerId = const Value.absent(),
    this.encryptedBlob = const Value.absent(),
    this.version = const Value.absent(),
    this.deleted = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CategoriesCompanion.insert({
    required String id,
    this.name = const Value.absent(),
    this.color = const Value.absent(),
    this.syncToServer = const Value.absent(),
    this.isShared = const Value.absent(),
    this.ownerId = const Value.absent(),
    this.encryptedBlob = const Value.absent(),
    this.version = const Value.absent(),
    this.deleted = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id);
  static Insertable<Category> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? color,
    Expression<bool>? syncToServer,
    Expression<bool>? isShared,
    Expression<int>? ownerId,
    Expression<String>? encryptedBlob,
    Expression<int>? version,
    Expression<bool>? deleted,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (color != null) 'color': color,
      if (syncToServer != null) 'sync_to_server': syncToServer,
      if (isShared != null) 'is_shared': isShared,
      if (ownerId != null) 'owner_id': ownerId,
      if (encryptedBlob != null) 'encrypted_blob': encryptedBlob,
      if (version != null) 'version': version,
      if (deleted != null) 'deleted': deleted,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CategoriesCompanion copyWith(
      {Value<String>? id,
      Value<String?>? name,
      Value<String?>? color,
      Value<bool>? syncToServer,
      Value<bool>? isShared,
      Value<int?>? ownerId,
      Value<String?>? encryptedBlob,
      Value<int>? version,
      Value<bool>? deleted,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return CategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      syncToServer: syncToServer ?? this.syncToServer,
      isShared: isShared ?? this.isShared,
      ownerId: ownerId ?? this.ownerId,
      encryptedBlob: encryptedBlob ?? this.encryptedBlob,
      version: version ?? this.version,
      deleted: deleted ?? this.deleted,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (syncToServer.present) {
      map['sync_to_server'] = Variable<bool>(syncToServer.value);
    }
    if (isShared.present) {
      map['is_shared'] = Variable<bool>(isShared.value);
    }
    if (ownerId.present) {
      map['owner_id'] = Variable<int>(ownerId.value);
    }
    if (encryptedBlob.present) {
      map['encrypted_blob'] = Variable<String>(encryptedBlob.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('color: $color, ')
          ..write('syncToServer: $syncToServer, ')
          ..write('isShared: $isShared, ')
          ..write('ownerId: $ownerId, ')
          ..write('encryptedBlob: $encryptedBlob, ')
          ..write('version: $version, ')
          ..write('deleted: $deleted, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TodosTable extends Todos with TableInfo<$TodosTable, Todo> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TodosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _priorityMeta =
      const VerificationMeta('priority');
  @override
  late final GeneratedColumn<int> priority = GeneratedColumn<int>(
      'priority', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _timeEstimateMeta =
      const VerificationMeta('timeEstimate');
  @override
  late final GeneratedColumn<String> timeEstimate = GeneratedColumn<String>(
      'time_estimate', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _dueDateMeta =
      const VerificationMeta('dueDate');
  @override
  late final GeneratedColumn<DateTime> dueDate = GeneratedColumn<DateTime>(
      'due_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _encryptedBlobMeta =
      const VerificationMeta('encryptedBlob');
  @override
  late final GeneratedColumn<String> encryptedBlob = GeneratedColumn<String>(
      'encrypted_blob', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _versionMeta =
      const VerificationMeta('version');
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
      'version', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _deletedMeta =
      const VerificationMeta('deleted');
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
      'deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _categoryIdMeta =
      const VerificationMeta('categoryId');
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
      'category_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES categories (id)'));
  static const VerificationMeta _ownerIdMeta =
      const VerificationMeta('ownerId');
  @override
  late final GeneratedColumn<int> ownerId = GeneratedColumn<int>(
      'owner_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('Backlog'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        title,
        priority,
        timeEstimate,
        dueDate,
        encryptedBlob,
        version,
        deleted,
        updatedAt,
        categoryId,
        ownerId,
        status
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'todos';
  @override
  VerificationContext validateIntegrity(Insertable<Todo> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    }
    if (data.containsKey('priority')) {
      context.handle(_priorityMeta,
          priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta));
    }
    if (data.containsKey('time_estimate')) {
      context.handle(
          _timeEstimateMeta,
          timeEstimate.isAcceptableOrUnknown(
              data['time_estimate']!, _timeEstimateMeta));
    }
    if (data.containsKey('due_date')) {
      context.handle(_dueDateMeta,
          dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta));
    }
    if (data.containsKey('encrypted_blob')) {
      context.handle(
          _encryptedBlobMeta,
          encryptedBlob.isAcceptableOrUnknown(
              data['encrypted_blob']!, _encryptedBlobMeta));
    } else if (isInserting) {
      context.missing(_encryptedBlobMeta);
    }
    if (data.containsKey('version')) {
      context.handle(_versionMeta,
          version.isAcceptableOrUnknown(data['version']!, _versionMeta));
    }
    if (data.containsKey('deleted')) {
      context.handle(_deletedMeta,
          deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('category_id')) {
      context.handle(
          _categoryIdMeta,
          categoryId.isAcceptableOrUnknown(
              data['category_id']!, _categoryIdMeta));
    }
    if (data.containsKey('owner_id')) {
      context.handle(_ownerIdMeta,
          ownerId.isAcceptableOrUnknown(data['owner_id']!, _ownerIdMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Todo map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Todo(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title']),
      priority: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}priority']),
      timeEstimate: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}time_estimate']),
      dueDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}due_date']),
      encryptedBlob: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}encrypted_blob'])!,
      version: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}version'])!,
      deleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}deleted'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      categoryId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category_id']),
      ownerId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}owner_id']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
    );
  }

  @override
  $TodosTable createAlias(String alias) {
    return $TodosTable(attachedDatabase, alias);
  }
}

class Todo extends DataClass implements Insertable<Todo> {
  final String id;
  final String? title;
  final int? priority;
  final String? timeEstimate;
  final DateTime? dueDate;
  final String encryptedBlob;
  final int version;
  final bool deleted;
  final DateTime updatedAt;
  final String? categoryId;
  final int? ownerId;
  final String status;
  const Todo(
      {required this.id,
      this.title,
      this.priority,
      this.timeEstimate,
      this.dueDate,
      required this.encryptedBlob,
      required this.version,
      required this.deleted,
      required this.updatedAt,
      this.categoryId,
      this.ownerId,
      required this.status});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    if (!nullToAbsent || priority != null) {
      map['priority'] = Variable<int>(priority);
    }
    if (!nullToAbsent || timeEstimate != null) {
      map['time_estimate'] = Variable<String>(timeEstimate);
    }
    if (!nullToAbsent || dueDate != null) {
      map['due_date'] = Variable<DateTime>(dueDate);
    }
    map['encrypted_blob'] = Variable<String>(encryptedBlob);
    map['version'] = Variable<int>(version);
    map['deleted'] = Variable<bool>(deleted);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<String>(categoryId);
    }
    if (!nullToAbsent || ownerId != null) {
      map['owner_id'] = Variable<int>(ownerId);
    }
    map['status'] = Variable<String>(status);
    return map;
  }

  TodosCompanion toCompanion(bool nullToAbsent) {
    return TodosCompanion(
      id: Value(id),
      title:
          title == null && nullToAbsent ? const Value.absent() : Value(title),
      priority: priority == null && nullToAbsent
          ? const Value.absent()
          : Value(priority),
      timeEstimate: timeEstimate == null && nullToAbsent
          ? const Value.absent()
          : Value(timeEstimate),
      dueDate: dueDate == null && nullToAbsent
          ? const Value.absent()
          : Value(dueDate),
      encryptedBlob: Value(encryptedBlob),
      version: Value(version),
      deleted: Value(deleted),
      updatedAt: Value(updatedAt),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      ownerId: ownerId == null && nullToAbsent
          ? const Value.absent()
          : Value(ownerId),
      status: Value(status),
    );
  }

  factory Todo.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Todo(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String?>(json['title']),
      priority: serializer.fromJson<int?>(json['priority']),
      timeEstimate: serializer.fromJson<String?>(json['timeEstimate']),
      dueDate: serializer.fromJson<DateTime?>(json['dueDate']),
      encryptedBlob: serializer.fromJson<String>(json['encryptedBlob']),
      version: serializer.fromJson<int>(json['version']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      categoryId: serializer.fromJson<String?>(json['categoryId']),
      ownerId: serializer.fromJson<int?>(json['ownerId']),
      status: serializer.fromJson<String>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String?>(title),
      'priority': serializer.toJson<int?>(priority),
      'timeEstimate': serializer.toJson<String?>(timeEstimate),
      'dueDate': serializer.toJson<DateTime?>(dueDate),
      'encryptedBlob': serializer.toJson<String>(encryptedBlob),
      'version': serializer.toJson<int>(version),
      'deleted': serializer.toJson<bool>(deleted),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'categoryId': serializer.toJson<String?>(categoryId),
      'ownerId': serializer.toJson<int?>(ownerId),
      'status': serializer.toJson<String>(status),
    };
  }

  Todo copyWith(
          {String? id,
          Value<String?> title = const Value.absent(),
          Value<int?> priority = const Value.absent(),
          Value<String?> timeEstimate = const Value.absent(),
          Value<DateTime?> dueDate = const Value.absent(),
          String? encryptedBlob,
          int? version,
          bool? deleted,
          DateTime? updatedAt,
          Value<String?> categoryId = const Value.absent(),
          Value<int?> ownerId = const Value.absent(),
          String? status}) =>
      Todo(
        id: id ?? this.id,
        title: title.present ? title.value : this.title,
        priority: priority.present ? priority.value : this.priority,
        timeEstimate:
            timeEstimate.present ? timeEstimate.value : this.timeEstimate,
        dueDate: dueDate.present ? dueDate.value : this.dueDate,
        encryptedBlob: encryptedBlob ?? this.encryptedBlob,
        version: version ?? this.version,
        deleted: deleted ?? this.deleted,
        updatedAt: updatedAt ?? this.updatedAt,
        categoryId: categoryId.present ? categoryId.value : this.categoryId,
        ownerId: ownerId.present ? ownerId.value : this.ownerId,
        status: status ?? this.status,
      );
  Todo copyWithCompanion(TodosCompanion data) {
    return Todo(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      priority: data.priority.present ? data.priority.value : this.priority,
      timeEstimate: data.timeEstimate.present
          ? data.timeEstimate.value
          : this.timeEstimate,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      encryptedBlob: data.encryptedBlob.present
          ? data.encryptedBlob.value
          : this.encryptedBlob,
      version: data.version.present ? data.version.value : this.version,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      categoryId:
          data.categoryId.present ? data.categoryId.value : this.categoryId,
      ownerId: data.ownerId.present ? data.ownerId.value : this.ownerId,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Todo(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('priority: $priority, ')
          ..write('timeEstimate: $timeEstimate, ')
          ..write('dueDate: $dueDate, ')
          ..write('encryptedBlob: $encryptedBlob, ')
          ..write('version: $version, ')
          ..write('deleted: $deleted, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('categoryId: $categoryId, ')
          ..write('ownerId: $ownerId, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, priority, timeEstimate, dueDate,
      encryptedBlob, version, deleted, updatedAt, categoryId, ownerId, status);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Todo &&
          other.id == this.id &&
          other.title == this.title &&
          other.priority == this.priority &&
          other.timeEstimate == this.timeEstimate &&
          other.dueDate == this.dueDate &&
          other.encryptedBlob == this.encryptedBlob &&
          other.version == this.version &&
          other.deleted == this.deleted &&
          other.updatedAt == this.updatedAt &&
          other.categoryId == this.categoryId &&
          other.ownerId == this.ownerId &&
          other.status == this.status);
}

class TodosCompanion extends UpdateCompanion<Todo> {
  final Value<String> id;
  final Value<String?> title;
  final Value<int?> priority;
  final Value<String?> timeEstimate;
  final Value<DateTime?> dueDate;
  final Value<String> encryptedBlob;
  final Value<int> version;
  final Value<bool> deleted;
  final Value<DateTime> updatedAt;
  final Value<String?> categoryId;
  final Value<int?> ownerId;
  final Value<String> status;
  final Value<int> rowid;
  const TodosCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.priority = const Value.absent(),
    this.timeEstimate = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.encryptedBlob = const Value.absent(),
    this.version = const Value.absent(),
    this.deleted = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.ownerId = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TodosCompanion.insert({
    required String id,
    this.title = const Value.absent(),
    this.priority = const Value.absent(),
    this.timeEstimate = const Value.absent(),
    this.dueDate = const Value.absent(),
    required String encryptedBlob,
    this.version = const Value.absent(),
    this.deleted = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.ownerId = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        encryptedBlob = Value(encryptedBlob);
  static Insertable<Todo> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<int>? priority,
    Expression<String>? timeEstimate,
    Expression<DateTime>? dueDate,
    Expression<String>? encryptedBlob,
    Expression<int>? version,
    Expression<bool>? deleted,
    Expression<DateTime>? updatedAt,
    Expression<String>? categoryId,
    Expression<int>? ownerId,
    Expression<String>? status,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (priority != null) 'priority': priority,
      if (timeEstimate != null) 'time_estimate': timeEstimate,
      if (dueDate != null) 'due_date': dueDate,
      if (encryptedBlob != null) 'encrypted_blob': encryptedBlob,
      if (version != null) 'version': version,
      if (deleted != null) 'deleted': deleted,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (categoryId != null) 'category_id': categoryId,
      if (ownerId != null) 'owner_id': ownerId,
      if (status != null) 'status': status,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TodosCompanion copyWith(
      {Value<String>? id,
      Value<String?>? title,
      Value<int?>? priority,
      Value<String?>? timeEstimate,
      Value<DateTime?>? dueDate,
      Value<String>? encryptedBlob,
      Value<int>? version,
      Value<bool>? deleted,
      Value<DateTime>? updatedAt,
      Value<String?>? categoryId,
      Value<int?>? ownerId,
      Value<String>? status,
      Value<int>? rowid}) {
    return TodosCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      priority: priority ?? this.priority,
      timeEstimate: timeEstimate ?? this.timeEstimate,
      dueDate: dueDate ?? this.dueDate,
      encryptedBlob: encryptedBlob ?? this.encryptedBlob,
      version: version ?? this.version,
      deleted: deleted ?? this.deleted,
      updatedAt: updatedAt ?? this.updatedAt,
      categoryId: categoryId ?? this.categoryId,
      ownerId: ownerId ?? this.ownerId,
      status: status ?? this.status,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (priority.present) {
      map['priority'] = Variable<int>(priority.value);
    }
    if (timeEstimate.present) {
      map['time_estimate'] = Variable<String>(timeEstimate.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<DateTime>(dueDate.value);
    }
    if (encryptedBlob.present) {
      map['encrypted_blob'] = Variable<String>(encryptedBlob.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (ownerId.present) {
      map['owner_id'] = Variable<int>(ownerId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TodosCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('priority: $priority, ')
          ..write('timeEstimate: $timeEstimate, ')
          ..write('dueDate: $dueDate, ')
          ..write('encryptedBlob: $encryptedBlob, ')
          ..write('version: $version, ')
          ..write('deleted: $deleted, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('categoryId: $categoryId, ')
          ..write('ownerId: $ownerId, ')
          ..write('status: $status, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CategorySharesTable extends CategoryShares
    with TableInfo<$CategorySharesTable, CategoryShare> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategorySharesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoryIdMeta =
      const VerificationMeta('categoryId');
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
      'category_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES categories (id)'));
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _sharedWithUserIdMeta =
      const VerificationMeta('sharedWithUserId');
  @override
  late final GeneratedColumn<int> sharedWithUserId = GeneratedColumn<int>(
      'shared_with_user_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _permissionMeta =
      const VerificationMeta('permission');
  @override
  late final GeneratedColumn<String> permission = GeneratedColumn<String>(
      'permission', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('read'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, categoryId, userId, sharedWithUserId, permission, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'category_shares';
  @override
  VerificationContext validateIntegrity(Insertable<CategoryShare> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
          _categoryIdMeta,
          categoryId.isAcceptableOrUnknown(
              data['category_id']!, _categoryIdMeta));
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('shared_with_user_id')) {
      context.handle(
          _sharedWithUserIdMeta,
          sharedWithUserId.isAcceptableOrUnknown(
              data['shared_with_user_id']!, _sharedWithUserIdMeta));
    } else if (isInserting) {
      context.missing(_sharedWithUserIdMeta);
    }
    if (data.containsKey('permission')) {
      context.handle(
          _permissionMeta,
          permission.isAcceptableOrUnknown(
              data['permission']!, _permissionMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CategoryShare map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CategoryShare(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      categoryId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category_id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}user_id'])!,
      sharedWithUserId: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}shared_with_user_id'])!,
      permission: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}permission'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $CategorySharesTable createAlias(String alias) {
    return $CategorySharesTable(attachedDatabase, alias);
  }
}

class CategoryShare extends DataClass implements Insertable<CategoryShare> {
  final String id;
  final String categoryId;
  final int userId;
  final int sharedWithUserId;
  final String permission;
  final DateTime createdAt;
  const CategoryShare(
      {required this.id,
      required this.categoryId,
      required this.userId,
      required this.sharedWithUserId,
      required this.permission,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['category_id'] = Variable<String>(categoryId);
    map['user_id'] = Variable<int>(userId);
    map['shared_with_user_id'] = Variable<int>(sharedWithUserId);
    map['permission'] = Variable<String>(permission);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CategorySharesCompanion toCompanion(bool nullToAbsent) {
    return CategorySharesCompanion(
      id: Value(id),
      categoryId: Value(categoryId),
      userId: Value(userId),
      sharedWithUserId: Value(sharedWithUserId),
      permission: Value(permission),
      createdAt: Value(createdAt),
    );
  }

  factory CategoryShare.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CategoryShare(
      id: serializer.fromJson<String>(json['id']),
      categoryId: serializer.fromJson<String>(json['categoryId']),
      userId: serializer.fromJson<int>(json['userId']),
      sharedWithUserId: serializer.fromJson<int>(json['sharedWithUserId']),
      permission: serializer.fromJson<String>(json['permission']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'categoryId': serializer.toJson<String>(categoryId),
      'userId': serializer.toJson<int>(userId),
      'sharedWithUserId': serializer.toJson<int>(sharedWithUserId),
      'permission': serializer.toJson<String>(permission),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  CategoryShare copyWith(
          {String? id,
          String? categoryId,
          int? userId,
          int? sharedWithUserId,
          String? permission,
          DateTime? createdAt}) =>
      CategoryShare(
        id: id ?? this.id,
        categoryId: categoryId ?? this.categoryId,
        userId: userId ?? this.userId,
        sharedWithUserId: sharedWithUserId ?? this.sharedWithUserId,
        permission: permission ?? this.permission,
        createdAt: createdAt ?? this.createdAt,
      );
  CategoryShare copyWithCompanion(CategorySharesCompanion data) {
    return CategoryShare(
      id: data.id.present ? data.id.value : this.id,
      categoryId:
          data.categoryId.present ? data.categoryId.value : this.categoryId,
      userId: data.userId.present ? data.userId.value : this.userId,
      sharedWithUserId: data.sharedWithUserId.present
          ? data.sharedWithUserId.value
          : this.sharedWithUserId,
      permission:
          data.permission.present ? data.permission.value : this.permission,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CategoryShare(')
          ..write('id: $id, ')
          ..write('categoryId: $categoryId, ')
          ..write('userId: $userId, ')
          ..write('sharedWithUserId: $sharedWithUserId, ')
          ..write('permission: $permission, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, categoryId, userId, sharedWithUserId, permission, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoryShare &&
          other.id == this.id &&
          other.categoryId == this.categoryId &&
          other.userId == this.userId &&
          other.sharedWithUserId == this.sharedWithUserId &&
          other.permission == this.permission &&
          other.createdAt == this.createdAt);
}

class CategorySharesCompanion extends UpdateCompanion<CategoryShare> {
  final Value<String> id;
  final Value<String> categoryId;
  final Value<int> userId;
  final Value<int> sharedWithUserId;
  final Value<String> permission;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const CategorySharesCompanion({
    this.id = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.userId = const Value.absent(),
    this.sharedWithUserId = const Value.absent(),
    this.permission = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CategorySharesCompanion.insert({
    required String id,
    required String categoryId,
    required int userId,
    required int sharedWithUserId,
    this.permission = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        categoryId = Value(categoryId),
        userId = Value(userId),
        sharedWithUserId = Value(sharedWithUserId);
  static Insertable<CategoryShare> custom({
    Expression<String>? id,
    Expression<String>? categoryId,
    Expression<int>? userId,
    Expression<int>? sharedWithUserId,
    Expression<String>? permission,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (categoryId != null) 'category_id': categoryId,
      if (userId != null) 'user_id': userId,
      if (sharedWithUserId != null) 'shared_with_user_id': sharedWithUserId,
      if (permission != null) 'permission': permission,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CategorySharesCompanion copyWith(
      {Value<String>? id,
      Value<String>? categoryId,
      Value<int>? userId,
      Value<int>? sharedWithUserId,
      Value<String>? permission,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return CategorySharesCompanion(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      userId: userId ?? this.userId,
      sharedWithUserId: sharedWithUserId ?? this.sharedWithUserId,
      permission: permission ?? this.permission,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (sharedWithUserId.present) {
      map['shared_with_user_id'] = Variable<int>(sharedWithUserId.value);
    }
    if (permission.present) {
      map['permission'] = Variable<String>(permission.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategorySharesCompanion(')
          ..write('id: $id, ')
          ..write('categoryId: $categoryId, ')
          ..write('userId: $userId, ')
          ..write('sharedWithUserId: $sharedWithUserId, ')
          ..write('permission: $permission, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CommentsTable extends Comments with TableInfo<$CommentsTable, Comment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CommentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _todoIdMeta = const VerificationMeta('todoId');
  @override
  late final GeneratedColumn<String> todoId = GeneratedColumn<String>(
      'todo_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES todos (id)'));
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _encryptedBlobMeta =
      const VerificationMeta('encryptedBlob');
  @override
  late final GeneratedColumn<String> encryptedBlob = GeneratedColumn<String>(
      'encrypted_blob', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, todoId, userId, encryptedBlob, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'comments';
  @override
  VerificationContext validateIntegrity(Insertable<Comment> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('todo_id')) {
      context.handle(_todoIdMeta,
          todoId.isAcceptableOrUnknown(data['todo_id']!, _todoIdMeta));
    } else if (isInserting) {
      context.missing(_todoIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('encrypted_blob')) {
      context.handle(
          _encryptedBlobMeta,
          encryptedBlob.isAcceptableOrUnknown(
              data['encrypted_blob']!, _encryptedBlobMeta));
    } else if (isInserting) {
      context.missing(_encryptedBlobMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Comment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Comment(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      todoId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}todo_id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}user_id'])!,
      encryptedBlob: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}encrypted_blob'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $CommentsTable createAlias(String alias) {
    return $CommentsTable(attachedDatabase, alias);
  }
}

class Comment extends DataClass implements Insertable<Comment> {
  final String id;
  final String todoId;
  final int userId;
  final String encryptedBlob;
  final DateTime createdAt;
  const Comment(
      {required this.id,
      required this.todoId,
      required this.userId,
      required this.encryptedBlob,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['todo_id'] = Variable<String>(todoId);
    map['user_id'] = Variable<int>(userId);
    map['encrypted_blob'] = Variable<String>(encryptedBlob);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CommentsCompanion toCompanion(bool nullToAbsent) {
    return CommentsCompanion(
      id: Value(id),
      todoId: Value(todoId),
      userId: Value(userId),
      encryptedBlob: Value(encryptedBlob),
      createdAt: Value(createdAt),
    );
  }

  factory Comment.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Comment(
      id: serializer.fromJson<String>(json['id']),
      todoId: serializer.fromJson<String>(json['todoId']),
      userId: serializer.fromJson<int>(json['userId']),
      encryptedBlob: serializer.fromJson<String>(json['encryptedBlob']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'todoId': serializer.toJson<String>(todoId),
      'userId': serializer.toJson<int>(userId),
      'encryptedBlob': serializer.toJson<String>(encryptedBlob),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Comment copyWith(
          {String? id,
          String? todoId,
          int? userId,
          String? encryptedBlob,
          DateTime? createdAt}) =>
      Comment(
        id: id ?? this.id,
        todoId: todoId ?? this.todoId,
        userId: userId ?? this.userId,
        encryptedBlob: encryptedBlob ?? this.encryptedBlob,
        createdAt: createdAt ?? this.createdAt,
      );
  Comment copyWithCompanion(CommentsCompanion data) {
    return Comment(
      id: data.id.present ? data.id.value : this.id,
      todoId: data.todoId.present ? data.todoId.value : this.todoId,
      userId: data.userId.present ? data.userId.value : this.userId,
      encryptedBlob: data.encryptedBlob.present
          ? data.encryptedBlob.value
          : this.encryptedBlob,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Comment(')
          ..write('id: $id, ')
          ..write('todoId: $todoId, ')
          ..write('userId: $userId, ')
          ..write('encryptedBlob: $encryptedBlob, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, todoId, userId, encryptedBlob, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Comment &&
          other.id == this.id &&
          other.todoId == this.todoId &&
          other.userId == this.userId &&
          other.encryptedBlob == this.encryptedBlob &&
          other.createdAt == this.createdAt);
}

class CommentsCompanion extends UpdateCompanion<Comment> {
  final Value<String> id;
  final Value<String> todoId;
  final Value<int> userId;
  final Value<String> encryptedBlob;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const CommentsCompanion({
    this.id = const Value.absent(),
    this.todoId = const Value.absent(),
    this.userId = const Value.absent(),
    this.encryptedBlob = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CommentsCompanion.insert({
    required String id,
    required String todoId,
    required int userId,
    required String encryptedBlob,
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        todoId = Value(todoId),
        userId = Value(userId),
        encryptedBlob = Value(encryptedBlob);
  static Insertable<Comment> custom({
    Expression<String>? id,
    Expression<String>? todoId,
    Expression<int>? userId,
    Expression<String>? encryptedBlob,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (todoId != null) 'todo_id': todoId,
      if (userId != null) 'user_id': userId,
      if (encryptedBlob != null) 'encrypted_blob': encryptedBlob,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CommentsCompanion copyWith(
      {Value<String>? id,
      Value<String>? todoId,
      Value<int>? userId,
      Value<String>? encryptedBlob,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return CommentsCompanion(
      id: id ?? this.id,
      todoId: todoId ?? this.todoId,
      userId: userId ?? this.userId,
      encryptedBlob: encryptedBlob ?? this.encryptedBlob,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (todoId.present) {
      map['todo_id'] = Variable<String>(todoId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (encryptedBlob.present) {
      map['encrypted_blob'] = Variable<String>(encryptedBlob.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CommentsCompanion(')
          ..write('id: $id, ')
          ..write('todoId: $todoId, ')
          ..write('userId: $userId, ')
          ..write('encryptedBlob: $encryptedBlob, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AttachmentsTable extends Attachments
    with TableInfo<$AttachmentsTable, Attachment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AttachmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _todoIdMeta = const VerificationMeta('todoId');
  @override
  late final GeneratedColumn<String> todoId = GeneratedColumn<String>(
      'todo_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES todos (id)'));
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _filePathMeta =
      const VerificationMeta('filePath');
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
      'file_path', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _encryptedNameMeta =
      const VerificationMeta('encryptedName');
  @override
  late final GeneratedColumn<String> encryptedName = GeneratedColumn<String>(
      'encrypted_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, todoId, userId, filePath, encryptedName, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'attachments';
  @override
  VerificationContext validateIntegrity(Insertable<Attachment> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('todo_id')) {
      context.handle(_todoIdMeta,
          todoId.isAcceptableOrUnknown(data['todo_id']!, _todoIdMeta));
    } else if (isInserting) {
      context.missing(_todoIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('file_path')) {
      context.handle(_filePathMeta,
          filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta));
    } else if (isInserting) {
      context.missing(_filePathMeta);
    }
    if (data.containsKey('encrypted_name')) {
      context.handle(
          _encryptedNameMeta,
          encryptedName.isAcceptableOrUnknown(
              data['encrypted_name']!, _encryptedNameMeta));
    } else if (isInserting) {
      context.missing(_encryptedNameMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Attachment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Attachment(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      todoId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}todo_id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}user_id'])!,
      filePath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}file_path'])!,
      encryptedName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}encrypted_name'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $AttachmentsTable createAlias(String alias) {
    return $AttachmentsTable(attachedDatabase, alias);
  }
}

class Attachment extends DataClass implements Insertable<Attachment> {
  final String id;
  final String todoId;
  final int userId;
  final String filePath;
  final String encryptedName;
  final DateTime createdAt;
  const Attachment(
      {required this.id,
      required this.todoId,
      required this.userId,
      required this.filePath,
      required this.encryptedName,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['todo_id'] = Variable<String>(todoId);
    map['user_id'] = Variable<int>(userId);
    map['file_path'] = Variable<String>(filePath);
    map['encrypted_name'] = Variable<String>(encryptedName);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  AttachmentsCompanion toCompanion(bool nullToAbsent) {
    return AttachmentsCompanion(
      id: Value(id),
      todoId: Value(todoId),
      userId: Value(userId),
      filePath: Value(filePath),
      encryptedName: Value(encryptedName),
      createdAt: Value(createdAt),
    );
  }

  factory Attachment.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Attachment(
      id: serializer.fromJson<String>(json['id']),
      todoId: serializer.fromJson<String>(json['todoId']),
      userId: serializer.fromJson<int>(json['userId']),
      filePath: serializer.fromJson<String>(json['filePath']),
      encryptedName: serializer.fromJson<String>(json['encryptedName']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'todoId': serializer.toJson<String>(todoId),
      'userId': serializer.toJson<int>(userId),
      'filePath': serializer.toJson<String>(filePath),
      'encryptedName': serializer.toJson<String>(encryptedName),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Attachment copyWith(
          {String? id,
          String? todoId,
          int? userId,
          String? filePath,
          String? encryptedName,
          DateTime? createdAt}) =>
      Attachment(
        id: id ?? this.id,
        todoId: todoId ?? this.todoId,
        userId: userId ?? this.userId,
        filePath: filePath ?? this.filePath,
        encryptedName: encryptedName ?? this.encryptedName,
        createdAt: createdAt ?? this.createdAt,
      );
  Attachment copyWithCompanion(AttachmentsCompanion data) {
    return Attachment(
      id: data.id.present ? data.id.value : this.id,
      todoId: data.todoId.present ? data.todoId.value : this.todoId,
      userId: data.userId.present ? data.userId.value : this.userId,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      encryptedName: data.encryptedName.present
          ? data.encryptedName.value
          : this.encryptedName,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Attachment(')
          ..write('id: $id, ')
          ..write('todoId: $todoId, ')
          ..write('userId: $userId, ')
          ..write('filePath: $filePath, ')
          ..write('encryptedName: $encryptedName, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, todoId, userId, filePath, encryptedName, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Attachment &&
          other.id == this.id &&
          other.todoId == this.todoId &&
          other.userId == this.userId &&
          other.filePath == this.filePath &&
          other.encryptedName == this.encryptedName &&
          other.createdAt == this.createdAt);
}

class AttachmentsCompanion extends UpdateCompanion<Attachment> {
  final Value<String> id;
  final Value<String> todoId;
  final Value<int> userId;
  final Value<String> filePath;
  final Value<String> encryptedName;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const AttachmentsCompanion({
    this.id = const Value.absent(),
    this.todoId = const Value.absent(),
    this.userId = const Value.absent(),
    this.filePath = const Value.absent(),
    this.encryptedName = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AttachmentsCompanion.insert({
    required String id,
    required String todoId,
    required int userId,
    required String filePath,
    required String encryptedName,
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        todoId = Value(todoId),
        userId = Value(userId),
        filePath = Value(filePath),
        encryptedName = Value(encryptedName);
  static Insertable<Attachment> custom({
    Expression<String>? id,
    Expression<String>? todoId,
    Expression<int>? userId,
    Expression<String>? filePath,
    Expression<String>? encryptedName,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (todoId != null) 'todo_id': todoId,
      if (userId != null) 'user_id': userId,
      if (filePath != null) 'file_path': filePath,
      if (encryptedName != null) 'encrypted_name': encryptedName,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AttachmentsCompanion copyWith(
      {Value<String>? id,
      Value<String>? todoId,
      Value<int>? userId,
      Value<String>? filePath,
      Value<String>? encryptedName,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return AttachmentsCompanion(
      id: id ?? this.id,
      todoId: todoId ?? this.todoId,
      userId: userId ?? this.userId,
      filePath: filePath ?? this.filePath,
      encryptedName: encryptedName ?? this.encryptedName,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (todoId.present) {
      map['todo_id'] = Variable<String>(todoId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (encryptedName.present) {
      map['encrypted_name'] = Variable<String>(encryptedName.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AttachmentsCompanion(')
          ..write('id: $id, ')
          ..write('todoId: $todoId, ')
          ..write('userId: $userId, ')
          ..write('filePath: $filePath, ')
          ..write('encryptedName: $encryptedName, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CategoriesTable categories = $CategoriesTable(this);
  late final $TodosTable todos = $TodosTable(this);
  late final $CategorySharesTable categoryShares = $CategorySharesTable(this);
  late final $CommentsTable comments = $CommentsTable(this);
  late final $AttachmentsTable attachments = $AttachmentsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [categories, todos, categoryShares, comments, attachments];
}

typedef $$CategoriesTableCreateCompanionBuilder = CategoriesCompanion Function({
  required String id,
  Value<String?> name,
  Value<String?> color,
  Value<bool> syncToServer,
  Value<bool> isShared,
  Value<int?> ownerId,
  Value<String?> encryptedBlob,
  Value<int> version,
  Value<bool> deleted,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});
typedef $$CategoriesTableUpdateCompanionBuilder = CategoriesCompanion Function({
  Value<String> id,
  Value<String?> name,
  Value<String?> color,
  Value<bool> syncToServer,
  Value<bool> isShared,
  Value<int?> ownerId,
  Value<String?> encryptedBlob,
  Value<int> version,
  Value<bool> deleted,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

final class $$CategoriesTableReferences
    extends BaseReferences<_$AppDatabase, $CategoriesTable, Category> {
  $$CategoriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TodosTable, List<Todo>> _todosRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.todos,
          aliasName:
              $_aliasNameGenerator(db.categories.id, db.todos.categoryId));

  $$TodosTableProcessedTableManager get todosRefs {
    final manager = $$TodosTableTableManager($_db, $_db.todos)
        .filter((f) => f.categoryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_todosRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$CategorySharesTable, List<CategoryShare>>
      _categorySharesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.categoryShares,
              aliasName: $_aliasNameGenerator(
                  db.categories.id, db.categoryShares.categoryId));

  $$CategorySharesTableProcessedTableManager get categorySharesRefs {
    final manager = $$CategorySharesTableTableManager($_db, $_db.categoryShares)
        .filter((f) => f.categoryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_categorySharesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$CategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get color => $composableBuilder(
      column: $table.color, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get syncToServer => $composableBuilder(
      column: $table.syncToServer, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isShared => $composableBuilder(
      column: $table.isShared, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get ownerId => $composableBuilder(
      column: $table.ownerId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get encryptedBlob => $composableBuilder(
      column: $table.encryptedBlob, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get deleted => $composableBuilder(
      column: $table.deleted, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  Expression<bool> todosRefs(
      Expression<bool> Function($$TodosTableFilterComposer f) f) {
    final $$TodosTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.todos,
        getReferencedColumn: (t) => t.categoryId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TodosTableFilterComposer(
              $db: $db,
              $table: $db.todos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> categorySharesRefs(
      Expression<bool> Function($$CategorySharesTableFilterComposer f) f) {
    final $$CategorySharesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.categoryShares,
        getReferencedColumn: (t) => t.categoryId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CategorySharesTableFilterComposer(
              $db: $db,
              $table: $db.categoryShares,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$CategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get color => $composableBuilder(
      column: $table.color, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get syncToServer => $composableBuilder(
      column: $table.syncToServer,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isShared => $composableBuilder(
      column: $table.isShared, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get ownerId => $composableBuilder(
      column: $table.ownerId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get encryptedBlob => $composableBuilder(
      column: $table.encryptedBlob,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get deleted => $composableBuilder(
      column: $table.deleted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$CategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<bool> get syncToServer => $composableBuilder(
      column: $table.syncToServer, builder: (column) => column);

  GeneratedColumn<bool> get isShared =>
      $composableBuilder(column: $table.isShared, builder: (column) => column);

  GeneratedColumn<int> get ownerId =>
      $composableBuilder(column: $table.ownerId, builder: (column) => column);

  GeneratedColumn<String> get encryptedBlob => $composableBuilder(
      column: $table.encryptedBlob, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> todosRefs<T extends Object>(
      Expression<T> Function($$TodosTableAnnotationComposer a) f) {
    final $$TodosTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.todos,
        getReferencedColumn: (t) => t.categoryId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TodosTableAnnotationComposer(
              $db: $db,
              $table: $db.todos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> categorySharesRefs<T extends Object>(
      Expression<T> Function($$CategorySharesTableAnnotationComposer a) f) {
    final $$CategorySharesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.categoryShares,
        getReferencedColumn: (t) => t.categoryId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CategorySharesTableAnnotationComposer(
              $db: $db,
              $table: $db.categoryShares,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$CategoriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CategoriesTable,
    Category,
    $$CategoriesTableFilterComposer,
    $$CategoriesTableOrderingComposer,
    $$CategoriesTableAnnotationComposer,
    $$CategoriesTableCreateCompanionBuilder,
    $$CategoriesTableUpdateCompanionBuilder,
    (Category, $$CategoriesTableReferences),
    Category,
    PrefetchHooks Function({bool todosRefs, bool categorySharesRefs})> {
  $$CategoriesTableTableManager(_$AppDatabase db, $CategoriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String?> name = const Value.absent(),
            Value<String?> color = const Value.absent(),
            Value<bool> syncToServer = const Value.absent(),
            Value<bool> isShared = const Value.absent(),
            Value<int?> ownerId = const Value.absent(),
            Value<String?> encryptedBlob = const Value.absent(),
            Value<int> version = const Value.absent(),
            Value<bool> deleted = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CategoriesCompanion(
            id: id,
            name: name,
            color: color,
            syncToServer: syncToServer,
            isShared: isShared,
            ownerId: ownerId,
            encryptedBlob: encryptedBlob,
            version: version,
            deleted: deleted,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<String?> name = const Value.absent(),
            Value<String?> color = const Value.absent(),
            Value<bool> syncToServer = const Value.absent(),
            Value<bool> isShared = const Value.absent(),
            Value<int?> ownerId = const Value.absent(),
            Value<String?> encryptedBlob = const Value.absent(),
            Value<int> version = const Value.absent(),
            Value<bool> deleted = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CategoriesCompanion.insert(
            id: id,
            name: name,
            color: color,
            syncToServer: syncToServer,
            isShared: isShared,
            ownerId: ownerId,
            encryptedBlob: encryptedBlob,
            version: version,
            deleted: deleted,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$CategoriesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {todosRefs = false, categorySharesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (todosRefs) db.todos,
                if (categorySharesRefs) db.categoryShares
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (todosRefs)
                    await $_getPrefetchedData<Category, $CategoriesTable, Todo>(
                        currentTable: table,
                        referencedTable:
                            $$CategoriesTableReferences._todosRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CategoriesTableReferences(db, table, p0)
                                .todosRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.categoryId == item.id),
                        typedResults: items),
                  if (categorySharesRefs)
                    await $_getPrefetchedData<Category, $CategoriesTable,
                            CategoryShare>(
                        currentTable: table,
                        referencedTable: $$CategoriesTableReferences
                            ._categorySharesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CategoriesTableReferences(db, table, p0)
                                .categorySharesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.categoryId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$CategoriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CategoriesTable,
    Category,
    $$CategoriesTableFilterComposer,
    $$CategoriesTableOrderingComposer,
    $$CategoriesTableAnnotationComposer,
    $$CategoriesTableCreateCompanionBuilder,
    $$CategoriesTableUpdateCompanionBuilder,
    (Category, $$CategoriesTableReferences),
    Category,
    PrefetchHooks Function({bool todosRefs, bool categorySharesRefs})>;
typedef $$TodosTableCreateCompanionBuilder = TodosCompanion Function({
  required String id,
  Value<String?> title,
  Value<int?> priority,
  Value<String?> timeEstimate,
  Value<DateTime?> dueDate,
  required String encryptedBlob,
  Value<int> version,
  Value<bool> deleted,
  Value<DateTime> updatedAt,
  Value<String?> categoryId,
  Value<int?> ownerId,
  Value<String> status,
  Value<int> rowid,
});
typedef $$TodosTableUpdateCompanionBuilder = TodosCompanion Function({
  Value<String> id,
  Value<String?> title,
  Value<int?> priority,
  Value<String?> timeEstimate,
  Value<DateTime?> dueDate,
  Value<String> encryptedBlob,
  Value<int> version,
  Value<bool> deleted,
  Value<DateTime> updatedAt,
  Value<String?> categoryId,
  Value<int?> ownerId,
  Value<String> status,
  Value<int> rowid,
});

final class $$TodosTableReferences
    extends BaseReferences<_$AppDatabase, $TodosTable, Todo> {
  $$TodosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CategoriesTable _categoryIdTable(_$AppDatabase db) => db.categories
      .createAlias($_aliasNameGenerator(db.todos.categoryId, db.categories.id));

  $$CategoriesTableProcessedTableManager? get categoryId {
    final $_column = $_itemColumn<String>('category_id');
    if ($_column == null) return null;
    final manager = $$CategoriesTableTableManager($_db, $_db.categories)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$CommentsTable, List<Comment>> _commentsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.comments,
          aliasName: $_aliasNameGenerator(db.todos.id, db.comments.todoId));

  $$CommentsTableProcessedTableManager get commentsRefs {
    final manager = $$CommentsTableTableManager($_db, $_db.comments)
        .filter((f) => f.todoId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_commentsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$AttachmentsTable, List<Attachment>>
      _attachmentsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.attachments,
          aliasName: $_aliasNameGenerator(db.todos.id, db.attachments.todoId));

  $$AttachmentsTableProcessedTableManager get attachmentsRefs {
    final manager = $$AttachmentsTableTableManager($_db, $_db.attachments)
        .filter((f) => f.todoId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_attachmentsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$TodosTableFilterComposer extends Composer<_$AppDatabase, $TodosTable> {
  $$TodosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get priority => $composableBuilder(
      column: $table.priority, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get timeEstimate => $composableBuilder(
      column: $table.timeEstimate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dueDate => $composableBuilder(
      column: $table.dueDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get encryptedBlob => $composableBuilder(
      column: $table.encryptedBlob, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get deleted => $composableBuilder(
      column: $table.deleted, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get ownerId => $composableBuilder(
      column: $table.ownerId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  $$CategoriesTableFilterComposer get categoryId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.categories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CategoriesTableFilterComposer(
              $db: $db,
              $table: $db.categories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> commentsRefs(
      Expression<bool> Function($$CommentsTableFilterComposer f) f) {
    final $$CommentsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.comments,
        getReferencedColumn: (t) => t.todoId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CommentsTableFilterComposer(
              $db: $db,
              $table: $db.comments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> attachmentsRefs(
      Expression<bool> Function($$AttachmentsTableFilterComposer f) f) {
    final $$AttachmentsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.attachments,
        getReferencedColumn: (t) => t.todoId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AttachmentsTableFilterComposer(
              $db: $db,
              $table: $db.attachments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$TodosTableOrderingComposer
    extends Composer<_$AppDatabase, $TodosTable> {
  $$TodosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get priority => $composableBuilder(
      column: $table.priority, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get timeEstimate => $composableBuilder(
      column: $table.timeEstimate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dueDate => $composableBuilder(
      column: $table.dueDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get encryptedBlob => $composableBuilder(
      column: $table.encryptedBlob,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get deleted => $composableBuilder(
      column: $table.deleted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get ownerId => $composableBuilder(
      column: $table.ownerId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  $$CategoriesTableOrderingComposer get categoryId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.categories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CategoriesTableOrderingComposer(
              $db: $db,
              $table: $db.categories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TodosTableAnnotationComposer
    extends Composer<_$AppDatabase, $TodosTable> {
  $$TodosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<int> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<String> get timeEstimate => $composableBuilder(
      column: $table.timeEstimate, builder: (column) => column);

  GeneratedColumn<DateTime> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<String> get encryptedBlob => $composableBuilder(
      column: $table.encryptedBlob, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get ownerId =>
      $composableBuilder(column: $table.ownerId, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  $$CategoriesTableAnnotationComposer get categoryId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.categories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CategoriesTableAnnotationComposer(
              $db: $db,
              $table: $db.categories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> commentsRefs<T extends Object>(
      Expression<T> Function($$CommentsTableAnnotationComposer a) f) {
    final $$CommentsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.comments,
        getReferencedColumn: (t) => t.todoId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CommentsTableAnnotationComposer(
              $db: $db,
              $table: $db.comments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> attachmentsRefs<T extends Object>(
      Expression<T> Function($$AttachmentsTableAnnotationComposer a) f) {
    final $$AttachmentsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.attachments,
        getReferencedColumn: (t) => t.todoId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AttachmentsTableAnnotationComposer(
              $db: $db,
              $table: $db.attachments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$TodosTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TodosTable,
    Todo,
    $$TodosTableFilterComposer,
    $$TodosTableOrderingComposer,
    $$TodosTableAnnotationComposer,
    $$TodosTableCreateCompanionBuilder,
    $$TodosTableUpdateCompanionBuilder,
    (Todo, $$TodosTableReferences),
    Todo,
    PrefetchHooks Function(
        {bool categoryId, bool commentsRefs, bool attachmentsRefs})> {
  $$TodosTableTableManager(_$AppDatabase db, $TodosTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TodosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TodosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TodosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String?> title = const Value.absent(),
            Value<int?> priority = const Value.absent(),
            Value<String?> timeEstimate = const Value.absent(),
            Value<DateTime?> dueDate = const Value.absent(),
            Value<String> encryptedBlob = const Value.absent(),
            Value<int> version = const Value.absent(),
            Value<bool> deleted = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<String?> categoryId = const Value.absent(),
            Value<int?> ownerId = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TodosCompanion(
            id: id,
            title: title,
            priority: priority,
            timeEstimate: timeEstimate,
            dueDate: dueDate,
            encryptedBlob: encryptedBlob,
            version: version,
            deleted: deleted,
            updatedAt: updatedAt,
            categoryId: categoryId,
            ownerId: ownerId,
            status: status,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<String?> title = const Value.absent(),
            Value<int?> priority = const Value.absent(),
            Value<String?> timeEstimate = const Value.absent(),
            Value<DateTime?> dueDate = const Value.absent(),
            required String encryptedBlob,
            Value<int> version = const Value.absent(),
            Value<bool> deleted = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<String?> categoryId = const Value.absent(),
            Value<int?> ownerId = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TodosCompanion.insert(
            id: id,
            title: title,
            priority: priority,
            timeEstimate: timeEstimate,
            dueDate: dueDate,
            encryptedBlob: encryptedBlob,
            version: version,
            deleted: deleted,
            updatedAt: updatedAt,
            categoryId: categoryId,
            ownerId: ownerId,
            status: status,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$TodosTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {categoryId = false,
              commentsRefs = false,
              attachmentsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (commentsRefs) db.comments,
                if (attachmentsRefs) db.attachments
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (categoryId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.categoryId,
                    referencedTable:
                        $$TodosTableReferences._categoryIdTable(db),
                    referencedColumn:
                        $$TodosTableReferences._categoryIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (commentsRefs)
                    await $_getPrefetchedData<Todo, $TodosTable, Comment>(
                        currentTable: table,
                        referencedTable:
                            $$TodosTableReferences._commentsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$TodosTableReferences(db, table, p0).commentsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.todoId == item.id),
                        typedResults: items),
                  if (attachmentsRefs)
                    await $_getPrefetchedData<Todo, $TodosTable, Attachment>(
                        currentTable: table,
                        referencedTable:
                            $$TodosTableReferences._attachmentsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$TodosTableReferences(db, table, p0)
                                .attachmentsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.todoId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$TodosTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TodosTable,
    Todo,
    $$TodosTableFilterComposer,
    $$TodosTableOrderingComposer,
    $$TodosTableAnnotationComposer,
    $$TodosTableCreateCompanionBuilder,
    $$TodosTableUpdateCompanionBuilder,
    (Todo, $$TodosTableReferences),
    Todo,
    PrefetchHooks Function(
        {bool categoryId, bool commentsRefs, bool attachmentsRefs})>;
typedef $$CategorySharesTableCreateCompanionBuilder = CategorySharesCompanion
    Function({
  required String id,
  required String categoryId,
  required int userId,
  required int sharedWithUserId,
  Value<String> permission,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$CategorySharesTableUpdateCompanionBuilder = CategorySharesCompanion
    Function({
  Value<String> id,
  Value<String> categoryId,
  Value<int> userId,
  Value<int> sharedWithUserId,
  Value<String> permission,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$CategorySharesTableReferences
    extends BaseReferences<_$AppDatabase, $CategorySharesTable, CategoryShare> {
  $$CategorySharesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $CategoriesTable _categoryIdTable(_$AppDatabase db) =>
      db.categories.createAlias(
          $_aliasNameGenerator(db.categoryShares.categoryId, db.categories.id));

  $$CategoriesTableProcessedTableManager get categoryId {
    final $_column = $_itemColumn<String>('category_id')!;

    final manager = $$CategoriesTableTableManager($_db, $_db.categories)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$CategorySharesTableFilterComposer
    extends Composer<_$AppDatabase, $CategorySharesTable> {
  $$CategorySharesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sharedWithUserId => $composableBuilder(
      column: $table.sharedWithUserId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get permission => $composableBuilder(
      column: $table.permission, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$CategoriesTableFilterComposer get categoryId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.categories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CategoriesTableFilterComposer(
              $db: $db,
              $table: $db.categories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$CategorySharesTableOrderingComposer
    extends Composer<_$AppDatabase, $CategorySharesTable> {
  $$CategorySharesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sharedWithUserId => $composableBuilder(
      column: $table.sharedWithUserId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get permission => $composableBuilder(
      column: $table.permission, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$CategoriesTableOrderingComposer get categoryId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.categories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CategoriesTableOrderingComposer(
              $db: $db,
              $table: $db.categories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$CategorySharesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategorySharesTable> {
  $$CategorySharesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<int> get sharedWithUserId => $composableBuilder(
      column: $table.sharedWithUserId, builder: (column) => column);

  GeneratedColumn<String> get permission => $composableBuilder(
      column: $table.permission, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$CategoriesTableAnnotationComposer get categoryId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.categories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CategoriesTableAnnotationComposer(
              $db: $db,
              $table: $db.categories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$CategorySharesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CategorySharesTable,
    CategoryShare,
    $$CategorySharesTableFilterComposer,
    $$CategorySharesTableOrderingComposer,
    $$CategorySharesTableAnnotationComposer,
    $$CategorySharesTableCreateCompanionBuilder,
    $$CategorySharesTableUpdateCompanionBuilder,
    (CategoryShare, $$CategorySharesTableReferences),
    CategoryShare,
    PrefetchHooks Function({bool categoryId})> {
  $$CategorySharesTableTableManager(
      _$AppDatabase db, $CategorySharesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategorySharesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategorySharesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategorySharesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> categoryId = const Value.absent(),
            Value<int> userId = const Value.absent(),
            Value<int> sharedWithUserId = const Value.absent(),
            Value<String> permission = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CategorySharesCompanion(
            id: id,
            categoryId: categoryId,
            userId: userId,
            sharedWithUserId: sharedWithUserId,
            permission: permission,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String categoryId,
            required int userId,
            required int sharedWithUserId,
            Value<String> permission = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CategorySharesCompanion.insert(
            id: id,
            categoryId: categoryId,
            userId: userId,
            sharedWithUserId: sharedWithUserId,
            permission: permission,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$CategorySharesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({categoryId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (categoryId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.categoryId,
                    referencedTable:
                        $$CategorySharesTableReferences._categoryIdTable(db),
                    referencedColumn:
                        $$CategorySharesTableReferences._categoryIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$CategorySharesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CategorySharesTable,
    CategoryShare,
    $$CategorySharesTableFilterComposer,
    $$CategorySharesTableOrderingComposer,
    $$CategorySharesTableAnnotationComposer,
    $$CategorySharesTableCreateCompanionBuilder,
    $$CategorySharesTableUpdateCompanionBuilder,
    (CategoryShare, $$CategorySharesTableReferences),
    CategoryShare,
    PrefetchHooks Function({bool categoryId})>;
typedef $$CommentsTableCreateCompanionBuilder = CommentsCompanion Function({
  required String id,
  required String todoId,
  required int userId,
  required String encryptedBlob,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$CommentsTableUpdateCompanionBuilder = CommentsCompanion Function({
  Value<String> id,
  Value<String> todoId,
  Value<int> userId,
  Value<String> encryptedBlob,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$CommentsTableReferences
    extends BaseReferences<_$AppDatabase, $CommentsTable, Comment> {
  $$CommentsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TodosTable _todoIdTable(_$AppDatabase db) => db.todos
      .createAlias($_aliasNameGenerator(db.comments.todoId, db.todos.id));

  $$TodosTableProcessedTableManager get todoId {
    final $_column = $_itemColumn<String>('todo_id')!;

    final manager = $$TodosTableTableManager($_db, $_db.todos)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_todoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$CommentsTableFilterComposer
    extends Composer<_$AppDatabase, $CommentsTable> {
  $$CommentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get encryptedBlob => $composableBuilder(
      column: $table.encryptedBlob, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$TodosTableFilterComposer get todoId {
    final $$TodosTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.todoId,
        referencedTable: $db.todos,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TodosTableFilterComposer(
              $db: $db,
              $table: $db.todos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$CommentsTableOrderingComposer
    extends Composer<_$AppDatabase, $CommentsTable> {
  $$CommentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get encryptedBlob => $composableBuilder(
      column: $table.encryptedBlob,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$TodosTableOrderingComposer get todoId {
    final $$TodosTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.todoId,
        referencedTable: $db.todos,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TodosTableOrderingComposer(
              $db: $db,
              $table: $db.todos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$CommentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CommentsTable> {
  $$CommentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get encryptedBlob => $composableBuilder(
      column: $table.encryptedBlob, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$TodosTableAnnotationComposer get todoId {
    final $$TodosTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.todoId,
        referencedTable: $db.todos,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TodosTableAnnotationComposer(
              $db: $db,
              $table: $db.todos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$CommentsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CommentsTable,
    Comment,
    $$CommentsTableFilterComposer,
    $$CommentsTableOrderingComposer,
    $$CommentsTableAnnotationComposer,
    $$CommentsTableCreateCompanionBuilder,
    $$CommentsTableUpdateCompanionBuilder,
    (Comment, $$CommentsTableReferences),
    Comment,
    PrefetchHooks Function({bool todoId})> {
  $$CommentsTableTableManager(_$AppDatabase db, $CommentsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CommentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CommentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CommentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> todoId = const Value.absent(),
            Value<int> userId = const Value.absent(),
            Value<String> encryptedBlob = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CommentsCompanion(
            id: id,
            todoId: todoId,
            userId: userId,
            encryptedBlob: encryptedBlob,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String todoId,
            required int userId,
            required String encryptedBlob,
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CommentsCompanion.insert(
            id: id,
            todoId: todoId,
            userId: userId,
            encryptedBlob: encryptedBlob,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$CommentsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({todoId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (todoId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.todoId,
                    referencedTable: $$CommentsTableReferences._todoIdTable(db),
                    referencedColumn:
                        $$CommentsTableReferences._todoIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$CommentsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CommentsTable,
    Comment,
    $$CommentsTableFilterComposer,
    $$CommentsTableOrderingComposer,
    $$CommentsTableAnnotationComposer,
    $$CommentsTableCreateCompanionBuilder,
    $$CommentsTableUpdateCompanionBuilder,
    (Comment, $$CommentsTableReferences),
    Comment,
    PrefetchHooks Function({bool todoId})>;
typedef $$AttachmentsTableCreateCompanionBuilder = AttachmentsCompanion
    Function({
  required String id,
  required String todoId,
  required int userId,
  required String filePath,
  required String encryptedName,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$AttachmentsTableUpdateCompanionBuilder = AttachmentsCompanion
    Function({
  Value<String> id,
  Value<String> todoId,
  Value<int> userId,
  Value<String> filePath,
  Value<String> encryptedName,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$AttachmentsTableReferences
    extends BaseReferences<_$AppDatabase, $AttachmentsTable, Attachment> {
  $$AttachmentsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TodosTable _todoIdTable(_$AppDatabase db) => db.todos
      .createAlias($_aliasNameGenerator(db.attachments.todoId, db.todos.id));

  $$TodosTableProcessedTableManager get todoId {
    final $_column = $_itemColumn<String>('todo_id')!;

    final manager = $$TodosTableTableManager($_db, $_db.todos)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_todoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$AttachmentsTableFilterComposer
    extends Composer<_$AppDatabase, $AttachmentsTable> {
  $$AttachmentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get filePath => $composableBuilder(
      column: $table.filePath, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get encryptedName => $composableBuilder(
      column: $table.encryptedName, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$TodosTableFilterComposer get todoId {
    final $$TodosTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.todoId,
        referencedTable: $db.todos,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TodosTableFilterComposer(
              $db: $db,
              $table: $db.todos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AttachmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $AttachmentsTable> {
  $$AttachmentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get filePath => $composableBuilder(
      column: $table.filePath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get encryptedName => $composableBuilder(
      column: $table.encryptedName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$TodosTableOrderingComposer get todoId {
    final $$TodosTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.todoId,
        referencedTable: $db.todos,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TodosTableOrderingComposer(
              $db: $db,
              $table: $db.todos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AttachmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AttachmentsTable> {
  $$AttachmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumn<String> get encryptedName => $composableBuilder(
      column: $table.encryptedName, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$TodosTableAnnotationComposer get todoId {
    final $$TodosTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.todoId,
        referencedTable: $db.todos,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TodosTableAnnotationComposer(
              $db: $db,
              $table: $db.todos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AttachmentsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AttachmentsTable,
    Attachment,
    $$AttachmentsTableFilterComposer,
    $$AttachmentsTableOrderingComposer,
    $$AttachmentsTableAnnotationComposer,
    $$AttachmentsTableCreateCompanionBuilder,
    $$AttachmentsTableUpdateCompanionBuilder,
    (Attachment, $$AttachmentsTableReferences),
    Attachment,
    PrefetchHooks Function({bool todoId})> {
  $$AttachmentsTableTableManager(_$AppDatabase db, $AttachmentsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AttachmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AttachmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AttachmentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> todoId = const Value.absent(),
            Value<int> userId = const Value.absent(),
            Value<String> filePath = const Value.absent(),
            Value<String> encryptedName = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AttachmentsCompanion(
            id: id,
            todoId: todoId,
            userId: userId,
            filePath: filePath,
            encryptedName: encryptedName,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String todoId,
            required int userId,
            required String filePath,
            required String encryptedName,
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AttachmentsCompanion.insert(
            id: id,
            todoId: todoId,
            userId: userId,
            filePath: filePath,
            encryptedName: encryptedName,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$AttachmentsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({todoId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (todoId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.todoId,
                    referencedTable:
                        $$AttachmentsTableReferences._todoIdTable(db),
                    referencedColumn:
                        $$AttachmentsTableReferences._todoIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$AttachmentsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AttachmentsTable,
    Attachment,
    $$AttachmentsTableFilterComposer,
    $$AttachmentsTableOrderingComposer,
    $$AttachmentsTableAnnotationComposer,
    $$AttachmentsTableCreateCompanionBuilder,
    $$AttachmentsTableUpdateCompanionBuilder,
    (Attachment, $$AttachmentsTableReferences),
    Attachment,
    PrefetchHooks Function({bool todoId})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db, _db.categories);
  $$TodosTableTableManager get todos =>
      $$TodosTableTableManager(_db, _db.todos);
  $$CategorySharesTableTableManager get categoryShares =>
      $$CategorySharesTableTableManager(_db, _db.categoryShares);
  $$CommentsTableTableManager get comments =>
      $$CommentsTableTableManager(_db, _db.comments);
  $$AttachmentsTableTableManager get attachments =>
      $$AttachmentsTableTableManager(_db, _db.attachments);
}
