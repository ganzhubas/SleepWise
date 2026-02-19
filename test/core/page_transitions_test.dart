import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sleepwise/core/transitions/page_transitions.dart';

void main() {
  group('FadeScaleRoute', () {
    test('creates route with correct duration', () {
      final route = FadeScaleRoute(page: const SizedBox());
      expect(route.transitionDuration, const Duration(milliseconds: 500));
      expect(route.reverseTransitionDuration, const Duration(milliseconds: 300));
    });

    testWidgets('renders page content', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () => Navigator.of(context).push(
              FadeScaleRoute(page: const Text('Destination')),
            ),
            child: const Text('Go'),
          ),
        ),
      ));

      await tester.tap(find.text('Go'));
      await tester.pumpAndSettle();
      expect(find.text('Destination'), findsOneWidget);
    });
  });

  group('FadeToBlackRoute', () {
    test('creates route with correct duration', () {
      final route = FadeToBlackRoute(page: const SizedBox());
      expect(route.transitionDuration, const Duration(milliseconds: 800));
      expect(route.reverseTransitionDuration, const Duration(milliseconds: 400));
    });

    testWidgets('renders page content', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () => Navigator.of(context).push(
              FadeToBlackRoute(page: const Text('Night Mode')),
            ),
            child: const Text('Go'),
          ),
        ),
      ));

      await tester.tap(find.text('Go'));
      await tester.pumpAndSettle();
      expect(find.text('Night Mode'), findsOneWidget);
    });
  });

  group('DawnRoute', () {
    test('creates route with correct duration', () {
      final route = DawnRoute(page: const SizedBox());
      expect(route.transitionDuration, const Duration(milliseconds: 1500));
      expect(route.reverseTransitionDuration, const Duration(milliseconds: 400));
    });

    testWidgets('renders page content', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () => Navigator.of(context).push(
              DawnRoute(page: const Text('Wake Up')),
            ),
            child: const Text('Go'),
          ),
        ),
      ));

      await tester.tap(find.text('Go'));
      await tester.pumpAndSettle();
      expect(find.text('Wake Up'), findsOneWidget);
    });
  });

  group('SlideUpRoute', () {
    test('creates route with correct duration', () {
      final route = SlideUpRoute(page: const SizedBox());
      expect(route.transitionDuration, const Duration(milliseconds: 400));
      expect(route.reverseTransitionDuration, const Duration(milliseconds: 300));
    });

    testWidgets('renders page content', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () => Navigator.of(context).push(
              SlideUpRoute(page: const Text('Morning Report')),
            ),
            child: const Text('Go'),
          ),
        ),
      ));

      await tester.tap(find.text('Go'));
      await tester.pumpAndSettle();
      expect(find.text('Morning Report'), findsOneWidget);
    });
  });
}
