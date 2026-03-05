import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:private_planner/data/database.dart';
import 'package:private_planner/providers/database_provider.dart';
import 'package:private_planner/screens/todo_detail_screen.dart';
import 'package:intl/intl.dart';

class SearchScreen extends HookConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = useTextEditingController();
    final searchQuery = useState('');
    final results = ref.watch(searchTodosProvider(searchQuery.value));

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchController,
          decoration: const InputDecoration(
            hintText: 'Tickets suchen...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white70),
          ),
          style: const TextStyle(color: Colors.white),
          onChanged: (val) => searchQuery.value = val,
        ),
        actions: [
          if (searchQuery.value.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                searchController.clear();
                searchQuery.value = '';
              },
            ),
        ],
      ),
      body: results.when(
        data: (todos) => todos.isEmpty
            ? const Center(child: Text('Keine Ergebnisse'))
            : ListView.builder(
                itemCount: todos.length,
                itemBuilder: (context, index) {
                  final todo = todos[index];
                  return ListTile(
                    title: Text(todo.title ?? 'Unbenannt'),
                    subtitle: Text('Status: ${todo.status}'),
                    trailing: todo.dueDate != null
                        ? Text(DateFormat('dd.MM.yyyy').format(todo.dueDate!))
                        : null,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TodoDetailScreen(todo: todo),
                      ),
                    ),
                  );
                },
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Fehler: $e')),
      ),
    );
  }
}

final searchTodosProvider =
    StreamProvider.family<List<Todo>, String>((ref, query) {
  final db = ref.watch(databaseProvider);
  if (query.isEmpty) return const Stream.empty();
  return db.searchTodos(query);
});
