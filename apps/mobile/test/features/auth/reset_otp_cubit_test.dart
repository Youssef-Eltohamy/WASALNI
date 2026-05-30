import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wasalni/data/repositories/auth_repository.dart';
import 'package:wasalni/features/auth/auth_exceptions.dart';
import 'package:wasalni/features/auth/bloc/reset_otp_cubit.dart';
import 'package:wasalni/features/auth/bloc/reset_otp_state.dart';

class MockAuthRepo extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepo repo;
  setUp(() => repo = MockAuthRepo());

  blocTest<ResetOtpCubit, ResetOtpState>(
    'verify success → [verifying, verified]',
    build: () {
      when(() => repo.verifyResetCode(
              phone: any(named: 'phone'), code: any(named: 'code')))
          .thenAnswer((_) async => 'rt_0');
      return ResetOtpCubit(repo, '+201000000000');
    },
    act: (c) => c.verify('1234'),
    expect: () => [
      isA<ResetOtpVerifying>(),
      isA<ResetOtpVerified>().having((s) => s.token, 'token', 'rt_0'),
    ],
  );

  blocTest<ResetOtpCubit, ResetOtpState>(
    'wrong code → [verifying, error]',
    build: () {
      when(() => repo.verifyResetCode(
              phone: any(named: 'phone'), code: any(named: 'code')))
          .thenThrow(const OtpWrongCodeException());
      return ResetOtpCubit(repo, '+201000000000');
    },
    act: (c) => c.verify('0000'),
    expect: () => [isA<ResetOtpVerifying>(), isA<ResetOtpError>()],
  );

  blocTest<ResetOtpCubit, ResetOtpState>(
    'expired code → [verifying, error]',
    build: () {
      when(() => repo.verifyResetCode(
              phone: any(named: 'phone'), code: any(named: 'code')))
          .thenThrow(const OtpExpiredException());
      return ResetOtpCubit(repo, '+201000000000');
    },
    act: (c) => c.verify('1234'),
    expect: () => [isA<ResetOtpVerifying>(), isA<ResetOtpError>()],
  );
}
