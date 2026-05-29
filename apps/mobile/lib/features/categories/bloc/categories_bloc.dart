import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/network/repository_exception.dart';
import '../../../data/repositories/category_repository.dart';
import 'categories_event.dart';
import 'categories_state.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  CategoriesBloc(this._repo) : super(const CategoriesState.loading()) {
    on<CategoriesRequested>(_onRequested);
  }

  final CategoryRepository _repo;

  Future<void> _onRequested(CategoriesRequested e, Emitter<CategoriesState> emit) async {
    emit(const CategoriesState.loading());
    try {
      final categories = await _repo.getCategories();
      emit(CategoriesState.loaded(categories));
    } on NoConnectionException {
      emit(const CategoriesState.noConnection());
    } on RepositoryException catch (e) {
      emit(CategoriesState.error(e.message ?? 'حصل خطأ'));
    }
  }
}
