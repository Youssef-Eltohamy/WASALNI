import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:wasalni/data/repositories/auth_repository.dart';
import 'package:wasalni/data/repositories/mock/mock_auth_repository.dart';
import 'package:wasalni/features/auth/view/phone_entry_screen.dart';

/// Minimal router that hosts PhoneEntryScreen at '/' and a stub at '/auth/verify'
GoRouter _makeRouter() => GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const Directionality(
            textDirection: TextDirection.rtl,
            child: PhoneEntryScreen(),
          ),
        ),
        GoRoute(
          path: '/auth/verify',
          builder: (context, state) => const Scaffold(body: Text('otp stub')),
        ),
      ],
    );

void main() {
  setUp(() {
    GetIt.instance
        .registerLazySingleton<AuthRepository>(() => MockAuthRepository(latency: Duration.zero));
  });

  tearDown(() async {
    await GetIt.instance.reset();
  });

  testWidgets('tapping "إرسال الكود" with invalid number shows error text', (tester) async {
    await tester.pumpWidget(MaterialApp.router(routerConfig: _makeRouter()));
    await tester.pumpAndSettle();

    // Enter an invalid phone number (too short)
    await tester.enterText(find.byType(TextField), '0100');
    await tester.tap(find.text('إرسال الكود'));
    await tester.pump();

    expect(find.text('اكتب رقم موبايل صح (11 رقم يبدأ بـ 01)'), findsOneWidget);
  });

  testWidgets('valid 11-digit number clears validation error and navigates to OTP', (tester) async {
    await tester.pumpWidget(MaterialApp.router(routerConfig: _makeRouter()));
    await tester.pumpAndSettle();

    // First trigger the validation error with a short number
    await tester.enterText(find.byType(TextField), '0100');
    await tester.tap(find.text('إرسال الكود'));
    await tester.pump();
    expect(find.text('اكتب رقم موبايل صح (11 رقم يبدأ بـ 01)'), findsOneWidget);

    // Now enter a valid number — validation error clears immediately (before async OTP request)
    await tester.enterText(find.byType(TextField), '01000000000');
    await tester.tap(find.text('إرسال الكود'));
    await tester.pump();

    // Validation error is cleared
    expect(find.text('اكتب رقم موبايل صح (11 رقم يبدأ بـ 01)'), findsNothing);

    // Drain the pending Duration.zero future (requestOtp completes, OtpCodeSent emitted,
    // BlocListener pushes /auth/verify — all within Duration.zero)
    await tester.pump(Duration.zero);
    await tester.pumpAndSettle();

    // Should have navigated to the OTP stub screen
    expect(find.text('otp stub'), findsOneWidget);
  });
}
