import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/network/repository_exception.dart';
import '../../../data/models/enums.dart';
import '../../../data/repositories/listing_repository.dart';
import 'feed_event.dart';
import 'feed_state.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  FeedBloc(this._repo) : super(const FeedState.loading()) {
    on<FeedRequested>(_onRequested);
    on<FeedRefreshed>(_onRefreshed);
  }

  final ListingRepository _repo;
  String? _villageId;
  ListingKind? _kind;
  String? _categoryId;

  Future<void> _onRequested(FeedRequested e, Emitter<FeedState> emit) async {
    _villageId = e.villageId;
    _kind = e.kind;
    _categoryId = e.categoryId;
    await _load(emit);
  }

  Future<void> _onRefreshed(FeedRefreshed e, Emitter<FeedState> emit) async {
    if (_villageId != null) await _load(emit);
  }

  Future<void> _load(Emitter<FeedState> emit) async {
    emit(const FeedState.loading());
    try {
      final items = await _repo.getFeed(
        villageId: _villageId!,
        kind: _kind,
        categoryId: _categoryId,
      );
      emit(items.isEmpty
          ? const FeedState.empty()
          : FeedState.loaded(items, villageId: _villageId, kind: _kind));
    } on NoConnectionException {
      emit(const FeedState.noConnection());
    } on RepositoryException catch (e) {
      emit(FeedState.error(e.message ?? 'حصل خطأ'));
    }
  }
}
