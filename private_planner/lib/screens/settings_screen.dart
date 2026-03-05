import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:private_planner/services/auth_service.dart';

class SettingsScreen extends HookConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final encryptionPasswordController = useTextEditingController();
    const storage = FlutterSecureStorage();
    final authService = ref.watch(authServiceProvider);

    useEffect(() {
      storage.read(key: 'encryption_password').then((value) {
        if (value != null) encryptionPasswordController.text = value;
      });
      return null;
    }, []);

    return Scaffold(
      appBar: AppBar(title: const Text('Einstellungen')),
      body: FutureBuilder<String?>(
        future: authService.baseUrlAsync,
        builder: (context, snapshot) {
          final serverUrl = snapshot.data;

          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              const Text(
                'Server Verbindung',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(serverUrl ?? 'Lokaler Modus',
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text(serverUrl != null
                    ? 'Verbunden'
                    : 'Kein Server konfiguriert'),
                leading: Icon(
                    serverUrl != null ? Icons.cloud_done : Icons.cloud_off,
                    color: serverUrl != null ? Colors.green : Colors.grey),
              ),
              if (serverUrl != null) ...[
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Verbindung trennen?'),
                        content: const Text(
                            'Möchten Sie die Verbindung zum Server wirklich trennen? Ihre Daten bleiben lokal erhalten.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Abbrechen'),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context, true),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red),
                            child: const Text('Trennen',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    );

                    if (confirm == true) {
                      await authService.disconnect();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Verbindung vom Server getrennt')),
                        );
                        Navigator.pop(context); // Optional: Pop settings screen
                      }
                    }
                  },
                  icon: const Icon(Icons.link_off, color: Colors.white),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  label: const Text('Vom Server trennen',
                      style: TextStyle(color: Colors.white)),
                ),
              ],
              const SizedBox(height: 32),
              const Divider(),
              const SizedBox(height: 32),
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
            ],
          );
        },
      ),
    );
  }
}
