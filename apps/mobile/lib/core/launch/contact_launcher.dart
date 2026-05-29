import 'package:url_launcher/url_launcher.dart';

const _arabicDigits = '٠١٢٣٤٥٦٧٨٩';

/// Normalizes an Egyptian phone number to E.164 (`+20...`).
/// Accepts already-E.164, `00`-prefixed, local `0`-prefixed, or bare numbers,
/// and converts Arabic-Indic digits to ASCII. Strips spaces/dashes/parens.
String toE164(String raw) {
  final buf = StringBuffer();
  for (final ch in raw.trim().split('')) {
    final ai = _arabicDigits.indexOf(ch);
    if (ai >= 0) {
      buf.write(ai);
    } else if (ch == '+' || (ch.codeUnitAt(0) >= 0x30 && ch.codeUnitAt(0) <= 0x39)) {
      buf.write(ch);
    }
  }
  final s = buf.toString();
  if (s.startsWith('+')) return s;
  if (s.startsWith('00')) return '+${s.substring(2)}';
  if (s.startsWith('0')) return '+20${s.substring(1)}';
  if (s.startsWith('20')) return '+$s';
  return '+20$s';
}

/// Launches external contact channels. Returns false if the channel can't be opened
/// (e.g. WhatsApp not installed), so the caller can show a fallback.
class ContactLauncher {
  const ContactLauncher();

  Future<bool> whatsapp(String phone, {String? message}) {
    final number = toE164(phone).replaceFirst('+', '');
    final suffix = (message == null || message.isEmpty)
        ? ''
        : '?text=${Uri.encodeComponent(message)}';
    return _launch(Uri.parse('https://wa.me/$number$suffix'));
  }

  Future<bool> call(String phone) => _launch(Uri.parse('tel:${toE164(phone)}'));

  Future<bool> _launch(Uri uri) async {
    if (await canLaunchUrl(uri)) {
      return launchUrl(uri, mode: LaunchMode.externalApplication);
    }
    return false;
  }
}
