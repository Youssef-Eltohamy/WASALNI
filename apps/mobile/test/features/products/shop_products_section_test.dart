import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wasalni/data/repositories/product_repository.dart';
import 'package:wasalni/data/repositories/mock/mock_product_repository.dart';
import 'package:wasalni/features/products/widgets/shop_products_section.dart';

void main() {
  testWidgets('ShopProductsSection lists the shop products', (tester) async {
    final ProductRepository repo = MockProductRepository(latency: Duration.zero);
    await tester.pumpWidget(MaterialApp(
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          body: SingleChildScrollView(
            child: ShopProductsSection(shopId: 'l4', repository: repo),
          ),
        ),
      ),
    ));
    await tester.pumpAndSettle();

    expect(find.text('بنادول إكسترا'), findsOneWidget);
    expect(find.text('المنتجات'), findsOneWidget);
  });
}
