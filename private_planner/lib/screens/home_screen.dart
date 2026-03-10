import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:private_planner/data/database.dart';
import 'package:private_planner/core/theme/app_theme.dart';
import 'package:private_planner/screens/category_management_screen.dart';
import 'package:private_planner/screens/todo_detail_screen.dart';
import 'package:private_planner/providers/app_providers.dart';
import 'package:private_planner/screens/search_screen.dart';
import 'package:private_planner/services/jira_service.dart';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:intl/intl.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:private_planner/services/sync_service.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todosStream = ref.watch(watchTodosWithCategoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Private Planner'),
        actions: [
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
          PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == 'import_jira') {
                // Show import dialog
                final creds = await JiraService.getStoredCredentials();
                final urlController = TextEditingController();
                final userController = TextEditingController(text: creds['username'] ?? '');
                final passController = TextEditingController(text: creds['password'] ?? '');
                bool saveCreds = creds['username'] != null && creds['password'] != null;

                await showDialog<void>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Import from JIRA'),
                    content: SingleChildScrollView(
                      child: Column(
                        children: [
                          TextField(
                            controller: urlController,
                            decoration: const InputDecoration(labelText: 'JIRA Issue URL'),
                          ),
                          TextField(
                            controller: userController,
                            decoration: const InputDecoration(labelText: 'Username'),
                          ),
                          TextField(
                            controller: passController,
                            decoration: const InputDecoration(labelText: 'Password'),
                            obscureText: true,
                          ),
                          Row(
                            children: [
                              Checkbox(
                                value: saveCreds,
                                onChanged: (v) => saveCreds = v ?? false,
                              ),
                              const Text('Save credentials')
                            ],
                          )
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Cancel')),
                      ElevatedButton(
                        onPressed: () async {
                          final url = urlController.text.trim();
                          final username = userController.text.trim();
                          final password = passController.text;
                          if (url.isEmpty || username.isEmpty || password.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
                            return;
                          }
                          Navigator.of(context).pop();
                          try {
                            final issue = await JiraService.fetchIssueFromUrl(url, username, password);
                            if (saveCreds) {
                              await JiraService.storeCredentials(username, password);
                            }
                            final db = ref.read(databaseProvider);
                            final newId = const Uuid().v4();
                            await db.insertTodo(TodosCompanion.insert(
                              id: newId,
                              title: Value(issue['summary']),
                              priority: const Value(1),
                              timeEstimate: Value(''),
                              dueDate: Value(DateTime.now()),
                              encryptedBlob: '',
                            ));
                            // Attach URL as attachment so it can be opened from details.
                            await db.into(db.attachments).insert(AttachmentsCompanion.insert(
                              id: const Uuid().v4(),
                              todoId: newId,
                              userId: 0,
                              filePath: url,
                              encryptedName: issue['key'] ?? '',
                            ));
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Imported JIRA issue')));
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Import failed: $e')));
                            }
                          }
                        },
                        child: const Text('OK'),
                      )
                    ],
                  ),
                );
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'import_jira', child: Text('Import from JIRA'))
            ],
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
                  return DropTarget(
                    onDragDone: (detail) async {
                      if (detail.files.isNotEmpty) {
                        final file = detail.files.first;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Dropped file: \\${file.path}')),
                        );
                        // TODO: Persist or attach the dropped file to the todo item.
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Drop had no files or is not supported')),
                        );
                      }
                    },
                    child: GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TodoDetailScreen(todo: item.todo),
                        ),
                      ),
                      child: TodoListTile(todo: item.todo, category: item.category),
                    ),
                  );
                },
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Fehler: $e')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Open Add Todo Screen
          // (Implement this navigation)
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
