import 'package:flutter_test/flutter_test.dart';
import 'package:wasalni/data/models/cart.dart';
import 'package:wasalni/features/cart/cart_message.dart';

void main() {
  final shop = ShopCart(
    shopId: 's1', shopName: 'بقالة أبو أحمد', shopPhone: '+201000000005',
    lines: const [
      CartLine(productId: 'p4', name: 'زيت 1 لتر', priceEgp: 60, qty: 2),
      CartLine(productId: 'p5', name: 'سكر 1 كيلو', priceEgp: 30, qty: 1),
    ],
  );

  test('message includes shop name, lines, quantities, and total', () {
    final msg = buildOrderMessage(shop, userName: 'محمد');
    expect(msg, contains('بقالة أبو أحمد'));
    expect(msg, contains('زيت 1 لتر'));
    expect(msg, contains('سكر 1 كيلو'));
    expect(msg, contains('150')); // 60*2 + 30 = 150
    expect(msg, contains('محمد'));
  });

  test('omits the name line when userName is empty', () {
    final msg = buildOrderMessage(shop, userName: '');
    expect(msg, isNot(contains('اسمي')));
  });
}
