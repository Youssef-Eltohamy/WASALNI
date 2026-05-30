import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wasalni/data/repositories/auth_repository.dart';
import 'package:wasalni/features/auth/auth_exceptions.dart';
import 'package:wasalni/features/auth/bloc/reset_phone_cubit.dart';
import 'package:wasalni/features/auth/bloc/reset_phone_state.dart';

class MockAuthRepo extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepo repo;
  setUp(() => repo = MockAuthRepo());

  blocTest<ResetPhoneCubit, ResetPhoneState>(
    'success → [submitting, sent]',
    build: () {
      when(() => repo.startReset(phone: any(named: 'phone')))
          .thenAnswer((_) async {});
      return ResetPhoneCubit(repo);
    },
    act: (c) => c.submit('+201000000000'),
    expect: () => [isA<ResetPhoneSubmitting>(), isA<ResetPhoneSent>()],
  );

  blocTest<ResetPhoneCubit, ResetPhoneState>(
    'unknown phone → [submitting, error]',
    build: () {
      when(() => repo.startReset(phone: any(named: 'phone')))
          .thenThrow(const AccountNotFoundException());
      return ResetPhoneCubit(repo);
    },
    act: (c) => c.submit('+201999999999'),
    expect: () => [isA<ResetPhoneSubmitting>(), isA<ResetPhoneError>()],
  );

  blocTest<ResetPhoneCubit, ResetPhoneState>(
    'resend-too-soon → [submitting, error]',
    build: () {
      when(() => repo.startReset(phone: any(named: 'phone')))
          .thenThrow(const OtpResendTooSoonException());
      return ResetPhoneCubit(repo);
    },
    act: (c) => c.submit('+201000000000'),
    expect: () => [isA<ResetPhoneSubmitting>(), isA<ResetPhoneError>()],
  );
}
