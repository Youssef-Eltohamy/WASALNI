import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wasalni/data/models/profile.dart';
import 'package:wasalni/data/repositories/auth_repository.dart';
import 'package:wasalni/features/auth/auth_exceptions.dart';
import 'package:wasalni/features/auth/bloc/reset_password_cubit.dart';
import 'package:wasalni/features/auth/bloc/reset_password_state.dart';

class MockAuthRepo extends Mock implements AuthRepository {}

Profile _p() => Profile(
    id: 'u1', phone: '+201000000000', displayName: 'أحمد', createdAt: DateTime(2026));

void main() {
  late MockAuthRepo repo;
  setUp(() => repo = MockAuthRepo());

  blocTest<ResetPasswordCubit, ResetPasswordState>(
    'success → [submitting, success]',
    build: () {
      when(() => repo.setNewPassword(
              phone: any(named: 'phone'),
              token: any(named: 'token'),
              newPassword: any(named: 'newPassword')))
          .thenAnswer((_) async => _p());
      return ResetPasswordCubit(repo, '+201000000000', 'rt_0');
    },
    act: (c) => c.submit('brandnew'),
    expect: () => [isA<ResetPasswordSubmitting>(), isA<ResetPasswordSuccess>()],
  );

  blocTest<ResetPasswordCubit, ResetPasswordState>(
    'invalid token → [submitting, tokenInvalid]',
    build: () {
      when(() => repo.setNewPassword(
              phone: any(named: 'phone'),
              token: any(named: 'token'),
              newPassword: any(named: 'newPassword')))
          .thenThrow(const ResetTokenInvalidException());
      return ResetPasswordCubit(repo, '+201000000000', 'bogus');
    },
    act: (c) => c.submit('brandnew'),
    expect: () =>
        [isA<ResetPasswordSubmitting>(), isA<ResetPasswordTokenInvalid>()],
  );
}
