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

  blocTest<CartCubit, Cart>(
    'mutating an existing shop keeps its position (does not jump to the end)',
    build: CartCubit.new,
    act: (c) {
      addP1(c); // s1 first
      c.addProduct(product: _prod('p9'), shopId: 's2', shopName: 'محل ب', shopPhone: 'y'); // s2 second
      c.increment('s1', 'p1'); // mutate s1 — must stay first
    },
    verify: (c) {
      expect(c.state.shopCarts.map((s) => s.shopId).toList(), ['s1', 's2']);
    },
  );

  group('session binding (ISSUE-1)', () {
    test('mergeOnSignIn keeps the guest cart when the user cart is empty', () {
      final c = CartCubit();
      addP1(c);
      c.mergeOnSignIn('u1');
      expect(c.state.shopCart('s1')!.lines.single.qty, 1);
    });

    test('mergeOnSignIn sums quantities for the same product', () {
      final c = CartCubit();
      addP1(c); // guest p1
      c.mergeOnSignIn('u1'); // u1 = {s1: p1x1}
      c.saveAndResetOnSignOut(); // saved, guest empty
      addP1(c); // guest p1 again
      c.mergeOnSignIn('u1'); // merge → p1x2
      expect(c.state.shopCart('s1')!.lines.single.qty, 2);
    });

    test('saveAndResetOnSignOut empties the cart for the next guest', () {
      final c = CartCubit();
      addP1(c);
      c.mergeOnSignIn('u1');
      c.saveAndResetOnSignOut();
      expect(c.state.isEmpty, isTrue);
    });

    test('user keeps their cart across sign-out then sign-in, plus guest items', () {
      final c = CartCubit();
      addP1(c); // guest p1 @ s1
      c.mergeOnSignIn('u1'); // u1 has s1/p1
      c.addProduct(product: _prod('p2'), shopId: 's2', shopName: 'محل ب', shopPhone: 'z');
      c.saveAndResetOnSignOut(); // u1 saved {s1,s2}, guest empty
      expect(c.state.isEmpty, isTrue);
      c.addProduct(product: _prod('p3'), shopId: 's3', shopName: 'محل ج', shopPhone: 'w');
      c.mergeOnSignIn('u1'); // load {s1,s2} + merge {s3}
      expect(c.state.shopCarts.map((s) => s.shopId).toSet(), {'s1', 's2', 's3'});
    });

    test("a different user does not see another user's cart", () {
      final c = CartCubit();
      addP1(c);
      c.mergeOnSignIn('u1');
      c.saveAndResetOnSignOut();
      c.mergeOnSignIn('u2'); // fresh user, guest was empty
      expect(c.state.isEmpty, isTrue);
    });
  });
}
