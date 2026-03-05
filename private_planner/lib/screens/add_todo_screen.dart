import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:private_planner/data/database.dart';
import 'package:private_planner/models/todo.dart';
import 'package:private_planner/providers/database_provider.dart';
import 'package:private_planner/providers/app_providers.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart' hide Column;

class AddTodoScreen extends HookConsumerWidget {
  const AddTodoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titleController = useTextEditingController();
    final estimateController = useTextEditingController();
    final dueDate = useState<DateTime>(DateTime.now());
    final priority = useState<TodoPriority>(TodoPriority.medium);
    final selectedCategory = useState<String?>(null);

    return Scaffold(
      appBar: AppBar(title: const Text('Neues Todo')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Titel'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: estimateController,
              decoration:
                  const InputDecoration(labelText: 'Zeitaufwand (z.B. 2h)'),
            ),
            const SizedBox(height: 24),
            ListTile(
              title: const Text('Fälligkeitsdatum'),
              subtitle: Text(DateFormat('dd.MM.yyyy').format(dueDate.value)),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: dueDate.value,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (date != null) dueDate.value = date;
              },
            ),
            const SizedBox(height: 16),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Kategorie',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 8),
            ref.watch(watchCategoriesProvider).when(
                  data: (cats) => DropdownButtonFormField<String>(
                    value: selectedCategory.value,
                    decoration:
                        const InputDecoration(border: OutlineInputBorder()),
                    items: cats
                        .map((c) => DropdownMenuItem(
                              value: c.id,
                              child: Text(c.name ?? 'Unbenannt'),
                            ))
                        .toList(),
                    onChanged: (val) => selectedCategory.value = val,
                  ),
                  loading: () => const CircularProgressIndicator(),
                  error: (e, s) => Text('Fehler: $e'),
                ),
            const SizedBox(height: 24),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Priorität',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 8),
            SegmentedButton<TodoPriority>(
              segments: const [
                ButtonSegment(value: TodoPriority.low, label: Text('Niedrig')),
                ButtonSegment(
                    value: TodoPriority.medium, label: Text('Mittel')),
                ButtonSegment(value: TodoPriority.high, label: Text('Hoch')),
              ],
              selected: {priority.value},
              onSelectionChanged: (val) => priority.value = val.first,
            ),
            const SizedBox(height: 48),
            ElevatedButton(
              onPressed: () async {
                if (titleController.text.isEmpty) return;

                final db = ref.read(databaseProvider);
                await db.insertTodo(TodosCompanion.insert(
                  id: const Uuid().v4(),
                  title: Value(titleController.text),
                  priority: Value(priority.value.index),
                  timeEstimate: Value(estimateController.text),
                  dueDate: Value(dueDate.value),
                  categoryId: Value(selectedCategory.value),
                  encryptedBlob:
                      '', // TODO: Encrypt fields here or in SyncService
                ));

                if (context.mounted) Navigator.pop(context);
              },
              child: const Text('Speichern'),
            ),
          ],
        ),
      ),
    );
  }
}
