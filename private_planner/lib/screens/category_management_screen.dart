import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:private_planner/data/database.dart';
import 'package:private_planner/providers/database_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart' hide Column;

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
              trailing: Switch(
                value: cat.syncToServer,
                onChanged: (val) {
                  db.insertCategory(cat.copyWith(syncToServer: val));
                },
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
}

final watchCategoriesProvider = StreamProvider((ref) {
  return ref.watch(databaseProvider).watchAllCategories();
});
