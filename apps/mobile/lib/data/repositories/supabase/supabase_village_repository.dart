import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/network/repository_exception.dart';
import '../../models/village.dart';
import '../village_repository.dart';
import 'mappers.dart';

class SupabaseVillageRepository implements VillageRepository {
  SupabaseVillageRepository(this._client);
  final SupabaseClient _client;

  @override
  Future<List<Village>> getVillages() async {
    try {
      final rows = await _client.from('villages').select().order('name');
      return rows.map((r) => villageFromRow(r)).toList();
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (_) {
      throw const NoConnectionException();
    }
  }
}
