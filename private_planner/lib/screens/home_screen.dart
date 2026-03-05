import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:private_planner/data/database.dart';
import 'package:private_planner/core/theme/app_theme.dart';
import 'package:private_planner/screens/category_management_screen.dart';
import 'package:private_planner/screens/todo_detail_screen.dart';
import 'package:private_planner/providers/app_providers.dart';
import 'package:private_planner/screens/search_screen.dart';
import 'package:private_planner/widgets/add_todo_dialog.dart';
import 'package:private_planner/screens/settings_screen.dart';
import 'package:intl/intl.dart';
import 'package:private_planner/services/sync_service.dart';
import 'package:private_planner/providers/database_provider.dart';

final isDraggingTodoProvider = StateProvider<bool>((ref) => false);

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategoryId = ref.watch(selectedCategoryProvider);
    final todosStream =
        ref.watch(watchTodosWithCategoryProvider(selectedCategoryId));
    final categoriesAsync = ref.watch(watchCategoriesProvider);
    final selectedTodoId = ref.watch(selectedTodoIdProvider);
    final isCompactHeight = MediaQuery.sizeOf(context).height < 500;

    return Scaffold(
      appBar: isCompactHeight
          ? null
          : AppBar(
              title: const Text('Private Planner'),
              actions: [
                Row(
                  children: [
                    const Text('Show Done', style: TextStyle(fontSize: 14)),
                    Checkbox(
                      value: ref.watch(showDoneTodosProvider),
                      onChanged: (val) {
                        if (val != null) {
                          ref.read(showDoneTodosProvider.notifier).state = val;
                        }
                      },
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SearchScreen(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.category),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CategoryManagementScreen(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.sync),
                  onPressed: () => ref.read(syncServiceProvider).sync(),
                ),
                IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsScreen(),
                    ),
                  ),
                ),
              ],
            ),
      body: Stack(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final isDesktop = constraints.maxWidth > 800;
              final listWidget = _buildList(context, ref, todosStream,
                  categoriesAsync, isDesktop, selectedTodoId, isCompactHeight);

              if (isDesktop) {
                return Row(
                  children: [
                    Expanded(flex: 1, child: listWidget),
                    const VerticalDivider(width: 1),
                    Expanded(
                        flex: 2,
                        child: _buildDetail(
                            context, ref, todosStream, selectedTodoId)),
                  ],
                );
              } else {
                return listWidget;
              }
            },
          ),
          if (ref.watch(isDraggingTodoProvider))
            Positioned(
              left: 16,
              right: 16,
              bottom: 32,
              child: _buildDragBaskets(context, ref),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => const AddTodoDialog(),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildList(
      BuildContext context,
      WidgetRef ref,
      AsyncValue<List<ListTodoResult>> todosStream,
      AsyncValue<List<Category>> categoriesAsync,
      bool isDesktop,
      String? selectedTodoId,
      bool isCompactHeight) {
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
                    border: OutlineInputBorder()),
                items: [
                  const DropdownMenuItem(
                      value: null, child: Text('Alle Kategorien')),
                  ...categories.map((c) =>
                      DropdownMenuItem(value: c.id, child: Text(c.name ?? ''))),
                ],
                onChanged: (val) {
                  ref.read(selectedCategoryProvider.notifier).state = val;
                },
              ),
              loading: () => const LinearProgressIndicator(),
              error: (e, s) => const Text('Fehler beim Laden'),
            ),
          ),
        Expanded(
          child: todosStream.when(
            data: (items) => items.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.task_alt,
                            size: 64, color: Colors.grey.shade300),
                        const SizedBox(height: 16),
                        Text('Keine Todos gefunden',
                            style: TextStyle(color: Colors.grey.shade500)),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      final isSelected = selectedTodoId == item.todo.id;
                      return GestureDetector(
                        onTap: () {
                          if (isDesktop) {
                            ref.read(selectedTodoIdProvider.notifier).state =
                                item.todo.id;
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    TodoDetailScreen(todo: item.todo),
                              ),
                            );
                          }
                        },
                        child: Draggable<Todo>(
                          data: item.todo,
                          feedback: Material(
                            elevation: 8,
                            borderRadius: BorderRadius.circular(12),
                            color: Theme.of(context).cardColor,
                            child: SizedBox(
                              width: 300,
                              child: TodoListTile(
                                  todo: item.todo, category: item.category),
                            ),
                          ),
                          childWhenDragging: Opacity(
                            opacity: 0.3,
                            child: Container(
                              decoration: isDesktop && isSelected
                                  ? BoxDecoration(
                                      border: Border.all(
                                          color: Theme.of(context).primaryColor,
                                          width: 2),
                                      borderRadius: BorderRadius.circular(12),
                                    )
                                  : null,
                              child: TodoListTile(
                                  todo: item.todo, category: item.category),
                            ),
                          ),
                          onDragStarted: () => ref
                              .read(isDraggingTodoProvider.notifier)
                              .state = true,
                          onDragEnd: (_) => ref
                              .read(isDraggingTodoProvider.notifier)
                              .state = false,
                          child: Container(
                            decoration: isDesktop && isSelected
                                ? BoxDecoration(
                                    border: Border.all(
                                        color: Theme.of(context).primaryColor,
                                        width: 2),
                                    borderRadius: BorderRadius.circular(12),
                                  )
                                : null,
                            child: TodoListTile(
                                todo: item.todo, category: item.category),
                          ),
                        ),
                      );
                    },
                  ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, s) => Center(child: Text('Fehler: $e')),
          ),
        ),
      ],
    );
  }

  Widget _buildDetail(BuildContext context, WidgetRef ref,
      AsyncValue<List<ListTodoResult>> todosStream, String? selectedTodoId) {
    if (selectedTodoId == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.touch_app, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text('Wähle ein Todo aus, um Details zu sehen',
                style: TextStyle(color: Colors.grey.shade500)),
          ],
        ),
      );
    }

    return todosStream.when(
      data: (items) {
        final selected =
            items.where((i) => i.todo.id == selectedTodoId).firstOrNull;
        if (selected == null) {
          return const Center(child: Text('Todo nicht gefunden oder gelöscht'));
        }
        return ClipRect(
          child: TodoDetailScreen(todo: selected.todo, isEmbedded: true),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => const Center(child: Text('Fehler')),
    );
  }

  Widget _buildDragBaskets(BuildContext context, WidgetRef ref) {
    final statuses = ['Backlog', 'In Progress', 'Review', 'Done'];
    final colors = [Colors.grey, Colors.blue, Colors.orange, Colors.green];
    final icons = [
      Icons.inbox,
      Icons.play_arrow,
      Icons.visibility,
      Icons.check
    ];

    return Material(
      elevation: 12,
      borderRadius: BorderRadius.circular(16),
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Container(
        height: 120,
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(4, (index) {
            final status = statuses[index];
            return DragTarget<Todo>(
              onAcceptWithDetails: (details) async {
                final todo = details.data;
                final db = ref.read(databaseProvider);
                await db.update(db.todos).replace(
                    todo.copyWith(status: status, version: todo.version + 1));
              },
              builder: (context, candidateData, rejectedData) {
                final isHovered = candidateData.isNotEmpty;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: isHovered ? 140 : 120,
                  decoration: BoxDecoration(
                    color: isHovered
                        ? colors[index].withValues(alpha: 0.2)
                        : Theme.of(context).colorScheme.surface,
                    border: Border.all(
                        color: colors[index], width: isHovered ? 3 : 1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(icons[index],
                          color: colors[index], size: isHovered ? 40 : 32),
                      const SizedBox(height: 8),
                      Text(status,
                          style: TextStyle(
                              color: colors[index],
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                );
              },
            );
          }),
        ),
      ),
    );
  }
}

class TodoListTile extends StatelessWidget {
  final Todo todo;
  final Category? category;

  const TodoListTile({super.key, required this.todo, this.category});

  Color getPriorityColor() {
    switch (todo.priority) {
      case 2:
        return AppTheme.priorityHigh;
      case 1:
        return AppTheme.priorityMedium;
      default:
        return AppTheme.priorityLow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 40,
              decoration: BoxDecoration(
                color: getPriorityColor(),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    todo.title ?? 'No Title',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      if (category != null) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: _parseColor(category!.color)
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            category!.name ?? '',
                            style: TextStyle(
                              fontSize: 10,
                              color: _parseColor(category!.color),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      Icon(Icons.calendar_today,
                          size: 14, color: Colors.grey.shade600),
                      const SizedBox(width: 4),
                      Text(
                        todo.dueDate != null
                            ? DateFormat('dd.MM.yyyy').format(todo.dueDate!)
                            : '',
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Text(
              todo.status,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
            ),
          ],
        ),
      ),
    );
  }

  Color _parseColor(String? colorStr) {
    if (colorStr == null) return Colors.grey;
    try {
      return Color(int.parse(colorStr.replaceAll('#', '0xFF')));
    } catch (e) {
      return Colors.grey;
    }
  }
}
