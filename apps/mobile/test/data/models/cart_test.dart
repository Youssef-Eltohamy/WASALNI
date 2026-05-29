import 'package:flutter_test/flutter_test.dart';
import 'package:wasalni/data/models/cart.dart';

CartLine _line(String id, {double price = 10, int qty = 1}) =>
    CartLine(productId: id, name: 'منتج $id', priceEgp: price, qty: qty);

void main() {
  test('CartLine.lineTotal multiplies price by qty', () {
    expect(_line('p1', price: 25, qty: 3).lineTotal, 75);
  });

  test('CartLine.effectivePrice uses latestPriceEgp when set', () {
    final l = _line('p1', price: 25).copyWith(latestPriceEgp: 30);
    expect(l.effectivePrice, 30);
    expect(l.priceChanged, isTrue);
  });

  test('CartLine.priceChanged is false when latest equals snapshot', () {
    final l = _line('p1', price: 25).copyWith(latestPriceEgp: 25);
    expect(l.priceChanged, isFalse);
  });

  test('ShopCart aggregates total and itemCount', () {
    final cart = ShopCart(
      shopId: 's1', shopName: 'محل', shopPhone: '+201000000000',
      lines: [_line('p1', price: 10, qty: 2), _line('p2', price: 5, qty: 1)],
    );
    expect(cart.total, 25);
    expect(cart.itemCount, 3);
  });

  test('ShopCart.canSend is false when phone empty', () {
    final cart = ShopCart(
      shopId: 's1', shopName: 'محل', shopPhone: '',
      lines: [_line('p1')],
    );
    expect(cart.canSend, isFalse);
  });

  test('Cart.totalItemCount sums across shops; lookup works', () {
    final cart = Cart(shopCarts: [
      ShopCart(shopId: 's1', shopName: 'أ', shopPhone: 'x', lines: [_line('p1', qty: 2)]),
      ShopCart(shopId: 's2', shopName: 'ب', shopPhone: 'y', lines: [_line('p2', qty: 3)]),
    ]);
    expect(cart.totalItemCount, 5);
    expect(cart.isEmpty, isFalse);
    expect(cart.shopCart('s2')?.itemCount, 3);
    expect(cart.shopCart('nope'), isNull);
  });

  test('empty Cart reports isEmpty', () {
    expect(const Cart(shopCarts: []).isEmpty, isTrue);
  });
}
