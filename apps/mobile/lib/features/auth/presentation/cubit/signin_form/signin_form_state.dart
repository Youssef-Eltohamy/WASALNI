part of 'signin_form_cubit.dart';

class SigninFormState extends Equatable {
  const SigninFormState({
    this.email = const EmailInput.pure(),
    this.password = const SigninPasswordInput.pure(),
    this.isSubmitting = false,
    this.errorMessage,
    this.needsEmailConfirmation = false,
  });

  final EmailInput email;
  final SigninPasswordInput password;
  final bool isSubmitting;
  final String? errorMessage;
  final bool needsEmailConfirmation;

  bool get isValid => Formz.validate([email, password]);

  SigninFormState copyWith({
    EmailInput? email,
    SigninPasswordInput? password,
    bool? isSubmitting,
    String? errorMessage,
    bool clearError = false,
    bool? needsEmailConfirmation,
  }) {
    return SigninFormState(
      email: email ?? this.email,
      password: password ?? this.password,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      needsEmailConfirmation:
          needsEmailConfirmation ?? this.needsEmailConfirmation,
    );
  }

  @override
  List<Object?> get props => [
        email,
        password,
        isSubmitting,
        errorMessage,
        needsEmailConfirmation,
      ];
}

/// Signin يقبل أي كلمة سر غير فاضية (الـ server يتحقق فعلياً)
class SigninPasswordInput extends FormzInput<String, SigninPasswordError> {
  const SigninPasswordInput.pure() : super.pure('');
  const SigninPasswordInput.dirty([super.value = '']) : super.dirty();

  @override
  SigninPasswordError? validator(String value) {
    return value.isEmpty ? SigninPasswordError.empty : null;
  }
}

enum SigninPasswordError { empty }
