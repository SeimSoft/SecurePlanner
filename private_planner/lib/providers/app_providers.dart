import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:private_planner/data/database.dart';
import 'package:private_planner/providers/database_provider.dart';

final watchCategoriesProvider = StreamProvider((ref) {
  return ref.watch(databaseProvider).watchAllCategories();
});

final selectedCategoryProvider = StateProvider<String?>((ref) => null);
final selectedTodoIdProvider = StateProvider<String?>((ref) => null);

final watchTodosWithCategoryProvider =
    StreamProvider.family<List<ListTodoResult>, String?>((ref, categoryId) {
  return ref
      .watch(databaseProvider)
      .watchTodosWithCategory(categoryId: categoryId);
});

final watchCommentsProvider =
    StreamProvider.family<List<Comment>, String>((ref, todoId) {
  return ref.watch(databaseProvider).watchComments(todoId);
});

final watchAttachmentsProvider =
    StreamProvider.family<List<Attachment>, String>((ref, todoId) {
  return ref.watch(databaseProvider).watchAttachments(todoId);
});

final appLockProvider = StateNotifierProvider<AppLockNotifier, bool>((ref) {
  return AppLockNotifier();
});

class AppLockNotifier extends StateNotifier<bool> {
  AppLockNotifier() : super(true); // Default to locked

  void unlock() => state = false;
  void lock() => state = true;
}
