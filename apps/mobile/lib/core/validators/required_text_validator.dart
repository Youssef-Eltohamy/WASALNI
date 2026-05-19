import 'package:formz/formz.dart';

enum RequiredTextValidationError { empty, tooShort }

class RequiredTextInput
    extends FormzInput<String, RequiredTextValidationError> {
  const RequiredTextInput.pure({this.minLength = 1, this.fieldName = 'الحقل'})
      : super.pure('');
  const RequiredTextInput.dirty({
    String value = '',
    this.minLength = 1,
    this.fieldName = 'الحقل',
  }) : super.dirty(value);

  final int minLength;
  final String fieldName;

  @override
  RequiredTextValidationError? validator(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return RequiredTextValidationError.empty;
    if (trimmed.length < minLength) {
      return RequiredTextValidationError.tooShort;
    }
    return null;
  }

  String? errorMessage(RequiredTextValidationError? error) {
    return switch (error) {
      RequiredTextValidationError.empty => '$fieldName مطلوب',
      RequiredTextValidationError.tooShort =>
        '$fieldName يجب أن يكون $minLength حروف على الأقل',
      null => null,
    };
  }
}
