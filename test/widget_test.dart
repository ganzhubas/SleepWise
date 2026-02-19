import 'package:flutter_test/flutter_test.dart';
import 'package:sleepwise/app/sleepwise_app.dart';

void main() {
  testWidgets('SleepWise app renders placeholder', (WidgetTester tester) async {
    await tester.pumpWidget(const SleepWiseApp());

    expect(find.text('SleepWise'), findsOneWidget);
    expect(find.text('Sleep smarter, wake better'), findsOneWidget);
  });
}
