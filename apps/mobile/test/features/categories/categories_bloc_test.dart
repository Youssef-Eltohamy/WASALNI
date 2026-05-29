import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wasalni/core/network/repository_exception.dart';
import 'package:wasalni/data/models/category.dart';
import 'package:wasalni/data/models/enums.dart';
import 'package:wasalni/data/repositories/category_repository.dart';
import 'package:wasalni/features/categories/bloc/categories_bloc.dart';
import 'package:wasalni/features/categories/bloc/categories_event.dart';
import 'package:wasalni/features/categories/bloc/categories_state.dart';

class MockCategoryRepo extends Mock implements CategoryRepository {}

Category _cat(String id) => Category(
    id: id, name: 'فئة $id', slug: id, iconName: 'category', kind: ListingKind.service);

void main() {
  late MockCategoryRepo repo;
  setUp(() => repo = MockCategoryRepo());

  blocTest<CategoriesBloc, CategoriesState>(
    'emits [loading, loaded] with categories',
    build: () {
      when(() => repo.getCategories(kind: any(named: 'kind')))
          .thenAnswer((_) async => [_cat('a'), _cat('b')]);
      return CategoriesBloc(repo);
    },
    act: (bloc) => bloc.add(const CategoriesRequested()),
    expect: () => [
      const CategoriesState.loading(),
      isA<CategoriesLoaded>().having((s) => s.categories.length, 'count', 2),
    ],
  );

  blocTest<CategoriesBloc, CategoriesState>(
    'emits [loading, noConnection] on NoConnectionException',
    build: () {
      when(() => repo.getCategories(kind: any(named: 'kind')))
          .thenThrow(const NoConnectionException());
      return CategoriesBloc(repo);
    },
    act: (bloc) => bloc.add(const CategoriesRequested()),
    expect: () => [const CategoriesState.loading(), const CategoriesState.noConnection()],
  );
}
