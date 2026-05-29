import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wasalni/core/network/repository_exception.dart';
import 'package:wasalni/data/models/enums.dart';
import 'package:wasalni/data/models/listing.dart';
import 'package:wasalni/data/repositories/listing_repository.dart';
import 'package:wasalni/features/listing_detail/bloc/listing_detail_bloc.dart';
import 'package:wasalni/features/listing_detail/bloc/listing_detail_event.dart';
import 'package:wasalni/features/listing_detail/bloc/listing_detail_state.dart';

class MockListingRepo extends Mock implements ListingRepository {}

Listing _listing(String id) => Listing(
      id: id, kind: ListingKind.service, ownerId: 'o', villageId: 'v_kafr',
      categoryId: 'c', name: 'اسم $id', bio: 'وصف', phoneWhatsapp: '+201000000000',
      createdAt: DateTime.utc(2026, 1, 1));

void main() {
  late MockListingRepo repo;
  setUp(() => repo = MockListingRepo());

  blocTest<ListingDetailBloc, ListingDetailState>(
    'emits [loading, loaded] when found',
    build: () {
      when(() => repo.getById(any())).thenAnswer((_) async => _listing('l1'));
      return ListingDetailBloc(repo);
    },
    act: (bloc) => bloc.add(const ListingDetailRequested('l1')),
    expect: () => [
      const ListingDetailState.loading(),
      isA<ListingDetailLoaded>().having((s) => s.listing.id, 'id', 'l1'),
    ],
  );

  blocTest<ListingDetailBloc, ListingDetailState>(
    'emits [loading, error] when not found',
    build: () {
      when(() => repo.getById(any())).thenThrow(const NotFoundException());
      return ListingDetailBloc(repo);
    },
    act: (bloc) => bloc.add(const ListingDetailRequested('nope')),
    expect: () => [const ListingDetailState.loading(), isA<ListingDetailError>()],
  );

  blocTest<ListingDetailBloc, ListingDetailState>(
    'emits [loading, noConnection] on NoConnectionException',
    build: () {
      when(() => repo.getById(any())).thenThrow(const NoConnectionException());
      return ListingDetailBloc(repo);
    },
    act: (bloc) => bloc.add(const ListingDetailRequested('l1')),
    expect: () => [const ListingDetailState.loading(), const ListingDetailState.noConnection()],
  );
}
