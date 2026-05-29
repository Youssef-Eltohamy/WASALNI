import '../../../features/auth/auth_exceptions.dart';
import '../../models/profile.dart';
import '../auth_repository.dart';

class _Account {
  _Account({required this.profile, required this.password});
  Profile profile;
  String password;
}

/// In-memory accounts. Magic OTP code = 1234. Seeded demo account:
/// +201000000000 / 123456 / "أحمد". Real backend (Supabase auth) replaces this.
class MockAuthRepository implements AuthRepository {
  MockAuthRepository({this.latency = const Duration(milliseconds: 500)}) {
    _accounts['+201000000000'] = _Account(
      profile: Profile(
        id: 'u_demo',
        phone: '+201000000000',
        displayName: 'أحمد',
        createdAt: DateTime(2026, 1, 1),
      ),
      password: '123456',
    );
  }

  final Duration latency;
  static const _magicCode = '1234';
  final Map<String, _Account> _accounts = {};

  @override
  Future<Profile> login({required String phone, required String password}) async {
    await Future<void>.delayed(latency);
    final acc = _accounts[phone];
    if (acc == null || acc.password != password) {
      throw const WrongCredentialsException();
    }
    return acc.profile;
  }

  @override
  Future<void> startSignup({required String phone}) async {
    await Future<void>.delayed(latency);
    if (_accounts.containsKey(phone)) {
      throw const PhoneAlreadyRegisteredException();
    }
  }

  @override
  Future<Profile> confirmSignup({
    required String name,
    required String phone,
    required String password,
    required String code,
  }) async {
    await Future<void>.delayed(latency);
    if (code != _magicCode) throw const OtpWrongCodeException();
    final profile = Profile(
      id: 'u_${phone.hashCode.abs()}',
      phone: phone,
      displayName: name,
      createdAt: DateTime.now(),
    );
    _accounts[phone] = _Account(profile: profile, password: password);
    return profile;
  }

  @override
  Future<void> startReset({required String phone}) async {
    await Future<void>.delayed(latency);
    if (!_accounts.containsKey(phone)) {
      throw const AccountNotFoundException();
    }
  }

  @override
  Future<Profile> confirmReset({
    required String phone,
    required String code,
    required String newPassword,
  }) async {
    await Future<void>.delayed(latency);
    if (code != _magicCode) throw const OtpWrongCodeException();
    final acc = _accounts[phone];
    if (acc == null) throw const AccountNotFoundException();
    acc.password = newPassword;
    return acc.profile;
  }
}
