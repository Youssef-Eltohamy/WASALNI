import '../models/profile.dart';

abstract interface class AuthRepository {
  /// Logs in with phone + password. Throws [WrongCredentialsException] on failure.
  Future<Profile> login({required String phone, required String password});

  /// Starts signup: validates the phone is free and "sends" an OTP.
  /// Throws [PhoneAlreadyRegisteredException] if the phone is taken.
  Future<void> startSignup({required String phone});

  /// Confirms signup with the OTP code, creates the account, returns the profile.
  /// Throws [OtpWrongCodeException] on a bad code.
  Future<Profile> confirmSignup({
    required String name,
    required String phone,
    required String password,
    required String code,
  });

  /// Starts a password reset: validates the account exists and "sends" an OTP.
  /// Throws [AccountNotFoundException] if there is no account.
  Future<void> startReset({required String phone});

  /// Verifies a reset OTP and returns a short-lived reset token.
  /// Throws [OtpWrongCodeException] on a bad code, [OtpExpiredException] if expired.
  Future<String> verifyResetCode({required String phone, required String code});

  /// Sets a new password using a reset token from [verifyResetCode].
  /// Throws [ResetTokenInvalidException] if the token is bad or expired.
  Future<Profile> setNewPassword({
    required String phone,
    required String token,
    required String newPassword,
  });
}
