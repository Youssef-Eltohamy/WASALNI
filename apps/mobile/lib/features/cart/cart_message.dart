import '../../core/format/money.dart';
import '../../data/models/cart.dart';

/// Builds the pre-filled WhatsApp order message for one shop's cart.
String buildOrderMessage(ShopCart shop, {required String userName}) {
  final b = StringBuffer()
    ..writeln('السلام عليكم 👋')
    ..writeln('حابب أطلب من ${shop.shopName}:')
    ..writeln();
  for (final l in shop.lines) {
    if (l.isUnavailable) continue;
    b.writeln('• ${l.name} × ${l.qty} — ${formatEgp(l.lineTotal)}');
  }
  b
    ..writeln()
    ..writeln('الإجمالي: ${formatEgp(shop.total)}');
  if (userName.trim().isNotEmpty) {
    b.writeln('اسمي: ${userName.trim()}');
  }
  b.write('(الطلب من تطبيق وصلني)');
  return b.toString();
}
