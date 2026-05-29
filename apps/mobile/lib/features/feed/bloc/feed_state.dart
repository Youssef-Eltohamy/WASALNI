import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../data/models/enums.dart';
import '../../../data/models/listing.dart';

part 'feed_state.freezed.dart';

@freezed
sealed class FeedState with _$FeedState {
  const factory FeedState.loading() = FeedLoading;
  const factory FeedState.loaded(List<Listing> listings, {String? villageId, ListingKind? kind}) = FeedLoaded;
  const factory FeedState.empty() = FeedEmpty;
  const factory FeedState.noConnection() = FeedNoConnection;
  const factory FeedState.error(String message) = FeedError;
}
