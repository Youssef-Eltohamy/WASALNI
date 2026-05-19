import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wasalni/core/errors/failures.dart';
import 'package:wasalni/features/auth/data/repositories/auth_repository.dart';
import 'package:wasalni/features/auth/domain/entities/auth_user.dart';
import 'package:wasalni/features/auth/presentation/cubit/signin_form/signin_form_cubit.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository repository;

  AuthUser confirmedUser() => AuthUser(
        id: 'u-1',
        email: 'user@example.com',
        isEmailConfirmed: true,
        createdAt: DateTime.now(),
      );

  setUp(() {
    repository = MockAuthRepository();
  });

  group('SigninFormCubit', () {
    test('initial state has empty inputs and is invalid', () {
      final cubit = SigninFormCubit(repository: repository);
      expect(cubit.state.email.value, '');
      expect(cubit.state.isValid, isFalse);
    });

    blocTest<SigninFormCubit, SigninFormState>(
      'becomes valid when email + password filled correctly',
      build: () => SigninFormCubit(repository: repository),
      act: (cubit) {
        cubit.emailChanged('user@example.com');
        cubit.passwordChanged('anyPassword');
      },
      verify: (cubit) {
        expect(cubit.state.isValid, isTrue);
      },
    );

    blocTest<SigninFormCubit, SigninFormState>(
      'submit calls repository and succeeds',
      build: () {
        when(() => repository.signIn(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenAnswer((_) async => Right(confirmedUser()));
        return SigninFormCubit(repository: repository);
      },
      act: (cubit) async {
        cubit.emailChanged('user@example.com');
        cubit.passwordChanged('Strong1234');
        await cubit.submit();
      },
      verify: (cubit) {
        expect(cubit.state.isSubmitting, isFalse);
        expect(cubit.state.errorMessage, isNull);
        verify(() => repository.signIn(
              email: 'user@example.com',
              password: 'Strong1234',
            )).called(1);
      },
    );

    blocTest<SigninFormCubit, SigninFormState>(
      'submit shows error on invalid credentials',
      build: () {
        when(() => repository.signIn(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenAnswer(
          (_) async => const Left(AuthFailure('بيانات الدخول غير صحيحة')),
        );
        return SigninFormCubit(repository: repository);
      },
      act: (cubit) async {
        cubit.emailChanged('user@example.com');
        cubit.passwordChanged('wrongPass');
        await cubit.submit();
      },
      verify: (cubit) {
        expect(cubit.state.errorMessage, 'بيانات الدخول غير صحيحة');
        expect(cubit.state.needsEmailConfirmation, isFalse);
      },
    );

    blocTest<SigninFormCubit, SigninFormState>(
      'submit flags needsEmailConfirmation on unconfirmed error',
      build: () {
        when(() => repository.signIn(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenAnswer(
          (_) async =>
              const Left(AuthFailure('الإيميل غير مؤكد، تحقق من بريدك')),
        );
        return SigninFormCubit(repository: repository);
      },
      act: (cubit) async {
        cubit.emailChanged('user@example.com');
        cubit.passwordChanged('Strong1234');
        await cubit.submit();
      },
      verify: (cubit) {
        expect(cubit.state.needsEmailConfirmation, isTrue);
      },
    );

    blocTest<SigninFormCubit, SigninFormState>(
      'submit does nothing when form invalid',
      build: () => SigninFormCubit(repository: repository),
      act: (cubit) => cubit.submit(),
      verify: (_) {
        verifyNever(() => repository.signIn(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ));
      },
    );
  });
}
