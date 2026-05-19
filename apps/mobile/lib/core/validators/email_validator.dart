import 'package:formz/formz.dart';

enum EmailValidationError { empty, invalid }

class EmailInput extends FormzInput<String, EmailValidationError> {
  const EmailInput.pure() : super.pure('');
  const EmailInput.dirty([super.value = '']) : super.dirty();

  static final _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  @override
  EmailValidationError? validator(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return EmailValidationError.empty;
    if (!_emailRegex.hasMatch(trimmed)) return EmailValidationError.invalid;
    return null;
  }

  static String? errorMessage(EmailValidationError? error) {
    return switch (error) {
      EmailValidationError.empty => 'الإيميل مطلوب',
      EmailValidationError.invalid => 'تنسيق الإيميل غير صحيح',
      null => null,
    };
  }
}
