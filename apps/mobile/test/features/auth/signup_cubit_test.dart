import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wasalni/data/models/profile.dart';
import 'package:wasalni/data/repositories/auth_repository.dart';
import 'package:wasalni/features/auth/auth_exceptions.dart';
import 'package:wasalni/features/auth/bloc/signup_cubit.dart';
import 'package:wasalni/features/auth/bloc/signup_state.dart';

class MockAuthRepo extends Mock implements AuthRepository {}

Profile _p() => Profile(id: 'u1', phone: '+201222222222', displayName: 'سعيد', createdAt: DateTime(2026));

void main() {
  late MockAuthRepo repo;
  setUp(() => repo = MockAuthRepo());

  blocTest<SignupCubit, SignupState>(
    'submitForm success → [submitting, codeSent]',
    build: () {
      when(() => repo.startSignup(phone: any(named: 'phone'))).thenAnswer((_) async {});
      return SignupCubit(repo);
    },
    act: (c) => c.submitForm(name: 'سعيد', phone: '+201222222222', password: 'secret1'),
    expect: () => [isA<SignupSubmitting>(), isA<SignupCodeSent>()],
  );

  blocTest<SignupCubit, SignupState>(
    'submitForm on taken phone → [submitting, formError]',
    build: () {
      when(() => repo.startSignup(phone: any(named: 'phone')))
          .thenThrow(const PhoneAlreadyRegisteredException());
      return SignupCubit(repo);
    },
    act: (c) => c.submitForm(name: 'سعيد', phone: '+201000000000', password: 'secret1'),
    expect: () => [isA<SignupSubmitting>(), isA<SignupFormError>()],
  );

  blocTest<SignupCubit, SignupState>(
    'confirmCode success → [..., verifying, success]',
    build: () {
      when(() => repo.startSignup(phone: any(named: 'phone'))).thenAnswer((_) async {});
      when(() => repo.confirmSignup(
              name: any(named: 'name'),
              phone: any(named: 'phone'),
              password: any(named: 'password'),
              code: any(named: 'code')))
          .thenAnswer((_) async => _p());
      return SignupCubit(repo);
    },
    act: (c) async {
      await c.submitForm(name: 'سعيد', phone: '+201222222222', password: 'secret1');
      await c.confirmCode('1234');
    },
    expect: () => [
      isA<SignupSubmitting>(),
      isA<SignupCodeSent>(),
      isA<SignupVerifying>(),
      isA<SignupSuccess>(),
    ],
  );

  blocTest<SignupCubit, SignupState>(
    'confirmCode wrong → [..., verifying, codeSent(error)]',
    build: () {
      when(() => repo.startSignup(phone: any(named: 'phone'))).thenAnswer((_) async {});
      when(() => repo.confirmSignup(
              name: any(named: 'name'),
              phone: any(named: 'phone'),
              password: any(named: 'password'),
              code: any(named: 'code')))
          .thenThrow(const OtpWrongCodeException());
      return SignupCubit(repo);
    },
    act: (c) async {
      await c.submitForm(name: 'سعيد', phone: '+201222222222', password: 'secret1');
      await c.confirmCode('0000');
    },
    expect: () => [
      isA<SignupSubmitting>(),
      isA<SignupCodeSent>(),
      isA<SignupVerifying>(),
      isA<SignupCodeSent>().having((s) => s.error, 'error', isNotNull),
    ],
  );
}
