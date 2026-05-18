import 'package:flutter_test/flutter_test.dart';
import 'package:arch_academy/main.dart';
import 'package:arch_academy/features/onboarding/presentation/pages/onboarding_page.dart';

void main() {
  testWidgets('App starts with OnboardingPage smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ArchAcademyApp());

    // Verify that OnboardingPage placeholder is rendered.
    expect(find.byType(OnboardingPage), findsOneWidget);
    expect(find.text('Onboarding Page Placeholder'), findsOneWidget);
  });
}
