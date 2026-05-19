import 'package:flutter_test/flutter_test.dart';
import 'package:wasalni/core/validators/password_validator.dart';

void main() {
  group('PasswordInput', () {
    test('pure has no displayError', () {
      const input = PasswordInput.pure();
      expect(input.displayError, isNull);
    });

    test('empty returns empty error', () {
      const input = PasswordInput.dirty('');
      expect(input.error, PasswordValidationError.empty);
    });

    test('too short returns tooShort error', () {
      const input = PasswordInput.dirty('Aa1');
      expect(input.error, PasswordValidationError.tooShort);
    });

    test('no uppercase returns noUppercase error', () {
      const input = PasswordInput.dirty('aaaa1234');
      expect(input.error, PasswordValidationError.noUppercase);
    });

    test('no lowercase returns noLowercase error', () {
      const input = PasswordInput.dirty('AAAA1234');
      expect(input.error, PasswordValidationError.noLowercase);
    });

    test('no digit returns noDigit error', () {
      const input = PasswordInput.dirty('Abcdefgh');
      expect(input.error, PasswordValidationError.noDigit);
    });

    test('valid password passes', () {
      const input = PasswordInput.dirty('Strong1234');
      expect(input.error, isNull);
    });

    test('error messages mapped correctly', () {
      expect(
        PasswordInput.errorMessage(PasswordValidationError.tooShort),
        'كلمة السر يجب أن تكون 8 حروف على الأقل',
      );
      expect(
        PasswordInput.errorMessage(PasswordValidationError.noDigit),
        'يجب أن تحتوي على رقم',
      );
    });
  });

  group('ConfirmPasswordInput', () {
    test('empty returns empty error', () {
      const input = ConfirmPasswordInput.dirty(password: 'Abc1');
      expect(input.error, ConfirmPasswordValidationError.empty);
    });

    test('mismatch returns mismatch error', () {
      const input = ConfirmPasswordInput.dirty(
        password: 'Abc12345',
        value: 'Abc99999',
      );
      expect(input.error, ConfirmPasswordValidationError.mismatch);
    });

    test('matching passwords pass', () {
      const input = ConfirmPasswordInput.dirty(
        password: 'Abc12345',
        value: 'Abc12345',
      );
      expect(input.error, isNull);
    });
  });
}
