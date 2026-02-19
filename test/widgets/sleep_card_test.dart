import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sleepwise/widgets/sleep_card.dart';
import '../helpers/localized_app.dart';

void main() {
  group('SleepCard', () {
    testWidgets('renders child content', (tester) async {
      await tester.pumpWidget(localizedApp(
        home: const Scaffold(
          body: SleepCard(
            child: Text('Card Content'),
          ),
        ),
      ));
      expect(find.text('Card Content'), findsOneWidget);
    });

    testWidgets('renders with accent color stripe', (tester) async {
      await tester.pumpWidget(localizedApp(
        home: const Scaffold(
          body: SleepCard(
            accentColor: Colors.blue,
            child: Text('Accent Card'),
          ),
        ),
      ));
      expect(find.text('Accent Card'), findsOneWidget);
    });

    testWidgets('renders without accent color', (tester) async {
      await tester.pumpWidget(localizedApp(
        home: const Scaffold(
          body: SleepCard(
            child: Text('No Accent'),
          ),
        ),
      ));
      expect(find.text('No Accent'), findsOneWidget);
    });

    testWidgets('calls onTap callback', (tester) async {
      var tapped = false;
      await tester.pumpWidget(localizedApp(
        home: Scaffold(
          body: SleepCard(
            onTap: () => tapped = true,
            child: const Text('Tappable Card'),
          ),
        ),
      ));

      await tester.tap(find.text('Tappable Card'));
      expect(tapped, true);
    });

    testWidgets('works with custom padding', (tester) async {
      await tester.pumpWidget(localizedApp(
        home: const Scaffold(
          body: SleepCard(
            padding: EdgeInsets.all(32),
            child: Text('Custom Padding'),
          ),
        ),
      ));
      expect(find.text('Custom Padding'), findsOneWidget);
    });
  });
}
