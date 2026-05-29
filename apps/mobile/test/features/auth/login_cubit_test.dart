import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wasalni/data/models/profile.dart';
import 'package:wasalni/data/repositories/auth_repository.dart';
import 'package:wasalni/features/auth/auth_exceptions.dart';
import 'package:wasalni/features/auth/bloc/login_cubit.dart';
import 'package:wasalni/features/auth/bloc/login_state.dart';

class MockAuthRepo extends Mock implements AuthRepository {}

Profile _p() => Profile(id: 'u1', phone: '+201000000000', displayName: 'أحمد', createdAt: DateTime(2026));

void main() {
  late MockAuthRepo repo;
  setUp(() => repo = MockAuthRepo());

  blocTest<LoginCubit, LoginState>(
    'success: [submitting, success]',
    build: () {
      when(() => repo.login(phone: any(named: 'phone'), password: any(named: 'password')))
          .thenAnswer((_) async => _p());
      return LoginCubit(repo);
    },
    act: (c) => c.submit(phone: '+201000000000', password: '123456'),
    expect: () => [isA<LoginSubmitting>(), isA<LoginSuccess>()],
  );

  blocTest<LoginCubit, LoginState>(
    'wrong credentials: [submitting, error]',
    build: () {
      when(() => repo.login(phone: any(named: 'phone'), password: any(named: 'password')))
          .thenThrow(const WrongCredentialsException());
      return LoginCubit(repo);
    },
    act: (c) => c.submit(phone: '+201000000000', password: 'nope'),
    expect: () => [isA<LoginSubmitting>(), isA<LoginError>()],
  );
}
