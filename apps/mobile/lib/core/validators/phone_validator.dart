import 'package:formz/formz.dart';

enum PhoneValidationError { empty, invalid }

class PhoneInput extends FormzInput<String, PhoneValidationError> {
  const PhoneInput.pure() : super.pure('');
  const PhoneInput.dirty([super.value = '']) : super.dirty();

  static final _normalizedRegex = RegExp(r'^\+201[0125]\d{8}$');

  @override
  PhoneValidationError? validator(String value) {
    if (value.trim().isEmpty) return PhoneValidationError.empty;
    final normalized = tryNormalize(value);
    if (normalized == null) return PhoneValidationError.invalid;
    if (!_normalizedRegex.hasMatch(normalized)) {
      return PhoneValidationError.invalid;
    }
    return null;
  }

  /// يحول أي صيغة مصرية إلى +201XXXXXXXXX
  /// يقبل: 01XXXXXXXXX, 201XXXXXXXXX, 00201XXXXXXXXX, +201XXXXXXXXX
  /// يرجع null لو الرقم مش مصري صالح.
  static String? tryNormalize(String input) {
    var digits = input.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) return null;

    if (digits.startsWith('0020')) {
      digits = digits.substring(2); // '0020XXXXX' -> '20XXXXX'
    } else if (digits.startsWith('20') && digits.length == 12) {
      // already starts with 20 (country code) — keep as is
    } else if (digits.startsWith('01') && digits.length == 11) {
      digits = '2$digits'; // '01XXXXXXXXX' -> '201XXXXXXXXX'
    } else {
      return null;
    }

    final normalized = '+$digits';
    return _normalizedRegex.hasMatch(normalized) ? normalized : null;
  }

  static String? errorMessage(PhoneValidationError? error) {
    return switch (error) {
      PhoneValidationError.empty => 'رقم الموبايل مطلوب',
      PhoneValidationError.invalid => 'رقم الموبايل غير صحيح',
      null => null,
    };
  }
}
