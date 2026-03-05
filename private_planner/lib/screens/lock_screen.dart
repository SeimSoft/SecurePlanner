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
                }
              },
              child: const Text('Jetzt entsperren'),
            ),
          ],
        ),
      ),
    );
  }
}
