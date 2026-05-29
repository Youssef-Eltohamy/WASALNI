# WASALNI Frontend — Phase 3d: Shop Products + Product Detail

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development. Steps use checkbox (`- [ ]`) syntax.

**Goal:** Show a shop's products on its detail screen, and a product detail page with a "اطلب عبر واتساب" (order via WhatsApp) action.

**Architecture:** Reuses the proven pattern. Adds a `Product` model, a `ProductRepository` (+ mock + seed data), a `ProductsBloc` (products of a shop), and a `ProductDetailBloc` (one product + its shop's contact info). The shop's products render inside the existing `ListingDetailScreen` (only when `kind == shop`). The product page orders directly via WhatsApp (the cart/multi-item flow is a later phase).

**Tech Stack:** flutter_bloc, go_router, get_it, freezed (`--force-jit`), url_launcher (already added), bloc_test, mocktail.

**Scope:** Shop products list + product detail + single-product WhatsApp order. The multi-item Soft Cart is a later phase. Reference spec: `docs/superpowers/specs/2026-05-29-frontend-architecture-design.md`.

**Working dir:** `apps/mobile`. **build_runner MUST use `--force-jit`** (Dart 3.10).

---

## File Structure (this plan)

```
apps/mobile/lib/
  data/models/product.dart                              # CREATE (freezed)
  data/repositories/product_repository.dart             # CREATE (interface)
  data/repositories/mock/mock_product_repository.dart   # CREATE
  data/repositories/mock/mock_data.dart                 # MODIFY: add products
  app/di.dart                                           # MODIFY: register ProductRepository
  core/format/money.dart                                # CREATE (price formatter)
  features/products/bloc/products_event.dart            # CREATE
  features/products/bloc/products_state.dart            # CREATE (freezed)
  features/products/bloc/products_bloc.dart             # CREATE
  features/products/bloc/product_detail_event.dart      # CREATE
  features/products/bloc/product_detail_state.dart      # CREATE (freezed)
  features/products/bloc/product_detail_bloc.dart       # CREATE
  features/products/widgets/product_card.dart           # CREATE
  features/products/widgets/shop_products_section.dart  # CREATE
  features/products/view/product_detail_screen.dart     # CREATE
  features/listing_detail/view/listing_detail_screen.dart  # MODIFY: shop products section
  app/router.dart                                       # MODIFY: /product/:id route
test/
  data/repositories/mock_product_repository_test.dart   # CREATE
  features/products/products_bloc_test.dart             # CREATE
  features/products/shop_products_section_test.dart     # CREATE
  features/products/product_detail_bloc_test.dart       # CREATE
  features/products/product_detail_screen_test.dart     # CREATE
```

---

## Task 1: Product model + repository + seed data

**Files:**
- Create: `lib/data/models/product.dart`, `lib/data/repositories/product_repository.dart`, `lib/data/repositories/mock/mock_product_repository.dart`, `lib/core/format/money.dart`
- Modify: `lib/data/repositories/mock/mock_data.dart`, `lib/app/di.dart`
- Test: `test/data/repositories/mock_product_repository_test.dart`

- [ ] **Step 1: Failing test** `test/data/repositories/mock_product_repository_test.dart`:
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:wasalni/core/network/repository_exception.dart';
import 'package:wasalni/data/repositories/mock/mock_product_repository.dart';

void main() {
  test('getProducts returns the shop products', () async {
    final repo = MockProductRepository();
    final result = await repo.getProducts(shopId: 'l4');
    expect(result, isNotEmpty);
    expect(result.every((p) => p.listingId == 'l4'), true);
  });

  test('getProducts returns empty for a shop with no products', () async {
    final repo = MockProductRepository();
    expect(await repo.getProducts(shopId: 'l1'), isEmpty);
  });

  test('getProductById throws NotFoundException for unknown id', () async {
    final repo = MockProductRepository();
    expect(() => repo.getProductById('nope'), throwsA(isA<NotFoundException>()));
  });
}
```

- [ ] **Step 2: Run → FAIL:** `flutter test test/data/repositories/mock_product_repository_test.dart`

- [ ] **Step 3: `lib/data/models/product.dart`:**
```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'product.freezed.dart';

@freezed
abstract class Product with _$Product {
  const factory Product({
    required String id,
    required String listingId,
    required String name,
    required String description,
    required double priceEgp,
    String? imageUrl,
    @Default(true) bool isAvailable,
    @Default(0) int sortOrder,
  }) = _Product;
}
```

- [ ] **Step 4: Run codegen** so `product.freezed.dart` exists before the repo references it:
```bash
dart run build_runner build --force-jit --delete-conflicting-outputs
```

- [ ] **Step 5: `lib/data/repositories/product_repository.dart`:**
```dart
import '../models/product.dart';

abstract interface class ProductRepository {
  Future<List<Product>> getProducts({required String shopId});
  Future<Product> getProductById(String id);
}
```

- [ ] **Step 6: Seed data.** In `lib/data/repositories/mock/mock_data.dart`, add an import at top: `import '../../models/product.dart';` and add this static list to the `MockData` class:
```dart
  static final products = <Product>[
    // صيدلية الشفاء (l4)
    Product(id: 'p1', listingId: 'l4', name: 'بنادول إكسترا', description: 'علبة 24 قرص', priceEgp: 35),
    Product(id: 'p2', listingId: 'l4', name: 'فوار فيتامين سي', description: '10 أكياس', priceEgp: 45),
    Product(id: 'p3', listingId: 'l4', name: 'كمامات طبية', description: 'علبة 50', priceEgp: 30, isAvailable: false),
    // بقالة أبو أحمد (l5)
    Product(id: 'p4', listingId: 'l5', name: 'زيت عافية 1 لتر', description: 'زيت دوار الشمس', priceEgp: 60),
    Product(id: 'p5', listingId: 'l5', name: 'سكر 1 كيلو', description: 'سكر أبيض', priceEgp: 30),
    Product(id: 'p6', listingId: 'l5', name: 'شاي العروسة', description: 'علبة 250 جرام', priceEgp: 40),
    // سوبر ماركت تفهنا (l7)
    Product(id: 'p7', listingId: 'l7', name: 'أرز مصري 1 كيلو', description: 'أرز شعير', priceEgp: 35),
  ];
```

- [ ] **Step 7: `lib/data/repositories/mock/mock_product_repository.dart`:**
```dart
import '../../../core/network/repository_exception.dart';
import '../../models/product.dart';
import '../product_repository.dart';
import 'mock_data.dart';

class MockProductRepository implements ProductRepository {
  MockProductRepository({this.latency = const Duration(milliseconds: 300)});
  final Duration latency;

  @override
  Future<List<Product>> getProducts({required String shopId}) async {
    await Future<void>.delayed(latency);
    final items = MockData.products.where((p) => p.listingId == shopId).toList();
    items.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    return items;
  }

  @override
  Future<Product> getProductById(String id) async {
    await Future<void>.delayed(latency);
    final match = MockData.products.where((p) => p.id == id);
    if (match.isEmpty) throw const NotFoundException();
    return match.first;
  }
}
```

- [ ] **Step 8: `lib/core/format/money.dart`:**
```dart
/// Formats an EGP amount for display, e.g. 35.0 -> "35 جنيه".
String formatEgp(double amount) {
  final whole = amount == amount.roundToDouble();
  final n = whole ? amount.toStringAsFixed(0) : amount.toStringAsFixed(2);
  return '$n جنيه';
}
```

- [ ] **Step 9: Register in DI.** In `lib/app/di.dart`, add the imports `import '../data/repositories/product_repository.dart';` and `import '../data/repositories/mock/mock_product_repository.dart';`, and add to the `setupDi()` cascade:
```dart
    ..registerLazySingleton<ProductRepository>(MockProductRepository.new)
```

- [ ] **Step 10: Test + analyze:** `flutter test test/data/repositories/mock_product_repository_test.dart` → PASS (3). `flutter analyze` → clean.

- [ ] **Step 11: Commit**
```bash
git add lib/data/models/product.dart lib/data/repositories/product_repository.dart lib/data/repositories/mock/mock_product_repository.dart lib/data/repositories/mock/mock_data.dart lib/app/di.dart lib/core/format/money.dart test/data/repositories/mock_product_repository_test.dart
git commit -m "feat(mobile): add Product model + repository + seed data + money format"
```

---

## Task 2: ProductsBloc

**Files:**
- Create: `lib/features/products/bloc/products_event.dart`, `products_state.dart`, `products_bloc.dart`
- Test: `test/features/products/products_bloc_test.dart`

- [ ] **Step 1: Failing bloc test** `test/features/products/products_bloc_test.dart`:
```dart
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wasalni/core/network/repository_exception.dart';
import 'package:wasalni/data/models/product.dart';
import 'package:wasalni/data/repositories/product_repository.dart';
import 'package:wasalni/features/products/bloc/products_bloc.dart';
import 'package:wasalni/features/products/bloc/products_event.dart';
import 'package:wasalni/features/products/bloc/products_state.dart';

class MockProductRepo extends Mock implements ProductRepository {}

Product _p(String id) =>
    Product(id: id, listingId: 'l4', name: 'منتج $id', description: 'وصف', priceEgp: 10);

void main() {
  late MockProductRepo repo;
  setUp(() => repo = MockProductRepo());

  blocTest<ProductsBloc, ProductsState>(
    'emits [loading, loaded] when products exist',
    build: () {
      when(() => repo.getProducts(shopId: any(named: 'shopId')))
          .thenAnswer((_) async => [_p('p1'), _p('p2')]);
      return ProductsBloc(repo);
    },
    act: (bloc) => bloc.add(const ProductsRequested('l4')),
    expect: () => [
      const ProductsState.loading(),
      isA<ProductsLoaded>().having((s) => s.products.length, 'count', 2),
    ],
  );

  blocTest<ProductsBloc, ProductsState>(
    'emits [loading, empty] when none',
    build: () {
      when(() => repo.getProducts(shopId: any(named: 'shopId')))
          .thenAnswer((_) async => []);
      return ProductsBloc(repo);
    },
    act: (bloc) => bloc.add(const ProductsRequested('l4')),
    expect: () => [const ProductsState.loading(), const ProductsState.empty()],
  );

  blocTest<ProductsBloc, ProductsState>(
    'emits [loading, noConnection] on NoConnectionException',
    build: () {
      when(() => repo.getProducts(shopId: any(named: 'shopId')))
          .thenThrow(const NoConnectionException());
      return ProductsBloc(repo);
    },
    act: (bloc) => bloc.add(const ProductsRequested('l4')),
    expect: () => [const ProductsState.loading(), const ProductsState.noConnection()],
  );
}
```

- [ ] **Step 2: Run → FAIL.**

- [ ] **Step 3: `lib/features/products/bloc/products_event.dart`:**
```dart
sealed class ProductsEvent {
  const ProductsEvent();
}

class ProductsRequested extends ProductsEvent {
  const ProductsRequested(this.shopId);
  final String shopId;
}
```

- [ ] **Step 4: `lib/features/products/bloc/products_state.dart`:**
```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../data/models/product.dart';

part 'products_state.freezed.dart';

@freezed
sealed class ProductsState with _$ProductsState {
  const factory ProductsState.loading() = ProductsLoading;
  const factory ProductsState.loaded(List<Product> products) = ProductsLoaded;
  const factory ProductsState.empty() = ProductsEmpty;
  const factory ProductsState.noConnection() = ProductsNoConnection;
  const factory ProductsState.error(String message) = ProductsError;
}
```

- [ ] **Step 5: `lib/features/products/bloc/products_bloc.dart`:**
```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/network/repository_exception.dart';
import '../../../data/repositories/product_repository.dart';
import 'products_event.dart';
import 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  ProductsBloc(this._repo) : super(const ProductsState.loading()) {
    on<ProductsRequested>(_onRequested);
  }

  final ProductRepository _repo;

  Future<void> _onRequested(ProductsRequested e, Emitter<ProductsState> emit) async {
    emit(const ProductsState.loading());
    try {
      final products = await _repo.getProducts(shopId: e.shopId);
      emit(products.isEmpty ? const ProductsState.empty() : ProductsState.loaded(products));
    } on NoConnectionException {
      emit(const ProductsState.noConnection());
    } on RepositoryException catch (e) {
      emit(ProductsState.error(e.message ?? 'حصل خطأ'));
    }
  }
}
```

- [ ] **Step 6: Codegen + test:**
```bash
dart run build_runner build --force-jit --delete-conflicting-outputs
flutter test test/features/products/products_bloc_test.dart
```
Expected: 3 tests PASS.

- [ ] **Step 7: Commit**
```bash
git add lib/features/products/bloc/products_event.dart lib/features/products/bloc/products_state.dart lib/features/products/bloc/products_bloc.dart test/features/products/products_bloc_test.dart
git commit -m "feat(mobile): add ProductsBloc (loading/loaded/empty/offline/error)"
```

---

## Task 3: ProductCard + shop products section in the detail screen

**Files:**
- Create: `lib/features/products/widgets/product_card.dart`, `lib/features/products/widgets/shop_products_section.dart`
- Modify: `lib/features/listing_detail/view/listing_detail_screen.dart`
- Test: `test/features/products/shop_products_section_test.dart`

- [ ] **Step 1: Failing widget test** `test/features/products/shop_products_section_test.dart`:
```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wasalni/data/repositories/product_repository.dart';
import 'package:wasalni/data/repositories/mock/mock_product_repository.dart';
import 'package:wasalni/features/products/widgets/shop_products_section.dart';

void main() {
  testWidgets('ShopProductsSection lists the shop products', (tester) async {
    final ProductRepository repo = MockProductRepository(latency: Duration.zero);
    await tester.pumpWidget(MaterialApp(
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          body: SingleChildScrollView(
            child: ShopProductsSection(shopId: 'l4', repository: repo),
          ),
        ),
      ),
    ));
    await tester.pumpAndSettle();

    expect(find.text('بنادول إكسترا'), findsOneWidget);
    expect(find.text('المنتجات'), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run → FAIL.**

- [ ] **Step 3: `lib/features/products/widgets/product_card.dart`:**
```dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../core/format/money.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/product.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product, required this.onTap});
  final Product product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        onTap: onTap,
        leading: SizedBox(
          width: 56,
          height: 56,
          child: (product.imageUrl == null || product.imageUrl!.isEmpty)
              ? Container(
                  color: AppColors.border,
                  child: const Icon(Icons.inventory_2_outlined, color: AppColors.textMuted))
              : CachedNetworkImage(imageUrl: product.imageUrl!, fit: BoxFit.cover),
        ),
        title: Text(product.name, style: AppTextStyles.label,
            maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text(
          product.isAvailable ? formatEgp(product.priceEgp) : 'غير متوفر حالياً',
          style: AppTextStyles.caption.copyWith(
            color: product.isAvailable ? AppColors.primary : AppColors.accent),
        ),
      ),
    );
  }
}
```

- [ ] **Step 4: `lib/features/products/widgets/shop_products_section.dart`:**
```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../app/di.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/repositories/product_repository.dart';
import '../bloc/products_bloc.dart';
import '../bloc/products_event.dart';
import '../bloc/products_state.dart';
import 'product_card.dart';

class ShopProductsSection extends StatelessWidget {
  const ShopProductsSection({super.key, required this.shopId, this.repository});
  final String shopId;
  final ProductRepository? repository;

  @override
  Widget build(BuildContext context) {
    final repo = repository ?? getIt<ProductRepository>();
    return BlocProvider(
      create: (_) => ProductsBloc(repo)..add(ProductsRequested(shopId)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('المنتجات', style: AppTextStyles.title),
          const SizedBox(height: AppSpacing.sm),
          BlocBuilder<ProductsBloc, ProductsState>(
            builder: (context, state) => switch (state) {
              ProductsLoading() => const Padding(
                  padding: EdgeInsets.all(AppSpacing.lg),
                  child: Center(child: CircularProgressIndicator()),
                ),
              ProductsEmpty() => Text('مفيش منتجات لسه', style: AppTextStyles.caption),
              ProductsNoConnection() =>
                Text('تعذّر تحميل المنتجات (مفيش نت)', style: AppTextStyles.caption),
              ProductsError(:final message) => Text(message, style: AppTextStyles.caption),
              ProductsLoaded(:final products) => Column(
                  children: [
                    for (final p in products)
                      ProductCard(
                        product: p,
                        onTap: () => context.push('/product/${p.id}'),
                      ),
                  ],
                ),
            },
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 5: Wire into the detail screen.** In `lib/features/listing_detail/view/listing_detail_screen.dart`:
- Add imports: `import '../../../data/models/enums.dart';` and `import '../../products/widgets/shop_products_section.dart';`
- In `_DetailBody.build`, inside the `Column` children, AFTER the contact-buttons `Row(...)`, add:
```dart
                  if (listing.kind == ListingKind.shop) ...[
                    const SizedBox(height: AppSpacing.xl),
                    ShopProductsSection(shopId: listing.id),
                  ],
```

- [ ] **Step 6: Test + analyze:**
```bash
flutter test test/features/products/shop_products_section_test.dart
flutter test test/features/listing_detail/listing_detail_screen_test.dart
flutter analyze
```
Expected: section test PASS; existing detail-screen test (uses service listing `l1`, no products section) still PASS; analyze clean.

- [ ] **Step 7: Commit**
```bash
git add lib/features/products/widgets lib/features/listing_detail/view/listing_detail_screen.dart test/features/products/shop_products_section_test.dart
git commit -m "feat(mobile): show shop products on the listing detail screen"
```

---

## Task 4: ProductDetailBloc (product + shop contact)

**Files:**
- Create: `lib/features/products/bloc/product_detail_event.dart`, `product_detail_state.dart`, `product_detail_bloc.dart`
- Test: `test/features/products/product_detail_bloc_test.dart`

- [ ] **Step 1: Failing bloc test** `test/features/products/product_detail_bloc_test.dart`:
```dart
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wasalni/core/network/repository_exception.dart';
import 'package:wasalni/data/models/enums.dart';
import 'package:wasalni/data/models/listing.dart';
import 'package:wasalni/data/models/product.dart';
import 'package:wasalni/data/repositories/listing_repository.dart';
import 'package:wasalni/data/repositories/product_repository.dart';
import 'package:wasalni/features/products/bloc/product_detail_bloc.dart';
import 'package:wasalni/features/products/bloc/product_detail_event.dart';
import 'package:wasalni/features/products/bloc/product_detail_state.dart';

class MockProductRepo extends Mock implements ProductRepository {}
class MockListingRepo extends Mock implements ListingRepository {}

final _product = Product(
    id: 'p1', listingId: 'l4', name: 'بنادول', description: 'وصف', priceEgp: 35);
Listing _shop() => Listing(
    id: 'l4', kind: ListingKind.shop, ownerId: 'o', villageId: 'v_kafr', categoryId: 'c',
    name: 'صيدلية الشفاء', bio: 'وصف', phoneWhatsapp: '+201000000004',
    createdAt: DateTime.utc(2026, 1, 1));

void main() {
  late MockProductRepo products;
  late MockListingRepo listings;
  setUp(() {
    products = MockProductRepo();
    listings = MockListingRepo();
  });

  blocTest<ProductDetailBloc, ProductDetailState>(
    'emits [loading, loaded] with product + shop contact',
    build: () {
      when(() => products.getProductById(any())).thenAnswer((_) async => _product);
      when(() => listings.getById(any())).thenAnswer((_) async => _shop());
      return ProductDetailBloc(products, listings);
    },
    act: (bloc) => bloc.add(const ProductDetailRequested('p1')),
    expect: () => [
      const ProductDetailState.loading(),
      isA<ProductDetailLoaded>()
          .having((s) => s.product.id, 'product id', 'p1')
          .having((s) => s.shopName, 'shop name', 'صيدلية الشفاء')
          .having((s) => s.shopPhone, 'shop phone', '+201000000004'),
    ],
  );

  blocTest<ProductDetailBloc, ProductDetailState>(
    'emits [loading, error] when product not found',
    build: () {
      when(() => products.getProductById(any())).thenThrow(const NotFoundException());
      return ProductDetailBloc(products, listings);
    },
    act: (bloc) => bloc.add(const ProductDetailRequested('nope')),
    expect: () => [const ProductDetailState.loading(), isA<ProductDetailError>()],
  );
}
```

- [ ] **Step 2: Run → FAIL.**

- [ ] **Step 3: `lib/features/products/bloc/product_detail_event.dart`:**
```dart
sealed class ProductDetailEvent {
  const ProductDetailEvent();
}

class ProductDetailRequested extends ProductDetailEvent {
  const ProductDetailRequested(this.productId);
  final String productId;
}
```

- [ ] **Step 4: `lib/features/products/bloc/product_detail_state.dart`:**
```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../data/models/product.dart';

part 'product_detail_state.freezed.dart';

@freezed
sealed class ProductDetailState with _$ProductDetailState {
  const factory ProductDetailState.loading() = ProductDetailLoading;
  const factory ProductDetailState.loaded({
    required Product product,
    required String shopName,
    required String shopPhone,
  }) = ProductDetailLoaded;
  const factory ProductDetailState.noConnection() = ProductDetailNoConnection;
  const factory ProductDetailState.error(String message) = ProductDetailError;
}
```

- [ ] **Step 5: `lib/features/products/bloc/product_detail_bloc.dart`:**
```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/network/repository_exception.dart';
import '../../../data/repositories/listing_repository.dart';
import '../../../data/repositories/product_repository.dart';
import 'product_detail_event.dart';
import 'product_detail_state.dart';

class ProductDetailBloc extends Bloc<ProductDetailEvent, ProductDetailState> {
  ProductDetailBloc(this._products, this._listings)
      : super(const ProductDetailState.loading()) {
    on<ProductDetailRequested>(_onRequested);
  }

  final ProductRepository _products;
  final ListingRepository _listings;

  Future<void> _onRequested(
      ProductDetailRequested e, Emitter<ProductDetailState> emit) async {
    emit(const ProductDetailState.loading());
    try {
      final product = await _products.getProductById(e.productId);
      final shop = await _listings.getById(product.listingId);
      emit(ProductDetailState.loaded(
        product: product,
        shopName: shop.name,
        shopPhone: shop.phoneWhatsapp,
      ));
    } on NoConnectionException {
      emit(const ProductDetailState.noConnection());
    } on RepositoryException catch (e) {
      emit(ProductDetailState.error(e.message ?? 'حصل خطأ'));
    }
  }
}
```

- [ ] **Step 6: Codegen + test:**
```bash
dart run build_runner build --force-jit --delete-conflicting-outputs
flutter test test/features/products/product_detail_bloc_test.dart
```
Expected: 2 tests PASS.

- [ ] **Step 7: Commit**
```bash
git add lib/features/products/bloc/product_detail_event.dart lib/features/products/bloc/product_detail_state.dart lib/features/products/bloc/product_detail_bloc.dart test/features/products/product_detail_bloc_test.dart
git commit -m "feat(mobile): add ProductDetailBloc (product + shop contact)"
```

---

## Task 5: Product detail screen + route + verify

**Files:**
- Create: `lib/features/products/view/product_detail_screen.dart`
- Modify: `lib/app/router.dart`
- Test: `test/features/products/product_detail_screen_test.dart`

- [ ] **Step 1: Failing screen test** `test/features/products/product_detail_screen_test.dart`:
```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wasalni/data/repositories/listing_repository.dart';
import 'package:wasalni/data/repositories/product_repository.dart';
import 'package:wasalni/data/repositories/mock/mock_listing_repository.dart';
import 'package:wasalni/data/repositories/mock/mock_product_repository.dart';
import 'package:wasalni/features/products/bloc/product_detail_bloc.dart';
import 'package:wasalni/features/products/bloc/product_detail_event.dart';
import 'package:wasalni/features/products/view/product_detail_screen.dart';

void main() {
  testWidgets('ProductDetailScreen shows product, price, shop and order button',
      (tester) async {
    final ProductRepository products = MockProductRepository(latency: Duration.zero);
    final ListingRepository listings = MockListingRepository(latency: Duration.zero);

    await tester.pumpWidget(MaterialApp(
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: BlocProvider(
          create: (_) => ProductDetailBloc(products, listings)
            ..add(const ProductDetailRequested('p1')),
          child: const ProductDetailScreen(),
        ),
      ),
    ));
    await tester.pumpAndSettle();

    expect(find.text('بنادول إكسترا'), findsOneWidget); // p1 name
    expect(find.text('35 جنيه'), findsOneWidget);
    expect(find.text('اطلب عبر واتساب'), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run → FAIL.**

- [ ] **Step 3: `lib/features/products/view/product_detail_screen.dart`:**
```dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/format/money.dart';
import '../../../core/launch/contact_launcher.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/loading_view.dart';
import '../bloc/product_detail_bloc.dart';
import '../bloc/product_detail_state.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key, this.launcher = const ContactLauncher()});
  final ContactLauncher launcher;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تفاصيل المنتج')),
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
                AspectRatio(
                  aspectRatio: 4 / 3,
                  child: (product.imageUrl == null || product.imageUrl!.isEmpty)
                      ? Container(
                          color: AppColors.border,
                          child: const Icon(Icons.inventory_2_outlined,
                              size: 64, color: AppColors.textMuted))
                      : CachedNetworkImage(imageUrl: product.imageUrl!, fit: BoxFit.cover),
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
                FilledButton.icon(
                  style: FilledButton.styleFrom(backgroundColor: AppColors.whatsapp),
                  onPressed: product.isAvailable
                      ? () => _order(context, product.name, product.priceEgp, shopPhone)
                      : null,
                  icon: const Icon(Icons.chat),
                  label: Text(product.isAvailable ? 'اطلب عبر واتساب' : 'غير متوفر حالياً'),
                ),
              ],
            ),
        },
      ),
    );
  }

  Future<void> _order(
      BuildContext context, String name, double price, String shopPhone) async {
    final messenger = ScaffoldMessenger.of(context);
    final ok = await launcher.whatsapp(
      shopPhone,
      message: 'السلام عليكم، عايز أطلب: $name (${formatEgp(price)}) — لقيته على وصلني',
    );
    if (!ok) {
      messenger.showSnackBar(
        const SnackBar(content: Text('تعذّر فتح واتساب — اتأكد إنه متنصّب')),
      );
    }
  }
}
```

- [ ] **Step 4: Run the screen test → PASS.**

- [ ] **Step 5: Add the route.** In `lib/app/router.dart`:
- Add imports: `import '../data/repositories/product_repository.dart';`, `import '../features/products/bloc/product_detail_bloc.dart';`, `import '../features/products/bloc/product_detail_event.dart';`, `import '../features/products/view/product_detail_screen.dart';` (`ListingRepository`, `getIt`, `flutter_bloc` already imported).
- Add a top-level `GoRoute` (sibling of the shell route, next to `/listing/:id`):
```dart
      GoRoute(
        path: '/product/:id',
        builder: (context, state) => BlocProvider(
          create: (_) => ProductDetailBloc(
            getIt<ProductRepository>(),
            getIt<ListingRepository>(),
          )..add(ProductDetailRequested(state.pathParameters['id']!)),
          child: const ProductDetailScreen(),
        ),
      ),
```

- [ ] **Step 6: Full suite + analyze:**
```bash
flutter test
flutter analyze
```
Expected: ALL tests pass; analyze clean. If `unnecessary_underscores`/unused-import lints appear, fix only those.

- [ ] **Step 7: Commit**
```bash
git add lib/features/products/view/product_detail_screen.dart lib/app/router.dart test/features/products/product_detail_screen_test.dart
git commit -m "feat(mobile): add product detail screen + /product/:id + WhatsApp order"
```

---

## Done — Definition of Complete

- `flutter analyze` clean; `flutter test` all green.
- A shop's detail screen lists its products (with price / "غير متوفر" state). Tapping a product opens a detail page (image, name, price, shop) with an "اطلب عبر واتساب" button that opens the shop's WhatsApp with a pre-filled order message (disabled when the product is unavailable).

**Follow-ups (noted):** multi-item Soft Cart (per-shop + send) — the spec's cart flow; provider portfolio gallery; transport vehicle/area details; Eastern-Arabic numerals for prices (polish, Phase 4). **Next plan:** the Soft Cart, or auth/account.
