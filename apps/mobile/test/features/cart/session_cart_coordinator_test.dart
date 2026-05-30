import 'package:flutter_test/flutter_test.dart';
import 'package:wasalni/data/models/profile.dart';
import 'package:wasalni/features/auth/bloc/session_cubit.dart';
import 'package:wasalni/features/cart/bloc/cart_cubit.dart';
import 'package:wasalni/features/cart/session_cart_coordinator.dart';

Profile _user(String id) =>
    Profile(id: id, phone: '+201000000000', displayName: 'أحمد', createdAt: DateTime(2026));

void main() {
  late SessionCubit session;
  late CartCubit cart;
  late SessionCartCoordinator coordinator;

  setUp(() {
    session = SessionCubit();
    cart = CartCubit();
    coordinator = SessionCartCoordinator(session, cart)..start();
  });

  tearDown(() async {
    await coordinator.dispose();
    await session.close();
    await cart.close();
  });

  void add(String id) =>
      cart.addProduct(productId: id, listingId: 'l1', name: id, price: 10);

  test('guest cart survives sign-in (merged into the user cart)', () async {
    add('p1');
    session.signIn(_user('u1'));
    await Future<void>.delayed(Duration.zero); // let the stream listener run
    expect(cart.state.lines.containsKey('p1'), isTrue);
  });

  test('sign-out empties the cart for the next guest', () async {
    add('p1');
    session.signIn(_user('u1'));
    await Future<void>.delayed(Duration.zero);
    session.signOut();
    await Future<void>.delayed(Duration.zero);
    expect(cart.state.isEmpty, isTrue);
  });

  test('user gets their cart back on re-sign-in, merged with new guest items',
      () async {
    add('p1');
    session.signIn(_user('u1'));
    await Future<void>.delayed(Duration.zero);
    add('p2'); // bought while signed in
    session.signOut();
    await Future<void>.delayed(Duration.zero);
    add('p3'); // added as a fresh guest
    session.signIn(_user('u1'));
    await Future<void>.delayed(Duration.zero);
    expect(cart.state.lines.keys.toSet(), {'p1', 'p2', 'p3'});
  });
}
