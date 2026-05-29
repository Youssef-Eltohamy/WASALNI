import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../data/models/listing.dart';

part 'listing_detail_state.freezed.dart';

@freezed
sealed class ListingDetailState with _$ListingDetailState {
  const factory ListingDetailState.loading() = ListingDetailLoading;
  const factory ListingDetailState.loaded(Listing listing) = ListingDetailLoaded;
  const factory ListingDetailState.noConnection() = ListingDetailNoConnection;
  const factory ListingDetailState.error(String message) = ListingDetailError;
}
