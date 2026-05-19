import 'package:flutter_test/flutter_test.dart';
import 'package:wasalni/core/validators/email_validator.dart';

void main() {
  group('EmailInput', () {
    test('pure() returns no displayError', () {
      const input = EmailInput.pure();
      expect(input.displayError, isNull);
    });

    test('empty string returns empty error when dirty', () {
      const input = EmailInput.dirty('');
      expect(input.error, EmailValidationError.empty);
    });

    test('whitespace-only returns empty error', () {
      const input = EmailInput.dirty('   ');
      expect(input.error, EmailValidationError.empty);
    });

    test('valid email passes', () {
      const input = EmailInput.dirty('user@example.com');
      expect(input.error, isNull);
    });

    test('valid email with subdomain passes', () {
      const input = EmailInput.dirty('user@mail.example.co');
      expect(input.error, isNull);
    });

    test('valid email with plus alias passes', () {
      const input = EmailInput.dirty('user+test@example.com');
      expect(input.error, isNull);
    });

    test('invalid: missing @', () {
      const input = EmailInput.dirty('userexample.com');
      expect(input.error, EmailValidationError.invalid);
    });

    test('invalid: missing TLD', () {
      const input = EmailInput.dirty('user@example');
      expect(input.error, EmailValidationError.invalid);
    });

    test('invalid: spaces in email', () {
      const input = EmailInput.dirty('user @example.com');
      expect(input.error, EmailValidationError.invalid);
    });

    test('errorMessage maps correctly', () {
      expect(
        EmailInput.errorMessage(EmailValidationError.empty),
        'الإيميل مطلوب',
      );
      expect(
        EmailInput.errorMessage(EmailValidationError.invalid),
        'تنسيق الإيميل غير صحيح',
      );
      expect(EmailInput.errorMessage(null), isNull);
    });
  });
}
