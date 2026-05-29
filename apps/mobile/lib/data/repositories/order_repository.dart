import '../models/order_intent.dart';

abstract interface class OrderRepository {
  Future<void> recordIntent(OrderIntent intent);
}
