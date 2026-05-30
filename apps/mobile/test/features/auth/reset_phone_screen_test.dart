import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:wasalni/app/di.dart';
import 'package:wasalni/data/repositories/auth_repository.dart';
import 'package:wasalni/data/repositories/mock/mock_auth_repository.dart';
import 'package:wasalni/features/auth/view/reset_phone_screen.dart';

void main() {
  setUp(() async {
    await getIt.reset();
    getIt.registerLazySingleton<AuthRepository>(
        () => MockAuthRepository(latency: Duration.zero));
  });
  tearDown(() async => getIt.reset());

  GoRouter makeRouter() => GoRouter(
        initialLocation: '/auth/forgot',
        routes: [
          GoRoute(
              path: '/auth/forgot',
              builder: (c, s) => const ResetPhoneScreen()),
          GoRoute(
              path: '/auth/forgot/otp',
              builder: (c, s) => const Scaffold(body: Text('otp stub'))),
        ],
      );

  Widget app() => MaterialApp.router(routerConfig: makeRouter());

  testWidgets('demo phone → navigates to OTP screen', (tester) async {
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, '01000000000');
    await tester.tap(find.text('إرسال الكود'));
    await tester.pumpAndSettle();
    expect(find.text('otp stub'), findsOneWidget);
  });

  testWidgets('unknown phone shows account-not-found error', (tester) async {
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, '01999999999');
    await tester.tap(find.text('إرسال الكود'));
    await tester.pumpAndSettle();
    expect(find.text('مفيش حساب على الرقم ده'), findsOneWidget);
    expect(find.text('otp stub'), findsNothing);
  });

  testWidgets('invalid phone shows inline validation error, no navigation',
      (tester) async {
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, '012');
    await tester.tap(find.text('إرسال الكود'));
    await tester.pump();
    expect(find.text('اكتب رقم موبايل صح (11 رقم يبدأ بـ 01)'), findsOneWidget);
    expect(find.text('otp stub'), findsNothing);
  });
}
