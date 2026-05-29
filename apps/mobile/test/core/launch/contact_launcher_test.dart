import 'package:flutter_test/flutter_test.dart';
import 'package:wasalni/core/launch/contact_launcher.dart';

void main() {
  group('toE164', () {
    test('keeps an already-normalized number', () {
      expect(toE164('+201000000001'), '+201000000001');
    });
    test('converts a local 0-prefixed number', () {
      expect(toE164('01000000001'), '+201000000001');
    });
    test('converts Arabic-Indic digits', () {
      expect(toE164('٠١٠٠٠٠٠٠٠٠١'), '+201000000001');
    });
    test('strips spaces and separators', () {
      expect(toE164('0100 000 0001'), '+201000000001');
    });
  });
}
