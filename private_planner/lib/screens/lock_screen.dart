import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:private_planner/services/security_service.dart';
import 'package:private_planner/providers/app_providers.dart';

class LockScreen extends HookConsumerWidget {
  const LockScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final security = ref.watch(securityServiceProvider);

    useEffect(() {
      Future.microtask(() async {
        if (await security.shouldPromptBiometrics()) {
          final authenticated = await security.authenticate();
          if (authenticated) {
            ref.read(appLockProvider.notifier).unlock();
          }
        }
      });
      return null;
    }, []);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock_person, size: 80, color: Colors.indigo),
            const SizedBox(height: 24),
            const Text('App gesperrt',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () async {
                final authenticated = await security.authenticate();
                if (authenticated) {
                  ref.read(appLockProvider.notifier).unlock();
                } else {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Authentifizierung fehlgeschlagen'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              child: const Text('Jetzt entsperren'),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                _showPasswordDialog(context, ref, security);
              },
              child: const Text('Mit Passwort entsperren'),
            ),
          ],
        ),
      ),
    );
  }

  void _showPasswordDialog(
      BuildContext context, WidgetRef ref, SecurityService security) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Master Key eingeben'),
        content: TextField(
          controller: controller,
          obscureText: true,
          decoration: const InputDecoration(labelText: 'Passwort'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Abbrechen'),
          ),
          ElevatedButton(
            onPressed: () async {
              final ok = await security.verifyPassword(controller.text);
              if (ok) {
                if (context.mounted) {
                  Navigator.pop(context);
                  ref.read(appLockProvider.notifier).unlock();
                }
              } else {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Falsches Passwort'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text('Entsperren'),
          ),
        ],
      ),
    );
  }
}
