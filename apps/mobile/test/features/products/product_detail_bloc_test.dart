import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wasalni/core/network/repository_exception.dart';
import 'package:wasalni/data/models/enums.dart';
import 'package:wasalni/data/models/listing.dart';
import 'package:wasalni/data/models/product.dart';
import 'package:wasalni/data/repositories/listing_repository.dart';
import 'package:wasalni/data/repositories/product_repository.dart';
import 'package:wasalni/features/products/bloc/product_detail_bloc.dart';
import 'package:wasalni/features/products/bloc/product_detail_event.dart';
import 'package:wasalni/features/products/bloc/product_detail_state.dart';

class MockProductRepo extends Mock implements ProductRepository {}
class MockListingRepo extends Mock implements ListingRepository {}

final _product = Product(
    id: 'p1', listingId: 'l4', name: 'بنادول', description: 'وصف', priceEgp: 35);
Listing _shop() => Listing(
    id: 'l4', kind: ListingKind.shop, ownerId: 'o', villageId: 'v_kafr', categoryId: 'c',
    name: 'صيدلية الشفاء', bio: 'وصف', phoneWhatsapp: '+201000000004',
    createdAt: DateTime.utc(2026, 1, 1));

void main() {
  late MockProductRepo products;
  late MockListingRepo listings;
  setUp(() {
    products = MockProductRepo();
    listings = MockListingRepo();
  });

  blocTest<ProductDetailBloc, ProductDetailState>(
    'emits [loading, loaded] with product + shop contact',
    build: () {
      when(() => products.getProductById(any())).thenAnswer((_) async => _product);
      when(() => listings.getById(any())).thenAnswer((_) async => _shop());
      return ProductDetailBloc(products, listings);
    },
    act: (bloc) => bloc.add(const ProductDetailRequested('p1')),
    expect: () => [
      const ProductDetailState.loading(),
      isA<ProductDetailLoaded>()
          .having((s) => s.product.id, 'product id', 'p1')
          .having((s) => s.shopName, 'shop name', 'صيدلية الشفاء')
          .having((s) => s.shopPhone, 'shop phone', '+201000000004'),
    ],
  );

  blocTest<ProductDetailBloc, ProductDetailState>(
    'emits [loading, error] when product not found',
    build: () {
      when(() => products.getProductById(any())).thenThrow(const NotFoundException());
      return ProductDetailBloc(products, listings);
    },
    act: (bloc) => bloc.add(const ProductDetailRequested('nope')),
    expect: () => [const ProductDetailState.loading(), isA<ProductDetailError>()],
  );
}
