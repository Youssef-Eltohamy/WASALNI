import 'package:flutter_test/flutter_test.dart';
import 'package:wasalni/data/repositories/mock/mock_auth_repository.dart';
import 'package:wasalni/features/auth/auth_exceptions.dart';

void main() {
  late MockAuthRepository repo;
  setUp(() => repo = MockAuthRepository(latency: Duration.zero));

  test('requestOtp completes for a normal phone', () async {
    await expectLater(repo.requestOtp('+201000000000'), completes);
  });

  test('verifyOtp with 1234 returns a profile carrying the phone', () async {
    final p = await repo.verifyOtp(phone: '+201000000000', code: '1234');
    expect(p.phone, '+201000000000');
    expect(p.id, isNotEmpty);
  });

  test('wrong code throws OtpWrongCodeException', () {
    expect(() => repo.verifyOtp(phone: '+201000000000', code: '5555'),
        throwsA(isA<OtpWrongCodeException>()));
  });

  test('0000 throws OtpExpiredException', () {
    expect(() => repo.verifyOtp(phone: '+201000000000', code: '0000'),
        throwsA(isA<OtpExpiredException>()));
  });

  test('9999 throws OtpRateLimitedException', () {
    expect(() => repo.verifyOtp(phone: '+201000000000', code: '9999'),
        throwsA(isA<OtpRateLimitedException>()));
  });
}
