import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:private_planner/providers/app_providers.dart';
import 'package:private_planner/screens/home/todo_list_view.dart';
import 'package:private_planner/screens/todo_detail_screen.dart';
import 'package:private_planner/screens/home/jira_import_dialog.dart';
import 'package:private_planner/widgets/add_todo_dialog.dart';
import 'package:private_planner/widgets/todo_list_tile.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ── Method channel listener (must be at hook root, NOT inside LayoutBuilder) ──
    useEffect(() {
      if (!Platform.isWindows) return null;
      const channel = MethodChannel('window_state');
      channel.setMethodCallHandler((call) async {
        if (call.method == 'titlebarHidden') {
          final val = call.arguments as bool? ?? false;
          ref.read(titlebarHiddenProvider.notifier).state = val;
        }
        return null;
      });
      return () => channel.setMethodCallHandler(null);
    }, const []);

    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    // Native titlebar hidden state ORed with height threshold.
    final nativeTitlebarHidden = ref.watch(titlebarHiddenProvider);
    final isCompact = nativeTitlebarHidden || height <= 220;

    // ── TIER 1: Very small / borderless → show single in-progress todo ──
    if (isCompact) {
      return _CompactSingleTodoView();
    }

    final isMobile = width < 800;

    final selectedCategory = ref.watch(selectedCategoryProvider);
    final todosStream =
        ref.watch(watchTodosWithCategoryProvider(selectedCategory));
    final categoriesAsync = ref.watch(watchCategoriesProvider);
    final selectedTodoId = ref.watch(selectedTodoIdProvider);

    // ── TIER 2: Mid-sized / mobile → master list only ──
    if (isMobile) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Secure Planner'),
          actions: [_jiraMenuButton(context)],
        ),
        body: TodoListView(
          todosStream: todosStream,
          categoriesAsync: categoriesAsync,
          isCompactHeight: false,
          isDesktop: false,
          selectedTodoId: selectedTodoId,
        ),
        floatingActionButton: ref.watch(isDraggingTodoProvider)
            ? null
            : FloatingActionButton(
                onPressed: () => showDialog(
                    context: context,
                    builder: (_) => const AddTodoDialog()),
                child: const Icon(Icons.add),
              ),
      );
    }

    // ── TIER 3: Large / desktop → master-detail ──
    return Scaffold(
      appBar: AppBar(
        title: const Text('Secure Planner'),
        actions: [_jiraMenuButton(context)],
      ),
      body: Row(
        children: [
          SizedBox(
            width: 360,
            child: TodoListView(
              todosStream: todosStream,
              categoriesAsync: categoriesAsync,
              isCompactHeight: false,
              isDesktop: true,
              selectedTodoId: selectedTodoId,
            ),
          ),
          const VerticalDivider(width: 1),
          Expanded(
            child: _DetailPane(selectedTodoId: selectedTodoId, ref: ref),
          ),
        ],
      ),
      floatingActionButton: ref.watch(isDraggingTodoProvider)
          ? null
          : FloatingActionButton(
              onPressed: () => showDialog(
                  context: context, builder: (_) => const AddTodoDialog()),
              child: const Icon(Icons.add),
            ),
    );
  }

  /// JIRA import menu entry – extracted to avoid duplication.
  Widget _jiraMenuButton(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) async {
        if (value == 'import_jira') {
          await showDialog<void>(
            context: context,
            builder: (context) => const JiraImportDialog(),
          );
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
            value: 'import_jira', child: Text('Import from JIRA')),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Detail pane used in master-detail tier
// ─────────────────────────────────────────────────────────────────────────────
class _DetailPane extends ConsumerWidget {
  final String? selectedTodoId;
  final WidgetRef ref;

  const _DetailPane({required this.selectedTodoId, required this.ref});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (selectedTodoId == null) {
      return const Center(
          child: Text('Wähle ein Todo aus, um Details zu sehen'));
    }
    // Grab the actual Todo from the stream and render TodoDetailScreen.
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final todosAsync =
        ref.watch(watchTodosWithCategoryProvider(selectedCategory));
    return todosAsync.when(
      data: (items) {
        final match = items
            .where((i) => i.todo.id == selectedTodoId)
            .toList();
        if (match.isEmpty) {
          return const Center(child: Text('Todo nicht gefunden'));
        }
        return TodoDetailScreen(todo: match.first.todo, isEmbedded: true);
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Fehler: $e')),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Compact view: shows the first in-progress todo only, transparent scaffold,
// no AppBar, no window border. The native runner already handles
// WM_NCHITTEST for drag & resize when the titlebar is hidden.
// ─────────────────────────────────────────────────────────────────────────────
class _CompactSingleTodoView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final todosAsync =
        ref.watch(watchTodosWithCategoryProvider(selectedCategory));

    return Scaffold(
      body: todosAsync.when(
        data: (items) {
          // Find the first todo with status "In Progress"
          final inProgress =
              items.where((i) => i.todo.status == 'In Progress').toList();
          if (inProgress.isEmpty) {
            return Center(
              child: Opacity(
                opacity: 0.7,
                child: Text(
                  'No in-progress todos',
                  style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                ),
              ),
            );
          }
          final item = inProgress.first;
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: TodoListTile(todo: item.todo, category: item.category),
          );
        },
        loading: () => const Center(
            child: SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2))),
        error: (e, _) => Center(
            child: Text('$e',
                style: const TextStyle(color: Colors.red, fontSize: 10))),
      ),
    );
  }
}
