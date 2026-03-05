import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SettingsScreen extends HookConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final encryptionPasswordController = useTextEditingController();
    const storage = FlutterSecureStorage();

    useEffect(() {
      storage.read(key: 'encryption_password').then((value) {
        if (value != null) encryptionPasswordController.text = value;
      });
      return null;
    }, []);

    return Scaffold(
      appBar: AppBar(title: const Text('Einstellungen')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text(
            'Sicherheit',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: encryptionPasswordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Verschlüsselungs-Passwort',
              helperText:
                  'Dieses Passwort wird zur End-to-End Verschlüsselung genutzt.',
              prefixIcon: Icon(Icons.enhanced_encryption),
            ),
            onChanged: (value) async {
              await storage.write(key: 'encryption_password', value: value);
            },
          ),
          const SizedBox(height: 32),
          const Divider(),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {
              // Trigger sync manually
            },
            icon: const Icon(Icons.sync),
            label: const Text('Jetzt synchronisieren'),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () {
              // Logout
            },
            icon: const Icon(Icons.logout),
            label: const Text('Abmelden'),
            style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
          ),
        ],
      ),
    );
  }
}
