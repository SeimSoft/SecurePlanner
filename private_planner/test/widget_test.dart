import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:private_planner/main.dart';
import 'package:private_planner/screens/onboarding_screen.dart';
import 'package:private_planner/services/security_service.dart';

class MockSecurityService extends SecurityService {
  @override
  Future<bool> isAppSetup() async => false;
}

void main() {
  testWidgets('App starts with onboarding when not setup',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          securityServiceProvider.overrideWithValue(MockSecurityService()),
        ],
        child: const MyApp(),
      ),
    );

    await tester.pump();
    await tester
        .pump(const Duration(milliseconds: 100)); // Give it time to settle

    expect(find.byType(OnboardingScreen), findsOneWidget);
  });
}
