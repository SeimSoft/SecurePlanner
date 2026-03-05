import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'database.g.dart';

class Todos extends Table {
  TextColumn get id => text()();
  TextColumn get title => text().nullable()();
  IntColumn get priority => integer().nullable()();
  TextColumn get timeEstimate => text().nullable()();
  DateTimeColumn get dueDate => dateTime().nullable()();
  TextColumn get encryptedBlob => text()();
  IntColumn get version => integer().withDefault(const Constant(1))();
  BoolColumn get deleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get categoryId => text().nullable().references(Categories, #id)();
  IntColumn get ownerId => integer().nullable()();
  TextColumn get status => text().withDefault(const Constant('Backlog'))();

  @override
  Set<Column> get primaryKey => {id};
}

class Categories extends Table {
  TextColumn get id => text()();
  TextColumn get name =>
      text().nullable()(); // Local name (unencrypted or separately encrypted)
  TextColumn get color => text().nullable()();
  BoolColumn get syncToServer => boolean().withDefault(const Constant(true))();
  BoolColumn get isShared => boolean().withDefault(const Constant(false))();
  IntColumn get ownerId => integer().nullable()();
  TextColumn get encryptedBlob => text().nullable()(); // For syncing to server
  IntColumn get version => integer().withDefault(const Constant(1))();
  BoolColumn get deleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class CategoryShares extends Table {
  TextColumn get id => text()();
  TextColumn get categoryId => text().references(Categories, #id)();
  IntColumn get userId => integer()();
  IntColumn get sharedWithUserId => integer()();
  TextColumn get permission => text().withDefault(const Constant('read'))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class Comments extends Table {
  TextColumn get id => text()();
  TextColumn get todoId => text().references(Todos, #id)();
  IntColumn get userId => integer()();
  TextColumn get encryptedBlob => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class Attachments extends Table {
  TextColumn get id => text()();
  TextColumn get todoId => text().references(Todos, #id)();
  IntColumn get userId => integer()();
  TextColumn get filePath => text()();
  TextColumn get encryptedName => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(
    tables: [Todos, Categories, CategoryShares, Comments, Attachments])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2; // Incremented schema version

  // Todos
  Future<List<Todo>> getAllTodos() => select(todos).get();
  Stream<List<ListTodoResult>> watchTodosWithCategory() {
    final query = select(todos).join([
      leftOuterJoin(categories, categories.id.equalsExp(todos.categoryId)),
    ]);
    return query.watch().map((rows) {
      return rows.map((row) {
        return ListTodoResult(
          todo: row.readTable(todos),
          category: row.readTableOrNull(categories),
        );
      }).toList();
    });
  }

  Stream<List<Todo>> watchAllTodos() =>
      (select(todos)..where((t) => t.deleted.equals(false))).watch();

  Future insertTodo(Insertable<Todo> todo) =>
      into(todos).insert(todo, mode: InsertMode.insertOrReplace);

  Future updateTodo(Insertable<Todo> todo) => update(todos).replace(todo);

  Future deleteTodo(String id) => (update(todos)..where((t) => t.id.equals(id)))
      .write(const TodosCompanion(deleted: Value(true)));

  // Categories
  Future<List<Category>> getAllCategories() => select(categories).get();
  Stream<List<Category>> watchAllCategories() =>
      (select(categories)..where((t) => t.deleted.equals(false))).watch();
  Future insertCategory(Insertable<Category> category) =>
      into(categories).insert(category, mode: InsertMode.insertOrReplace);

  // Sync helpers
  Future<List<Todo>> getTodosToSync() => (select(todos)
        ..where((t) {
          // Only sync if category is not local-only OR if it has no category
          return t.categoryId.isNull() |
              existsQuery(select(categories)
                ..where((c) =>
                    c.id.equalsExp(t.categoryId) &
                    c.syncToServer.equals(true)));
        }))
      .get();
}

class ListTodoResult {
  final Todo todo;
  final Category? category;
  ListTodoResult({required this.todo, this.category});
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}
