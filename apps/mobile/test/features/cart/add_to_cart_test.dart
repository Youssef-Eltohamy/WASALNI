import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wasalni/data/models/product.dart';
import 'package:wasalni/features/cart/bloc/cart_cubit.dart';
import 'package:wasalni/features/products/widgets/product_card.dart';

void main() {
  testWidgets('ProductCard add button adds the product to the cart', (tester) async {
    final cart = CartCubit();
    final product = Product(
        id: 'p1', listingId: 's1', name: 'منتج', description: 'وصف', priceEgp: 10);

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider.value(
          value: cart,
          child: Scaffold(
            body: ProductCard(
              product: product,
              onTap: () {},
              onAdd: () => cart.addProduct(
                  product: product, shopId: 's1', shopName: 'محل', shopPhone: 'x'),
            ),
          ),
        ),
      ),
    );

    for (var i = 0; i < 13; i++) {
      await tester.tap(find.byIcon(Icons.add));
    }
    await tester.pumpAndSettle();

    expect(cart.state.totalItemCount, 13); // qty per add is 1; 13 taps → 13
  });
}
