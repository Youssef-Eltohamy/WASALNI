import '../../core/launch/contact_launcher.dart';
import '../../data/models/cart.dart';
import '../../data/models/order_intent.dart';
import '../../data/repositories/order_repository.dart';
import 'cart_message.dart';
import 'outbox_service.dart';

/// Sends one shop's cart: builds the message, records the intent, and either
/// opens WhatsApp (online) or queues to the outbox (offline).
class CartSender {
  CartSender(this._orders, this._outbox, {ContactLauncher launcher = const ContactLauncher()})
      : _launcher = launcher;

  final OrderRepository _orders;
  final OutboxService _outbox;
  final ContactLauncher _launcher;

  Future<SendOutcome> send(ShopCart shop, {required String userName, required bool isOnline}) async {
    if (!shop.canSend) return SendOutcome.noPhone;

    final message = buildOrderMessage(shop, userName: userName);
    final intent = OrderIntent(
      id: '${shop.shopId}-${DateTime.now().microsecondsSinceEpoch}',
      shopId: shop.shopId,
      shopName: shop.shopName,
      shopPhone: shop.shopPhone,
      message: message,
      totalEgp: shop.total,
      itemCount: shop.itemCount,
      createdAt: DateTime.now(),
    );

    if (!isOnline) {
      _outbox.enqueue(intent);
      return SendOutcome.queued;
    }

    final ok = await _launcher.whatsapp(shop.shopPhone, message: message);
    if (!ok) return SendOutcome.whatsappFailed;
    await _orders.recordIntent(intent);
    return SendOutcome.sent;
  }
}
