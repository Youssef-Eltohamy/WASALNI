import 'package:flutter_test/flutter_test.dart';

import 'package:wasalni/main.dart';

void main() {
  testWidgets('Home page shows welcome message', (WidgetTester tester) async {
    await tester.pumpWidget(const WasalniApp());
    await tester.pumpAndSettle();

    expect(find.text('مرحباً بك في وصلني'), findsOneWidget);
    expect(find.text('منصة الاكتشاف المحلي'), findsOneWidget);
  });
}
