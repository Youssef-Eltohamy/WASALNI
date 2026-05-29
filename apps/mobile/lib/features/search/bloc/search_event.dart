sealed class SearchEvent {
  const SearchEvent();
}

class SearchQueryChanged extends SearchEvent {
  const SearchQueryChanged({required this.villageId, required this.query});
  final String villageId;
  final String query;
}
