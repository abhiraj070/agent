import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:aaraam/app.dart';
import 'package:aaraam/application/providers.dart';

void main() {
  testWidgets('App boots to the splash screen', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final sharedPreferences = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(sharedPreferences),
        ],
        child: const AaraamApp(),
      ),
    );

    // AppStageController starts on the splash stage.
    expect(find.text('Aaraam'), findsOneWidget);

    // Its bootstrap timer resolves after 900ms; with no local
    // "onboarded" flag set, that lands on onboarding's welcome step —
    // this must be pumped out fully (not left pending) or the test
    // framework flags a leaked timer on teardown.
    await tester.pump(const Duration(milliseconds: 950));
    expect(find.text('Begin'), findsOneWidget);
  });
}
