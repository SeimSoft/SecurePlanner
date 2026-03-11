import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:private_planner/services/auth_service.dart';
import 'package:private_planner/services/security_service.dart';
import 'package:private_planner/services/user_service.dart';
import 'package:private_planner/providers/database_provider.dart';
import 'package:private_planner/screens/qr_scan_screen.dart';

class SettingsScreen extends HookConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final encryptionPasswordController = useTextEditingController();
    const storage = FlutterSecureStorage();
    final authService = ref.watch(authServiceProvider);
    final userService = ref.watch(userServiceProvider);
    final db = ref.watch(databaseProvider);
    final usersStream = useMemoized(() => db.watchUsers());
    final usersAsync = useStream(usersStream);

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
              ] else ...[
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const QrScanScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.qr_code_scanner),
                  label: const Text('QR-Code scannen'),
                ),
              ],
              if (serverUrl != null) ...[
                const SizedBox(height: 32),
                const Divider(),
                const SizedBox(height: 32),
                const Text(
                  'Profil & Haushalt',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                if (usersAsync.hasData) ...[
                  for (final user in usersAsync.data!) ...[
                    ListTile(
                      leading: CircleAvatar(
                        backgroundImage: user.profilePicturePath != null
                            ? NetworkImage(
                                '$serverUrl/${user.profilePicturePath}')
                            : null,
                        child: user.profilePicturePath == null
                            ? Text(user.username.substring(0, 1).toUpperCase())
                            : null,
                      ),
                      title: Text(user.username),
                      subtitle: const Text('Haushaltsmitglied'),
                      trailing: IconButton(
                        icon: const Icon(Icons.photo_camera),
                        onPressed: () async {
                          final picker = ImagePicker();
                          final image = await picker.pickImage(
                              source: ImageSource.gallery);
                          if (image != null) {
                            try {
                              await userService
                                  .uploadProfilePicture(File(image.path));
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Profilbild aktualisiert')),
                              );
                            } catch (e) {
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Fehler: $e')),
                              );
                            }
                          }
                        },
                      ),
                    ),
                  ],
                ],
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () async {
                        try {
                          final token = await userService.createHousehold();
                          if (token != null && context.mounted) {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Haushalt QR-Code'),
                                content: SizedBox(
                                  width: 200,
                                  height: 200,
                                  child: QrImageView(
                                    data: '{"household_token": "$token"}',
                                    version: QrVersions.auto,
                                    size: 200.0,
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Schließen'),
                                  ),
                                ],
                              ),
                            );
                          }
                        } catch (e) {
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Fehler beim Erstellen: $e')),
                          );
                        }
                      },
                      icon: const Icon(Icons.qr_code),
                      label: const Text('QR erstellen'),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const QrScanScreen(isHousehold: true),
                          ),
                        );
                      },
                      icon: const Icon(Icons.qr_code_scanner),
                      label: const Text('Haushalt beitreten'),
                    ),
                  ],
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
              FutureBuilder<bool>(
                future: ref.read(securityServiceProvider).shouldPromptBiometrics(),
                builder: (context, snap) {
                  final enabled = snap.data == true;
                  return SwitchListTile(
                    title: const Text('Use biometric login'),
                    subtitle: const Text('Use fingerprint/FaceID where available'),
                    value: enabled,
                    onChanged: (v) async {
                      await ref.read(securityServiceProvider).setUseBiometrics(v);
                      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(v ? 'Biometric login enabled' : 'Biometric login disabled')));
                      // force rebuild to reflect new state
                      (context as Element).markNeedsBuild();
                    },
                  );
                },
              ),
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
