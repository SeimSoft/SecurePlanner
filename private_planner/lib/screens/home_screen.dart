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

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final height = MediaQuery.of(context).size.height;
    final isCompactHeight = height < 600;
    // Native titlebar hidden state comes from the Windows runner; combine with
    // the height threshold as a fallback for platforms without native messages.
    final nativeTitlebarHidden = ref.watch(titlebarHiddenProvider);
    final isTitlebarHidden = nativeTitlebarHidden || height <= 220;
    final isDesktop = MediaQuery.of(context).size.width > 800;

    final selectedCategory = ref.watch(selectedCategoryProvider);
    final todosStream = ref.watch(watchTodosWithCategoryProvider(selectedCategory));
    final categoriesAsync = ref.watch(watchCategoriesProvider);
    final selectedTodoId = ref.watch(selectedTodoIdProvider);

    return Scaffold(
      appBar: isTitlebarHidden
          ? null
          : AppBar(
              title: const Text('Secure Planner'),
              actions: [
          PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == 'import_jira') {
                // simple dialog to collect URL + optional save creds
                await showDialog<void>(
                  context: context,
                  builder: (context) => const JiraImportDialog(),
                );
              }
            },
            itemBuilder: (context) => [const PopupMenuItem(value: 'import_jira', child: Text('Import from JIRA'))],
          ),
              ],
            ),
      body: LayoutBuilder(builder: (context, constraints) {

        // Initialize method channel listener once for Windows so native runner
        // can inform us about compact/borderless titlebar state.
        if (Platform.isWindows) {
          useEffect(() {
            final channel = const MethodChannel('window_state');
            channel.setMethodCallHandler((call) async {
              if (call.method == 'titlebarHidden') {
                final val = call.arguments as bool? ?? false;
                ref.read(titlebarHiddenProvider.notifier).state = val;
              }
              return null;
            });
            return () {
              channel.setMethodCallHandler(null);
            };
          }, const []);
        }
        if (constraints.maxWidth > 1000) {
          return Row(
            children: [
              Expanded(
                flex: 1,
                child: TodoListView(
                  todosStream: todosStream,
                  categoriesAsync: categoriesAsync,
                  isCompactHeight: isCompactHeight,
                  isDesktop: true,
                  selectedTodoId: selectedTodoId,
                ),
              ),
              const VerticalDivider(width: 1),
              Expanded(
                flex: 2,
                child: selectedTodoId == null
                    ? const Center(child: Text('Wähle ein Todo aus, um Details zu sehen'))
                    : const Center(child: Text('Todo detail (embedded)')),
              ),
            ],
          );
        }

        return TodoListView(
          todosStream: todosStream,
          categoriesAsync: categoriesAsync,
          isCompactHeight: isCompactHeight,
          isDesktop: false,
          selectedTodoId: selectedTodoId,
        );
      }),
      floatingActionButton: isCompactHeight || ref.watch(isDraggingTodoProvider) ? null : FloatingActionButton(
        onPressed: () => showDialog(context: context, builder: (_) => const AddTodoDialog()),
        child: const Icon(Icons.add),
      ),
    );
  }
}
