import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wasalni/core/network/repository_exception.dart';
import 'package:wasalni/data/models/enums.dart';
import 'package:wasalni/data/models/listing.dart';
import 'package:wasalni/data/repositories/listing_repository.dart';
import 'package:wasalni/features/search/bloc/search_bloc.dart';
import 'package:wasalni/features/search/bloc/search_event.dart';
import 'package:wasalni/features/search/bloc/search_state.dart';

class MockListingRepo extends Mock implements ListingRepository {}

Listing _listing(String id) => Listing(
      id: id, kind: ListingKind.service, ownerId: 'o', villageId: 'v_kafr',
      categoryId: 'c', name: 'اسم $id', bio: 'وصف', phoneWhatsapp: '+201000000000',
      createdAt: DateTime.utc(2026, 1, 1));

void main() {
  late MockListingRepo repo;
  setUp(() => repo = MockListingRepo());

  blocTest<SearchBloc, SearchState>(
    'emits [loading, loaded] when results found',
    build: () {
      when(() => repo.search(villageId: any(named: 'villageId'), query: any(named: 'query')))
          .thenAnswer((_) async => [_listing('l1')]);
      return SearchBloc(repo);
    },
    act: (bloc) => bloc.add(const SearchQueryChanged(villageId: 'v_kafr', query: 'سباك')),
    expect: () => [
      const SearchState.loading(),
      isA<SearchLoaded>().having((s) => s.results.length, 'count', 1),
    ],
  );

  blocTest<SearchBloc, SearchState>(
    'emits [loading, empty] when no results',
    build: () {
      when(() => repo.search(villageId: any(named: 'villageId'), query: any(named: 'query')))
          .thenAnswer((_) async => []);
      return SearchBloc(repo);
    },
    act: (bloc) => bloc.add(const SearchQueryChanged(villageId: 'v_kafr', query: 'xyz')),
    expect: () => [const SearchState.loading(), const SearchState.empty()],
  );

  blocTest<SearchBloc, SearchState>(
    'emits [initial] when query is blank',
    build: () => SearchBloc(repo),
    act: (bloc) => bloc.add(const SearchQueryChanged(villageId: 'v_kafr', query: '   ')),
    expect: () => [const SearchState.initial()],
  );

  blocTest<SearchBloc, SearchState>(
    'emits [loading, noConnection] on NoConnectionException',
    build: () {
      when(() => repo.search(villageId: any(named: 'villageId'), query: any(named: 'query')))
          .thenThrow(const NoConnectionException());
      return SearchBloc(repo);
    },
    act: (bloc) => bloc.add(const SearchQueryChanged(villageId: 'v_kafr', query: 'سباك')),
    expect: () => [const SearchState.loading(), const SearchState.noConnection()],
  );
}
