import 'package:flutter_test/flutter_test.dart';
import 'package:wasalni/features/auth/phone_validator.dart';

void main() {
  test('accepts 11-digit Egyptian mobile starting 01', () {
    expect(isValidEgyptianMobile('01000000000'), isTrue);
    expect(isValidEgyptianMobile('٠١٠٠٠٠٠٠٠٠٠'), isTrue); // arabic-indic
  });
  test('rejects too short / wrong prefix', () {
    expect(isValidEgyptianMobile('0100'), isFalse);
    expect(isValidEgyptianMobile('02000000000'), isFalse);
    expect(isValidEgyptianMobile(''), isFalse);
  });
}
