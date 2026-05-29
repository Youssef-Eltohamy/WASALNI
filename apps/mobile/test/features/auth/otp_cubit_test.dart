import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wasalni/data/models/profile.dart';
import 'package:wasalni/data/repositories/auth_repository.dart';
import 'package:wasalni/features/auth/auth_exceptions.dart';
import 'package:wasalni/features/auth/bloc/otp_cubit.dart';
import 'package:wasalni/features/auth/bloc/otp_state.dart';

class MockAuthRepo extends Mock implements AuthRepository {}

Profile _p() => Profile(id: 'u1', phone: '+201000000000', displayName: '', createdAt: DateTime(2026));

void main() {
  late MockAuthRepo repo;
  setUp(() => repo = MockAuthRepo());

  blocTest<OtpCubit, OtpState>(
    'requestCode emits [sending, codeSent]',
    build: () {
      when(() => repo.requestOtp(any())).thenAnswer((_) async {});
      return OtpCubit(repo);
    },
    act: (c) => c.requestCode('+201000000000'),
    expect: () => [isA<OtpSending>(), isA<OtpCodeSent>()],
    verify: (c) => expect((c.state as OtpCodeSent).resendSeconds, 30),
  );

  blocTest<OtpCubit, OtpState>(
    'verify success emits [verifying, success]',
    build: () {
      when(() => repo.verifyOtp(phone: any(named: 'phone'), code: any(named: 'code')))
          .thenAnswer((_) async => _p());
      return OtpCubit(repo);
    },
    act: (c) => c.verify(phone: '+201000000000', code: '1234'),
    expect: () => [isA<OtpVerifying>(), isA<OtpSuccess>()],
  );

  blocTest<OtpCubit, OtpState>(
    'wrong code emits [verifying, wrongCode]',
    build: () {
      when(() => repo.verifyOtp(phone: any(named: 'phone'), code: any(named: 'code')))
          .thenThrow(const OtpWrongCodeException());
      return OtpCubit(repo);
    },
    act: (c) => c.verify(phone: '+201000000000', code: '5555'),
    expect: () => [isA<OtpVerifying>(), isA<OtpWrongCode>()],
  );

  blocTest<OtpCubit, OtpState>(
    'expired emits [verifying, expired]',
    build: () {
      when(() => repo.verifyOtp(phone: any(named: 'phone'), code: any(named: 'code')))
          .thenThrow(const OtpExpiredException());
      return OtpCubit(repo);
    },
    act: (c) => c.verify(phone: '+201000000000', code: '0000'),
    expect: () => [isA<OtpVerifying>(), isA<OtpExpired>()],
  );

  blocTest<OtpCubit, OtpState>(
    'rate limited emits [verifying, rateLimited]',
    build: () {
      when(() => repo.verifyOtp(phone: any(named: 'phone'), code: any(named: 'code')))
          .thenThrow(const OtpRateLimitedException());
      return OtpCubit(repo);
    },
    act: (c) => c.verify(phone: '+201000000000', code: '9999'),
    expect: () => [isA<OtpVerifying>(), isA<OtpRateLimited>()],
  );

  blocTest<OtpCubit, OtpState>(
    'resend countdown does not overwrite a wrong-code error after a tick',
    build: () {
      when(() => repo.requestOtp(any())).thenAnswer((_) async {});
      when(() => repo.verifyOtp(phone: any(named: 'phone'), code: any(named: 'code')))
          .thenThrow(const OtpWrongCodeException());
      return OtpCubit(repo);
    },
    act: (c) async {
      await c.requestCode('+201000000000'); // starts the 30s countdown
      await c.verify(phone: '+201000000000', code: '5555'); // wrong → cancels timer
    },
    wait: const Duration(milliseconds: 1200), // let a would-be tick fire
    verify: (c) => expect(c.state, isA<OtpWrongCode>()),
  );
}
