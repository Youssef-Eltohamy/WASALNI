import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wasalni/core/errors/failures.dart';
import 'package:wasalni/features/auth/data/repositories/auth_repository.dart';
import 'package:wasalni/features/auth/domain/entities/auth_user.dart';
import 'package:wasalni/features/auth/presentation/cubit/signup_form/signup_form_cubit.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository repository;

  setUp(() {
    repository = MockAuthRepository();
  });

  AuthUser fakeUser() => AuthUser(
        id: 'user-123',
        email: 'test@example.com',
        isEmailConfirmed: false,
        createdAt: DateTime.now(),
      );

  group('SignupFormCubit', () {
    test('initial state has empty inputs and isValid false', () {
      final cubit = SignupFormCubit(repository: repository);
      expect(cubit.state.email.value, '');
      expect(cubit.state.isValid, isFalse);
      expect(cubit.state.termsAccepted, isFalse);
    });

    blocTest<SignupFormCubit, SignupFormState>(
      'emailChanged updates email input',
      build: () => SignupFormCubit(repository: repository),
      act: (cubit) => cubit.emailChanged('user@example.com'),
      expect: () => [
        predicate<SignupFormState>(
          (s) => s.email.value == 'user@example.com' && s.email.isValid,
        ),
      ],
    );

    blocTest<SignupFormCubit, SignupFormState>(
      'becomes valid only when email + passwords match + terms accepted',
      build: () => SignupFormCubit(repository: repository),
      act: (cubit) {
        cubit.emailChanged('user@example.com');
        cubit.passwordChanged('Strong123');
        cubit.confirmPasswordChanged('Strong123');
        cubit.termsAcceptedChanged(true);
      },
      verify: (cubit) {
        expect(cubit.state.isValid, isTrue);
      },
    );

    blocTest<SignupFormCubit, SignupFormState>(
      'invalid when terms not accepted',
      build: () => SignupFormCubit(repository: repository),
      act: (cubit) {
        cubit.emailChanged('user@example.com');
        cubit.passwordChanged('Strong123');
        cubit.confirmPasswordChanged('Strong123');
        // ملاحظ: مفيش termsAcceptedChanged(true)
      },
      verify: (cubit) {
        expect(cubit.state.isValid, isFalse);
      },
    );

    blocTest<SignupFormCubit, SignupFormState>(
      'submit succeeds when valid and repository succeeds',
      build: () {
        when(() => repository.signUp(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenAnswer((_) async => Right(fakeUser()));
        return SignupFormCubit(repository: repository);
      },
      act: (cubit) async {
        cubit.emailChanged('user@example.com');
        cubit.passwordChanged('Strong123');
        cubit.confirmPasswordChanged('Strong123');
        cubit.termsAcceptedChanged(true);
        await cubit.submit();
      },
      verify: (cubit) {
        expect(cubit.state.isSuccess, isTrue);
        expect(cubit.state.isSubmitting, isFalse);
        verify(() => repository.signUp(
              email: 'user@example.com',
              password: 'Strong123',
            )).called(1);
      },
    );

    blocTest<SignupFormCubit, SignupFormState>(
      'submit emits error message on repository failure',
      build: () {
        when(() => repository.signUp(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenAnswer(
          (_) async => const Left(AuthFailure('الإيميل مسجل بالفعل')),
        );
        return SignupFormCubit(repository: repository);
      },
      act: (cubit) async {
        cubit.emailChanged('user@example.com');
        cubit.passwordChanged('Strong123');
        cubit.confirmPasswordChanged('Strong123');
        cubit.termsAcceptedChanged(true);
        await cubit.submit();
      },
      verify: (cubit) {
        expect(cubit.state.errorMessage, 'الإيميل مسجل بالفعل');
        expect(cubit.state.isSubmitting, isFalse);
        expect(cubit.state.isSuccess, isFalse);
      },
    );

    blocTest<SignupFormCubit, SignupFormState>(
      'submit does nothing when form invalid',
      build: () => SignupFormCubit(repository: repository),
      act: (cubit) => cubit.submit(),
      verify: (_) {
        verifyNever(() => repository.signUp(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ));
      },
    );
  });
}
