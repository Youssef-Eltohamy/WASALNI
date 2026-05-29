import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wasalni/data/models/product.dart';
import 'package:wasalni/data/repositories/listing_repository.dart';
import 'package:wasalni/data/repositories/product_repository.dart';
import 'package:wasalni/data/repositories/mock/mock_listing_repository.dart';
import 'package:wasalni/data/repositories/mock/mock_product_repository.dart';
import 'package:wasalni/features/cart/bloc/cart_cubit.dart';
import 'package:wasalni/features/products/bloc/product_detail_bloc.dart';
import 'package:wasalni/features/products/bloc/product_detail_event.dart';
import 'package:wasalni/features/products/view/product_detail_screen.dart';

void main() {
  testWidgets('ProductDetailScreen shows product, price, shop and add-to-cart button',
      (tester) async {
    final ProductRepository products = MockProductRepository(latency: Duration.zero);
    final ListingRepository listings = MockListingRepository(latency: Duration.zero);
    final cart = CartCubit();

    await tester.pumpWidget(MaterialApp(
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => ProductDetailBloc(products, listings)
                ..add(const ProductDetailRequested('p1')),
            ),
            BlocProvider<CartCubit>.value(value: cart),
          ],
          child: const ProductDetailScreen(),
        ),
      ),
    ));
    await tester.pumpAndSettle();

    expect(find.text('بنادول إكسترا'), findsOneWidget);
    expect(find.text('35 جنيه'), findsOneWidget);
    expect(find.text('أضف للسلة'), findsOneWidget);

    await tester.tap(find.text('أضف للسلة'));
    await tester.pump();
    expect(cart.state.totalItemCount, 1);
  });

  testWidgets('unavailable product shows disabled button labelled غير متوفر حالياً',
      (tester) async {
    final ListingRepository listings = MockListingRepository(latency: Duration.zero);
    final cart = CartCubit();
    final unavailableRepo = _UnavailableProductRepository();

    await tester.pumpWidget(MaterialApp(
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => ProductDetailBloc(unavailableRepo, listings)
                ..add(const ProductDetailRequested('p_unavail')),
            ),
            BlocProvider<CartCubit>.value(value: cart),
          ],
          child: const ProductDetailScreen(),
        ),
      ),
    ));
    await tester.pumpAndSettle();

    expect(find.text('غير متوفر حالياً'), findsOneWidget);

    // The FilledButton.icon should be disabled (onPressed == null).
    final buttons = tester.widgetList<FilledButton>(find.byType(FilledButton));
    expect(buttons.every((b) => b.onPressed == null), isTrue);
  });
}

/// Minimal stub that returns a single unavailable product.
class _UnavailableProductRepository implements ProductRepository {
  static const _product = Product(
    id: 'p_unavail',
    listingId: 'l4', // l4 exists in MockListingRepository
    name: 'منتج غير متاح',
    description: 'وصف',
    priceEgp: 20,
    isAvailable: false,
  );

  @override
  Future<Product> getProductById(String id) async => _product;

  @override
  Future<List<Product>> getProducts({required String shopId}) async => [_product];
}
