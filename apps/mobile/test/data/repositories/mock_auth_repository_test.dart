import 'package:flutter_test/flutter_test.dart';
import 'package:wasalni/data/repositories/mock/mock_auth_repository.dart';
import 'package:wasalni/features/auth/auth_exceptions.dart';

void main() {
  late DateTime clock;
  late MockAuthRepository repo;

  setUp(() {
    clock = DateTime(2026, 1, 1, 12, 0, 0);
    repo = MockAuthRepository(latency: Duration.zero, now: () => clock);
  });

  group('login', () {
    test('seeded demo account logs in', () async {
      final p = await repo.login(phone: '+201000000000', password: '123456');
      expect(p.displayName, 'أحمد');
    });
    test('wrong password throws WrongCredentialsException', () {
      expect(() => repo.login(phone: '+201000000000', password: 'nope'),
          throwsA(isA<WrongCredentialsException>()));
    });
  });

  group('signup', () {
    test('startSignup on a free phone issues a code', () async {
      await expectLater(repo.startSignup(phone: '+201222222222'), completes);
    });
    test('startSignup on a taken phone throws PhoneAlreadyRegisteredException', () {
      expect(() => repo.startSignup(phone: '+201000000000'),
          throwsA(isA<PhoneAlreadyRegisteredException>()));
    });
    test('resend while code still valid throws OtpResendTooSoonException', () async {
      await repo.startSignup(phone: '+201222222222');
      expect(() => repo.startSignup(phone: '+201222222222'),
          throwsA(isA<OtpResendTooSoonException>()));
    });
    test('resend after code expires succeeds', () async {
      await repo.startSignup(phone: '+201222222222');
      clock = clock.add(const Duration(minutes: 3));
      await expectLater(repo.startSignup(phone: '+201222222222'), completes);
    });
    test('confirmSignup with 1234 creates an account that logs in', () async {
      await repo.startSignup(phone: '+201222222222');
      final p = await repo.confirmSignup(
          name: 'سعيد', phone: '+201222222222', password: 'secret1', code: '1234');
      expect(p.displayName, 'سعيد');
      final again = await repo.login(phone: '+201222222222', password: 'secret1');
      expect(again.phone, '+201222222222');
    });
    test('confirmSignup with wrong code throws OtpWrongCodeException', () async {
      await repo.startSignup(phone: '+201222222222');
      expect(
          () => repo.confirmSignup(
              name: 'x', phone: '+201222222222', password: 'secret1', code: '0000'),
          throwsA(isA<OtpWrongCodeException>()));
    });
    test('confirmSignup after code expires throws OtpExpiredException', () async {
      await repo.startSignup(phone: '+201222222222');
      clock = clock.add(const Duration(minutes: 3));
      expect(
          () => repo.confirmSignup(
              name: 'x', phone: '+201222222222', password: 'secret1', code: '1234'),
          throwsA(isA<OtpExpiredException>()));
    });
  });

  group('reset', () {
    test('startReset on an existing account issues a code', () async {
      await expectLater(repo.startReset(phone: '+201000000000'), completes);
    });
    test('startReset on unknown phone throws AccountNotFoundException', () {
      expect(() => repo.startReset(phone: '+201999999999'),
          throwsA(isA<AccountNotFoundException>()));
    });
    test('resend while code still valid throws OtpResendTooSoonException', () async {
      await repo.startReset(phone: '+201000000000');
      expect(() => repo.startReset(phone: '+201000000000'),
          throwsA(isA<OtpResendTooSoonException>()));
    });
    test('verifyResetCode returns a token; setNewPassword then logs in', () async {
      await repo.startReset(phone: '+201000000000');
      final token = await repo.verifyResetCode(phone: '+201000000000', code: '1234');
      expect(token, isNotEmpty);
      await repo.setNewPassword(
          phone: '+201000000000', token: token, newPassword: 'brandnew');
      final p = await repo.login(phone: '+201000000000', password: 'brandnew');
      expect(p.phone, '+201000000000');
    });
    test('verifyResetCode with wrong code throws OtpWrongCodeException', () async {
      await repo.startReset(phone: '+201000000000');
      expect(() => repo.verifyResetCode(phone: '+201000000000', code: '0000'),
          throwsA(isA<OtpWrongCodeException>()));
    });
    test('verifyResetCode after expiry throws OtpExpiredException', () async {
      await repo.startReset(phone: '+201000000000');
      clock = clock.add(const Duration(minutes: 3));
      expect(() => repo.verifyResetCode(phone: '+201000000000', code: '1234'),
          throwsA(isA<OtpExpiredException>()));
    });
    test('setNewPassword with a bad token throws ResetTokenInvalidException', () {
      expect(
          () => repo.setNewPassword(
              phone: '+201000000000', token: 'nope', newPassword: 'x'),
          throwsA(isA<ResetTokenInvalidException>()));
    });
    test('setNewPassword after token expires throws ResetTokenInvalidException', () async {
      await repo.startReset(phone: '+201000000000');
      final token = await repo.verifyResetCode(phone: '+201000000000', code: '1234');
      clock = clock.add(const Duration(minutes: 6));
      expect(
          () => repo.setNewPassword(
              phone: '+201000000000', token: token, newPassword: 'x'),
          throwsA(isA<ResetTokenInvalidException>()));
    });
  });
}
