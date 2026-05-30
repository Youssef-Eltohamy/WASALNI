import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/network/repository_exception.dart';
import '../../models/enums.dart';
import '../../models/listing.dart';
import '../listing_repository.dart';
import 'mappers.dart';

class SupabaseListingRepository implements ListingRepository {
  SupabaseListingRepository(this._client);
  final SupabaseClient _client;

  @override
  Future<List<Listing>> getFeed({
    required String villageId,
    ListingKind? kind,
    String? categoryId,
  }) async {
    try {
      var query = _client
          .from('listings')
          .select()
          .eq('village_id', villageId)
          .eq('status', 'active');
      if (kind != null) query = query.eq('kind', kind.name);
      if (categoryId != null) query = query.eq('category_id', categoryId);
      final rows = await query
          .order('is_featured', ascending: false)
          .order('created_at', ascending: false);
      return rows.map((r) => listingFromRow(r)).toList();
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (_) {
      throw const NoConnectionException();
    }
  }

  @override
  Future<Listing> getById(String id) async {
    try {
      final row =
          await _client.from('listings').select().eq('id', id).maybeSingle();
      if (row == null) throw const NotFoundException();
      return listingFromRow(row);
    } on NotFoundException {
      rethrow;
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (_) {
      throw const NoConnectionException();
    }
  }

  @override
  Future<List<Listing>> search({
    required String villageId,
    required String query,
  }) async {
    final q = query.trim();
    if (q.isEmpty) return const [];
    try {
      final rows = await _client
          .from('listings')
          .select()
          .eq('village_id', villageId)
          .eq('status', 'active')
          .or('name.ilike.%$q%,bio.ilike.%$q%');
      return rows.map((r) => listingFromRow(r)).toList();
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (_) {
      throw const NoConnectionException();
    }
  }
}
