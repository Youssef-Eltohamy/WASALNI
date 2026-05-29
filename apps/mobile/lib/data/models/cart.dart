import 'package:freezed_annotation/freezed_annotation.dart';

part 'cart.freezed.dart';

@freezed
abstract class CartLine with _$CartLine {
  const CartLine._();
  const factory CartLine({
    required String productId,
    required String name,
    required double priceEgp,
    @Default(1) int qty,
    @Default(false) bool isUnavailable,
    double? latestPriceEgp,
  }) = _CartLine;

  /// Price to charge now (latest from revalidation if known, else the snapshot).
  double get effectivePrice => latestPriceEgp ?? priceEgp;
  double get lineTotal => effectivePrice * qty;
  bool get priceChanged => latestPriceEgp != null && latestPriceEgp != priceEgp;
}

@freezed
abstract class ShopCart with _$ShopCart {
  const ShopCart._();
  const factory ShopCart({
    required String shopId,
    required String shopName,
    required String shopPhone,
    @Default(<CartLine>[]) List<CartLine> lines,
  }) = _ShopCart;

  double get total =>
      lines.fold(0, (sum, l) => sum + (l.isUnavailable ? 0 : l.lineTotal));
  int get itemCount => lines.fold(0, (sum, l) => sum + l.qty);
  bool get canSend =>
      shopPhone.trim().isNotEmpty && lines.any((l) => !l.isUnavailable);
  bool get hasIssues => lines.any((l) => l.isUnavailable || l.priceChanged);
}

@freezed
abstract class Cart with _$Cart {
  const Cart._();
  const factory Cart({@Default(<ShopCart>[]) List<ShopCart> shopCarts}) = _Cart;

  bool get isEmpty => shopCarts.every((s) => s.lines.isEmpty);
  int get totalItemCount =>
      shopCarts.fold(0, (sum, s) => sum + s.itemCount);
  ShopCart? shopCart(String shopId) {
    for (final s in shopCarts) {
      if (s.shopId == shopId) return s;
    }
    return null;
  }
}
