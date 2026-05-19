import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wasalni/core/errors/failures.dart';
import 'package:wasalni/features/auth/data/repositories/auth_repository.dart';
import 'package:wasalni/features/auth/domain/entities/auth_user.dart';
import 'package:wasalni/features/auth/presentation/bloc/auth_bloc.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository repository;
  late StreamController<AuthUser?> userStreamController;

  AuthUser confirmedUser() => AuthUser(
        id: 'u-1',
        email: 'user@example.com',
        isEmailConfirmed: true,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      );

  AuthUser unconfirmedUser() => AuthUser(
        id: 'u-2',
        email: 'newbie@example.com',
        isEmailConfirmed: false,
        createdAt: DateTime.now(),
      );

  setUp(() {
    repository = MockAuthRepository();
    userStreamController = StreamController<AuthUser?>.broadcast();
    when(() => repository.authStateChanges)
        .thenAnswer((_) => userStreamController.stream);
  });

  tearDown(() async {
    await userStreamController.close();
  });

  group('AuthBloc — AuthStarted', () {
    blocTest<AuthBloc, AuthState>(
      'emits unauthenticated when no current user',
      build: () {
        when(() => repository.currentUser).thenReturn(null);
        return AuthBloc(repository: repository);
      },
      act: (bloc) => bloc.add(const AuthStarted()),
      expect: () => [
        predicate<AuthState>((s) => s.status == AuthStatus.unauthenticated),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits awaitingEmailConfirmation when user exists but unconfirmed',
      build: () {
        when(() => repository.currentUser).thenReturn(unconfirmedUser());
        return AuthBloc(repository: repository);
      },
      act: (bloc) => bloc.add(const AuthStarted()),
      expect: () => [
        predicate<AuthState>(
          (s) => s.status == AuthStatus.awaitingEmailConfirmation,
        ),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits authenticatedNoProfile when confirmed user',
      build: () {
        when(() => repository.currentUser).thenReturn(confirmedUser());
        return AuthBloc(repository: repository);
      },
      act: (bloc) => bloc.add(const AuthStarted()),
      expect: () => [
        predicate<AuthState>(
          (s) => s.status == AuthStatus.authenticatedNoProfile,
        ),
      ],
    );
  });

  group('AuthBloc — SignupRequested', () {
    blocTest<AuthBloc, AuthState>(
      'emits [processing, awaitingEmailConfirmation] on success',
      build: () {
        when(() => repository.currentUser).thenReturn(null);
        when(() => repository.signUp(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenAnswer((_) async => Right(unconfirmedUser()));
        return AuthBloc(repository: repository);
      },
      act: (bloc) => bloc.add(
        const SignupRequested(email: 'a@b.com', password: 'Pass1234'),
      ),
      expect: () => [
        predicate<AuthState>((s) => s.status == AuthStatus.processing),
        predicate<AuthState>(
          (s) => s.status == AuthStatus.awaitingEmailConfirmation,
        ),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits unauthenticated with failure on signup error',
      build: () {
        when(() => repository.currentUser).thenReturn(null);
        when(() => repository.signUp(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenAnswer(
          (_) async => const Left(AuthFailure('الإيميل مسجل بالفعل')),
        );
        return AuthBloc(repository: repository);
      },
      act: (bloc) => bloc.add(
        const SignupRequested(email: 'a@b.com', password: 'Pass1234'),
      ),
      expect: () => [
        predicate<AuthState>((s) => s.status == AuthStatus.processing),
        predicate<AuthState>(
          (s) =>
              s.status == AuthStatus.unauthenticated &&
              s.failure?.message == 'الإيميل مسجل بالفعل',
        ),
      ],
    );
  });

  group('AuthBloc — ProfileFound/Missing', () {
    blocTest<AuthBloc, AuthState>(
      'ProfileFound transitions authenticatedNoProfile → authenticated',
      build: () {
        when(() => repository.currentUser).thenReturn(confirmedUser());
        return AuthBloc(repository: repository);
      },
      seed: () => AuthState.authenticatedNoProfile(confirmedUser()),
      act: (bloc) => bloc.add(const ProfileFound()),
      expect: () => [
        predicate<AuthState>((s) => s.status == AuthStatus.authenticated),
      ],
    );
  });
}
