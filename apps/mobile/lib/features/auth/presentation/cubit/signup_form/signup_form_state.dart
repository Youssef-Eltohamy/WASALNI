part of 'signup_form_cubit.dart';

class SignupFormState extends Equatable {
  const SignupFormState({
    this.email = const EmailInput.pure(),
    this.password = const PasswordInput.pure(),
    this.confirmPassword = const ConfirmPasswordInput.pure(),
    this.termsAccepted = false,
    this.isSubmitting = false,
    this.errorMessage,
    this.isSuccess = false,
  });

  final EmailInput email;
  final PasswordInput password;
  final ConfirmPasswordInput confirmPassword;
  final bool termsAccepted;
  final bool isSubmitting;
  final String? errorMessage;
  final bool isSuccess;

  bool get isValid =>
      Formz.validate([email, password, confirmPassword]) && termsAccepted;

  SignupFormState copyWith({
    EmailInput? email,
    PasswordInput? password,
    ConfirmPasswordInput? confirmPassword,
    bool? termsAccepted,
    bool? isSubmitting,
    String? errorMessage,
    bool clearError = false,
    bool? isSuccess,
  }) {
    return SignupFormState(
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      termsAccepted: termsAccepted ?? this.termsAccepted,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }

  @override
  List<Object?> get props => [
        email,
        password,
        confirmPassword,
        termsAccepted,
        isSubmitting,
        errorMessage,
        isSuccess,
      ];
}
