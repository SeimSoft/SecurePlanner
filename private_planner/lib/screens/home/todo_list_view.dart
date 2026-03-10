import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:private_planner/providers/app_providers.dart';
import 'package:private_planner/providers/database_provider.dart';
import 'package:private_planner/services/sync_service.dart';
import 'package:private_planner/data/database.dart';
import 'package:private_planner/screens/todo_detail_screen.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:private_planner/widgets/todo_list_tile.dart';
import 'package:uuid/uuid.dart';

class TodoListView extends ConsumerWidget {
  final AsyncValue<List<ListTodoResult>> todosStream;
  final AsyncValue<List<Category>> categoriesAsync;
  final bool isCompactHeight;
  final bool isDesktop;
  final String? selectedTodoId;

  const TodoListView({
    Key? key,
    required this.todosStream,
    required this.categoriesAsync,
    required this.isCompactHeight,
    required this.isDesktop,
    required this.selectedTodoId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        if (!isCompactHeight)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: categoriesAsync.when(
              data: (categories) => DropdownButtonFormField<String?>(
                initialValue: ref.watch(selectedCategoryProvider),
                decoration: const InputDecoration(
                  labelText: 'Kategorie Filter',
                  border: OutlineInputBorder(),
                ),
                items: [
                  const DropdownMenuItem(value: null, child: Text('Alle Kategorien')),
                  ...categories.map((c) => DropdownMenuItem(value: c.id, child: Text(c.name ?? ''))),
                ],
                onChanged: (val) => ref.read(selectedCategoryProvider.notifier).state = val,
              ),
              loading: () => const LinearProgressIndicator(),
              error: (e, s) => const Text('Fehler beim Laden'),
            ),
          ),
        Expanded(
          child: todosStream.when(
            data: (items) {
              if (items.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.task_alt, size: 64, color: Colors.grey.shade300),
                      const SizedBox(height: 16),
                      Text('Keine Todos gefunden', style: TextStyle(color: Colors.grey.shade500)),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () async => ref.read(syncServiceProvider).sync(),
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return DropTarget(
                      onDragDone: (detail) async {
                        if (detail.files.isNotEmpty) {
                          final file = detail.files.first;
                          
                          try {
                            final db = ref.read(databaseProvider);
                            final attachmentId = const Uuid().v4();
                            await db.into(db.attachments).insert(AttachmentsCompanion.insert(
                              id: attachmentId,
                              todoId: item.todo.id,
                              userId: 0,
                              filePath: file.path,
                              encryptedName: file.name,
                            ));

                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Attached file: ${file.name}')),
                              );
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Failed to attach file: $e')),
                              );
                            }
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Drop had no files or is not supported')),
                          );
                        }
                      },
                      child: GestureDetector(
                        onTap: () {
                          if (isDesktop) {
                            ref.read(selectedTodoIdProvider.notifier).state = item.todo.id;
                          } else {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => TodoDetailScreen(todo: item.todo)));
                          }
                        },
                        child: TodoListTile(todo: item.todo, category: item.category),
                      ),
                    );
                  },
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, s) => Center(child: Text('Fehler: $e')),
          ),
        ),
      ],
    );
  }
}
