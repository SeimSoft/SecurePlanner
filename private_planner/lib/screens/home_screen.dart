import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:private_planner/data/database.dart';
import 'package:private_planner/core/theme/app_theme.dart';
import 'package:private_planner/providers/database_provider.dart';
import 'package:private_planner/screens/category_management_screen.dart';
import 'package:private_planner/screens/todo_detail_screen.dart';
import 'package:intl/intl.dart';
import 'package:private_planner/services/sync_service.dart';
import 'package:private_planner/services/auth_service.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todosStream = ref.watch(watchTodosProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Private Planner'),
        actions: [
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
        ],
      ),
      body: todosStream.when(
        data: (items) => items.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.task_alt, size: 64, color: Colors.grey.shade300),
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
                  return GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TodoDetailScreen(todo: item.todo),
                      ),
                    ),
                    child:
                        TodoListTile(todo: item.todo, category: item.category),
                  );
                },
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Fehler: $e')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Open Add Todo Dialog
        },
        child: const Icon(Icons.add),
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
                            color:
                                _parseColor(category!.color).withOpacity(0.1),
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

final watchTodosProvider = StreamProvider((ref) {
  return ref.watch(databaseProvider).watchTodosWithCategory();
});
