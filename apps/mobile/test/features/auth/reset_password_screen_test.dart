import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:wasalni/app/di.dart';
import 'package:wasalni/data/repositories/auth_repository.dart';
import 'package:wasalni/data/repositories/mock/mock_auth_repository.dart';
import 'package:wasalni/features/auth/bloc/session_cubit.dart';
import 'package:wasalni/features/auth/view/reset_password_screen.dart';

void main() {
  const phone = '+201000000000';
  late SessionCubit session;
  late String token;

  setUp(() async {
    await getIt.reset();
    getIt.registerLazySingleton<AuthRepository>(
        () => MockAuthRepository(latency: Duration.zero));
    final repo = getIt<AuthRepository>();
    await repo.startReset(phone: phone);
    token = await repo.verifyResetCode(phone: phone, code: '1234');
    session = SessionCubit();
  });
  tearDown(() async {
    await getIt.reset();
    session.close();
  });

  GoRouter makeRouter(String tok) => GoRouter(
        initialLocation: '/auth/forgot/reset',
        routes: [
          GoRoute(
              path: '/auth/forgot/reset',
              builder: (c, s) =>
                  ResetPasswordScreen(phone: phone, token: tok)),
          GoRoute(
              path: '/account',
              builder: (c, s) => const Scaffold(body: Text('account stub'))),
          GoRoute(
              path: '/auth/forgot',
              builder: (c, s) => const Scaffold(body: Text('forgot stub'))),
        ],
      );

  Widget app(String tok) => BlocProvider<SessionCubit>.value(
        value: session,
        child: MaterialApp.router(routerConfig: makeRouter(tok)),
      );

  testWidgets('valid token + new password → session authenticated', (tester) async {
    await tester.pumpWidget(app(token));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, 'brandnew');
    await tester.tap(find.text('تأكيد كلمة السر الجديدة'));
    await tester.pumpAndSettle();
    expect(session.isAuthenticated, isTrue);
    expect(find.text('account stub'), findsOneWidget);
  });

  testWidgets('invalid token bounces back to /auth/forgot', (tester) async {
    await tester.pumpWidget(app('bogus'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, 'brandnew');
    await tester.tap(find.text('تأكيد كلمة السر الجديدة'));
    await tester.pumpAndSettle();
    expect(find.text('forgot stub'), findsOneWidget);
    expect(session.isAuthenticated, isFalse);
  });
}
