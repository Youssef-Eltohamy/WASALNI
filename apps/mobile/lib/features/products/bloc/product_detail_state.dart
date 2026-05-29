import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../data/models/product.dart';

part 'product_detail_state.freezed.dart';

@freezed
sealed class ProductDetailState with _$ProductDetailState {
  const factory ProductDetailState.loading() = ProductDetailLoading;
  const factory ProductDetailState.loaded({
    required Product product,
    required String shopName,
    required String shopPhone,
  }) = ProductDetailLoaded;
  const factory ProductDetailState.noConnection() = ProductDetailNoConnection;
  const factory ProductDetailState.error(String message) = ProductDetailError;
}
