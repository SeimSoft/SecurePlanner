import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'dart:io';
import 'package:private_planner/core/theme/app_theme.dart';
import 'package:private_planner/screens/home_screen.dart';
import 'package:private_planner/screens/login_screen.dart';
import 'package:private_planner/screens/onboarding_screen.dart';
import 'package:private_planner/screens/lock_screen.dart';
import 'package:private_planner/services/security_service.dart';
import 'package:private_planner/providers/app_providers.dart';
import 'package:private_planner/services/auth_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    await windowManager.ensureInitialized();
    WindowOptions windowOptions = const WindowOptions(
      alwaysOnTop: true,
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Private Planner',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SecurityBootstrapper(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}

class SecurityBootstrapper extends ConsumerWidget {
  const SecurityBootstrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final security = ref.watch(securityServiceProvider);
    final isLocked = ref.watch(appLockProvider);

    return FutureBuilder<bool>(
      future: security.isAppSetup(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }

        if (snapshot.data == false) {
          return const OnboardingScreen();
        }

        if (isLocked) {
          return const LockScreen();
        }

        // App is setup and unlocked
        // Decide between Login (if server is configured) and Home
        final auth = ref.watch(authServiceProvider);
        if (auth.baseUrl != null) {
          return const LoginScreen();
        } else {
          return const HomeScreen();
        }
      },
    );
  }
}
