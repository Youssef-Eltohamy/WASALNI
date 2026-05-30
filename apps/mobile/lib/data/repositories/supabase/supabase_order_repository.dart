import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/network/repository_exception.dart';
import '../../models/order_intent.dart';
import '../order_repository.dart';
import 'mappers.dart';

class SupabaseOrderRepository implements OrderRepository {
  SupabaseOrderRepository(this._client);
  final SupabaseClient _client;

  /// Seed account id used while auth is still mock. Replaced by the real
  /// session user id when Supabase auth lands.
  static const _demoUserId = 'u_demo';

  @override
  Future<void> recordIntent(OrderIntent intent) async {
    try {
      await _client
          .from('order_intents')
          .insert(orderIntentToRow(intent, userId: _demoUserId));
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (_) {
      throw const NoConnectionException();
    }
  }
}
