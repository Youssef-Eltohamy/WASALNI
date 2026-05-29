import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:wasalni/data/repositories/auth_repository.dart';
import 'package:wasalni/data/repositories/mock/mock_auth_repository.dart';
import 'package:wasalni/features/auth/bloc/session_cubit.dart';
import 'package:wasalni/features/auth/view/otp_screen.dart';

void main() {
  setUp(() {
    GetIt.instance
        .registerLazySingleton<AuthRepository>(() => MockAuthRepository(latency: Duration.zero));
  });

  tearDown(() async {
    await GetIt.instance.reset();
  });

  testWidgets('wrong code shows inline error "الكود غلط، جرّب تاني"', (tester) async {
    final sessionCubit = SessionCubit();

    await tester.pumpWidget(
      MaterialApp(
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: BlocProvider<SessionCubit>.value(
            value: sessionCubit,
            child: const OtpScreen(phone: '+201000000000'),
          ),
        ),
      ),
    );

    // Let the auto-requestCode in OtpCubit.create settle (latency: Duration.zero)
    await tester.pump();
    await tester.pump(Duration.zero);

    // Enter wrong code and tap تأكيد
    await tester.enterText(find.byType(TextField), '5555');
    await tester.tap(find.text('تأكيد'));
    await tester.pump(); // trigger verify (async with Duration.zero latency)
    await tester.pump(Duration.zero); // let the Future complete

    expect(find.text('الكود غلط، جرّب تاني'), findsOneWidget);

    // Dispose the widget to cancel the OtpCubit timer and avoid pending-timer warnings
    await tester.pumpWidget(const SizedBox());
    sessionCubit.close();
  });
}
