import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/network/repository_exception.dart';
import '../../models/product.dart';
import '../product_repository.dart';
import 'mappers.dart';

class SupabaseProductRepository implements ProductRepository {
  SupabaseProductRepository(this._client);
  final SupabaseClient _client;

  @override
  Future<List<Product>> getProducts({required String shopId}) async {
    try {
      final rows = await _client
          .from('products')
          .select()
          .eq('listing_id', shopId)
          .order('sort_order');
      return rows.map((r) => productFromRow(r)).toList();
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (_) {
      throw const NoConnectionException();
    }
  }

  @override
  Future<Product> getProductById(String id) async {
    try {
      final row =
          await _client.from('products').select().eq('id', id).maybeSingle();
      if (row == null) throw const NotFoundException();
      return productFromRow(row);
    } on NotFoundException {
      rethrow;
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (_) {
      throw const NoConnectionException();
    }
  }
}
