import '../models/enums.dart';
import '../models/listing.dart';

abstract interface class ListingRepository {
  /// Active, non-hidden listings for a village, optionally filtered by kind.
  /// Throws [RepositoryException] subtypes on failure.
  Future<List<Listing>> getFeed({required String villageId, ListingKind? kind});

  Future<Listing> getById(String id);
}
