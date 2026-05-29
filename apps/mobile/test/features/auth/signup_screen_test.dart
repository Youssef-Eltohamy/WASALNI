import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:wasalni/app/di.dart';
import 'package:wasalni/data/repositories/auth_repository.dart';
import 'package:wasalni/data/repositories/mock/mock_auth_repository.dart';
import 'package:wasalni/features/auth/bloc/session_cubit.dart';
import 'package:wasalni/features/auth/view/signup_screen.dart';

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
        initialLocation: '/auth/signup',
        routes: [
          GoRoute(
            path: '/auth/signup',
            builder: (context, state) => const SignupScreen(),
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

  testWidgets('password too short shows inline error', (tester) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    // Fill name
    await tester.enterText(find.byType(TextField).at(0), 'سعيد');
    // Fill phone (new, free number)
    await tester.enterText(find.byType(TextField).at(1), '01222222222');
    // Fill short password
    await tester.enterText(find.byType(TextField).at(2), '123');

    // Tap continue
    await tester.tap(find.text('متابعة'));
    await tester.pump();

    // Inline error should appear
    expect(find.text('كلمة السر لازم 6 حروف على الأقل'), findsOneWidget);
    // Still on form phase - no OTP button visible
    expect(find.text('تأكيد وإنشاء الحساب'), findsNothing);
  });

  testWidgets('valid form → OTP phase appears; correct code → session authenticated',
      (tester) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    // Fill form with a new phone
    await tester.enterText(find.byType(TextField).at(0), 'سعيد');
    await tester.enterText(find.byType(TextField).at(1), '01222222222');
    await tester.enterText(find.byType(TextField).at(2), 'secret1');

    // Tap متابعة
    await tester.tap(find.text('متابعة'));
    await tester.pumpAndSettle();

    // OTP phase should now be visible
    expect(find.text('تأكيد وإنشاء الحساب'), findsOneWidget);

    // Enter the magic OTP code
    // The code TextField is now the first (and only) editable field in phase B
    await tester.enterText(find.byType(TextField).first, '1234');

    // Tap confirm
    await tester.tap(find.text('تأكيد وإنشاء الحساب'));
    await tester.pumpAndSettle();

    // Session should be authenticated
    expect(sessionCubit.isAuthenticated, isTrue);
    // Should have navigated to /account stub
    expect(find.text('account stub'), findsOneWidget);
  });
}
