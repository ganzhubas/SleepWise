import 'package:flutter_test/flutter_test.dart';
import 'package:sleepwise/app/sleepwise_app.dart';

void main() {
  testWidgets('SleepWise app renders showcase screen', (WidgetTester tester) async {
    await tester.pumpWidget(const SleepWiseApp());

    expect(find.text('Widget Showcase'), findsOneWidget);
  });
}
