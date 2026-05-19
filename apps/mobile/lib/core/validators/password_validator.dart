import 'package:formz/formz.dart';

enum PasswordValidationError { empty, tooShort, noUppercase, noLowercase, noDigit }

class PasswordInput extends FormzInput<String, PasswordValidationError> {
  const PasswordInput.pure() : super.pure('');
  const PasswordInput.dirty([super.value = '']) : super.dirty();

  static const int minLength = 8;

  @override
  PasswordValidationError? validator(String value) {
    if (value.isEmpty) return PasswordValidationError.empty;
    if (value.length < minLength) return PasswordValidationError.tooShort;
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return PasswordValidationError.noUppercase;
    }
    if (!value.contains(RegExp(r'[a-z]'))) {
      return PasswordValidationError.noLowercase;
    }
    if (!value.contains(RegExp(r'\d'))) return PasswordValidationError.noDigit;
    return null;
  }

  static String? errorMessage(PasswordValidationError? error) {
    return switch (error) {
      PasswordValidationError.empty => 'كلمة السر مطلوبة',
      PasswordValidationError.tooShort => 'كلمة السر يجب أن تكون 8 حروف على الأقل',
      PasswordValidationError.noUppercase => 'يجب أن تحتوي على حرف كبير',
      PasswordValidationError.noLowercase => 'يجب أن تحتوي على حرف صغير',
      PasswordValidationError.noDigit => 'يجب أن تحتوي على رقم',
      null => null,
    };
  }
}

enum ConfirmPasswordValidationError { empty, mismatch }

class ConfirmPasswordInput
    extends FormzInput<String, ConfirmPasswordValidationError> {
  const ConfirmPasswordInput.pure({this.password = ''}) : super.pure('');
  const ConfirmPasswordInput.dirty({
    required this.password,
    String value = '',
  }) : super.dirty(value);

  final String password;

  @override
  ConfirmPasswordValidationError? validator(String value) {
    if (value.isEmpty) return ConfirmPasswordValidationError.empty;
    if (value != password) return ConfirmPasswordValidationError.mismatch;
    return null;
  }

  static String? errorMessage(ConfirmPasswordValidationError? error) {
    return switch (error) {
      ConfirmPasswordValidationError.empty => 'تأكيد كلمة السر مطلوب',
      ConfirmPasswordValidationError.mismatch => 'كلمة السر غير مطابقة',
      null => null,
    };
  }
}
