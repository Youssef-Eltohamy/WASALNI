import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_intent.freezed.dart';

/// A recorded intent to order from one shop. In the mock phase this is held
/// in memory; in the backend phase it maps to the `order_intents` table.
@freezed
abstract class OrderIntent with _$OrderIntent {
  const factory OrderIntent({
    required String id, // dedupe id
    required String shopId,
    required String shopName,
    required String shopPhone,
    required String message,
    required double totalEgp,
    required int itemCount,
    required DateTime createdAt,
  }) = _OrderIntent;
}

/// Outcome of trying to send one shop's cart.
enum SendOutcome { sent, queued, whatsappFailed, noPhone }
