import '../../../core/network/repository_exception.dart';
import '../../models/enums.dart';
import '../../models/listing.dart';
import '../listing_repository.dart';
import 'mock_data.dart';

class MockListingRepository implements ListingRepository {
  MockListingRepository({this.latency = const Duration(milliseconds: 400)});

  final Duration latency;

  @override
  Future<List<Listing>> getFeed({required String villageId, ListingKind? kind}) async {
    await Future<void>.delayed(latency);
    final items = MockData.listings.where((l) =>
        l.villageId == villageId &&
        l.status == ListingStatus.active &&
        (kind == null || l.kind == kind)).toList();
    // Featured first, then newest.
    items.sort((a, b) {
      if (a.isFeatured != b.isFeatured) return a.isFeatured ? -1 : 1;
      return b.createdAt.compareTo(a.createdAt);
    });
    return items;
  }

  @override
  Future<Listing> getById(String id) async {
    await Future<void>.delayed(latency);
    final match = MockData.listings.where((l) => l.id == id);
    if (match.isEmpty) throw const NotFoundException();
    return match.first;
  }
}
