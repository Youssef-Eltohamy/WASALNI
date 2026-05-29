import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:wasalni/app/di.dart';
import 'package:wasalni/data/repositories/auth_repository.dart';
import 'package:wasalni/data/repositories/mock/mock_auth_repository.dart';
import 'package:wasalni/features/auth/bloc/session_cubit.dart';
import 'package:wasalni/features/auth/view/login_screen.dart';

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
        initialLocation: '/auth',
        routes: [
          GoRoute(
            path: '/auth',
            builder: (context, state) => const LoginScreen(),
          ),
          GoRoute(
            path: '/auth/signup',
            builder: (context, state) =>
                const Scaffold(body: Text('signup stub')),
          ),
          GoRoute(
            path: '/auth/forgot',
            builder: (context, state) =>
                const Scaffold(body: Text('forgot stub')),
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

  testWidgets('demo login (01000000000 / 123456) navigates to /account',
      (tester) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    // Enter demo phone
    await tester.enterText(
        find.byType(TextField).first, '01000000000');
    // Enter demo password — second TextField
    await tester.enterText(
        find.byType(TextField).last, '123456');

    // Tap login button
    await tester.tap(find.text('دخول'));
    await tester.pumpAndSettle();

    // Should have navigated to /account stub
    expect(find.text('account stub'), findsOneWidget);
    expect(sessionCubit.isAuthenticated, isTrue);
  });

  testWidgets('wrong password shows error SnackBar', (tester) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    await tester.enterText(
        find.byType(TextField).first, '01000000000');
    await tester.enterText(
        find.byType(TextField).last, 'wrongpassword');

    await tester.tap(find.text('دخول'));
    await tester.pump(); // start async
    await tester.pump(const Duration(milliseconds: 100)); // settle snackbar

    expect(find.text('رقم الموبايل أو كلمة السر غلط'), findsOneWidget);
    expect(sessionCubit.isAuthenticated, isFalse);
  });
}
