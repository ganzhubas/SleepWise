import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sleepwise/widgets/sleep_score_circle.dart';
import '../helpers/localized_app.dart';

void main() {
  group('SleepScoreCircle', () {
    testWidgets('displays score value after animation', (tester) async {
      await tester.pumpWidget(localizedApp(
        home: const Scaffold(
          body: Center(
            child: SleepScoreCircle(score: 85),
          ),
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.text('85'), findsOneWidget);
    });

    testWidgets('shows "Excellent" for score >= 85', (tester) async {
      await tester.pumpWidget(localizedApp(
        home: const Scaffold(
          body: Center(
            child: SleepScoreCircle(score: 90),
          ),
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.text('Excellent'), findsOneWidget);
    });

    testWidgets('shows "Good" for score 70-84', (tester) async {
      await tester.pumpWidget(localizedApp(
        home: const Scaffold(
          body: Center(
            child: SleepScoreCircle(score: 75),
          ),
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.text('Good'), findsOneWidget);
    });

    testWidgets('shows "Fair" for score 50-69', (tester) async {
      await tester.pumpWidget(localizedApp(
        home: const Scaffold(
          body: Center(
            child: SleepScoreCircle(score: 55),
          ),
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.text('Fair'), findsOneWidget);
    });

    testWidgets('shows "Poor" for score < 50', (tester) async {
      await tester.pumpWidget(localizedApp(
        home: const Scaffold(
          body: Center(
            child: SleepScoreCircle(score: 30),
          ),
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.text('Poor'), findsOneWidget);
    });

    testWidgets('clamps score to 0', (tester) async {
      await tester.pumpWidget(localizedApp(
        home: const Scaffold(
          body: Center(
            child: SleepScoreCircle(score: -10),
          ),
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.text('0'), findsOneWidget);
    });

    testWidgets('clamps score to 100', (tester) async {
      await tester.pumpWidget(localizedApp(
        home: const Scaffold(
          body: Center(
            child: SleepScoreCircle(score: 150),
          ),
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.text('100'), findsOneWidget);
    });

    testWidgets('respects custom size', (tester) async {
      await tester.pumpWidget(localizedApp(
        home: const Scaffold(
          body: Center(
            child: SleepScoreCircle(score: 80, size: 240),
          ),
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.text('80'), findsOneWidget);
    });

    testWidgets('score 0 shows Poor', (tester) async {
      await tester.pumpWidget(localizedApp(
        home: const Scaffold(
          body: Center(
            child: SleepScoreCircle(score: 0),
          ),
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.text('0'), findsOneWidget);
      expect(find.text('Poor'), findsOneWidget);
    });

    testWidgets('score 100 shows Excellent', (tester) async {
      await tester.pumpWidget(localizedApp(
        home: const Scaffold(
          body: Center(
            child: SleepScoreCircle(score: 100),
          ),
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.text('100'), findsOneWidget);
      expect(find.text('Excellent'), findsOneWidget);
    });

    testWidgets('updates when score changes', (tester) async {
      await tester.pumpWidget(localizedApp(
        home: const Scaffold(
          body: Center(
            child: SleepScoreCircle(score: 50),
          ),
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.text('50'), findsOneWidget);

      await tester.pumpWidget(localizedApp(
        home: const Scaffold(
          body: Center(
            child: SleepScoreCircle(score: 90),
          ),
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.text('90'), findsOneWidget);
    });
  });
}
