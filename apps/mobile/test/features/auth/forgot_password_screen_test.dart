import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:wasalni/app/di.dart';
import 'package:wasalni/data/repositories/auth_repository.dart';
import 'package:wasalni/data/repositories/mock/mock_auth_repository.dart';
import 'package:wasalni/features/auth/bloc/session_cubit.dart';
import 'package:wasalni/features/auth/view/forgot_password_screen.dart';

void main() {
  late SessionCubit sessionCubit;

  setUp(() async {
    await getIt.reset();
    getIt.registerLazySingleton<AuthRepository>(
        () => MockAuthRepository(latency: Duration.zero));
    sessionCubit = SessionCubit();
  });

  tearDown(() async {
    await getIt.reset();
    sessionCubit.close();
  });

  GoRouter makeRouter() => GoRouter(
        initialLocation: '/auth/forgot',
        routes: [
          GoRoute(
            path: '/auth/forgot',
            builder: (context, state) => const ForgotPasswordScreen(),
          ),
          GoRoute(
            path: '/account',
            builder: (context, state) =>
                const Scaffold(body: Text('account stub')),
          ),
        ],
      );

  Widget buildApp() => BlocProvider<SessionCubit>.value(
        value: sessionCubit,
        child: MaterialApp.router(
          routerConfig: makeRouter(),
        ),
      );

  testWidgets(
      'demo phone → code+password fields appear; correct code → session authenticated',
      (tester) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    // Enter demo phone (01000000000)
    await tester.enterText(find.byType(TextField).first, '01000000000');

    // Tap "إرسال الكود"
    await tester.tap(find.text('إرسال الكود'));
    await tester.pumpAndSettle();

    // Code + new-password fields should now be visible
    expect(find.text('تأكيد كلمة السر الجديدة'), findsOneWidget);

    // Enter magic OTP code into the first TextField (code field)
    await tester.enterText(find.byType(TextField).first, '1234');

    // Enter new password into the second TextField (password field)
    await tester.enterText(find.byType(TextField).last, 'newpass1');

    // Tap confirm
    await tester.tap(find.text('تأكيد كلمة السر الجديدة'));
    await tester.pumpAndSettle();

    // Session should be authenticated and navigated to /account stub
    expect(sessionCubit.isAuthenticated, isTrue);
    expect(find.text('account stub'), findsOneWidget);
  });

  testWidgets('unknown phone shows account-not-found error', (tester) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    // Enter an unknown phone
    await tester.enterText(find.byType(TextField).first, '01999999999');

    // Tap "إرسال الكود"
    await tester.tap(find.text('إرسال الكود'));
    await tester.pumpAndSettle();

    // The AccountNotFoundException message should appear as field error
    expect(find.text('مفيش حساب على الرقم ده'), findsOneWidget);
    // Still on phone phase
    expect(find.text('تأكيد كلمة السر الجديدة'), findsNothing);
  });
}
