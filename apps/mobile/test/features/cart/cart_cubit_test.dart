import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wasalni/data/models/cart.dart';
import 'package:wasalni/data/models/product.dart';
import 'package:wasalni/features/cart/bloc/cart_cubit.dart';

Product _prod(String id, {double price = 10}) => Product(
    id: id, listingId: 's1', name: 'منتج $id', description: 'وصف', priceEgp: price);

void addP1(CartCubit c) => c.addProduct(
    product: _prod('p1'), shopId: 's1', shopName: 'محل أ', shopPhone: '+201000000001');

void main() {
  test('starts empty', () {
    expect(CartCubit().state.isEmpty, isTrue);
  });

  blocTest<CartCubit, Cart>(
    'addProduct creates a shop cart with qty 1',
    build: CartCubit.new,
    act: addP1,
    verify: (c) {
      expect(c.state.totalItemCount, 1);
      expect(c.state.shopCart('s1')!.shopName, 'محل أ');
      expect(c.state.shopCart('s1')!.lines.single.productId, 'p1');
    },
  );

  blocTest<CartCubit, Cart>(
    'adding same product again increments qty (not a new line)',
    build: CartCubit.new,
    act: (c) { addP1(c); addP1(c); },
    verify: (c) {
      expect(c.state.shopCart('s1')!.lines.length, 1);
      expect(c.state.shopCart('s1')!.lines.single.qty, 2);
    },
  );

  blocTest<CartCubit, Cart>(
    'increment / decrement adjusts qty; decrement to zero removes the line',
    build: CartCubit.new,
    act: (c) {
      addP1(c);
      c.increment('s1', 'p1'); // qty 2
      c.decrement('s1', 'p1'); // qty 1
      c.decrement('s1', 'p1'); // removed
    },
    verify: (c) => expect(c.state.isEmpty, isTrue),
  );

  blocTest<CartCubit, Cart>(
    'removeLine drops the line; empty shop cart is pruned',
    build: CartCubit.new,
    act: (c) { addP1(c); c.removeLine('s1', 'p1'); },
    verify: (c) => expect(c.state.shopCart('s1'), isNull),
  );

  blocTest<CartCubit, Cart>(
    'clearShop empties one shop only',
    build: CartCubit.new,
    act: (c) {
      addP1(c);
      c.addProduct(product: _prod('p9'), shopId: 's2', shopName: 'محل ب', shopPhone: 'x');
      c.clearShop('s1');
    },
    verify: (c) {
      expect(c.state.shopCart('s1'), isNull);
      expect(c.state.shopCart('s2')!.itemCount, 1);
    },
  );

  blocTest<CartCubit, Cart>(
    'applyRevalidation flags unavailable + records latest price',
    build: CartCubit.new,
    act: (c) {
      addP1(c);
      c.applyRevalidation('s1', {'p1': _prod('p1', price: 12).copyWith(isAvailable: false)});
    },
    verify: (c) {
      final line = c.state.shopCart('s1')!.lines.single;
      expect(line.isUnavailable, isTrue);
      expect(line.latestPriceEgp, 12);
    },
  );
}
