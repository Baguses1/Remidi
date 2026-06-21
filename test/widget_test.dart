import 'package:flutter_test/flutter_test.dart';
import 'package:remidi/main.dart';

void main() {
  testWidgets('Smoke test placeholder', (WidgetTester tester) async {
    await tester.pumpWidget(const SpaceNewsApp());
    expect(find.byType(SpaceNewsApp), findsOneWidget);
  });
}