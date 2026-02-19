import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sleepwise/widgets/bounce_tap.dart';
import '../helpers/localized_app.dart';

void main() {
  group('BounceTap', () {
    testWidgets('renders child', (tester) async {
      await tester.pumpWidget(localizedApp(
        home: const Scaffold(
          body: Center(
            child: BounceTap(
              child: Text('Bouncy'),
            ),
          ),
        ),
      ));
      expect(find.text('Bouncy'), findsOneWidget);
    });

    testWidgets('calls onTap callback', (tester) async {
      var tapped = false;
      await tester.pumpWidget(localizedApp(
        home: Scaffold(
          body: Center(
            child: BounceTap(
              onTap: () => tapped = true,
              child: const Text('Tap'),
            ),
          ),
        ),
      ));

      await tester.tap(find.text('Tap'));
      await tester.pumpAndSettle();
      expect(tapped, true);
    });

    testWidgets('works without onTap', (tester) async {
      await tester.pumpWidget(localizedApp(
        home: const Scaffold(
          body: Center(
            child: BounceTap(
              child: Text('No Tap'),
            ),
          ),
        ),
      ));

      // Should not throw when tapped with no callback
      await tester.tap(find.text('No Tap'));
      await tester.pumpAndSettle();
    });

    testWidgets('uses custom scaleDown value', (tester) async {
      await tester.pumpWidget(localizedApp(
        home: Scaffold(
          body: Center(
            child: BounceTap(
              scaleDown: 0.9,
              onTap: () {},
              child: const Text('Custom Scale'),
            ),
          ),
        ),
      ));
      expect(find.text('Custom Scale'), findsOneWidget);
    });

    testWidgets('animation runs on tap down', (tester) async {
      await tester.pumpWidget(localizedApp(
        home: Scaffold(
          body: Center(
            child: BounceTap(
              onTap: () {},
              child: const SizedBox(width: 100, height: 50, child: Text('Animate')),
            ),
          ),
        ),
      ));

      // Start a tap (finger down)
      final gesture = await tester.startGesture(
        tester.getCenter(find.text('Animate')),
      );
      await tester.pump(const Duration(milliseconds: 50));

      // BounceTap wraps its child in a ScaleTransition
      expect(find.byType(ScaleTransition), findsAtLeast(1));

      // Release
      await gesture.up();
      await tester.pumpAndSettle();
    });
  });
}
