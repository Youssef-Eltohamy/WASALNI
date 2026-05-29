import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wasalni/core/launch/contact_launcher.dart';
import 'package:wasalni/data/models/cart.dart';
import 'package:wasalni/data/models/order_intent.dart';
import 'package:wasalni/data/repositories/order_repository.dart';
import 'package:wasalni/features/cart/cart_sender.dart';
import 'package:wasalni/features/cart/outbox_service.dart';

class MockLauncher extends Mock implements ContactLauncher {}
class MockOrders extends Mock implements OrderRepository {}
class FakeOrderIntent extends Fake implements OrderIntent {}

ShopCart _shop({String phone = '+201000000005'}) => ShopCart(
    shopId: 's1', shopName: 'محل', shopPhone: phone,
    lines: const [CartLine(productId: 'p1', name: 'منتج', priceEgp: 10, qty: 2)]);

void main() {
  setUpAll(() {
    registerFallbackValue(FakeOrderIntent());
  });

  late MockLauncher launcher;
  late MockOrders orders;
  late OutboxService outbox;
  late CartSender sender;

  setUp(() {
    launcher = MockLauncher();
    orders = MockOrders();
    outbox = OutboxService(orders, launcher: launcher);
    sender = CartSender(orders, outbox, launcher: launcher);
    when(() => orders.recordIntent(any())).thenAnswer((_) async {});
  });

  test('noPhone when shop has no phone', () async {
    final out = await sender.send(_shop(phone: ''), userName: 'x', isOnline: true);
    expect(out, SendOutcome.noPhone);
  });

  test('queued when offline (intent goes to outbox, whatsapp not launched)', () async {
    final out = await sender.send(_shop(), userName: 'x', isOnline: false);
    expect(out, SendOutcome.queued);
    expect(outbox.pending.length, 1);
    verifyNever(() => launcher.whatsapp(any(), message: any(named: 'message')));
  });

  test('sent when online and whatsapp opens; intent recorded', () async {
    when(() => launcher.whatsapp(any(), message: any(named: 'message')))
        .thenAnswer((_) async => true);
    final out = await sender.send(_shop(), userName: 'x', isOnline: true);
    expect(out, SendOutcome.sent);
    verify(() => orders.recordIntent(any())).called(1);
  });

  test('whatsappFailed when launch returns false (still recorded as intent)', () async {
    when(() => launcher.whatsapp(any(), message: any(named: 'message')))
        .thenAnswer((_) async => false);
    final out = await sender.send(_shop(), userName: 'x', isOnline: true);
    expect(out, SendOutcome.whatsappFailed);
  });
}
