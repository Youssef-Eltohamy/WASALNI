import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wasalni/data/models/product.dart';
import 'package:wasalni/features/cart/bloc/cart_cubit.dart';
import 'package:wasalni/features/cart/widgets/cart_icon_button.dart';

void main() {
  testWidgets('shows no badge when empty, shows count when items added', (tester) async {
    final cart = CartCubit();
    await tester.pumpWidget(MaterialApp(
      home: BlocProvider.value(
        value: cart,
        child: const Scaffold(appBar: PreferredSize(
          preferredSize: Size.fromHeight(56),
          child: SafeArea(child: SizedBox(height: 56, child: CartIconButton())),
        )),
      ),
    ));
    expect(find.text('2'), findsNothing);

    cart.addProduct(
      product: const Product(id: 'p1', listingId: 's1', name: 'x', description: 'd', priceEgp: 10),
      shopId: 's1', shopName: 'محل', shopPhone: 'x', qty: 2);
    await tester.pump();
    expect(find.text('2'), findsOneWidget);
  });
}
