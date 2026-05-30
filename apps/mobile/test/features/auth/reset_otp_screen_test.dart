import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:wasalni/app/di.dart';
import 'package:wasalni/data/repositories/auth_repository.dart';
import 'package:wasalni/data/repositories/mock/mock_auth_repository.dart';
import 'package:wasalni/features/auth/view/reset_otp_screen.dart';

void main() {
  const phone = '+201000000000';

  setUp(() async {
    await getIt.reset();
    getIt.registerLazySingleton<AuthRepository>(
        () => MockAuthRepository(latency: Duration.zero));
    // A code must already exist for verifyResetCode to accept it.
    await getIt<AuthRepository>().startReset(phone: phone);
  });
  tearDown(() async => getIt.reset());

  GoRouter makeRouter() => GoRouter(
        initialLocation: '/auth/forgot/otp',
        routes: [
          GoRoute(
              path: '/auth/forgot/otp',
              builder: (c, s) => const ResetOtpScreen(phone: phone)),
          GoRoute(
              path: '/auth/forgot/reset',
              builder: (c, s) => const Scaffold(body: Text('reset stub'))),
        ],
      );

  Widget app() => MaterialApp.router(routerConfig: makeRouter());

  testWidgets('correct code → navigates to new-password screen', (tester) async {
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, '1234');
    await tester.tap(find.text('تأكيد الكود'));
    await tester.pumpAndSettle();
    expect(find.text('reset stub'), findsOneWidget);
  });

  testWidgets('wrong code shows the error and stays', (tester) async {
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, '0000');
    await tester.tap(find.text('تأكيد الكود'));
    await tester.pumpAndSettle();
    expect(find.text('الكود غلط، جرّب تاني'), findsOneWidget);
    expect(find.text('reset stub'), findsNothing);
  });
}
