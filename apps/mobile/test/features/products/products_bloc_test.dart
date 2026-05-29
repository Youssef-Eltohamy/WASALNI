import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wasalni/core/network/repository_exception.dart';
import 'package:wasalni/data/models/product.dart';
import 'package:wasalni/data/repositories/product_repository.dart';
import 'package:wasalni/features/products/bloc/products_bloc.dart';
import 'package:wasalni/features/products/bloc/products_event.dart';
import 'package:wasalni/features/products/bloc/products_state.dart';

class MockProductRepo extends Mock implements ProductRepository {}

Product _p(String id) =>
    Product(id: id, listingId: 'l4', name: 'منتج $id', description: 'وصف', priceEgp: 10);

void main() {
  late MockProductRepo repo;
  setUp(() => repo = MockProductRepo());

  blocTest<ProductsBloc, ProductsState>(
    'emits [loading, loaded] when products exist',
    build: () {
      when(() => repo.getProducts(shopId: any(named: 'shopId')))
          .thenAnswer((_) async => [_p('p1'), _p('p2')]);
      return ProductsBloc(repo);
    },
    act: (bloc) => bloc.add(const ProductsRequested('l4')),
    expect: () => [
      const ProductsState.loading(),
      isA<ProductsLoaded>().having((s) => s.products.length, 'count', 2),
    ],
  );

  blocTest<ProductsBloc, ProductsState>(
    'emits [loading, empty] when none',
    build: () {
      when(() => repo.getProducts(shopId: any(named: 'shopId')))
          .thenAnswer((_) async => []);
      return ProductsBloc(repo);
    },
    act: (bloc) => bloc.add(const ProductsRequested('l4')),
    expect: () => [const ProductsState.loading(), const ProductsState.empty()],
  );

  blocTest<ProductsBloc, ProductsState>(
    'emits [loading, noConnection] on NoConnectionException',
    build: () {
      when(() => repo.getProducts(shopId: any(named: 'shopId')))
          .thenThrow(const NoConnectionException());
      return ProductsBloc(repo);
    },
    act: (bloc) => bloc.add(const ProductsRequested('l4')),
    expect: () => [const ProductsState.loading(), const ProductsState.noConnection()],
  );
}
