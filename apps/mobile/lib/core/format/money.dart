/// Formats an EGP amount for display, e.g. 35.0 -> "35 جنيه".
String formatEgp(double amount) {
  final whole = amount == amount.roundToDouble();
  final n = whole ? amount.toStringAsFixed(0) : amount.toStringAsFixed(2);
  return '$n جنيه';
}
