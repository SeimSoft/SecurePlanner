import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:private_planner/services/jira_service.dart';
import 'package:drift/drift.dart' show Value;
import 'package:private_planner/providers/database_provider.dart';
import 'package:private_planner/data/database.dart';
// app_providers not required here
import 'package:uuid/uuid.dart';

class JiraImportDialog extends ConsumerStatefulWidget {
  const JiraImportDialog({super.key});

  @override
  ConsumerState<JiraImportDialog> createState() => _JiraImportDialogState();
}

class _JiraImportDialogState extends ConsumerState<JiraImportDialog> {
  final _urlController = TextEditingController();
  final _userController = TextEditingController();
  final _passController = TextEditingController();
  bool _saveCreds = false;
  bool _loading = false;

  @override
  void dispose() {
    _urlController.dispose();
    _userController.dispose();
    _passController.dispose();
    super.dispose();
  }

  Future<void> _onImport() async {
    final url = _urlController.text.trim();
    final user = _userController.text.trim();
    final pass = _passController.text;
    if (url.isEmpty) return;
    setState(() => _loading = true);
    try {
      final issue = await JiraService.fetchIssueFromUrl(url, user, pass);

      final db = ref.read(databaseProvider);
      final newId = const Uuid().v4();
      await db.into(db.todos).insert(TodosCompanion.insert(
        id: newId,
        encryptedBlob: issue['description'] ?? '',
      ));
      // update optional fields for the newly created row
      await (db.update(db.todos)..where((t) => t.id.equals(newId))).write(TodosCompanion(
        title: Value(issue['summary'] ?? 'JIRA: ${issue['key']}'),
        timeEstimate: const Value(''),
        dueDate: Value(DateTime.now()),
      ));
      await db.into(db.attachments).insert(AttachmentsCompanion.insert(
        id: const Uuid().v4(),
        todoId: newId,
        userId: 0,
        filePath: url,
        encryptedName: issue['key'] ?? '',
      ));

      if (_saveCreds) {
        await JiraService.storeCredentials(user, pass);
      }

      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Import failed: $e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Import from JIRA'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(controller: _urlController, decoration: const InputDecoration(labelText: 'Issue URL')),
          const SizedBox(height: 8),
          TextField(controller: _userController, decoration: const InputDecoration(labelText: 'Username')),
          const SizedBox(height: 8),
          TextField(controller: _passController, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
          Row(children: [
            Checkbox(value: _saveCreds, onChanged: (v) => setState(() => _saveCreds = v ?? false)),
            const SizedBox(width: 4),
            const Text('Save credentials')
          ])
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel')),
        ElevatedButton(onPressed: _loading ? null : _onImport, child: _loading ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Import')),
      ],
    );
  }
}
