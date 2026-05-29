import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/network/repository_exception.dart';
import '../../../data/repositories/listing_repository.dart';
import '../../../data/repositories/product_repository.dart';
import 'product_detail_event.dart';
import 'product_detail_state.dart';

class ProductDetailBloc extends Bloc<ProductDetailEvent, ProductDetailState> {
  ProductDetailBloc(this._products, this._listings)
      : super(const ProductDetailState.loading()) {
    on<ProductDetailRequested>(_onRequested);
  }

  final ProductRepository _products;
  final ListingRepository _listings;

  Future<void> _onRequested(
      ProductDetailRequested e, Emitter<ProductDetailState> emit) async {
    emit(const ProductDetailState.loading());
    try {
      final product = await _products.getProductById(e.productId);
      final shop = await _listings.getById(product.listingId);
      emit(ProductDetailState.loaded(
        product: product,
        shopName: shop.name,
        shopPhone: shop.phoneWhatsapp,
      ));
    } on NoConnectionException {
      emit(const ProductDetailState.noConnection());
    } on RepositoryException catch (e) {
      emit(ProductDetailState.error(e.message ?? 'حصل خطأ'));
    }
  }
}
