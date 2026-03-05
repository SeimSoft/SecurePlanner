import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:private_planner/services/auth_service.dart';

final serverUrlProvider =
    StateProvider<String>((ref) => 'http://localhost:8080');

class LoginScreen extends HookConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usernameController = useTextEditingController();
    final passwordController = useTextEditingController();
    final serverUrlController =
        useTextEditingController(text: ref.read(serverUrlProvider));
    final isRegister = useState(false);
    final isLoading = useState(false);

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                isRegister.value
                    ? 'Neues Konto erstellen'
                    : 'Willkommen zurück',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Bitte melde dich an, um fortzufahren',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              TextField(
                controller: serverUrlController,
                decoration: const InputDecoration(
                  labelText: 'Server URL',
                  prefixIcon: Icon(Icons.dns),
                ),
              ),
              const SizedBox(height: 16),
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
                          final authService = ref.read(authServiceProvider);
                          authService.baseUrl = serverUrlController.text;
                          ref.read(serverUrlProvider.notifier).state =
                              serverUrlController.text;

                          if (isRegister.value) {
                            await authService.register(usernameController.text,
                                passwordController.text);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'Registrierung erfolgreich! Bitte einloggen.')),
                            );
                            isRegister.value = false;
                          } else {
                            await authService.login(usernameController.text,
                                passwordController.text);
                            // Navigate to Home
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Fehler: ${e.toString()}')),
                          );
                        } finally {
                          isLoading.value = false;
                        }
                      },
                child: isLoading.value
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(isRegister.value ? 'Registrieren' : 'Anmelden'),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => isRegister.value = !isRegister.value,
                child: Text(isRegister.value
                    ? 'Bereits ein Konto? Hier anmelden'
                    : 'Noch kein Konto? Jetzt registrieren'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
