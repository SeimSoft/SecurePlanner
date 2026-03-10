import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:private_planner/data/database.dart';
import 'package:private_planner/providers/database_provider.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:uuid/uuid.dart';
import 'package:private_planner/providers/app_providers.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:desktop_drop/desktop_drop.dart';

class TodoDetailScreen extends HookConsumerWidget {
  final Todo todo;
  final bool isEmbedded;

  const TodoDetailScreen(
      {super.key, required this.todo, this.isEmbedded = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(databaseProvider);
    final isDragging = useState(false);
    final isEditing = useState(false);
    final statusList = ['Backlog', 'In Progress', 'Review', 'Done'];
    final usersAsync = ref.watch(watchUsersProvider);
    final categoriesAsync = ref.watch(watchCategoriesProvider);

    final category = categoriesAsync.value?.firstWhere(
      (c) => c.id == todo.categoryId,
      orElse: () => categoriesAsync.value!.first,
    );
    final isShared = category?.sharedWithHousehold == true;
    final assigneeName = todo.ownerId == null
        ? 'Niemand'
        : (usersAsync.value?.any((u) => u.id == todo.ownerId) == true
            ? usersAsync.value!.firstWhere((u) => u.id == todo.ownerId).username
            : 'Unbekannt');

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: !isEmbedded,
        title: GestureDetector(
          onTap: isEditing.value
              ? () {
                  _showEditTitleDialog(context, db);
                }
              : null,
          child: Row(
            children: [
              Expanded(
                  child: Text(todo.title ?? 'Ticket Details',
                      overflow: TextOverflow.ellipsis)),
              if (isEditing.value) const Icon(Icons.edit, size: 16),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(isEditing.value ? Icons.check : Icons.edit),
            onPressed: () {
              isEditing.value = !isEditing.value;
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              await db.update(db.todos).replace(
                  todo.copyWith(deleted: true, version: todo.version + 1));
              if (context.mounted && !isEmbedded) {
                Navigator.of(context).pop();
              } else if (isEmbedded) {
                ref.read(selectedTodoIdProvider.notifier).state = null;
              }
            },
          ),
        ],
      ),
      body: DropTarget(
        onDragEntered: (details) {
          isDragging.value = true;
        },
        onDragExited: (details) {
          isDragging.value = false;
        },
        onDragDone: (details) async {
          isDragging.value = false;
          for (final file in details.files) {
            // Here you would eventually encrypt and store the file
            // For now, we'll just insert a local attachment record placeholder
            await db.into(db.attachments).insert(AttachmentsCompanion.insert(
                  id: const Uuid().v4(),
                  todoId: todo.id,
                  userId: 0,
                  filePath: file.path,
                  encryptedName: file.name,
                ));
          }
        },
        child: Container(
          color: isDragging.value
              ? Theme.of(context).primaryColor.withValues(alpha: 0.1)
              : null,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: isEditing.value
                          ? DropdownButtonFormField<String>(
                              initialValue: todo.status,
                              decoration:
                                  const InputDecoration(labelText: 'Status'),
                              items: statusList
                                  .map((s) => DropdownMenuItem(
                                      value: s, child: Text(s)))
                                  .toList(),
                              onChanged: (val) async {
                                if (val != null) {
                                  await db.update(db.todos).replace(
                                      todo.copyWith(
                                          status: val,
                                          version: todo.version + 1));
                                }
                              },
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Status',
                                    style:
                                        Theme.of(context).textTheme.bodySmall),
                                Text(todo.status,
                                    style:
                                        Theme.of(context).textTheme.bodyLarge),
                              ],
                            ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: isEditing.value
                          ? DropdownButtonFormField<int>(
                              initialValue: todo.priority ?? 0,
                              decoration:
                                  const InputDecoration(labelText: 'Priorität'),
                              items: const [
                                DropdownMenuItem(
                                    value: 0, child: Text('Niedrig')),
                                DropdownMenuItem(
                                    value: 1, child: Text('Mittel')),
                                DropdownMenuItem(value: 2, child: Text('Hoch')),
                              ],
                              onChanged: (val) async {
                                if (val != null) {
                                  await db.update(db.todos).replace(
                                      todo.copyWith(
                                          priority: Value(val),
                                          version: todo.version + 1));
                                }
                              },
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Priorität',
                                    style:
                                        Theme.of(context).textTheme.bodySmall),
                                Text(
                                    todo.priority == 2
                                        ? 'Hoch'
                                        : (todo.priority == 1
                                            ? 'Mittel'
                                            : 'Niedrig'),
                                    style:
                                        Theme.of(context).textTheme.bodyLarge),
                              ],
                            ),
                    ),
                  ],
                ),
                if (isShared && usersAsync.hasValue) ...[
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: isEditing.value
                            ? DropdownButtonFormField<int?>(
                                initialValue: todo.ownerId,
                                decoration: const InputDecoration(
                                    labelText: 'Zuweisen an'),
                                items: [
                                  const DropdownMenuItem(
                                      value: null, child: Text('Niemand')),
                                  ...usersAsync.value!.map((u) =>
                                      DropdownMenuItem(
                                          value: u.id,
                                          child: Text(u.username))),
                                ],
                                onChanged: (val) async {
                                  await db.update(db.todos).replace(
                                      todo.copyWith(
                                          ownerId: Value(val),
                                          version: todo.version + 1));
                                },
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Zugeordnet an',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall),
                                  Text(assigneeName,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge),
                                ],
                              ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                          'Fällig: ${todo.dueDate != null ? DateFormat('dd.MM.yyyy').format(todo.dueDate!) : 'Kein Datum'}',
                          style: Theme.of(context).textTheme.bodyLarge),
                    ),
                    if (isEditing.value)
                      TextButton.icon(
                        onPressed: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: todo.dueDate ?? DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate:
                                DateTime.now().add(const Duration(days: 3650)),
                          );
                          if (date != null) {
                            await db.update(db.todos).replace(todo.copyWith(
                                dueDate: Value(date),
                                version: todo.version + 1));
                          }
                        },
                        icon: const Icon(Icons.calendar_today),
                        label: const Text('Ändern'),
                      ),
                  ],
                ),
                const SizedBox(height: 24),
                Text('Kommentare',
                    style: Theme.of(context).textTheme.titleLarge),
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
                if (isEditing.value)
                  TextField(
                    decoration: const InputDecoration(
                      hintText: 'Kommentar hinzufügen...',
                      suffixIcon: Icon(Icons.send),
                    ),
                    onSubmitted: (val) async {
                      if (val.isNotEmpty) {
                        // TODO: Encrypt val
                        await db
                            .into(db.comments)
                            .insert(CommentsCompanion.insert(
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
                            .map((a) => GestureDetector(
                                  onDoubleTap: () async {
                                    try {
                                      // Open URLs with OpenFilex; files will open with default app
                                      await OpenFilex.open(a.filePath);
                                    } catch (e) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text('Kann Datei nicht öffnen: $e')),
                                      );
                                    }
                                  },
                                  child: Chip(
                                    label: Text(a.filePath
                                        .split(RegExp(r'[\\/]+'))
                                        .last),
                                    onDeleted: () async {
                                      await db.attachments.deleteWhere(
                                          (tbl) => tbl.id.equals(a.id));
                                    },
                                  ),
                                ))
                            .toList(),
                      ),
                      loading: () => const CircularProgressIndicator(),
                      error: (e, s) => Text('Fehler: $e'),
                    ),
                if (isEditing.value)
                  ElevatedButton.icon(
                    icon: const Icon(Icons.attach_file),
                    label: const Text('Datei anhängen (oder reinziehen)'),
                    onPressed: () {
                      // TODO: Implement file picker
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showEditTitleDialog(BuildContext context, AppDatabase db) {
    final controller = TextEditingController(text: todo.title);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Titel bearbeiten'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Titel'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Abbrechen'),
          ),
          ElevatedButton(
            onPressed: () async {
              final newTitle = controller.text.trim();
              await db.update(db.todos).replace(todo.copyWith(
                  title: Value(newTitle.isEmpty ? null : newTitle),
                  version: todo.version + 1));
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Speichern'),
          ),
        ],
      ),
    );
  }
}
