sealed class ListingDetailEvent {
  const ListingDetailEvent();
}

class ListingDetailRequested extends ListingDetailEvent {
  const ListingDetailRequested(this.id);
  final String id;
}
