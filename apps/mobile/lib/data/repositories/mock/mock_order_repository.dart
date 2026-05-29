import '../../models/order_intent.dart';
import '../order_repository.dart';

/// In-memory recorder. Backend phase: replace with Supabase `order_intents` insert.
class MockOrderRepository implements OrderRepository {
  final List<OrderIntent> recorded = [];

  @override
  Future<void> recordIntent(OrderIntent intent) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    recorded.add(intent);
  }
}
