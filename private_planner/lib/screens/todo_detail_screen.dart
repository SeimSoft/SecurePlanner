import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:private_planner/data/database.dart';
import 'package:private_planner/providers/database_provider.dart';
import 'package:private_planner/core/theme/app_theme.dart';
import 'package:intl/intl.dart';

class TodoDetailScreen extends HookConsumerWidget {
  final Todo todo;

  const TodoDetailScreen({super.key, required this.todo});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(databaseProvider);
    final statusList = ['Backlog', 'In Progress', 'Review', 'Done'];

    return Scaffold(
      appBar: AppBar(
        title: Text(todo.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              await db.update(db.todos).replace(
                  todo.copyWith(deleted: true, version: todo.version + 1));
              if (context.mounted) Navigator.pop(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<String>(
              value: todo.status,
              decoration: const InputDecoration(labelText: 'Status'),
              items: statusList
                  .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                  .toList(),
              onChanged: (val) async {
                if (val != null) {
                  await db.update(db.todos).replace(
                      todo.copyWith(status: val, version: todo.version + 1));
                }
              },
            ),
            const SizedBox(height: 16),
            Text('Priority: ${todo.priority}',
                style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 8),
            Text('Due Date: ${DateFormat('dd.MM.yyyy').format(todo.dueDate)}',
                style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 24),
            Text('Comments', style: Theme.of(context).textTheme.titleLarge),
            const Divider(),
            const Center(child: Text('Comments logic coming soon...')),
            const SizedBox(height: 24),
            Text('Attachments', style: Theme.of(context).textTheme.titleLarge),
            const Divider(),
            const Center(child: Text('File attachments coming soon...')),
          ],
        ),
      ),
    );
  }
}
