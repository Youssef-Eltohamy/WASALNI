import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/network/repository_exception.dart';
import '../../../data/repositories/listing_repository.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc(this._repo) : super(const SearchState.initial()) {
    on<SearchQueryChanged>(_onQueryChanged);
  }

  final ListingRepository _repo;

  Future<void> _onQueryChanged(SearchQueryChanged e, Emitter<SearchState> emit) async {
    final q = e.query.trim();
    if (q.isEmpty) {
      emit(const SearchState.initial());
      return;
    }
    emit(const SearchState.loading());
    try {
      final results = await _repo.search(villageId: e.villageId, query: q);
      emit(results.isEmpty ? const SearchState.empty() : SearchState.loaded(results));
    } on NoConnectionException {
      emit(const SearchState.noConnection());
    } on RepositoryException catch (e) {
      emit(SearchState.error(e.message ?? 'حصل خطأ'));
    }
  }
}
