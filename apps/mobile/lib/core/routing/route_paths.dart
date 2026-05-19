class RoutePaths {
  RoutePaths._();

  static const String splash = '/';
  static const String feed = '/feed';

  // Auth
  static const String signup = '/auth/signup';
  static const String signin = '/auth/signin';
  static const String emailConfirmation = '/auth/email-confirmation';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';

  // Deep link landing routes (Supabase redirect targets)
  static const String authConfirmCallback = '/auth/confirm';
  static const String authResetPasswordCallback = '/auth/reset-password-callback';

  // Profile
  static const String profileSetup = '/profile/setup';
  static const String myAccount = '/profile/me';
  static const String editProfile = '/profile/edit';

  // Legal
  static const String terms = '/legal/terms';
  static const String privacy = '/legal/privacy';
}
