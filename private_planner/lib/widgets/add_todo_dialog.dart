import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:private_planner/data/database.dart';
import 'package:private_planner/providers/database_provider.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:private_planner/providers/app_providers.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class AddTodoDialog extends ConsumerStatefulWidget {
  const AddTodoDialog({super.key});

  @override
  ConsumerState<AddTodoDialog> createState() => _AddTodoDialogState();
}

class _AddTodoDialogState extends ConsumerState<AddTodoDialog> {
  final _titleController = TextEditingController();
  final _timeEstimateController = TextEditingController();
  int _priority = 0;
  DateTime? _dueDate;
  String? _selectedCategoryId;

  @override
  void dispose() {
    _titleController.dispose();
    _timeEstimateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(watchCategoriesProvider);

    return AlertDialog(
      title: const Text('Neues Todo'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Titel'),
              autofocus: true,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
              initialValue: _priority,
              decoration: const InputDecoration(labelText: 'Priorität'),
              items: const [
                DropdownMenuItem(value: 0, child: Text('Niedrig')),
                DropdownMenuItem(value: 1, child: Text('Mittel')),
                DropdownMenuItem(value: 2, child: Text('Hoch')),
              ],
              onChanged: (val) {
                if (val != null) {
                  setState(() => _priority = val);
                }
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _timeEstimateController,
              decoration:
                  const InputDecoration(labelText: 'Geschätzte Zeit (z.B. 2h)'),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _dueDate == null
                        ? 'Kein Fälligkeitsdatum'
                        : 'Fällig: ${DateFormat('dd.MM.yyyy').format(_dueDate!)}',
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 3650)),
                    );
                    if (date != null) {
                      setState(() => _dueDate = date);
                    }
                  },
                  child: const Text('Wählen'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            categoriesAsync.when(
              data: (categories) => DropdownButtonFormField<String?>(
                initialValue: _selectedCategoryId,
                decoration: const InputDecoration(labelText: 'Kategorie'),
                items: [
                  const DropdownMenuItem(
                      value: null, child: Text('Keine Kategorie')),
                  ...categories.map(
                    (c) => DropdownMenuItem(
                        value: c.id, child: Text(c.name ?? '')),
                  ),
                ],
                onChanged: (val) {
                  setState(() => _selectedCategoryId = val);
                },
              ),
              loading: () => const CircularProgressIndicator(),
              error: (e, s) => const Text('Fehler beim Laden der Kategorien'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Abbrechen'),
        ),
        ElevatedButton(
          onPressed: () async {
            if (_titleController.text.trim().isEmpty) return;

            final db = ref.read(databaseProvider);
            final newTodo = TodosCompanion.insert(
              id: const Uuid().v4(),
              title: Value(_titleController.text.trim()),
              priority: Value(_priority),
              timeEstimate: Value(_timeEstimateController.text.trim()),
              dueDate: Value(_dueDate),
              categoryId: Value(_selectedCategoryId),
              encryptedBlob:
                  'local', // Placeholder, will be overwritten on sync if needed
              status: const Value('Backlog'),
            );

            await db.insertTodo(newTodo);

            if (context.mounted) {
              Navigator.pop(context);
            }
          },
          child: const Text('Speichern'),
        ),
      ],
    );
  }
}
