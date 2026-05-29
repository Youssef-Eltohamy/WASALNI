import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wasalni/core/connectivity/connectivity_cubit.dart';
import 'package:wasalni/core/connectivity/connectivity_service.dart';
import 'package:wasalni/data/models/product.dart';
import 'package:wasalni/data/repositories/order_repository.dart';
import 'package:wasalni/data/repositories/product_repository.dart';
import 'package:wasalni/features/auth/bloc/session_cubit.dart';
import 'package:wasalni/features/cart/bloc/cart_cubit.dart';
import 'package:wasalni/features/cart/cart_sender.dart';
import 'package:wasalni/features/cart/outbox_service.dart';
import 'package:wasalni/features/cart/view/cart_screen.dart';

class _FakeConn implements ConnectivityService {
  @override
  Stream<bool> get onStatusChange => Stream<bool>.empty();
  @override
  Future<bool> isOnline() async => true;
}

class MockProductRepo extends Mock implements ProductRepository {}
class MockOrders extends Mock implements OrderRepository {}

Product _p(String id, {double price = 10, bool avail = true}) => Product(
    id: id, listingId: 's1', name: 'منتج $id', description: 'd', priceEgp: price, isAvailable: avail);

Widget _host({required CartCubit cart, required ProductRepository repo, required CartSender sender}) {
  return MaterialApp(
    home: MultiBlocProvider(
      providers: [
        BlocProvider<CartCubit>.value(value: cart),
        BlocProvider<ConnectivityCubit>(create: (_) => ConnectivityCubit(_FakeConn())),
        BlocProvider<SessionCubit>(create: (_) => SessionCubit()),
      ],
      child: CartScreen(productRepository: repo, sender: sender),
    ),
  );
}

void main() {
  testWidgets('empty cart shows empty message', (tester) async {
    final repo = MockProductRepo();
    final orders = MockOrders();
    final sender = CartSender(orders, OutboxService(orders));
    await tester.pumpWidget(_host(cart: CartCubit(), repo: repo, sender: sender));
    await tester.pumpAndSettle();
    expect(find.textContaining('سلتك فاضية'), findsOneWidget);
  });

  testWidgets('renders a shop card with the shop name and a send button', (tester) async {
    final repo = MockProductRepo();
    when(() => repo.getProductById(any())).thenAnswer((i) async => _p(i.positionalArguments.first as String));
    final orders = MockOrders();
    final sender = CartSender(orders, OutboxService(orders));
    final cart = CartCubit()
      ..addProduct(product: _p('p1'), shopId: 's1', shopName: 'بقالة أبو أحمد', shopPhone: '+201000000005');
    await tester.pumpWidget(_host(cart: cart, repo: repo, sender: sender));
    await tester.pumpAndSettle();
    expect(find.text('بقالة أبو أحمد'), findsOneWidget);
    expect(find.text('أرسل السلة'), findsOneWidget);
  });
}
