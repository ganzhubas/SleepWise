import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sleepwise/widgets/time_display.dart';
import '../helpers/localized_app.dart';

void main() {
  group('TimeDisplay', () {
    testWidgets('displays time in 24-hour format', (tester) async {
      await tester.pumpWidget(localizedApp(
        home: const Scaffold(
          body: Center(
            child: TimeDisplay(hours: 14, minutes: 30),
          ),
        ),
      ));
      expect(find.text('14:30'), findsOneWidget);
    });

    testWidgets('pads single digits with zeros', (tester) async {
      await tester.pumpWidget(localizedApp(
        home: const Scaffold(
          body: Center(
            child: TimeDisplay(hours: 7, minutes: 5),
          ),
        ),
      ));
      expect(find.text('07:05'), findsOneWidget);
    });

    testWidgets('displays midnight as 00:00', (tester) async {
      await tester.pumpWidget(localizedApp(
        home: const Scaffold(
          body: Center(
            child: TimeDisplay(hours: 0, minutes: 0),
          ),
        ),
      ));
      expect(find.text('00:00'), findsOneWidget);
    });

    testWidgets('displays 12-hour format with PM', (tester) async {
      await tester.pumpWidget(localizedApp(
        home: const Scaffold(
          body: Center(
            child: TimeDisplay(
              hours: 14,
              minutes: 30,
              use24HourFormat: false,
            ),
          ),
        ),
      ));
      expect(find.text('02:30'), findsOneWidget);
      expect(find.text('PM'), findsOneWidget);
    });

    testWidgets('displays 12-hour format with AM', (tester) async {
      await tester.pumpWidget(localizedApp(
        home: const Scaffold(
          body: Center(
            child: TimeDisplay(
              hours: 7,
              minutes: 30,
              use24HourFormat: false,
            ),
          ),
        ),
      ));
      expect(find.text('07:30'), findsOneWidget);
      expect(find.text('AM'), findsOneWidget);
    });

    testWidgets('midnight in 12-hour format shows 12 AM', (tester) async {
      await tester.pumpWidget(localizedApp(
        home: const Scaffold(
          body: Center(
            child: TimeDisplay(
              hours: 0,
              minutes: 0,
              use24HourFormat: false,
            ),
          ),
        ),
      ));
      expect(find.text('12:00'), findsOneWidget);
      expect(find.text('AM'), findsOneWidget);
    });

    testWidgets('noon in 12-hour format shows 12 PM', (tester) async {
      await tester.pumpWidget(localizedApp(
        home: const Scaffold(
          body: Center(
            child: TimeDisplay(
              hours: 12,
              minutes: 0,
              use24HourFormat: false,
            ),
          ),
        ),
      ));
      expect(find.text('12:00'), findsOneWidget);
      expect(find.text('PM'), findsOneWidget);
    });

    testWidgets('does not show AM/PM in 24-hour format', (tester) async {
      await tester.pumpWidget(localizedApp(
        home: const Scaffold(
          body: Center(
            child: TimeDisplay(hours: 14, minutes: 30),
          ),
        ),
      ));
      expect(find.text('AM'), findsNothing);
      expect(find.text('PM'), findsNothing);
    });

    testWidgets('renders with custom color', (tester) async {
      await tester.pumpWidget(localizedApp(
        home: const Scaffold(
          body: Center(
            child: TimeDisplay(
              hours: 7,
              minutes: 30,
              color: Colors.red,
            ),
          ),
        ),
      ));
      expect(find.text('07:30'), findsOneWidget);
    });

    testWidgets('renders with custom font size', (tester) async {
      await tester.pumpWidget(localizedApp(
        home: const Scaffold(
          body: Center(
            child: TimeDisplay(
              hours: 7,
              minutes: 30,
              fontSize: 96,
            ),
          ),
        ),
      ));
      expect(find.text('07:30'), findsOneWidget);
    });
  });
}
