import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/network/repository_exception.dart';
import '../../models/category.dart';
import '../../models/enums.dart';
import '../category_repository.dart';
import 'mappers.dart';

class SupabaseCategoryRepository implements CategoryRepository {
  SupabaseCategoryRepository(this._client);
  final SupabaseClient _client;

  @override
  Future<List<Category>> getCategories({ListingKind? kind}) async {
    try {
      var query = _client.from('categories').select();
      if (kind != null) query = query.eq('kind', kind.name);
      final rows = await query.order('sort_order');
      return rows.map((r) => categoryFromRow(r)).toList();
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (_) {
      throw const NoConnectionException();
    }
  }
}
