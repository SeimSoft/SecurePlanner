import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:private_planner/services/security_service.dart';

class OnboardingScreen extends HookConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final passwordController = useTextEditingController();
    final confirmController = useTextEditingController();
    final security = ref.watch(securityServiceProvider);
    final isSubmitting = useState(false);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.security, size: 80, color: Colors.indigo),
              const SizedBox(height: 24),
              Text(
                'Willkommen beim Private Planner',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'Deine Daten werden lokal verschlüsselt. Bitte lege ein Master-Passwort fest.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Master Passwort',
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: confirmController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Passwort bestätigen',
                  prefixIcon: Icon(Icons.lock_outline),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: isSubmitting.value
                    ? null
                    : () async {
                        if (passwordController.text.length < 8) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'Passwort muss mindestens 8 Zeichen lang sein')),
                          );
                          return;
                        }
                        if (passwordController.text != confirmController.text) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Passwörter stimmen nicht überein')),
                          );
                          return;
                        }

                        isSubmitting.value = true;
                        await security.setupMasterKey(passwordController.text);

                        // Check for biometrics
                        final canBio = await security.canUseBiometrics();
                        if (canBio && context.mounted) {
                          final useBio = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Biometrie nutzen?'),
                              content: const Text(
                                  'Möchtest du FaceID/TouchID zum Entsperren nutzen?'),
                              actions: [
                                TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: const Text('Nein')),
                                TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    child: const Text('Ja')),
                              ],
                            ),
                          );
                          if (useBio == true) {
                            await security.setUseBiometrics(true);
                          }
                        }

                        if (context.mounted) {
                          // Setup complete, trigger app restart or state update to show home/login
                          // For now we just replace the route
                          Navigator.of(context).pushReplacementNamed('/');
                        }
                      },
                child: isSubmitting.value
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Setup abschließen'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
