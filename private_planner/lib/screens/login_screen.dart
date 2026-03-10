import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:private_planner/services/auth_service.dart';
import 'package:private_planner/screens/qr_scan_screen.dart';

class LoginScreen extends HookConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usernameController = useTextEditingController();
    final passwordController = useTextEditingController();
    final isLoading = useState(false);

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.lock_outline, size: 80, color: Colors.indigo),
              const SizedBox(height: 24),
              Text(
                'Mit Server verbinden',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Gib deine Zugangsdaten ein oder scanne einen QR-Code vom Administrator.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(
                  labelText: 'Benutzername',
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Passwort',
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: isLoading.value
                    ? null
                    : () async {
                        isLoading.value = true;
                        try {
                          await ref.read(authServiceProvider).login(
                                usernameController.text,
                                passwordController.text,
                              );
                          if (context.mounted) {
                            Navigator.of(context).pushReplacementNamed('/home');
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('Login fehlgeschlagen: $e')),
                            );
                          }
                        } finally {
                          isLoading.value = false;
                        }
                      },
                child: isLoading.value
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Anmelden'),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => const QrScanScreen()),
                  );
                },
                icon: const Icon(Icons.qr_code_scanner),
                label: const Text('QR-Code scannen'),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  // Skip to local mode
                  Navigator.of(context).pushReplacementNamed('/home');
                },
                child: const Text('Offline weiter nutzen'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
