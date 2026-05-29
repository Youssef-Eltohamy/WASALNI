import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../data/models/listing.dart';

part 'search_state.freezed.dart';

@freezed
sealed class SearchState with _$SearchState {
  const factory SearchState.initial() = SearchInitial;
  const factory SearchState.loading() = SearchLoading;
  const factory SearchState.loaded(List<Listing> results) = SearchLoaded;
  const factory SearchState.empty() = SearchEmpty;
  const factory SearchState.noConnection() = SearchNoConnection;
  const factory SearchState.error(String message) = SearchError;
}
