/// Auth-flow errors. Cubits map each to a distinct UI message.
sealed class AuthException implements Exception {
  const AuthException([this.message]);
  final String? message;
}

/// Login failed — wrong phone or password (don't reveal which).
class WrongCredentialsException extends AuthException {
  const WrongCredentialsException() : super('رقم الموبايل أو كلمة السر غلط');
}

/// Signup on a phone that already has an account.
class PhoneAlreadyRegisteredException extends AuthException {
  const PhoneAlreadyRegisteredException() : super('الرقم ده مسجّل قبل كده، سجّل دخولك');
}

/// Reset requested for a phone with no account.
class AccountNotFoundException extends AuthException {
  const AccountNotFoundException() : super('مفيش حساب على الرقم ده');
}

/// OTP verification code is incorrect.
class OtpWrongCodeException extends AuthException {
  const OtpWrongCodeException() : super('الكود غلط، جرّب تاني');
}

/// OTP code is past its 2-minute validity window.
class OtpExpiredException extends AuthException {
  const OtpExpiredException() : super('الكود خلصت صلاحيته، اطلب كود جديد');
}

/// A still-valid code already exists for this phone — resend is blocked.
class OtpResendTooSoonException extends AuthException {
  const OtpResendTooSoonException()
      : super('عندك كود لسه شغّال، استناه يخلص الأول');
}

/// Reset token is unknown, mismatched, or past its 5-minute validity.
class ResetTokenInvalidException extends AuthException {
  const ResetTokenInvalidException()
      : super('انتهت الجلسة، ابدأ من أول رقم الموبايل');
}
