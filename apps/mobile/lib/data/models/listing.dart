import 'package:freezed_annotation/freezed_annotation.dart';
import 'enums.dart';

part 'listing.freezed.dart';

@freezed
abstract class Listing with _$Listing {
  const factory Listing({
    required String id,
    required ListingKind kind,
    required String ownerId,
    required String villageId,
    required String categoryId,
    required String name,
    required String bio,
    required String phoneWhatsapp,
    String? logoUrl,
    @Default(ListingStatus.active) ListingStatus status,
    @Default(false) bool isVerified,
    @Default(false) bool isFeatured,
    @Default(ListingPlan.free) ListingPlan plan,
    @Default(false) bool isTemporarilyClosed,
    required DateTime createdAt,
  }) = _Listing;
}
