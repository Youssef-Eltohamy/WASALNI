import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/network/repository_exception.dart';
import '../../../data/repositories/listing_repository.dart';
import 'listing_detail_event.dart';
import 'listing_detail_state.dart';

class ListingDetailBloc extends Bloc<ListingDetailEvent, ListingDetailState> {
  ListingDetailBloc(this._repo) : super(const ListingDetailState.loading()) {
    on<ListingDetailRequested>(_onRequested);
  }

  final ListingRepository _repo;

  Future<void> _onRequested(
      ListingDetailRequested e, Emitter<ListingDetailState> emit) async {
    emit(const ListingDetailState.loading());
    try {
      final listing = await _repo.getById(e.id);
      emit(ListingDetailState.loaded(listing));
    } on NoConnectionException {
      emit(const ListingDetailState.noConnection());
    } on RepositoryException catch (e) {
      emit(ListingDetailState.error(e.message ?? 'حصل خطأ'));
    }
  }
}
