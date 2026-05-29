import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/network/repository_exception.dart';
import '../../../data/repositories/product_repository.dart';
import 'products_event.dart';
import 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  ProductsBloc(this._repo) : super(const ProductsState.loading()) {
    on<ProductsRequested>(_onRequested);
  }

  final ProductRepository _repo;

  Future<void> _onRequested(ProductsRequested e, Emitter<ProductsState> emit) async {
    emit(const ProductsState.loading());
    try {
      final products = await _repo.getProducts(shopId: e.shopId);
      emit(products.isEmpty ? const ProductsState.empty() : ProductsState.loaded(products));
    } on NoConnectionException {
      emit(const ProductsState.noConnection());
    } on RepositoryException catch (e) {
      emit(ProductsState.error(e.message ?? 'حصل خطأ'));
    }
  }
}
