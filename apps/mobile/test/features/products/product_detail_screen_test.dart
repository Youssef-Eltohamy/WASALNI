import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wasalni/data/repositories/listing_repository.dart';
import 'package:wasalni/data/repositories/product_repository.dart';
import 'package:wasalni/data/repositories/mock/mock_listing_repository.dart';
import 'package:wasalni/data/repositories/mock/mock_product_repository.dart';
import 'package:wasalni/features/products/bloc/product_detail_bloc.dart';
import 'package:wasalni/features/products/bloc/product_detail_event.dart';
import 'package:wasalni/features/products/view/product_detail_screen.dart';

void main() {
  testWidgets('ProductDetailScreen shows product, price, shop and order button',
      (tester) async {
    final ProductRepository products = MockProductRepository(latency: Duration.zero);
    final ListingRepository listings = MockListingRepository(latency: Duration.zero);

    await tester.pumpWidget(MaterialApp(
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: BlocProvider(
          create: (_) => ProductDetailBloc(products, listings)
            ..add(const ProductDetailRequested('p1')),
          child: const ProductDetailScreen(),
        ),
      ),
    ));
    await tester.pumpAndSettle();

    expect(find.text('بنادول إكسترا'), findsOneWidget);
    expect(find.text('35 جنيه'), findsOneWidget);
    expect(find.text('اطلب عبر واتساب'), findsOneWidget);
  });
}
