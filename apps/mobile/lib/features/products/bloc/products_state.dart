import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../data/models/product.dart';

part 'products_state.freezed.dart';

@freezed
sealed class ProductsState with _$ProductsState {
  const factory ProductsState.loading() = ProductsLoading;
  const factory ProductsState.loaded(List<Product> products) = ProductsLoaded;
  const factory ProductsState.empty() = ProductsEmpty;
  const factory ProductsState.noConnection() = ProductsNoConnection;
  const factory ProductsState.error(String message) = ProductsError;
}
