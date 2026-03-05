import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:private_planner/data/database.dart';
import 'package:private_planner/providers/database_provider.dart';

final watchCategoriesProvider = StreamProvider((ref) {
  return ref.watch(databaseProvider).watchAllCategories();
});

final watchTodosWithCategoryProvider = StreamProvider((ref) {
  return ref.watch(databaseProvider).watchTodosWithCategory();
});

final watchCommentsProvider =
    StreamProvider.family<List<Comment>, String>((ref, todoId) {
  return ref.watch(databaseProvider).watchComments(todoId);
});

final watchAttachmentsProvider =
    StreamProvider.family<List<Attachment>, String>((ref, todoId) {
  return ref.watch(databaseProvider).watchAttachments(todoId);
});
