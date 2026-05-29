import '../../../features/auth/auth_exceptions.dart';
import '../../models/profile.dart';
import '../auth_repository.dart';

/// Mock OTP. Magic codes: 1234 = success, 0000 = expired, 9999 = rate-limited,
/// everything else = wrong code. Real OTP server is deferred to the backend phase.
class MockAuthRepository implements AuthRepository {
  MockAuthRepository({this.latency = const Duration(milliseconds: 500)});
  final Duration latency;

  @override
  Future<void> requestOtp(String phone) async {
    await Future<void>.delayed(latency);
  }

  @override
  Future<Profile> verifyOtp({required String phone, required String code}) async {
    await Future<void>.delayed(latency);
    switch (code) {
      case '0000':
        throw const OtpExpiredException();
      case '9999':
        throw const OtpRateLimitedException();
      case '1234':
        return Profile(
          id: 'u_${phone.hashCode.abs()}',
          phone: phone,
          displayName: '',
          createdAt: DateTime.now(),
        );
      default:
        throw const OtpWrongCodeException();
    }
  }
}
