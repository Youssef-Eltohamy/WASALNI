import 'package:freezed_annotation/freezed_annotation.dart';

part 'product.freezed.dart';

@freezed
abstract class Product with _$Product {
  const factory Product({
    required String id,
    required String listingId,
    required String name,
    required String description,
    required double priceEgp,
    String? imageUrl,
    @Default(true) bool isAvailable,
    @Default(0) int sortOrder,
  }) = _Product;
}
