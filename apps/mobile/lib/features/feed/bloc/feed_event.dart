import '../../../data/models/enums.dart';

// Events don't need value-equality for bloc routing, so no Equatable dependency.
sealed class FeedEvent {
  const FeedEvent();
}

class FeedRequested extends FeedEvent {
  const FeedRequested({required this.villageId, this.kind});
  final String villageId;
  final ListingKind? kind;
}

class FeedRefreshed extends FeedEvent {
  const FeedRefreshed();
}
