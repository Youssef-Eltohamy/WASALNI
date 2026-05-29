import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wasalni/data/models/profile.dart';
import 'package:wasalni/features/account/view/account_screen.dart';
import 'package:wasalni/features/auth/bloc/session_cubit.dart';

Widget _host(SessionCubit session) => MaterialApp(
      home: BlocProvider.value(value: session, child: const AccountScreen()),
    );

void main() {
  testWidgets('guest sees a sign-in prompt', (tester) async {
    await tester.pumpWidget(_host(SessionCubit()));
    expect(find.text('تسجيل الدخول'), findsOneWidget);
  });

  testWidgets('authenticated user sees name + sign out', (tester) async {
    final session = SessionCubit()
      ..signIn(Profile(id: 'u1', phone: '+201000000000', displayName: 'محمد', createdAt: DateTime(2026)));
    await tester.pumpWidget(_host(session));
    expect(find.text('محمد'), findsOneWidget);
    expect(find.text('تسجيل الخروج'), findsOneWidget);
  });
}
