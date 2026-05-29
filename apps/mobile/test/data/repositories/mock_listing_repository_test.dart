import 'package:flutter_test/flutter_test.dart';
import 'package:wasalni/core/network/repository_exception.dart';
import 'package:wasalni/data/models/enums.dart';
import 'package:wasalni/data/repositories/mock/mock_listing_repository.dart';

void main() {
  test('getFeed returns only active listings for the village', () async {
    final repo = MockListingRepository();
    final result = await repo.getFeed(villageId: 'v_kafr');
    expect(result, isNotEmpty);
    expect(result.every((l) => l.villageId == 'v_kafr'), true);
    expect(result.every((l) => l.status == ListingStatus.active), true);
  });

  test('getFeed filters by kind', () async {
    final repo = MockListingRepository();
    final result = await repo.getFeed(villageId: 'v_kafr', kind: ListingKind.shop);
    expect(result.every((l) => l.kind == ListingKind.shop), true);
  });

  test('getFeed filters by categoryId', () async {
    final repo = MockListingRepository();
    final result = await repo.getFeed(villageId: 'v_kafr', categoryId: 'cat_plumb');
    expect(result, isNotEmpty);
    expect(result.every((l) => l.categoryId == 'cat_plumb'), true);
  });

  test('getById throws NotFoundException for unknown id', () async {
    final repo = MockListingRepository();
    expect(() => repo.getById('nope'), throwsA(isA<NotFoundException>()));
  });
}
