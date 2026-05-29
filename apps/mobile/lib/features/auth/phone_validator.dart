const _arabicDigits = '٠١٢٣٤٥٦٧٨٩';

String normalizeDigits(String raw) {
  final b = StringBuffer();
  for (final ch in raw.trim().split('')) {
    final ai = _arabicDigits.indexOf(ch);
    if (ai >= 0) {
      b.write(ai);
    } else if (ch.codeUnitAt(0) >= 0x30 && ch.codeUnitAt(0) <= 0x39) {
      b.write(ch);
    }
  }
  return b.toString();
}

/// Egyptian mobile: 11 digits starting with 01 (after digit normalization).
bool isValidEgyptianMobile(String raw) {
  final d = normalizeDigits(raw);
  return d.length == 11 && d.startsWith('01');
}
