import 'package:flutter/material.dart';

class JiraImportDialog extends StatefulWidget {
  const JiraImportDialog({super.key});

  @override
  State<JiraImportDialog> createState() => _JiraImportDialogState();
}

class _JiraImportDialogState extends State<JiraImportDialog> {
  final _urlController = TextEditingController();

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Import from JIRA'),
      content: TextField(controller: _urlController, decoration: const InputDecoration(labelText: 'Issue URL')),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
        ElevatedButton(onPressed: () => Navigator.of(context).pop(), child: const Text('OK')),
      ],
    );
  }
}
