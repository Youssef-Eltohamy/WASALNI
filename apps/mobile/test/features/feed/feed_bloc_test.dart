import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wasalni/core/network/repository_exception.dart';
import 'package:wasalni/data/models/enums.dart';
import 'package:wasalni/data/models/listing.dart';
import 'package:wasalni/data/repositories/listing_repository.dart';
import 'package:wasalni/features/feed/bloc/feed_bloc.dart';
import 'package:wasalni/features/feed/bloc/feed_event.dart';
import 'package:wasalni/features/feed/bloc/feed_state.dart';

class MockListingRepo extends Mock implements ListingRepository {}

Listing _listing(String id) => Listing(
      id: id, kind: ListingKind.service, ownerId: 'o', villageId: 'v_kafr',
      categoryId: 'c', name: 'اسم $id', bio: 'وصف', phoneWhatsapp: '+201000000000',
      createdAt: DateTime.utc(2026, 1, 1));

void main() {
  late MockListingRepo repo;
  setUp(() => repo = MockListingRepo());

  blocTest<FeedBloc, FeedState>(
    'emits [loading, loaded] when repo returns listings',
    build: () {
      when(() => repo.getFeed(villageId: any(named: 'villageId'), kind: any(named: 'kind')))
          .thenAnswer((_) async => [_listing('l1'), _listing('l2')]);
      return FeedBloc(repo);
    },
    act: (bloc) => bloc.add(const FeedRequested(villageId: 'v_kafr')),
    expect: () => [
      const FeedState.loading(),
      isA<FeedLoaded>().having((s) => s.listings.length, 'count', 2),
    ],
  );

  blocTest<FeedBloc, FeedState>(
    'emits [loading, empty] when repo returns nothing',
    build: () {
      when(() => repo.getFeed(villageId: any(named: 'villageId'), kind: any(named: 'kind')))
          .thenAnswer((_) async => []);
      return FeedBloc(repo);
    },
    act: (bloc) => bloc.add(const FeedRequested(villageId: 'v_kafr')),
    expect: () => [const FeedState.loading(), const FeedState.empty()],
  );

  blocTest<FeedBloc, FeedState>(
    'emits [loading, noConnection] on NoConnectionException',
    build: () {
      when(() => repo.getFeed(villageId: any(named: 'villageId'), kind: any(named: 'kind')))
          .thenThrow(const NoConnectionException());
      return FeedBloc(repo);
    },
    act: (bloc) => bloc.add(const FeedRequested(villageId: 'v_kafr')),
    expect: () => [const FeedState.loading(), const FeedState.noConnection()],
  );

  blocTest<FeedBloc, FeedState>(
    'emits [loading, error] on a generic RepositoryException',
    build: () {
      when(() => repo.getFeed(villageId: any(named: 'villageId'), kind: any(named: 'kind')))
          .thenThrow(const ServerException());
      return FeedBloc(repo);
    },
    act: (bloc) => bloc.add(const FeedRequested(villageId: 'v_kafr')),
    expect: () => [const FeedState.loading(), isA<FeedError>()],
  );
}
