import 'package:flutter_test/flutter_test.dart';
import 'package:wasalni/core/network/repository_exception.dart';
import 'package:wasalni/data/repositories/mock/mock_product_repository.dart';

void main() {
  test('getProducts returns the shop products', () async {
    final repo = MockProductRepository();
    final result = await repo.getProducts(shopId: 'l4');
    expect(result, isNotEmpty);
    expect(result.every((p) => p.listingId == 'l4'), true);
  });

  test('getProducts returns empty for a shop with no products', () async {
    final repo = MockProductRepository();
    expect(await repo.getProducts(shopId: 'l1'), isEmpty);
  });

  test('getProductById throws NotFoundException for unknown id', () async {
    final repo = MockProductRepository();
    expect(() => repo.getProductById('nope'), throwsA(isA<NotFoundException>()));
  });
}
