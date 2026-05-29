import '../../../features/auth/auth_exceptions.dart';
import '../../models/profile.dart';
import '../auth_repository.dart';

class _Account {
  _Account({required this.profile, required this.password});
  Profile profile;
  String password;
}

/// In-memory accounts. Magic OTP code = 1234. Codes live 2 min; reset tokens
/// live 5 min. Seeded demo account: +201000000000 / 123456 / "أحمد".
/// Real backend (Supabase auth) replaces this.
class MockAuthRepository implements AuthRepository {
  MockAuthRepository({
    this.latency = const Duration(milliseconds: 500),
    DateTime Function()? now,
  }) : _now = now ?? DateTime.now {
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
  final DateTime Function() _now;
  static const _magicCode = '1234';
  static const _codeValidity = Duration(minutes: 2);
  static const _tokenValidity = Duration(minutes: 5);

  final Map<String, _Account> _accounts = {};
  final Map<String, DateTime> _codeIssuedAt = {}; // by phone
  final Map<String, ({String phone, DateTime issuedAt})> _resetTokens = {}; // by token
  int _tokenSeq = 0;

  bool _hasValidCode(String phone) {
    final issued = _codeIssuedAt[phone];
    return issued != null && _now().difference(issued) < _codeValidity;
  }

  void _issueCode(String phone) => _codeIssuedAt[phone] = _now();

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
    if (_hasValidCode(phone)) throw const OtpResendTooSoonException();
    _issueCode(phone);
  }

  @override
  Future<Profile> confirmSignup({
    required String name,
    required String phone,
    required String password,
    required String code,
  }) async {
    await Future<void>.delayed(latency);
    if (!_hasValidCode(phone)) throw const OtpExpiredException();
    if (code != _magicCode) throw const OtpWrongCodeException();
    final profile = Profile(
      id: 'u_${phone.hashCode.abs()}',
      phone: phone,
      displayName: name,
      createdAt: _now(),
    );
    _accounts[phone] = _Account(profile: profile, password: password);
    _codeIssuedAt.remove(phone);
    return profile;
  }

  @override
  Future<void> startReset({required String phone}) async {
    await Future<void>.delayed(latency);
    if (!_accounts.containsKey(phone)) {
      throw const AccountNotFoundException();
    }
    if (_hasValidCode(phone)) throw const OtpResendTooSoonException();
    _issueCode(phone);
  }

  @override
  Future<String> verifyResetCode({
    required String phone,
    required String code,
  }) async {
    await Future<void>.delayed(latency);
    if (!_hasValidCode(phone)) throw const OtpExpiredException();
    if (code != _magicCode) throw const OtpWrongCodeException();
    final token = 'rt_${_tokenSeq++}';
    _resetTokens[token] = (phone: phone, issuedAt: _now());
    _codeIssuedAt.remove(phone); // code consumed
    return token;
  }

  @override
  Future<Profile> setNewPassword({
    required String phone,
    required String token,
    required String newPassword,
  }) async {
    await Future<void>.delayed(latency);
    final t = _resetTokens[token];
    final valid = t != null &&
        t.phone == phone &&
        _now().difference(t.issuedAt) < _tokenValidity;
    if (!valid) throw const ResetTokenInvalidException();
    final acc = _accounts[phone];
    if (acc == null) throw const ResetTokenInvalidException();
    acc.password = newPassword;
    _resetTokens.remove(token);
    return acc.profile;
  }
}
