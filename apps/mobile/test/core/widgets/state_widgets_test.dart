import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wasalni/core/widgets/empty_view.dart';
import 'package:wasalni/core/widgets/error_view.dart';

Widget _wrap(Widget child) => MaterialApp(
      locale: const Locale('ar', 'EG'),
      home: Directionality(textDirection: TextDirection.rtl, child: Scaffold(body: child)),
    );

void main() {
  testWidgets('EmptyView shows its message', (tester) async {
    await tester.pumpWidget(_wrap(const EmptyView(message: 'مفيش نتايج')));
    expect(find.text('مفيش نتايج'), findsOneWidget);
  });

  testWidgets('ErrorView shows message and fires onRetry', (tester) async {
    var tapped = false;
    await tester.pumpWidget(_wrap(ErrorView(message: 'حصل خطأ', onRetry: () => tapped = true)));
    expect(find.text('حصل خطأ'), findsOneWidget);
    await tester.tap(find.text('حاول تاني'));
    expect(tapped, true);
  });
}
