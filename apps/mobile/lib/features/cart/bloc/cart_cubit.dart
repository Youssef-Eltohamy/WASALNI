import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/cart.dart';
import '../../../data/models/product.dart';

/// In-memory cart, grouped per shop. Registered as a singleton so it survives
/// navigation within a session. Persistence (Hive) is deferred to the backend phase.
class CartCubit extends Cubit<Cart> {
  CartCubit() : super(const Cart());

  /// Saved carts by userId — the cart each signed-in user "leaves with".
  final Map<String, Cart> _savedCarts = {};

  /// The currently signed-in user, or null while a guest.
  String? _userId;

  /// On sign-in: load the user's saved cart and merge the current guest cart
  /// into it (quantities sum per product, per shop); the result becomes active.
  void mergeOnSignIn(String userId) {
    final saved = _savedCarts[userId] ?? const Cart();
    _userId = userId;
    emit(_mergeCarts(saved, state));
  }

  /// On sign-out: save the active cart under the signed-in user, then reset to
  /// an empty cart so the next guest starts fresh.
  void saveAndResetOnSignOut() {
    if (_userId != null) _savedCarts[_userId!] = state;
    _userId = null;
    emit(const Cart());
  }

  /// Merges [b] into [a]: shop carts by shopId, lines by productId (qty sums).
  Cart _mergeCarts(Cart a, Cart b) {
    final shops = [...a.shopCarts];
    for (final bShop in b.shopCarts) {
      final idx = shops.indexWhere((s) => s.shopId == bShop.shopId);
      if (idx < 0) {
        shops.add(bShop);
      } else {
        shops[idx] = _mergeShop(shops[idx], bShop);
      }
    }
    return Cart(shopCarts: shops);
  }

  ShopCart _mergeShop(ShopCart a, ShopCart b) {
    final lines = [...a.lines];
    for (final bLine in b.lines) {
      final idx = lines.indexWhere((l) => l.productId == bLine.productId);
      if (idx < 0) {
        lines.add(bLine);
      } else {
        lines[idx] = lines[idx].copyWith(qty: lines[idx].qty + bLine.qty);
      }
    }
    return a.copyWith(lines: lines);
  }

  void addProduct({
    required Product product,
    required String shopId,
    required String shopName,
    required String shopPhone,
    int qty = 1,
  }) {
    final existing = state.shopCart(shopId);
    if (existing == null) {
      _put(ShopCart(
        shopId: shopId,
        shopName: shopName,
        shopPhone: shopPhone,
        lines: [CartLine(productId: product.id, name: product.name, priceEgp: product.priceEgp, qty: qty)],
      ));
      return;
    }
    final idx = existing.lines.indexWhere((l) => l.productId == product.id);
    final lines = [...existing.lines];
    if (idx >= 0) {
      lines[idx] = lines[idx].copyWith(qty: lines[idx].qty + qty);
    } else {
      lines.add(CartLine(productId: product.id, name: product.name, priceEgp: product.priceEgp, qty: qty));
    }
    _put(existing.copyWith(lines: lines));
  }

  void increment(String shopId, String productId) =>
      _mutateLine(shopId, productId, (l) => l.copyWith(qty: l.qty + 1));

  void decrement(String shopId, String productId) =>
      _mutateLine(shopId, productId, (l) => l.qty <= 1 ? null : l.copyWith(qty: l.qty - 1));

  void removeLine(String shopId, String productId) =>
      _mutateLine(shopId, productId, (_) => null);

  void clearShop(String shopId) =>
      emit(Cart(shopCarts: state.shopCarts.where((s) => s.shopId != shopId).toList()));

  /// Applies fresh product data: missing/unavailable → flagged; price → latest.
  void applyRevalidation(String shopId, Map<String, Product?> latest) {
    final shop = state.shopCart(shopId);
    if (shop == null) return;
    final lines = shop.lines.map((l) {
      final p = latest[l.productId];
      if (p == null) return l.copyWith(isUnavailable: true);
      return l.copyWith(isUnavailable: !p.isAvailable, latestPriceEgp: p.priceEgp);
    }).toList();
    _put(shop.copyWith(lines: lines));
  }

  void _mutateLine(String shopId, String productId, CartLine? Function(CartLine) f) {
    final shop = state.shopCart(shopId);
    if (shop == null) return;
    final lines = <CartLine>[];
    for (final l in shop.lines) {
      if (l.productId == productId) {
        final next = f(l);
        if (next != null) lines.add(next);
      } else {
        lines.add(l);
      }
    }
    if (lines.isEmpty) {
      clearShop(shopId);
    } else {
      _put(shop.copyWith(lines: lines));
    }
  }

  void _put(ShopCart shop) {
    final idx = state.shopCarts.indexWhere((s) => s.shopId == shop.shopId);
    if (idx < 0) {
      emit(Cart(shopCarts: [...state.shopCarts, shop]));
    } else {
      final next = [...state.shopCarts];
      next[idx] = shop;
      emit(Cart(shopCarts: next));
    }
  }
}
