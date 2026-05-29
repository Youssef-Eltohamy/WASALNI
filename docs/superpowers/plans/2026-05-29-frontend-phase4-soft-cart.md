# Soft Cart Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build the per-shop Soft Cart: add products to a cart grouped by shop, review each shop's cart in its own card, and send each shop's order as a pre-filled WhatsApp message (no bulk send), with an offline outbox that flushes on reconnect.

**Architecture:** In-memory `CartCubit` (registered as a get_it singleton, provided app-wide) holds a `Cart` of per-shop `ShopCart`s. A `CartSender` service builds the WhatsApp message, records an `OrderIntent` via `OrderRepository` (mock), and routes through an in-memory `OutboxService` when offline. UI: add-to-cart on product surfaces + a cart icon with a count badge → `/cart` route. Persistence across app restarts (Hive) and real `order_intents` recording (Supabase) are deferred to the backend phase — consistent with the project's frontend-first, mock-first approach.

**Tech Stack:** Flutter, flutter_bloc (Cubit), go_router, get_it, freezed (no json_serializable yet), url_launcher (via existing `ContactLauncher`). Tests: flutter_test, bloc_test, mocktail.

**Conventions to follow (from existing code):**
- freezed: `abstract class` for data models, `sealed class` for unions/Bloc states.
- **No json_serializable / no `.g.dart`** — models are freezed-only (copyWith/equality). Do NOT add `fromJson`/`toJson`.
- codegen: `dart run build_runner build --force-jit --delete-conflicting-outputs` (run from `apps/mobile`).
- RTL: use `EdgeInsetsDirectional` for asymmetric padding; plain `EdgeInsets.all(...)` is fine.
- Theme tokens only: `AppColors`, `AppSpacing`, `AppTextStyles`. Cairo font, min 14sp.
- Egyptian-Arabic, friendly tone in all user-facing strings.
- Money display: `formatEgp(double)` from `core/format/money.dart`.
- All commands run from `D:\programing\wasalni\apps\mobile`.

---

### Task 1: Cart models (CartLine / ShopCart / Cart / OrderIntent + SendOutcome)

**Files:**
- Create: `apps/mobile/lib/data/models/cart.dart`
- Create: `apps/mobile/lib/data/models/order_intent.dart`
- Test: `apps/mobile/test/data/models/cart_test.dart`

- [ ] **Step 1: Write the failing test**

Create `apps/mobile/test/data/models/cart_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:wasalni/data/models/cart.dart';

CartLine _line(String id, {double price = 10, int qty = 1}) =>
    CartLine(productId: id, name: 'منتج $id', priceEgp: price, qty: qty);

void main() {
  test('CartLine.lineTotal multiplies price by qty', () {
    expect(_line('p1', price: 25, qty: 3).lineTotal, 75);
  });

  test('CartLine.effectivePrice uses latestPriceEgp when set', () {
    final l = _line('p1', price: 25).copyWith(latestPriceEgp: 30);
    expect(l.effectivePrice, 30);
    expect(l.priceChanged, isTrue);
  });

  test('CartLine.priceChanged is false when latest equals snapshot', () {
    final l = _line('p1', price: 25).copyWith(latestPriceEgp: 25);
    expect(l.priceChanged, isFalse);
  });

  test('ShopCart aggregates total and itemCount', () {
    final cart = ShopCart(
      shopId: 's1', shopName: 'محل', shopPhone: '+201000000000',
      lines: [_line('p1', price: 10, qty: 2), _line('p2', price: 5, qty: 1)],
    );
    expect(cart.total, 25);
    expect(cart.itemCount, 3);
  });

  test('ShopCart.canSend is false when phone empty', () {
    final cart = ShopCart(
      shopId: 's1', shopName: 'محل', shopPhone: '',
      lines: [_line('p1')],
    );
    expect(cart.canSend, isFalse);
  });

  test('Cart.totalItemCount sums across shops; lookup works', () {
    final cart = Cart(shopCarts: [
      ShopCart(shopId: 's1', shopName: 'أ', shopPhone: 'x', lines: [_line('p1', qty: 2)]),
      ShopCart(shopId: 's2', shopName: 'ب', shopPhone: 'y', lines: [_line('p2', qty: 3)]),
    ]);
    expect(cart.totalItemCount, 5);
    expect(cart.isEmpty, isFalse);
    expect(cart.shopCart('s2')?.itemCount, 3);
    expect(cart.shopCart('nope'), isNull);
  });

  test('empty Cart reports isEmpty', () {
    expect(const Cart(shopCarts: []).isEmpty, isTrue);
  });
}
```

- [ ] **Step 2: Run the test to verify it fails**

Run: `flutter test test/data/models/cart_test.dart`
Expected: FAIL — `cart.dart` does not exist / types undefined.

- [ ] **Step 3: Write the models**

Create `apps/mobile/lib/data/models/cart.dart`:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'cart.freezed.dart';

@freezed
abstract class CartLine with _$CartLine {
  const CartLine._();
  const factory CartLine({
    required String productId,
    required String name,
    required double priceEgp,
    @Default(1) int qty,
    @Default(false) bool isUnavailable,
    double? latestPriceEgp,
  }) = _CartLine;

  /// Price to charge now (latest from revalidation if known, else the snapshot).
  double get effectivePrice => latestPriceEgp ?? priceEgp;
  double get lineTotal => effectivePrice * qty;
  bool get priceChanged => latestPriceEgp != null && latestPriceEgp != priceEgp;
}

@freezed
abstract class ShopCart with _$ShopCart {
  const ShopCart._();
  const factory ShopCart({
    required String shopId,
    required String shopName,
    required String shopPhone,
    @Default(<CartLine>[]) List<CartLine> lines,
  }) = _ShopCart;

  double get total =>
      lines.fold(0, (sum, l) => sum + (l.isUnavailable ? 0 : l.lineTotal));
  int get itemCount => lines.fold(0, (sum, l) => sum + l.qty);
  bool get canSend => shopPhone.trim().isNotEmpty && lines.isNotEmpty;
  bool get hasIssues => lines.any((l) => l.isUnavailable || l.priceChanged);
}

@freezed
abstract class Cart with _$Cart {
  const Cart._();
  const factory Cart({@Default(<ShopCart>[]) List<ShopCart> shopCarts}) = _Cart;

  bool get isEmpty => shopCarts.every((s) => s.lines.isEmpty);
  int get totalItemCount =>
      shopCarts.fold(0, (sum, s) => sum + s.itemCount);
  ShopCart? shopCart(String shopId) {
    for (final s in shopCarts) {
      if (s.shopId == shopId) return s;
    }
    return null;
  }
}
```

Create `apps/mobile/lib/data/models/order_intent.dart`:

```dart
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
```

- [ ] **Step 4: Generate freezed code**

Run: `dart run build_runner build --force-jit --delete-conflicting-outputs`
Expected: generates `cart.freezed.dart` and `order_intent.freezed.dart`, no errors.

- [ ] **Step 5: Run the test to verify it passes**

Run: `flutter test test/data/models/cart_test.dart`
Expected: PASS (all 7 tests).

- [ ] **Step 6: Verify analyze is clean**

Run: `flutter analyze`
Expected: No issues.

- [ ] **Step 7: Commit**

```bash
git add apps/mobile/lib/data/models/cart.dart apps/mobile/lib/data/models/cart.freezed.dart apps/mobile/lib/data/models/order_intent.dart apps/mobile/lib/data/models/order_intent.freezed.dart apps/mobile/test/data/models/cart_test.dart
git commit -m "feat(cart): cart models + order intent + send outcome"
```

---

### Task 2: CartCubit + DI registration + app-wide provider

**Files:**
- Create: `apps/mobile/lib/features/cart/bloc/cart_cubit.dart`
- Modify: `apps/mobile/lib/app/di.dart`
- Modify: `apps/mobile/lib/app/app.dart`
- Test: `apps/mobile/test/features/cart/cart_cubit_test.dart`

- [ ] **Step 1: Write the failing test**

Create `apps/mobile/test/features/cart/cart_cubit_test.dart`:

```dart
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wasalni/data/models/cart.dart';
import 'package:wasalni/data/models/product.dart';
import 'package:wasalni/features/cart/bloc/cart_cubit.dart';

Product _prod(String id, {double price = 10}) => Product(
    id: id, listingId: 's1', name: 'منتج $id', description: 'وصف', priceEgp: price);

void addP1(CartCubit c) => c.addProduct(
    product: _prod('p1'), shopId: 's1', shopName: 'محل أ', shopPhone: '+201000000001');

void main() {
  test('starts empty', () {
    expect(CartCubit().state.isEmpty, isTrue);
  });

  blocTest<CartCubit, Cart>(
    'addProduct creates a shop cart with qty 1',
    build: CartCubit.new,
    act: addP1,
    verify: (c) {
      expect(c.state.totalItemCount, 1);
      expect(c.state.shopCart('s1')!.shopName, 'محل أ');
      expect(c.state.shopCart('s1')!.lines.single.productId, 'p1');
    },
  );

  blocTest<CartCubit, Cart>(
    'adding same product again increments qty (not a new line)',
    build: CartCubit.new,
    act: (c) { addP1(c); addP1(c); },
    verify: (c) {
      expect(c.state.shopCart('s1')!.lines.length, 1);
      expect(c.state.shopCart('s1')!.lines.single.qty, 2);
    },
  );

  blocTest<CartCubit, Cart>(
    'increment / decrement adjusts qty; decrement to zero removes the line',
    build: CartCubit.new,
    act: (c) {
      addP1(c);
      c.increment('s1', 'p1'); // qty 2
      c.decrement('s1', 'p1'); // qty 1
      c.decrement('s1', 'p1'); // removed
    },
    verify: (c) => expect(c.state.isEmpty, isTrue),
  );

  blocTest<CartCubit, Cart>(
    'removeLine drops the line; empty shop cart is pruned',
    build: CartCubit.new,
    act: (c) { addP1(c); c.removeLine('s1', 'p1'); },
    verify: (c) => expect(c.state.shopCart('s1'), isNull),
  );

  blocTest<CartCubit, Cart>(
    'clearShop empties one shop only',
    build: CartCubit.new,
    act: (c) {
      addP1(c);
      c.addProduct(product: _prod('p9'), shopId: 's2', shopName: 'محل ب', shopPhone: 'x');
      c.clearShop('s1');
    },
    verify: (c) {
      expect(c.state.shopCart('s1'), isNull);
      expect(c.state.shopCart('s2')!.itemCount, 1);
    },
  );

  blocTest<CartCubit, Cart>(
    'applyRevalidation flags unavailable + records latest price',
    build: CartCubit.new,
    act: (c) {
      addP1(c);
      c.applyRevalidation('s1', {'p1': _prod('p1', price: 12).copyWith(isAvailable: false)});
    },
    verify: (c) {
      final line = c.state.shopCart('s1')!.lines.single;
      expect(line.isUnavailable, isTrue);
      expect(line.latestPriceEgp, 12);
    },
  );
}
```

- [ ] **Step 2: Run the test to verify it fails**

Run: `flutter test test/features/cart/cart_cubit_test.dart`
Expected: FAIL — `cart_cubit.dart` does not exist.

- [ ] **Step 3: Write the CartCubit**

Create `apps/mobile/lib/features/cart/bloc/cart_cubit.dart`:

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/cart.dart';
import '../../../data/models/product.dart';

/// In-memory cart, grouped per shop. Registered as a singleton so it survives
/// navigation within a session. Persistence (Hive) is deferred to the backend phase.
class CartCubit extends Cubit<Cart> {
  CartCubit() : super(const Cart());

  void addProduct({
    required Product product,
    required String shopId,
    required String shopName,
    required String shopPhone,
    int qty = 1,
  }) {
    final existing = state.shopCart(shopId);
    if (existing == null) {
      _put(ShopCart(
        shopId: shopId,
        shopName: shopName,
        shopPhone: shopPhone,
        lines: [CartLine(productId: product.id, name: product.name, priceEgp: product.priceEgp, qty: qty)],
      ));
      return;
    }
    final idx = existing.lines.indexWhere((l) => l.productId == product.id);
    final lines = [...existing.lines];
    if (idx >= 0) {
      lines[idx] = lines[idx].copyWith(qty: lines[idx].qty + qty);
    } else {
      lines.add(CartLine(productId: product.id, name: product.name, priceEgp: product.priceEgp, qty: qty));
    }
    _put(existing.copyWith(lines: lines));
  }

  void increment(String shopId, String productId) =>
      _mutateLine(shopId, productId, (l) => l.copyWith(qty: l.qty + 1));

  void decrement(String shopId, String productId) =>
      _mutateLine(shopId, productId, (l) => l.qty <= 1 ? null : l.copyWith(qty: l.qty - 1));

  void removeLine(String shopId, String productId) =>
      _mutateLine(shopId, productId, (_) => null);

  void clearShop(String shopId) =>
      emit(Cart(shopCarts: state.shopCarts.where((s) => s.shopId != shopId).toList()));

  /// Applies fresh product data: missing/unavailable → flagged; price → latest.
  void applyRevalidation(String shopId, Map<String, Product?> latest) {
    final shop = state.shopCart(shopId);
    if (shop == null) return;
    final lines = shop.lines.map((l) {
      final p = latest[l.productId];
      if (p == null) return l.copyWith(isUnavailable: true);
      return l.copyWith(isUnavailable: !p.isAvailable, latestPriceEgp: p.priceEgp);
    }).toList();
    _put(shop.copyWith(lines: lines));
  }

  void _mutateLine(String shopId, String productId, CartLine? Function(CartLine) f) {
    final shop = state.shopCart(shopId);
    if (shop == null) return;
    final lines = <CartLine>[];
    for (final l in shop.lines) {
      if (l.productId == productId) {
        final next = f(l);
        if (next != null) lines.add(next);
      } else {
        lines.add(l);
      }
    }
    if (lines.isEmpty) {
      clearShop(shopId);
    } else {
      _put(shop.copyWith(lines: lines));
    }
  }

  void _put(ShopCart shop) {
    final others = state.shopCarts.where((s) => s.shopId != shop.shopId);
    emit(Cart(shopCarts: [...others, shop]));
  }
}
```

- [ ] **Step 4: Run the test to verify it passes**

Run: `flutter test test/features/cart/cart_cubit_test.dart`
Expected: PASS (all cases).

- [ ] **Step 5: Register in DI and provide app-wide**

Modify `apps/mobile/lib/app/di.dart` — add the import and registration:

```dart
import '../features/cart/bloc/cart_cubit.dart';
```

Inside `setupDi()`, add to the cascade (after the existing registrations):

```dart
    ..registerLazySingleton<CartCubit>(CartCubit.new)
```

Modify `apps/mobile/lib/app/app.dart` — wrap the existing `BlocProvider` (ConnectivityCubit) in a `MultiBlocProvider` so the `CartCubit` is available to the whole tree. Replace the `build` body's provider with:

```dart
import 'package:wasalni/features/cart/bloc/cart_cubit.dart';
// ...existing imports...

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ConnectivityCubit(getIt<ConnectivityService>())..init()),
        BlocProvider<CartCubit>.value(value: getIt<CartCubit>()),
      ],
      child: MaterialApp.router(
        // ...unchanged...
      ),
    );
```

(Keep all `MaterialApp.router` arguments exactly as they are.)

- [ ] **Step 6: Verify analyze + full suite**

Run: `flutter analyze && flutter test`
Expected: No analyze issues; all tests pass (45 prior + new cart tests).

- [ ] **Step 7: Commit**

```bash
git add apps/mobile/lib/features/cart/bloc/cart_cubit.dart apps/mobile/lib/app/di.dart apps/mobile/lib/app/app.dart apps/mobile/test/features/cart/cart_cubit_test.dart
git commit -m "feat(cart): in-memory CartCubit + DI singleton + app-wide provider"
```

---

### Task 3: Order-message builder + OrderRepository (mock) + OutboxService + CartSender

**Files:**
- Create: `apps/mobile/lib/features/cart/cart_message.dart`
- Create: `apps/mobile/lib/data/repositories/order_repository.dart`
- Create: `apps/mobile/lib/data/repositories/mock/mock_order_repository.dart`
- Create: `apps/mobile/lib/features/cart/outbox_service.dart`
- Create: `apps/mobile/lib/features/cart/cart_sender.dart`
- Modify: `apps/mobile/lib/app/di.dart`
- Test: `apps/mobile/test/features/cart/cart_message_test.dart`
- Test: `apps/mobile/test/features/cart/cart_sender_test.dart`

- [ ] **Step 1: Write the failing message-builder test**

Create `apps/mobile/test/features/cart/cart_message_test.dart`:

```dart
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
```

- [ ] **Step 2: Run it to verify it fails**

Run: `flutter test test/features/cart/cart_message_test.dart`
Expected: FAIL — `cart_message.dart` does not exist.

- [ ] **Step 3: Write the message builder**

Create `apps/mobile/lib/features/cart/cart_message.dart`:

```dart
import '../../core/format/money.dart';
import '../../data/models/cart.dart';

/// Builds the pre-filled WhatsApp order message for one shop's cart.
String buildOrderMessage(ShopCart shop, {required String userName}) {
  final b = StringBuffer()
    ..writeln('السلام عليكم 👋')
    ..writeln('حابب أطلب من ${shop.shopName}:')
    ..writeln();
  for (final l in shop.lines) {
    if (l.isUnavailable) continue;
    b.writeln('• ${l.name} × ${l.qty} — ${formatEgp(l.lineTotal)}');
  }
  b
    ..writeln()
    ..writeln('الإجمالي: ${formatEgp(shop.total)}');
  if (userName.trim().isNotEmpty) {
    b.writeln('اسمي: ${userName.trim()}');
  }
  b.write('(الطلب من تطبيق وصلني)');
  return b.toString();
}
```

- [ ] **Step 4: Run it to verify it passes**

Run: `flutter test test/features/cart/cart_message_test.dart`
Expected: PASS.

- [ ] **Step 5: Write OrderRepository + mock + OutboxService**

Create `apps/mobile/lib/data/repositories/order_repository.dart`:

```dart
import '../models/order_intent.dart';

abstract interface class OrderRepository {
  Future<void> recordIntent(OrderIntent intent);
}
```

Create `apps/mobile/lib/data/repositories/mock/mock_order_repository.dart`:

```dart
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
```

Create `apps/mobile/lib/features/cart/outbox_service.dart`:

```dart
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
```

- [ ] **Step 6: Write the failing CartSender test**

Create `apps/mobile/test/features/cart/cart_sender_test.dart`:

```dart
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

ShopCart _shop({String phone = '+201000000005'}) => ShopCart(
    shopId: 's1', shopName: 'محل', shopPhone: phone,
    lines: const [CartLine(productId: 'p1', name: 'منتج', priceEgp: 10, qty: 2)]);

void main() {
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
```

- [ ] **Step 7: Run it to verify it fails**

Run: `flutter test test/features/cart/cart_sender_test.dart`
Expected: FAIL — `cart_sender.dart` does not exist.

- [ ] **Step 8: Write CartSender**

Create `apps/mobile/lib/features/cart/cart_sender.dart`:

```dart
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
```

- [ ] **Step 9: Register OrderRepository, OutboxService, CartSender in DI**

Modify `apps/mobile/lib/app/di.dart` — add imports:

```dart
import '../data/repositories/order_repository.dart';
import '../data/repositories/mock/mock_order_repository.dart';
import '../features/cart/cart_sender.dart';
import '../features/cart/outbox_service.dart';
```

Add to the `setupDi()` cascade:

```dart
    ..registerLazySingleton<OrderRepository>(MockOrderRepository.new)
    ..registerLazySingleton<OutboxService>(() => OutboxService(getIt<OrderRepository>()))
    ..registerLazySingleton<CartSender>(() => CartSender(getIt<OrderRepository>(), getIt<OutboxService>()))
```

- [ ] **Step 10: Run tests + analyze**

Run: `flutter test test/features/cart/ && flutter analyze`
Expected: all cart tests pass; analyze clean.

- [ ] **Step 11: Commit**

```bash
git add apps/mobile/lib/features/cart/cart_message.dart apps/mobile/lib/features/cart/outbox_service.dart apps/mobile/lib/features/cart/cart_sender.dart apps/mobile/lib/data/repositories/order_repository.dart apps/mobile/lib/data/repositories/mock/mock_order_repository.dart apps/mobile/lib/app/di.dart apps/mobile/test/features/cart/cart_message_test.dart apps/mobile/test/features/cart/cart_sender_test.dart
git commit -m "feat(cart): order message builder + order repo + outbox + cart sender"
```

---

### Task 4: Add-to-cart UI + cart icon with count badge

**Files:**
- Create: `apps/mobile/lib/features/cart/widgets/cart_icon_button.dart`
- Modify: `apps/mobile/lib/features/products/view/product_detail_screen.dart`
- Modify: `apps/mobile/lib/features/products/widgets/product_card.dart`
- Modify: `apps/mobile/lib/features/products/widgets/shop_products_section.dart`
- Modify: `apps/mobile/lib/features/listing_detail/view/listing_detail_screen.dart`
- Test: `apps/mobile/test/features/cart/cart_icon_button_test.dart`
- Test: `apps/mobile/test/features/cart/add_to_cart_test.dart`

**Context:** The product detail bloc state `ProductDetailLoaded` exposes `product`, `shopName`, `shopPhone` (see `product_detail_state.dart`). The shop's id is the product's `listingId`. The cart icon shows the total item count from `CartCubit`. Replace the single-product "اطلب عبر واتساب" button with an "أضف للسلة" button + a quantity stepper; the cart is now the ordering path.

- [ ] **Step 1: Write the failing cart-icon test**

Create `apps/mobile/test/features/cart/cart_icon_button_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wasalni/data/models/product.dart';
import 'package:wasalni/features/cart/bloc/cart_cubit.dart';
import 'package:wasalni/features/cart/widgets/cart_icon_button.dart';

void main() {
  testWidgets('shows no badge when empty, shows count when items added', (tester) async {
    final cart = CartCubit();
    await tester.pumpWidget(MaterialApp(
      home: BlocProvider.value(
        value: cart,
        child: const Scaffold(appBar: PreferredSize(
          preferredSize: Size.fromHeight(56),
          child: SafeArea(child: SizedBox(height: 56, child: CartIconButton())),
        )),
      ),
    ));
    expect(find.text('2'), findsNothing);

    cart.addProduct(
      product: const Product(id: 'p1', listingId: 's1', name: 'x', description: 'd', priceEgp: 10),
      shopId: 's1', shopName: 'محل', shopPhone: 'x', qty: 2);
    await tester.pump();
    expect(find.text('2'), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run it to verify it fails**

Run: `flutter test test/features/cart/cart_icon_button_test.dart`
Expected: FAIL — `cart_icon_button.dart` does not exist.

- [ ] **Step 3: Write CartIconButton**

Create `apps/mobile/lib/features/cart/widgets/cart_icon_button.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/cart.dart';
import '../bloc/cart_cubit.dart';

/// AppBar action: cart icon with an item-count badge. Taps → /cart.
class CartIconButton extends StatelessWidget {
  const CartIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    final count = context.watch<CartCubit>().state.totalItemCount;
    return Stack(
      alignment: Alignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.shopping_cart_outlined),
          tooltip: 'السلة',
          onPressed: () => context.push('/cart'),
        ),
        if (count > 0)
          PositionedDirectional(
            top: 6,
            end: 6,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              decoration: const BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              constraints: const BoxConstraints(minWidth: 16),
              child: Text(
                '$count',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontFamily: 'Cairo', fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white),
              ),
            ),
          ),
      ],
    );
  }
}
```

- [ ] **Step 4: Run it to verify it passes**

Run: `flutter test test/features/cart/cart_icon_button_test.dart`
Expected: PASS.

- [ ] **Step 5: Write the failing add-to-cart widget test**

Create `apps/mobile/test/features/cart/add_to_cart_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wasalni/data/models/product.dart';
import 'package:wasalni/features/cart/bloc/cart_cubit.dart';
import 'package:wasalni/features/products/widgets/product_card.dart';

void main() {
  testWidgets('ProductCard add button adds the product to the cart', (tester) async {
    final cart = CartCubit();
    const product = Product(
        id: 'p1', listingId: 's1', name: 'زيت', description: 'وصف', priceEgp: 60);
    await tester.pumpWidget(MaterialApp(
      home: BlocProvider.value(
        value: cart,
        child: Scaffold(
          body: ProductCard(
            product: product,
            onTap: () {},
            onAdd: () => cart.addProduct(
                product: product, shopId: 's1', shopName: 'بقالة', shopPhone: 'x'),
          ),
        ),
      ),
    ));
    await tester.tap(find.byIcon(Icons.add_shopping_cart));
    await tester.pump();
    expect(cart.state.totalItemCount, 1);
  });
}
```

- [ ] **Step 6: Run it to verify it fails**

Run: `flutter test test/features/cart/add_to_cart_test.dart`
Expected: FAIL — `ProductCard` has no `onAdd` parameter.

- [ ] **Step 7: Add `onAdd` to ProductCard**

Modify `apps/mobile/lib/features/products/widgets/product_card.dart`. Add an optional `onAdd` callback and render an add button as the `trailing` when the product is available:

```dart
class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product, required this.onTap, this.onAdd});
  final Product product;
  final VoidCallback onTap;
  final VoidCallback? onAdd;
```

In the `ListTile`, add `trailing`:

```dart
        trailing: (onAdd != null && product.isAvailable)
            ? IconButton(
                icon: const Icon(Icons.add_shopping_cart, color: AppColors.primary),
                tooltip: 'أضف للسلة',
                onPressed: onAdd,
              )
            : null,
```

(Keep the existing `leading`, `title`, `subtitle`, `onTap`.)

- [ ] **Step 8: Wire `onAdd` from ShopProductsSection**

Modify `apps/mobile/lib/features/products/widgets/shop_products_section.dart`. The section needs the shop's name + phone to populate the cart. Add required `shopName` and `shopPhone` params, and pass `onAdd` that calls `CartCubit`:

```dart
import 'package:flutter_bloc/flutter_bloc.dart'; // already imported
import '../../cart/bloc/cart_cubit.dart';
import '../../../data/models/product.dart';
```

Change the constructor:

```dart
  const ShopProductsSection({
    super.key,
    required this.shopId,
    required this.shopName,
    required this.shopPhone,
    this.repository,
  });
  final String shopId;
  final String shopName;
  final String shopPhone;
  final ProductRepository? repository;
```

In the `ProductsLoaded` builder, pass `onAdd`:

```dart
              ProductsLoaded(:final products) => Column(
                  children: [
                    for (final p in products)
                      ProductCard(
                        product: p,
                        onTap: () => context.push('/product/${p.id}'),
                        onAdd: () {
                          context.read<CartCubit>().addProduct(
                                product: p, shopId: shopId, shopName: shopName, shopPhone: shopPhone);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('تمت إضافة ${p.name} للسلة'), duration: const Duration(seconds: 1)),
                          );
                        },
                      ),
                  ],
                ),
```

- [ ] **Step 9: Update the ListingDetailScreen call + add cart icon**

Modify `apps/mobile/lib/features/listing_detail/view/listing_detail_screen.dart`:

1. Update the `ShopProductsSection` call (inside `_DetailBody`) to pass shop name + phone:

```dart
                    ShopProductsSection(
                      shopId: listing.id,
                      shopName: listing.name,
                      shopPhone: listing.phoneWhatsapp,
                    ),
```

2. Add the cart icon to the `SliverAppBar`. Import:

```dart
import '../../cart/widgets/cart_icon_button.dart';
```

Add `actions` to the `SliverAppBar`:

```dart
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            actions: const [CartIconButton()],
            flexibleSpace: FlexibleSpaceBar(
              // ...unchanged...
```

- [ ] **Step 10: Replace single-order button with add-to-cart on ProductDetailScreen**

Modify `apps/mobile/lib/features/products/view/product_detail_screen.dart`. The screen is a `StatelessWidget`; converting to add-to-cart with a quantity needs local state for qty. Change it to a `StatefulWidget`, add an `int _qty = 1`, add the cart icon to the AppBar, and replace the `_order` WhatsApp button with a qty stepper + "أضف للسلة".

Replace the whole file with:

```dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/format/money.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/loading_view.dart';
import '../../cart/bloc/cart_cubit.dart';
import '../../cart/widgets/cart_icon_button.dart';
import '../bloc/product_detail_bloc.dart';
import '../bloc/product_detail_state.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _qty = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تفاصيل المنتج'),
        actions: const [CartIconButton()],
      ),
      body: BlocBuilder<ProductDetailBloc, ProductDetailState>(
        builder: (context, state) => switch (state) {
          ProductDetailLoading() => const LoadingView(),
          ProductDetailNoConnection() =>
            const ErrorView(message: 'مفيش اتصال بالإنترنت', isOffline: true),
          ProductDetailError(:final message) => ErrorView(message: message),
          ProductDetailLoaded(:final product, :final shopName, :final shopPhone) =>
            ListView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 220),
                  child: AspectRatio(
                    aspectRatio: 4 / 3,
                    child: (product.imageUrl == null || product.imageUrl!.isEmpty)
                        ? Container(
                            color: AppColors.border,
                            child: const Icon(Icons.inventory_2_outlined,
                                size: 64, color: AppColors.textMuted))
                        : CachedNetworkImage(imageUrl: product.imageUrl!, fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(product.name, style: AppTextStyles.headline),
                const SizedBox(height: AppSpacing.xs),
                Text(formatEgp(product.priceEgp),
                    style: AppTextStyles.title.copyWith(color: AppColors.primary)),
                const SizedBox(height: AppSpacing.sm),
                Text(product.description, style: AppTextStyles.body),
                const SizedBox(height: AppSpacing.md),
                Text('من: $shopName', style: AppTextStyles.caption),
                const SizedBox(height: AppSpacing.xl),
                if (product.isAvailable) ...[
                  Row(
                    children: [
                      Text('الكمية:', style: AppTextStyles.label),
                      const SizedBox(width: AppSpacing.md),
                      IconButton.outlined(
                        onPressed: _qty > 1 ? () => setState(() => _qty--) : null,
                        icon: const Icon(Icons.remove),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                        child: Text('$_qty', style: AppTextStyles.title),
                      ),
                      IconButton.outlined(
                        onPressed: () => setState(() => _qty++),
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                ],
                FilledButton.icon(
                  style: FilledButton.styleFrom(backgroundColor: AppColors.accent),
                  onPressed: product.isAvailable
                      ? () {
                          context.read<CartCubit>().addProduct(
                                product: product,
                                shopId: product.listingId,
                                shopName: shopName,
                                shopPhone: shopPhone,
                                qty: _qty,
                              );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('أضفنا ${product.name} للسلة'), duration: const Duration(seconds: 1)),
                          );
                        }
                      : null,
                  icon: const Icon(Icons.add_shopping_cart),
                  label: Text(product.isAvailable ? 'أضف للسلة' : 'غير متوفر حالياً'),
                ),
              ],
            ),
        },
      ),
    );
  }
}
```

(Note: `ProductDetailScreen` is now const-constructible with no params. The router builds it as `const ProductDetailScreen()` — that still compiles. The `ContactLauncher`/`_order` are removed since ordering now goes through the cart.)

- [ ] **Step 11: Update the product_detail_screen_test for the new UI**

The old test (`test/features/products/product_detail_screen_test.dart`) likely taps "اطلب عبر واتساب". Read it and update so it:
- wraps the screen in `BlocProvider<CartCubit>` (plus the existing `ProductDetailBloc` provider),
- asserts "أضف للسلة" appears for an available product,
- taps it and asserts `cart.state.totalItemCount == 1`,
- for an unavailable product, asserts the button is disabled and labelled "غير متوفر حالياً".

Keep it consistent with the existing test's provider/setup style. Run it after editing.

- [ ] **Step 12: Run the cart + products suites + analyze**

Run: `flutter test test/features/cart/ test/features/products/ && flutter analyze`
Expected: all pass; analyze clean.

- [ ] **Step 13: Commit**

```bash
git add apps/mobile/lib/features/cart/widgets/cart_icon_button.dart apps/mobile/lib/features/products/ apps/mobile/lib/features/listing_detail/view/listing_detail_screen.dart apps/mobile/test/features/cart/cart_icon_button_test.dart apps/mobile/test/features/cart/add_to_cart_test.dart apps/mobile/test/features/products/product_detail_screen_test.dart
git commit -m "feat(cart): add-to-cart UI on products + cart icon with count badge"
```

---

### Task 5: Cart screen + route + per-shop send + revalidation + flush-on-reconnect

**Files:**
- Create: `apps/mobile/lib/features/cart/view/cart_screen.dart`
- Create: `apps/mobile/lib/features/cart/widgets/shop_cart_card.dart`
- Modify: `apps/mobile/lib/app/router.dart`
- Modify: `apps/mobile/lib/app/app.dart`
- Test: `apps/mobile/test/features/cart/cart_screen_test.dart`

**Context:** The cart screen reads `CartCubit` (already provided app-wide). On open it revalidates each shop's lines against `ProductRepository`. Each shop renders in its own card with qty steppers, remove (with confirm), the shop subtotal, an issues banner if `hasIssues`, and a per-shop "أرسل السلة" WhatsApp button (disabled when `!canSend`). Sending uses `CartSender` + the app's `ConnectivityCubit` status. On `sent`/`queued` the shop cart is cleared with a snackbar. Flush-on-reconnect: a `BlocListener<ConnectivityCubit>` in `app.dart` calls `OutboxService.flush()` when status returns to `online`.

- [ ] **Step 1: Write the failing cart-screen test**

Create `apps/mobile/test/features/cart/cart_screen_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wasalni/core/connectivity/connectivity_cubit.dart';
import 'package:wasalni/data/models/product.dart';
import 'package:wasalni/data/repositories/product_repository.dart';
import 'package:wasalni/features/cart/bloc/cart_cubit.dart';
import 'package:wasalni/features/cart/cart_sender.dart';
import 'package:wasalni/features/cart/outbox_service.dart';
import 'package:wasalni/data/repositories/order_repository.dart';
import 'package:wasalni/features/cart/view/cart_screen.dart';

class _Conn extends Cubit<ConnectivityStatus> implements ConnectivityCubit {
  _Conn(super.s);
  @override
  dynamic noSuchMethod(Invocation i) => super.noSuchMethod(i);
}
class MockProductRepo extends Mock implements ProductRepository {}
class MockOrders extends Mock implements OrderRepository {}

Product _p(String id, {double price = 10, bool avail = true}) => Product(
    id: id, listingId: 's1', name: 'منتج $id', description: 'd', priceEgp: price, isAvailable: avail);

Widget _host({required CartCubit cart, required ProductRepository repo, required CartSender sender}) {
  return MaterialApp(
    home: MultiBlocProvider(
      providers: [
        BlocProvider<CartCubit>.value(value: cart),
        BlocProvider<ConnectivityCubit>(create: (_) => _Conn(ConnectivityStatus.online)),
      ],
      child: CartScreen(productRepository: repo, sender: sender),
    ),
  );
}

void main() {
  testWidgets('empty cart shows empty message', (tester) async {
    final repo = MockProductRepo();
    final orders = MockOrders();
    final sender = CartSender(orders, OutboxService(orders));
    await tester.pumpWidget(_host(cart: CartCubit(), repo: repo, sender: sender));
    await tester.pumpAndSettle();
    expect(find.textContaining('سلتك فاضية'), findsOneWidget);
  });

  testWidgets('renders a shop card with the shop name and a send button', (tester) async {
    final repo = MockProductRepo();
    when(() => repo.getProductById(any())).thenAnswer((i) async => _p(i.positionalArguments.first as String));
    final orders = MockOrders();
    final sender = CartSender(orders, OutboxService(orders));
    final cart = CartCubit()
      ..addProduct(product: _p('p1'), shopId: 's1', shopName: 'بقالة أبو أحمد', shopPhone: '+201000000005');
    await tester.pumpWidget(_host(cart: cart, repo: repo, sender: sender));
    await tester.pumpAndSettle();
    expect(find.text('بقالة أبو أحمد'), findsOneWidget);
    expect(find.text('أرسل السلة'), findsOneWidget);
  });
}
```

> Note: `ConnectivityCubit` is a concrete `Cubit<ConnectivityStatus>`; in the test you can provide it directly as `ConnectivityCubit(fakeService)` if a fake service is simpler than the `_Conn` shim above. Prefer whichever compiles cleanly against the current `ConnectivityCubit` constructor — if the shim is awkward, build a tiny fake `ConnectivityService` and use the real cubit without calling `init()`. The screen only reads `context.read<ConnectivityCubit>().state`.

- [ ] **Step 2: Run it to verify it fails**

Run: `flutter test test/features/cart/cart_screen_test.dart`
Expected: FAIL — `cart_screen.dart` does not exist.

- [ ] **Step 3: Write ShopCartCard**

Create `apps/mobile/lib/features/cart/widgets/shop_cart_card.dart`:

```dart
import 'package:flutter/material.dart';
import '../../../core/format/money.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/cart.dart';

class ShopCartCard extends StatelessWidget {
  const ShopCartCard({
    super.key,
    required this.shop,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
    required this.onSend,
  });

  final ShopCart shop;
  final void Function(String productId) onIncrement;
  final void Function(String productId) onDecrement;
  final void Function(String productId) onRemove;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.storefront, color: AppColors.primary),
                const SizedBox(width: AppSpacing.sm),
                Expanded(child: Text(shop.shopName, style: AppTextStyles.title)),
              ],
            ),
            if (shop.hasIssues) ...[
              const SizedBox(height: AppSpacing.sm),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
                child: Text('في أصناف اتغيّر سعرها أو خلصت — راجع طلبك',
                    style: AppTextStyles.caption.copyWith(color: AppColors.accent)),
              ),
            ],
            const SizedBox(height: AppSpacing.sm),
            for (final line in shop.lines) _LineRow(
              line: line,
              onIncrement: () => onIncrement(line.productId),
              onDecrement: () => onDecrement(line.productId),
              onRemove: () => onRemove(line.productId),
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('الإجمالي', style: AppTextStyles.label),
                Text(formatEgp(shop.total),
                    style: AppTextStyles.title.copyWith(color: AppColors.primary)),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                style: FilledButton.styleFrom(backgroundColor: AppColors.whatsapp),
                onPressed: shop.canSend ? onSend : null,
                icon: const Icon(Icons.send),
                label: Text(shop.canSend ? 'أرسل السلة' : 'مفيش رقم واتساب للمحل'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LineRow extends StatelessWidget {
  const _LineRow({
    required this.line,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
  });
  final CartLine line;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(line.name, style: AppTextStyles.label,
                    maxLines: 1, overflow: TextOverflow.ellipsis),
                Text(
                  line.isUnavailable ? 'غير متوفر حالياً' : formatEgp(line.effectivePrice),
                  style: AppTextStyles.caption.copyWith(
                      color: line.isUnavailable ? AppColors.accent : AppColors.textMuted),
                ),
              ],
            ),
          ),
          IconButton(onPressed: onDecrement, icon: const Icon(Icons.remove_circle_outline)),
          Text('${line.qty}', style: AppTextStyles.label),
          IconButton(onPressed: onIncrement, icon: const Icon(Icons.add_circle_outline)),
          IconButton(
            onPressed: onRemove,
            icon: const Icon(Icons.delete_outline, color: AppColors.error),
            tooltip: 'حذف',
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 4: Write CartScreen**

Create `apps/mobile/lib/features/cart/view/cart_screen.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../app/di.dart';
import '../../../core/connectivity/connectivity_cubit.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/empty_view.dart';
import '../../../data/models/cart.dart';
import '../../../data/models/order_intent.dart';
import '../../../data/models/product.dart';
import '../../../data/repositories/product_repository.dart';
import '../bloc/cart_cubit.dart';
import '../cart_sender.dart';
import '../widgets/shop_cart_card.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key, this.productRepository, this.sender, this.userName = ''});
  final ProductRepository? productRepository;
  final CartSender? sender;
  final String userName;

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _revalidate());
  }

  Future<void> _revalidate() async {
    final repo = widget.productRepository ?? getIt<ProductRepository>();
    final cart = context.read<CartCubit>();
    for (final shop in cart.state.shopCarts) {
      final latest = <String, Product?>{};
      for (final line in shop.lines) {
        try {
          latest[line.productId] = await repo.getProductById(line.productId);
        } catch (_) {
          latest[line.productId] = null; // treat as unavailable
        }
      }
      if (!mounted) return;
      cart.applyRevalidation(shop.shopId, latest);
    }
  }

  Future<void> _send(ShopCart shop) async {
    final sender = widget.sender ?? getIt<CartSender>();
    final cart = context.read<CartCubit>();
    final messenger = ScaffoldMessenger.of(context);
    final isOnline = context.read<ConnectivityCubit>().state == ConnectivityStatus.online;

    final outcome = await sender.send(shop, userName: widget.userName, isOnline: isOnline);
    if (!mounted) return;
    switch (outcome) {
      case SendOutcome.sent:
        cart.clearShop(shop.shopId);
        messenger.showSnackBar(const SnackBar(content: Text('فتحنا واتساب بطلبك ✅')));
      case SendOutcome.queued:
        cart.clearShop(shop.shopId);
        messenger.showSnackBar(const SnackBar(
            content: Text('مفيش نت — هنبعت الطلب أول ما النت يرجع')));
      case SendOutcome.whatsappFailed:
        messenger.showSnackBar(const SnackBar(
            content: Text('تعذّر فتح واتساب — اتأكد إنه متنصّب')));
      case SendOutcome.noPhone:
        messenger.showSnackBar(const SnackBar(
            content: Text('المحل ده مالوش رقم واتساب')));
    }
  }

  Future<void> _confirmRemove(String shopId, String productId, String name) async {
    final cart = context.read<CartCubit>();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('حذف الصنف'),
        content: Text('تحذف "$name" من السلة؟'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('رجوع')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
    if (ok ?? false) cart.removeLine(shopId, productId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('السلة')),
      body: BlocBuilder<CartCubit, Cart>(
        builder: (context, cart) {
          if (cart.isEmpty) {
            return const EmptyView(
              icon: Icons.shopping_cart_outlined,
              message: 'سلتك فاضية — ضيف منتجات من المحلات',
            );
          }
          final cubit = context.read<CartCubit>();
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              for (final shop in cart.shopCarts)
                ShopCartCard(
                  shop: shop,
                  onIncrement: (pid) => cubit.increment(shop.shopId, pid),
                  onDecrement: (pid) => cubit.decrement(shop.shopId, pid),
                  onRemove: (pid) {
                    final line = shop.lines.firstWhere((l) => l.productId == pid);
                    _confirmRemove(shop.shopId, pid, line.name);
                  },
                  onSend: () => _send(shop),
                ),
              const SizedBox(height: AppSpacing.md),
              Text('كل محل بيستلم طلبه على واتساب لوحده',
                  textAlign: TextAlign.center, style: AppTextStyles.caption),
            ],
          );
        },
      ),
    );
  }
}
```

> Check `EmptyView`'s actual constructor (`core/widgets/empty_view.dart`) — match its real parameter names (`icon`, `message`, or `title`). Adjust the call to compile. If `EmptyView` doesn't take an icon, drop it.

- [ ] **Step 5: Add the `/cart` route**

Modify `apps/mobile/lib/app/router.dart`. Add import:

```dart
import '../features/cart/view/cart_screen.dart';
```

Add a sibling route (alongside `/listing/:id`, `/product/:id`):

```dart
      GoRoute(
        path: '/cart',
        builder: (context, state) => const CartScreen(),
      ),
```

(The `CartCubit` is provided app-wide already, so the screen reads it from context.)

- [ ] **Step 6: Wire flush-on-reconnect in app.dart**

Modify `apps/mobile/lib/app/app.dart`. Wrap the `MaterialApp.router` in a `BlocListener<ConnectivityCubit, ConnectivityStatus>` that flushes the outbox when status returns to online. Add imports:

```dart
import 'package:wasalni/features/cart/outbox_service.dart';
```

Wrap the `MaterialApp.router` child:

```dart
        child: BlocListener<ConnectivityCubit, ConnectivityStatus>(
          listenWhen: (prev, curr) =>
              prev == ConnectivityStatus.offline && curr == ConnectivityStatus.online,
          listener: (context, _) {
            final outbox = getIt<OutboxService>();
            if (outbox.hasPending) outbox.flush();
          },
          child: MaterialApp.router( /* ...unchanged... */ ),
        ),
```

- [ ] **Step 7: Run the cart screen test**

Run: `flutter test test/features/cart/cart_screen_test.dart`
Expected: PASS (empty state + shop card render).

- [ ] **Step 8: Run the full suite + analyze**

Run: `flutter analyze && flutter test`
Expected: No analyze issues; all tests pass.

- [ ] **Step 9: Commit**

```bash
git add apps/mobile/lib/features/cart/view/cart_screen.dart apps/mobile/lib/features/cart/widgets/shop_cart_card.dart apps/mobile/lib/app/router.dart apps/mobile/lib/app/app.dart apps/mobile/test/features/cart/cart_screen_test.dart
git commit -m "feat(cart): cart screen + /cart route + per-shop WhatsApp send + revalidation + flush-on-reconnect"
```

---

## Final review (after all 5 tasks)

Dispatch a final code-review subagent over the whole Soft Cart implementation. Verify against spec section 12:
- per-shop carts, aggregate cart screen, per-shop send (no bulk send) ✓
- empty state, remove-with-confirm ✓
- send button disabled when no phone ✓
- revalidation badges on open ✓
- offline → outbox queue → flush on reconnect ✓
- order message includes shop name + lines/qty/prices + total + user name ✓

Then run `flutter analyze` + `flutter test` once more and update `docs/superpowers/plans/PROGRESS-phase4-soft-cart.md`.
```
