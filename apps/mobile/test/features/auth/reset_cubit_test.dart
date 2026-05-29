import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wasalni/data/models/profile.dart';
import 'package:wasalni/data/repositories/auth_repository.dart';
import 'package:wasalni/features/auth/auth_exceptions.dart';
import 'package:wasalni/features/auth/bloc/reset_cubit.dart';
import 'package:wasalni/features/auth/bloc/reset_state.dart';

class MockAuthRepo extends Mock implements AuthRepository {}

Profile _p() => Profile(id: 'u1', phone: '+201000000000', displayName: 'أحمد', createdAt: DateTime(2026));

void main() {
  late MockAuthRepo repo;
  setUp(() => repo = MockAuthRepo());

  blocTest<ResetCubit, ResetState>(
    'submitPhone success → [submitting, codeSent]',
    build: () {
      when(() => repo.startReset(phone: any(named: 'phone'))).thenAnswer((_) async {});
      return ResetCubit(repo);
    },
    act: (c) => c.submitPhone('+201000000000'),
    expect: () => [isA<ResetSubmitting>(), isA<ResetCodeSent>()],
  );

  blocTest<ResetCubit, ResetState>(
    'submitPhone unknown → [submitting, phoneError]',
    build: () {
      when(() => repo.startReset(phone: any(named: 'phone')))
          .thenThrow(const AccountNotFoundException());
      return ResetCubit(repo);
    },
    act: (c) => c.submitPhone('+201999999999'),
    expect: () => [isA<ResetSubmitting>(), isA<ResetPhoneError>()],
  );

  blocTest<ResetCubit, ResetState>(
    'confirm success → [..., verifying, success]',
    build: () {
      when(() => repo.startReset(phone: any(named: 'phone'))).thenAnswer((_) async {});
      when(() => repo.confirmReset(
              phone: any(named: 'phone'),
              code: any(named: 'code'),
              newPassword: any(named: 'newPassword')))
          .thenAnswer((_) async => _p());
      return ResetCubit(repo);
    },
    act: (c) async {
      await c.submitPhone('+201000000000');
      await c.confirm(code: '1234', newPassword: 'brandnew');
    },
    expect: () => [
      isA<ResetSubmitting>(),
      isA<ResetCodeSent>(),
      isA<ResetVerifying>(),
      isA<ResetSuccess>(),
    ],
  );

  blocTest<ResetCubit, ResetState>(
    'confirm wrong code → [..., verifying, codeSent(error)]',
    build: () {
      when(() => repo.startReset(phone: any(named: 'phone'))).thenAnswer((_) async {});
      when(() => repo.confirmReset(
              phone: any(named: 'phone'),
              code: any(named: 'code'),
              newPassword: any(named: 'newPassword')))
          .thenThrow(const OtpWrongCodeException());
      return ResetCubit(repo);
    },
    act: (c) async {
      await c.submitPhone('+201000000000');
      await c.confirm(code: '0000', newPassword: 'brandnew');
    },
    expect: () => [
      isA<ResetSubmitting>(),
      isA<ResetCodeSent>(),
      isA<ResetVerifying>(),
      isA<ResetCodeSent>().having((s) => s.error, 'error', isNotNull),
    ],
  );
}
