import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:private_planner/data/database.dart';
import 'package:private_planner/providers/database_provider.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:private_planner/providers/app_providers.dart';

class TodoDetailScreen extends HookConsumerWidget {
  final Todo todo;

  const TodoDetailScreen({super.key, required this.todo});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(databaseProvider);
    final statusList = ['Backlog', 'In Progress', 'Review', 'Done'];

    return Scaffold(
      appBar: AppBar(
        title: Text(todo.title ?? 'Ticket Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              await db.update(db.todos).replace(
                  todo.copyWith(deleted: true, version: todo.version + 1));
              if (context.mounted) {
                Navigator.of(context).pop();
              }
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
              initialValue: todo.status,
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
            Text('Priorität: ${todo.priority}',
                style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 8),
            Text(
                'Fällig am: ${todo.dueDate != null ? DateFormat('dd.MM.yyyy').format(todo.dueDate!) : 'Kein Datum'}',
                style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 24),
            Text('Kommentare', style: Theme.of(context).textTheme.titleLarge),
            const Divider(),
            ref.watch(watchCommentsProvider(todo.id)).when(
                  data: (comments) => ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: comments.length,
                    itemBuilder: (context, index) {
                      final comment = comments[index];
                      return ListTile(
                        title: Text(comment.encryptedBlob), // TODO: Decrypt
                        subtitle: Text(DateFormat('dd.MM HH:mm')
                            .format(comment.createdAt)),
                      );
                    },
                  ),
                  loading: () => const CircularProgressIndicator(),
                  error: (e, s) => Text('Fehler: $e'),
                ),
            TextField(
              decoration: const InputDecoration(
                hintText: 'Kommentar hinzufügen...',
                suffixIcon: Icon(Icons.send),
              ),
              onSubmitted: (val) async {
                if (val.isNotEmpty) {
                  // TODO: Encrypt val
                  await db.into(db.comments).insert(CommentsCompanion.insert(
                        id: const Uuid().v4(),
                        todoId: todo.id,
                        userId: 0, // Current user
                        encryptedBlob: val,
                      ));
                }
              },
            ),
            const SizedBox(height: 24),
            Text('Anhänge', style: Theme.of(context).textTheme.titleLarge),
            const Divider(),
            ref.watch(watchAttachmentsProvider(todo.id)).when(
                  data: (attachments) => Wrap(
                    spacing: 8,
                    children: attachments
                        .map((a) => Chip(
                              label: Text(a.filePath.split('/').last),
                              onDeleted: () {
                                // Delete attachment logic
                              },
                            ))
                        .toList(),
                  ),
                  loading: () => const CircularProgressIndicator(),
                  error: (e, s) => Text('Fehler: $e'),
                ),
            ElevatedButton.icon(
              icon: const Icon(Icons.attach_file),
              label: const Text('Datei anhängen'),
              onPressed: () {
                // TODO: Implement file picker
              },
            ),
          ],
        ),
      ),
    );
  }
}
