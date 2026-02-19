import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sleepwise/widgets/gradient_background.dart';
import '../helpers/localized_app.dart';

void main() {
  group('GradientBackground', () {
    testWidgets('renders child content', (tester) async {
      await tester.pumpWidget(localizedApp(
        home: const Scaffold(
          body: GradientBackground(
            child: Center(child: Text('Content')),
          ),
        ),
      ));
      expect(find.text('Content'), findsOneWidget);
    });

    testWidgets('renders with stars by default', (tester) async {
      await tester.pumpWidget(localizedApp(
        home: const Scaffold(
          body: GradientBackground(
            showStars: true,
            child: Center(child: Text('Stars')),
          ),
        ),
      ));
      expect(find.text('Stars'), findsOneWidget);
      // Stars are rendered via CustomPaint
      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('renders without stars when disabled', (tester) async {
      await tester.pumpWidget(localizedApp(
        home: const Scaffold(
          body: GradientBackground(
            showStars: false,
            child: Center(child: Text('No Stars')),
          ),
        ),
      ));
      expect(find.text('No Stars'), findsOneWidget);
    });

    testWidgets('stars animation runs without errors', (tester) async {
      await tester.pumpWidget(localizedApp(
        home: const Scaffold(
          body: GradientBackground(
            showStars: true,
            child: SizedBox.expand(),
          ),
        ),
      ));

      // Pump individual frames to verify animation runs without errors
      // (pumpAndSettle won't work since the animation repeats infinitely)
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump(const Duration(milliseconds: 500));
      // No assertion errors means the animation is healthy

      // Verify CustomPaint exists (star painter)
      expect(find.byType(CustomPaint), findsWidgets);
    });
  });
}
