import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:private_planner/data/database.dart';
import 'package:private_planner/providers/database_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:private_planner/providers/app_providers.dart';

class CategoryManagementScreen extends ConsumerWidget {
  const CategoryManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesStream = ref.watch(watchCategoriesProvider);
    final db = ref.read(databaseProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Kategorien verwalten')),
      body: categoriesStream.when(
        data: (cats) => ListView.builder(
          itemCount: cats.length,
          itemBuilder: (context, index) {
            final cat = cats[index];
            return ListTile(
              leading: Icon(Icons.category, color: _parseColor(cat.color)),
              title: Text(cat.name ?? 'Unbenannt'),
              subtitle: Text(cat.syncToServer ? 'Synchronisiert' : 'Nur Lokal'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Switch(
                    value: cat.syncToServer,
                    onChanged: (val) {
                      db.insertCategory(cat.copyWith(
                          syncToServer: val, version: cat.version + 1));
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => _showEditCategoryDialog(context, db, cat),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      await db.update(db.categories).replace(cat.copyWith(
                          deleted: true, version: cat.version + 1));
                    },
                  ),
                ],
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Fehler: $e')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddCategoryDialog(context, db),
        child: const Icon(Icons.add),
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

  void _showAddCategoryDialog(BuildContext context, AppDatabase db) {
    final nameController = TextEditingController();
    bool syncToServer = true;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Neue Kategorie'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              SwitchListTile(
                title: const Text('Mit NAS synchronisieren'),
                value: syncToServer,
                onChanged: (val) => setState(() => syncToServer = val),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Abbrechen'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty) {
                  db.insertCategory(CategoriesCompanion.insert(
                    id: const Uuid().v4(),
                    name: Value(nameController.text),
                    syncToServer: Value(syncToServer),
                    color: const Value('#3498db'), // Default blue
                  ));
                  Navigator.pop(context);
                }
              },
              child: const Text('Erstellen'),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditCategoryDialog(
      BuildContext context, AppDatabase db, Category cat) {
    final nameController = TextEditingController(text: cat.name);
    bool syncToServer = cat.syncToServer;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Kategorie bearbeiten'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              SwitchListTile(
                title: const Text('Mit NAS synchronisieren'),
                value: syncToServer,
                onChanged: (val) => setState(() => syncToServer = val),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Abbrechen'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.isNotEmpty) {
                  final newName = nameController.text.trim();
                  await db.update(db.categories).replace(cat.copyWith(
                        name: Value(newName.isEmpty ? null : newName),
                        syncToServer: syncToServer,
                        version: cat.version + 1,
                      ));
                  if (context.mounted) Navigator.pop(context);
                }
              },
              child: const Text('Speichern'),
            ),
          ],
        ),
      ),
    );
  }
}
