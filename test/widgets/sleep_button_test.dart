import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sleepwise/widgets/sleep_button.dart';
import '../helpers/localized_app.dart';

void main() {
  group('SleepButton', () {
    testWidgets('renders label', (tester) async {
      await tester.pumpWidget(localizedApp(
        home: const Scaffold(
          body: Center(child: SleepButton(label: 'Test Button')),
        ),
      ));
      expect(find.text('Test Button'), findsOneWidget);
    });

    testWidgets('primary variant renders', (tester) async {
      await tester.pumpWidget(localizedApp(
        home: Scaffold(
          body: Center(
            child: SleepButton(
              label: 'Primary',
              variant: SleepButtonVariant.primary,
              onPressed: () {},
            ),
          ),
        ),
      ));
      expect(find.text('Primary'), findsOneWidget);
    });

    testWidgets('secondary variant renders', (tester) async {
      await tester.pumpWidget(localizedApp(
        home: Scaffold(
          body: Center(
            child: SleepButton(
              label: 'Secondary',
              variant: SleepButtonVariant.secondary,
              onPressed: () {},
            ),
          ),
        ),
      ));
      expect(find.text('Secondary'), findsOneWidget);
    });

    testWidgets('outline variant renders', (tester) async {
      await tester.pumpWidget(localizedApp(
        home: Scaffold(
          body: Center(
            child: SleepButton(
              label: 'Outline',
              variant: SleepButtonVariant.outline,
              onPressed: () {},
            ),
          ),
        ),
      ));
      expect(find.text('Outline'), findsOneWidget);
    });

    testWidgets('text variant renders', (tester) async {
      await tester.pumpWidget(localizedApp(
        home: Scaffold(
          body: Center(
            child: SleepButton(
              label: 'Text',
              variant: SleepButtonVariant.text,
              onPressed: () {},
            ),
          ),
        ),
      ));
      expect(find.text('Text'), findsOneWidget);
    });

    testWidgets('calls onPressed when tapped', (tester) async {
      var pressed = false;
      await tester.pumpWidget(localizedApp(
        home: Scaffold(
          body: Center(
            child: SleepButton(
              label: 'Tap Me',
              onPressed: () => pressed = true,
            ),
          ),
        ),
      ));

      await tester.tap(find.text('Tap Me'));
      await tester.pumpAndSettle();
      expect(pressed, true);
    });

    testWidgets('disabled button does not call onPressed', (tester) async {
      var pressed = false;
      await tester.pumpWidget(localizedApp(
        home: Scaffold(
          body: Center(
            child: SleepButton(
              label: 'Disabled',
              onPressed: null,
            ),
          ),
        ),
      ));

      await tester.tap(find.text('Disabled'));
      await tester.pumpAndSettle();
      expect(pressed, false);
    });

    testWidgets('renders with icon', (tester) async {
      await tester.pumpWidget(localizedApp(
        home: Scaffold(
          body: Center(
            child: SleepButton(
              label: 'With Icon',
              icon: Icons.alarm,
              onPressed: () {},
            ),
          ),
        ),
      ));
      expect(find.byIcon(Icons.alarm), findsOneWidget);
      expect(find.text('With Icon'), findsOneWidget);
    });

    testWidgets('respects custom width', (tester) async {
      await tester.pumpWidget(localizedApp(
        home: Scaffold(
          body: Center(
            child: SleepButton(
              label: 'Wide',
              width: 300,
              onPressed: () {},
            ),
          ),
        ),
      ));
      expect(find.text('Wide'), findsOneWidget);
    });
  });

  group('SleepButtonVariant', () {
    test('has four variants', () {
      expect(SleepButtonVariant.values.length, 4);
    });
  });
}
