/// OTP-flow errors. The OtpCubit maps each to a distinct UI state.
sealed class AuthException implements Exception {
  const AuthException([this.message]);
  final String? message;
}

class OtpWrongCodeException extends AuthException {
  const OtpWrongCodeException() : super('الكود غلط، جرّب تاني');
}

class OtpExpiredException extends AuthException {
  const OtpExpiredException() : super('الكود انتهت صلاحيته، اطلب كود جديد');
}

class OtpRateLimitedException extends AuthException {
  const OtpRateLimitedException() : super('حاولت كتير، استنى شوية وجرّب تاني');
}
