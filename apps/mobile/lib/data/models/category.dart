import 'package:freezed_annotation/freezed_annotation.dart';
import 'enums.dart';

part 'category.freezed.dart';

@freezed
abstract class Category with _$Category {
  const factory Category({
    required String id,
    required String name,
    required String slug,
    required String iconName,
    required ListingKind kind,
    @Default(0) int sortOrder,
  }) = _Category;
}
