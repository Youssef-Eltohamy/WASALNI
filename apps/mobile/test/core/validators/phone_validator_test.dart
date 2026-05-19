import 'package:flutter_test/flutter_test.dart';
import 'package:wasalni/core/validators/phone_validator.dart';

void main() {
  group('PhoneInput validation', () {
    test('empty returns empty error', () {
      const input = PhoneInput.dirty('');
      expect(input.error, PhoneValidationError.empty);
    });

    test('whitespace returns empty error', () {
      const input = PhoneInput.dirty('   ');
      expect(input.error, PhoneValidationError.empty);
    });

    test('valid +20 format passes', () {
      const input = PhoneInput.dirty('+201012345678');
      expect(input.error, isNull);
    });

    test('valid 01 format passes (normalization applied)', () {
      const input = PhoneInput.dirty('01012345678');
      expect(input.error, isNull);
    });

    test('valid 20 format passes', () {
      const input = PhoneInput.dirty('201012345678');
      expect(input.error, isNull);
    });

    test('valid 0020 format passes', () {
      const input = PhoneInput.dirty('00201012345678');
      expect(input.error, isNull);
    });

    test('non-egyptian operator (016) is invalid', () {
      const input = PhoneInput.dirty('01612345678');
      expect(input.error, PhoneValidationError.invalid);
    });

    test('too short is invalid', () {
      const input = PhoneInput.dirty('0101234');
      expect(input.error, PhoneValidationError.invalid);
    });

    test('non-numeric is invalid', () {
      const input = PhoneInput.dirty('abcdefghi');
      expect(input.error, PhoneValidationError.invalid);
    });
  });

  group('PhoneInput.tryNormalize', () {
    test('01XXXXXXXXX -> +201XXXXXXXXX', () {
      expect(PhoneInput.tryNormalize('01012345678'), '+201012345678');
      expect(PhoneInput.tryNormalize('01112345678'), '+201112345678');
      expect(PhoneInput.tryNormalize('01212345678'), '+201212345678');
      expect(PhoneInput.tryNormalize('01512345678'), '+201512345678');
    });

    test('201XXXXXXXXX -> +201XXXXXXXXX', () {
      expect(PhoneInput.tryNormalize('201012345678'), '+201012345678');
    });

    test('00201XXXXXXXXX -> +201XXXXXXXXX', () {
      expect(PhoneInput.tryNormalize('00201012345678'), '+201012345678');
    });

    test('+201XXXXXXXXX -> +201XXXXXXXXX (idempotent)', () {
      expect(PhoneInput.tryNormalize('+201012345678'), '+201012345678');
    });

    test('handles formatted input', () {
      expect(PhoneInput.tryNormalize('010 1234 5678'), '+201012345678');
      expect(PhoneInput.tryNormalize('010-1234-5678'), '+201012345678');
      expect(PhoneInput.tryNormalize('(010) 1234-5678'), '+201012345678');
    });

    test('returns null for invalid operator', () {
      expect(PhoneInput.tryNormalize('01612345678'), isNull);
    });

    test('returns null for too short', () {
      expect(PhoneInput.tryNormalize('010123'), isNull);
    });

    test('returns null for empty', () {
      expect(PhoneInput.tryNormalize(''), isNull);
    });
  });
}
