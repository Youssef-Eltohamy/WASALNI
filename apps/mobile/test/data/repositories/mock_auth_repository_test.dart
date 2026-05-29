import 'package:flutter_test/flutter_test.dart';
import 'package:wasalni/data/repositories/mock/mock_auth_repository.dart';
import 'package:wasalni/features/auth/auth_exceptions.dart';

void main() {
  late MockAuthRepository repo;
  setUp(() => repo = MockAuthRepository(latency: Duration.zero));

  group('login', () {
    test('seeded demo account logs in', () async {
      final p = await repo.login(phone: '+201000000000', password: '123456');
      expect(p.phone, '+201000000000');
      expect(p.displayName, 'أحمد');
    });
    test('wrong password throws WrongCredentialsException', () {
      expect(() => repo.login(phone: '+201000000000', password: 'nope'),
          throwsA(isA<WrongCredentialsException>()));
    });
    test('unknown phone throws WrongCredentialsException', () {
      expect(() => repo.login(phone: '+201111111111', password: '123456'),
          throwsA(isA<WrongCredentialsException>()));
    });
  });

  group('signup', () {
    test('startSignup on a free phone completes', () async {
      await expectLater(repo.startSignup(phone: '+201222222222'), completes);
    });
    test('startSignup on a taken phone throws PhoneAlreadyRegisteredException', () {
      expect(() => repo.startSignup(phone: '+201000000000'),
          throwsA(isA<PhoneAlreadyRegisteredException>()));
    });
    test('confirmSignup with 1234 creates the account and it can log in', () async {
      await repo.startSignup(phone: '+201222222222');
      final p = await repo.confirmSignup(
          name: 'سعيد', phone: '+201222222222', password: 'secret1', code: '1234');
      expect(p.displayName, 'سعيد');
      final again = await repo.login(phone: '+201222222222', password: 'secret1');
      expect(again.phone, '+201222222222');
    });
    test('confirmSignup with wrong code throws OtpWrongCodeException', () {
      expect(
          () => repo.confirmSignup(
              name: 'x', phone: '+201222222222', password: 'secret1', code: '0000'),
          throwsA(isA<OtpWrongCodeException>()));
    });
  });

  group('reset', () {
    test('startReset on existing account completes', () async {
      await expectLater(repo.startReset(phone: '+201000000000'), completes);
    });
    test('startReset on unknown phone throws AccountNotFoundException', () {
      expect(() => repo.startReset(phone: '+201999999999'),
          throwsA(isA<AccountNotFoundException>()));
    });
    test('confirmReset sets a new password that then logs in', () async {
      await repo.startReset(phone: '+201000000000');
      await repo.confirmReset(
          phone: '+201000000000', code: '1234', newPassword: 'brandnew');
      final p = await repo.login(phone: '+201000000000', password: 'brandnew');
      expect(p.phone, '+201000000000');
    });
    test('confirmReset with wrong code throws OtpWrongCodeException', () {
      expect(
          () => repo.confirmReset(
              phone: '+201000000000', code: '0000', newPassword: 'brandnew'),
          throwsA(isA<OtpWrongCodeException>()));
    });
  });
}
