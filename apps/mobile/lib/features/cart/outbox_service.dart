import '../../core/launch/contact_launcher.dart';
import '../../data/models/order_intent.dart';
import '../../data/repositories/order_repository.dart';

/// In-memory queue for order intents that couldn't be sent (offline).
/// Flushed when connectivity returns. Persistence (Hive) deferred to backend phase.
class OutboxService {
  OutboxService(this._orders, {ContactLauncher launcher = const ContactLauncher()})
      : _launcher = launcher;

  final OrderRepository _orders;
  final ContactLauncher _launcher;
  final List<OrderIntent> _pending = [];

  List<OrderIntent> get pending => List.unmodifiable(_pending);
  bool get hasPending => _pending.isNotEmpty;

  void enqueue(OrderIntent intent) {
    if (_pending.any((i) => i.id == intent.id)) return; // dedupe
    _pending.add(intent);
  }

  /// Tries to flush every pending intent. Returns how many were sent.
  Future<int> flush() async {
    var sent = 0;
    for (final intent in [..._pending]) {
      final ok = await _launcher.whatsapp(intent.shopPhone, message: intent.message);
      if (ok) {
        await _orders.recordIntent(intent);
        _pending.removeWhere((i) => i.id == intent.id);
        sent++;
      }
    }
    return sent;
  }
}
