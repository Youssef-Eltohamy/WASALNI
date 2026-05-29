# WASALNI Frontend — Foundation + Feed Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build the Flutter foundation (theme, RTL, DI, navigation shell, mock repository layer, connectivity) and a fully working Feed screen on realistic mock data — proving the architecture pattern end-to-end.

**Architecture:** feature-first layering. UI → Bloc → abstract Repository → Mock implementation. Swapping mock for Supabase later = one line in `di.dart`. State via `flutter_bloc`, navigation via `go_router` `StatefulShellRoute`, DI via `get_it`, models via `freezed` + `json_serializable`. RTL Arabic (`ar-EG`), Cairo font, WASALNI petrol palette.

**Tech Stack:** Flutter 3.38 / Dart 3.10, flutter_bloc, go_router, get_it, freezed 3.x, json_serializable, connectivity_plus, cached_network_image, bloc_test, mocktail.

**Scope:** This is the FIRST plan (spec phases 1–2). Remaining screens (categories, search, profiles, cart, auth, account, registration…) are later plans. Reference spec: `docs/superpowers/specs/2026-05-29-frontend-architecture-design.md`.

**Working directory for all commands:** `apps/mobile` (run `cd apps/mobile` first; all paths below are relative to it unless noted).

---

## File Structure (created by this plan)

```
apps/mobile/
  pubspec.yaml                                  # MODIFY: deps + fonts
  assets/fonts/Cairo-*.ttf                      # CREATE: bundled font
  lib/
    main.dart                                   # MODIFY: bootstrap DI + runApp(App)
    app/
      app.dart                                  # CREATE: MaterialApp.router
      router.dart                               # CREATE: go_router shell + branches
      di.dart                                   # CREATE: get_it setup
    core/
      theme/app_colors.dart                     # CREATE
      theme/app_spacing.dart                    # CREATE
      theme/app_text_styles.dart                # CREATE
      theme/app_theme.dart                      # CREATE
      network/repository_exception.dart         # CREATE: sealed exceptions
      connectivity/connectivity_service.dart    # CREATE: interface + real impl
      connectivity/connectivity_cubit.dart      # CREATE
      widgets/loading_view.dart                 # CREATE
      widgets/empty_view.dart                   # CREATE
      widgets/error_view.dart                   # CREATE
      widgets/offline_banner.dart               # CREATE
    data/
      models/enums.dart                         # CREATE
      models/village.dart                        # CREATE (freezed)
      models/category.dart                       # CREATE (freezed)
      models/listing.dart                        # CREATE (freezed)
      repositories/listing_repository.dart       # CREATE: interface
      repositories/village_repository.dart       # CREATE: interface
      repositories/category_repository.dart      # CREATE: interface
      repositories/mock/mock_data.dart           # CREATE: realistic fixtures
      repositories/mock/mock_listing_repository.dart   # CREATE
      repositories/mock/mock_village_repository.dart   # CREATE
      repositories/mock/mock_category_repository.dart  # CREATE
    features/
      shell/scaffold_with_nav_bar.dart          # CREATE: bottom nav shell
      categories/categories_placeholder.dart    # CREATE: stub tab
      favorites/favorites_placeholder.dart      # CREATE: stub tab
      account/account_placeholder.dart          # CREATE: stub tab
      feed/bloc/feed_event.dart                 # CREATE
      feed/bloc/feed_state.dart                 # CREATE (freezed sealed)
      feed/bloc/feed_bloc.dart                  # CREATE
      feed/widgets/listing_card.dart            # CREATE
      feed/view/feed_screen.dart                # CREATE
  test/
    data/models/listing_test.dart               # CREATE
    data/repositories/mock_listing_repository_test.dart  # CREATE
    core/connectivity/connectivity_cubit_test.dart       # CREATE
    core/widgets/state_widgets_test.dart        # CREATE
    app/app_boot_test.dart                      # CREATE
    features/feed/feed_bloc_test.dart           # CREATE
    features/feed/listing_card_test.dart        # CREATE
    features/feed/feed_screen_test.dart         # CREATE
```

---

# PHASE 1 — FOUNDATION

## Task 1: Dependencies + Cairo font

**Files:**
- Modify: `apps/mobile/pubspec.yaml`
- Create: `apps/mobile/assets/fonts/Cairo-Regular.ttf`, `Cairo-SemiBold.ttf`, `Cairo-Bold.ttf`

- [ ] **Step 1: Add runtime + dev dependencies**

Run (from `apps/mobile`):
```bash
flutter pub add flutter_bloc go_router get_it connectivity_plus cached_network_image freezed_annotation
flutter pub add dev:build_runner dev:freezed dev:bloc_test dev:mocktail
```
Expected: `pubspec.yaml` gains the packages; `flutter pub get` runs automatically with no resolution errors.

> NOTE: `json_serializable`/`json_annotation` are intentionally **deferred to the backend phase**. The mock phase needs no JSON, and the latest `json_serializable` conflicts with `bloc_test` on the `analyzer` version. Models use `freezed` for `copyWith`/equality only (no `fromJson`/`toJson`) for now.

- [ ] **Step 2: Acquire the Cairo font (already done)**

The Cairo **variable** font is already downloaded to `apps/mobile/assets/fonts/Cairo.ttf` (from google/fonts, contains the full weight axis 200–900). Flutter applies `FontWeight` via the variable wght axis, so a single asset covers all weights. Verify it exists:
```bash
ls -la apps/mobile/assets/fonts/Cairo.ttf
```
Expected: a ~600KB TrueType file.

- [ ] **Step 3: Register font + assets in pubspec**

In `pubspec.yaml`, under the existing `flutter:` section, ensure:
```yaml
flutter:
  uses-material-design: true
  assets:
    - .env
  fonts:
    - family: Cairo
      fonts:
        - asset: assets/fonts/Cairo.ttf
```

- [ ] **Step 4: Verify resolution + analyze**

Run:
```bash
flutter pub get && flutter analyze
```
Expected: `No issues found!` (or only pre-existing warnings in `main.dart`).

- [ ] **Step 5: Commit**

```bash
git add apps/mobile/pubspec.yaml apps/mobile/pubspec.lock apps/mobile/assets/fonts
git commit -m "chore(mobile): add core deps + bundle Cairo font"
```

---

## Task 2: Theme tokens

**Files:**
- Create: `lib/core/theme/app_colors.dart`, `app_spacing.dart`, `app_text_styles.dart`, `app_theme.dart`

- [ ] **Step 1: Create color tokens**

`lib/core/theme/app_colors.dart`:
```dart
import 'package:flutter/material.dart';

/// WASALNI palette — single source from return_to_zero/design_system.md.
abstract final class AppColors {
  static const primary = Color(0xFF0D5C75);
  static const primaryDark = Color(0xFF082F3D);
  static const accent = Color(0xFFFF7A45);
  static const whatsapp = Color(0xFF25D366);
  static const background = Color(0xFFF4F8FA);
  static const surface = Color(0xFFFFFFFF);
  static const text = Color(0xFF15252E);
  static const textMuted = Color(0xFF5B6B73);
  static const success = Color(0xFF2E9E5B);
  static const verified = Color(0xFF1B4965);
  static const error = Color(0xFFD64545);
  static const border = Color(0xFFD0DCE2);
}
```

- [ ] **Step 2: Create spacing tokens**

`lib/core/theme/app_spacing.dart`:
```dart
/// 4pt spacing scale + radii.
abstract final class AppSpacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 24.0;
  static const xxl = 32.0;

  static const radiusSm = 8.0;
  static const radiusMd = 12.0;
  static const radiusLg = 16.0;
}
```

- [ ] **Step 3: Create text styles (Cairo, min 14sp)**

`lib/core/theme/app_text_styles.dart`:
```dart
import 'package:flutter/material.dart';
import 'app_colors.dart';

abstract final class AppTextStyles {
  static const _family = 'Cairo';

  static const headline = TextStyle(
    fontFamily: _family, fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.text);
  static const title = TextStyle(
    fontFamily: _family, fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.text);
  static const body = TextStyle(
    fontFamily: _family, fontSize: 15, fontWeight: FontWeight.w400, color: AppColors.text);
  static const label = TextStyle(
    fontFamily: _family, fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.text);
  static const caption = TextStyle(
    fontFamily: _family, fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.textMuted);
}
```

- [ ] **Step 4: Create the ThemeData builder**

`lib/core/theme/app_theme.dart`:
```dart
import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_text_styles.dart';

abstract final class AppTheme {
  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      secondary: AppColors.accent,
      surface: AppColors.surface,
      error: AppColors.error,
      brightness: Brightness.light,
    );
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Cairo',
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: 'Cairo', fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd)),
      ),
      textTheme: const TextTheme(
        headlineSmall: AppTextStyles.headline,
        titleMedium: AppTextStyles.title,
        bodyMedium: AppTextStyles.body,
        labelLarge: AppTextStyles.label,
        bodySmall: AppTextStyles.caption,
      ),
    );
  }
}
```

- [ ] **Step 5: Analyze + commit**

Run: `flutter analyze`
Expected: no new issues.
```bash
git add lib/core/theme
git commit -m "feat(mobile): add WASALNI theme tokens (colors, spacing, text, theme)"
```

---

## Task 3: Enums + models (freezed)

**Files:**
- Create: `lib/data/models/enums.dart`, `village.dart`, `category.dart`, `listing.dart`
- Test: `test/data/models/listing_test.dart`

- [ ] **Step 1: Write the failing serialization test**

`test/data/models/listing_test.dart`:
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:wasalni/data/models/enums.dart';
import 'package:wasalni/data/models/listing.dart';

Listing _build() => Listing(
      id: 'l1',
      kind: ListingKind.service,
      ownerId: 'u1',
      villageId: 'v1',
      categoryId: 'c1',
      name: 'سباك الحرفية',
      bio: 'سباكة وتسليك مجاري',
      phoneWhatsapp: '+201000000001',
      status: ListingStatus.active,
      isVerified: true,
      plan: ListingPlan.free,
      createdAt: DateTime.utc(2026, 1, 1),
    );

void main() {
  test('Listing has value equality and copyWith preserves other fields', () {
    final a = _build();
    final b = _build();
    expect(a, b); // freezed value equality

    final c = a.copyWith(isVerified: false);
    expect(c.isVerified, false);
    expect(c.name, 'سباك الحرفية');
    expect(c, isNot(a));
    expect(a.kind, ListingKind.service);
  });
}
```

- [ ] **Step 2: Run the test to verify it fails**

Run: `flutter test test/data/models/listing_test.dart`
Expected: FAIL — compile error, `enums.dart` / `listing.dart` do not exist.

- [ ] **Step 3: Create the enums**

`lib/data/models/enums.dart`:
```dart
enum ListingKind { service, shop, transport }

enum ListingStatus { draft, pending, active, rejected, suspended, deactivated, expired }

enum ListingPlan { free, prime }
```

- [ ] **Step 4: Create the Village model**

`lib/data/models/village.dart`:
```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'village.freezed.dart';

@freezed
abstract class Village with _$Village {
  const factory Village({
    required String id,
    required String name,
    required String governorate,
    required String markaz,
  }) = _Village;
}
```

- [ ] **Step 5: Create the Category model**

`lib/data/models/category.dart`:
```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'enums.dart';

part 'category.freezed.dart';

@freezed
abstract class Category with _$Category {
  const factory Category({
    required String id,
    required String name,
    required String slug,
    required String iconName,
    required ListingKind kind,
    @Default(0) int sortOrder,
  }) = _Category;
}
```

- [ ] **Step 6: Create the Listing model**

`lib/data/models/listing.dart`:
```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'enums.dart';

part 'listing.freezed.dart';

@freezed
abstract class Listing with _$Listing {
  const factory Listing({
    required String id,
    required ListingKind kind,
    required String ownerId,
    required String villageId,
    required String categoryId,
    required String name,
    required String bio,
    required String phoneWhatsapp,
    String? logoUrl,
    @Default(ListingStatus.active) ListingStatus status,
    @Default(false) bool isVerified,
    @Default(false) bool isFeatured,
    @Default(ListingPlan.free) ListingPlan plan,
    @Default(false) bool isTemporarilyClosed,
    required DateTime createdAt,
  }) = _Listing;
}
```

- [ ] **Step 7: Run code generation**

Run: `dart run build_runner build --force-jit --delete-conflicting-outputs`
Expected: generates `*.freezed.dart` for village/category/listing with no errors.

> NOTE: The `--force-jit` flag is REQUIRED on this machine (Dart 3.10): the default AOT path fails with "'dart compile' does not support build hooks" because some transitive packages ship native build hooks. Always use `--force-jit` for build_runner here.

- [ ] **Step 8: Run the test to verify it passes**

Run: `flutter test test/data/models/listing_test.dart`
Expected: PASS.

- [ ] **Step 9: Commit**

```bash
git add lib/data/models test/data/models/listing_test.dart
git commit -m "feat(mobile): add Listing/Village/Category models + enums (freezed)"
```

---

## Task 4: Repository exceptions + interfaces

**Files:**
- Create: `lib/core/network/repository_exception.dart`
- Create: `lib/data/repositories/listing_repository.dart`, `village_repository.dart`, `category_repository.dart`

- [ ] **Step 1: Create the sealed exception hierarchy**

`lib/core/network/repository_exception.dart`:
```dart
/// Errors a repository can surface. UI maps each to a distinct state.
sealed class RepositoryException implements Exception {
  const RepositoryException([this.message]);
  final String? message;
}

class NoConnectionException extends RepositoryException {
  const NoConnectionException() : super('لا يوجد اتصال بالإنترنت');
}

class RequestTimeoutException extends RepositoryException {
  const RequestTimeoutException() : super('انتهت مهلة الاتصال');
}

class ServerException extends RepositoryException {
  const ServerException([super.message = 'خطأ في الخادم']);
}

class NotFoundException extends RepositoryException {
  const NotFoundException([super.message = 'غير موجود']);
}
```

- [ ] **Step 2: Create the ListingRepository interface**

`lib/data/repositories/listing_repository.dart`:
```dart
import '../models/enums.dart';
import '../models/listing.dart';

abstract interface class ListingRepository {
  /// Active, non-hidden listings for a village, optionally filtered by kind.
  /// Throws [RepositoryException] subtypes on failure.
  Future<List<Listing>> getFeed({required String villageId, ListingKind? kind});

  Future<Listing> getById(String id);
}
```

- [ ] **Step 3: Create the Village + Category interfaces**

`lib/data/repositories/village_repository.dart`:
```dart
import '../models/village.dart';

abstract interface class VillageRepository {
  Future<List<Village>> getVillages();
}
```

`lib/data/repositories/category_repository.dart`:
```dart
import '../models/category.dart';
import '../models/enums.dart';

abstract interface class CategoryRepository {
  Future<List<Category>> getCategories({ListingKind? kind});
}
```

- [ ] **Step 4: Analyze + commit**

Run: `flutter analyze`
Expected: no new issues.
```bash
git add lib/core/network lib/data/repositories
git commit -m "feat(mobile): add repository interfaces + sealed RepositoryException"
```

---

## Task 5: Realistic mock data

**Files:**
- Create: `lib/data/repositories/mock/mock_data.dart`

- [ ] **Step 1: Create the fixtures**

`lib/data/repositories/mock/mock_data.dart`:
```dart
import '../../models/category.dart';
import '../../models/enums.dart';
import '../../models/listing.dart';
import '../../models/village.dart';

/// Realistic seed data for Kafr El-Maqdam & Tahna. Mirrors the schema draft
/// so it can later seed the real DB.
abstract final class MockData {
  static final villages = <Village>[
    Village(id: 'v_kafr', name: 'كفر المقدام', governorate: 'الدقهلية', markaz: 'ميت غمر'),
    Village(id: 'v_tahna', name: 'تفهنا الأشراف', governorate: 'الدقهلية', markaz: 'أجا'),
  ];

  static final categories = <Category>[
    Category(id: 'cat_plumb', name: 'سباكة', slug: 'plumbing', iconName: 'plumbing', kind: ListingKind.service, sortOrder: 1),
    Category(id: 'cat_elec', name: 'كهرباء', slug: 'electric', iconName: 'electrical_services', kind: ListingKind.service, sortOrder: 2),
    Category(id: 'cat_carp', name: 'نجارة', slug: 'carpentry', iconName: 'carpenter', kind: ListingKind.service, sortOrder: 3),
    Category(id: 'cat_pharm', name: 'صيدلية', slug: 'pharmacy', iconName: 'local_pharmacy', kind: ListingKind.shop, sortOrder: 4),
    Category(id: 'cat_groc', name: 'بقالة', slug: 'grocery', iconName: 'storefront', kind: ListingKind.shop, sortOrder: 5),
    Category(id: 'cat_tuktuk', name: 'توك توك', slug: 'tuktuk', iconName: 'electric_rickshaw', kind: ListingKind.transport, sortOrder: 6),
  ];

  static final listings = <Listing>[
    Listing(
      id: 'l1', kind: ListingKind.service, ownerId: 'u1', villageId: 'v_kafr',
      categoryId: 'cat_plumb', name: 'سباك الأسطى محمود', bio: 'سباكة وتسليك وتركيب سخانات',
      phoneWhatsapp: '+201000000001', status: ListingStatus.active, isVerified: true,
      isFeatured: true, plan: ListingPlan.prime, createdAt: DateTime.utc(2026, 1, 2)),
    Listing(
      id: 'l2', kind: ListingKind.service, ownerId: 'u2', villageId: 'v_kafr',
      categoryId: 'cat_elec', name: 'كهربائي العمدة', bio: 'تأسيس وصيانة كهرباء المنازل',
      phoneWhatsapp: '+201000000002', status: ListingStatus.active, isVerified: true,
      createdAt: DateTime.utc(2026, 1, 3)),
    Listing(
      id: 'l3', kind: ListingKind.service, ownerId: 'u3', villageId: 'v_kafr',
      categoryId: 'cat_carp', name: 'نجار الخير', bio: 'موبيليا وأبواب وشبابيك',
      phoneWhatsapp: '+201000000003', status: ListingStatus.active,
      createdAt: DateTime.utc(2026, 1, 4)),
    Listing(
      id: 'l4', kind: ListingKind.shop, ownerId: 'u4', villageId: 'v_kafr',
      categoryId: 'cat_pharm', name: 'صيدلية الشفاء', bio: 'أدوية ومستلزمات طبية — توصيل متاح',
      phoneWhatsapp: '+201000000004', status: ListingStatus.active, isVerified: true,
      isFeatured: true, createdAt: DateTime.utc(2026, 1, 5)),
    Listing(
      id: 'l5', kind: ListingKind.shop, ownerId: 'u5', villageId: 'v_kafr',
      categoryId: 'cat_groc', name: 'بقالة أبو أحمد', bio: 'كل لوازم البيت',
      phoneWhatsapp: '+201000000005', status: ListingStatus.active,
      createdAt: DateTime.utc(2026, 1, 6)),
    Listing(
      id: 'l6', kind: ListingKind.transport, ownerId: 'u6', villageId: 'v_kafr',
      categoryId: 'cat_tuktuk', name: 'توك توك الصاوي', bio: 'نقل داخل القرية والعزب المجاورة',
      phoneWhatsapp: '+201000000006', status: ListingStatus.active,
      createdAt: DateTime.utc(2026, 1, 7)),
    Listing(
      id: 'l7', kind: ListingKind.shop, ownerId: 'u7', villageId: 'v_tahna',
      categoryId: 'cat_groc', name: 'سوبر ماركت تفهنا', bio: 'بقالة وخضار وفاكهة',
      phoneWhatsapp: '+201000000007', status: ListingStatus.active, isVerified: true,
      createdAt: DateTime.utc(2026, 1, 8)),
    Listing(
      id: 'l8', kind: ListingKind.service, ownerId: 'u8', villageId: 'v_tahna',
      categoryId: 'cat_plumb', name: 'سباك تفهنا', bio: 'صيانة سريعة',
      phoneWhatsapp: '+201000000008', status: ListingStatus.active,
      createdAt: DateTime.utc(2026, 1, 9)),
  ];
}
```

- [ ] **Step 2: Analyze + commit**

Run: `flutter analyze`
Expected: no new issues.
```bash
git add lib/data/repositories/mock/mock_data.dart
git commit -m "feat(mobile): add realistic mock data (Kafr El-Maqdam / Tahna)"
```

---

## Task 6: Mock repositories

**Files:**
- Create: `lib/data/repositories/mock/mock_listing_repository.dart`, `mock_village_repository.dart`, `mock_category_repository.dart`
- Test: `test/data/repositories/mock_listing_repository_test.dart`

- [ ] **Step 1: Write the failing test**

`test/data/repositories/mock_listing_repository_test.dart`:
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:wasalni/core/network/repository_exception.dart';
import 'package:wasalni/data/models/enums.dart';
import 'package:wasalni/data/repositories/mock/mock_listing_repository.dart';

void main() {
  test('getFeed returns only active listings for the village', () async {
    final repo = MockListingRepository();
    final result = await repo.getFeed(villageId: 'v_kafr');
    expect(result, isNotEmpty);
    expect(result.every((l) => l.villageId == 'v_kafr'), true);
    expect(result.every((l) => l.status == ListingStatus.active), true);
  });

  test('getFeed filters by kind', () async {
    final repo = MockListingRepository();
    final result = await repo.getFeed(villageId: 'v_kafr', kind: ListingKind.shop);
    expect(result.every((l) => l.kind == ListingKind.shop), true);
  });

  test('getById throws NotFoundException for unknown id', () async {
    final repo = MockListingRepository();
    expect(() => repo.getById('nope'), throwsA(isA<NotFoundException>()));
  });
}
```

- [ ] **Step 2: Run to verify it fails**

Run: `flutter test test/data/repositories/mock_listing_repository_test.dart`
Expected: FAIL — `mock_listing_repository.dart` does not exist.

- [ ] **Step 3: Implement the mock listing repository**

`lib/data/repositories/mock/mock_listing_repository.dart`:
```dart
import '../../../core/network/repository_exception.dart';
import '../../models/enums.dart';
import '../../models/listing.dart';
import '../listing_repository.dart';
import 'mock_data.dart';

class MockListingRepository implements ListingRepository {
  MockListingRepository({this.latency = const Duration(milliseconds: 400)});

  final Duration latency;

  @override
  Future<List<Listing>> getFeed({required String villageId, ListingKind? kind}) async {
    await Future<void>.delayed(latency);
    final items = MockData.listings.where((l) =>
        l.villageId == villageId &&
        l.status == ListingStatus.active &&
        (kind == null || l.kind == kind)).toList();
    // Featured first, then newest.
    items.sort((a, b) {
      if (a.isFeatured != b.isFeatured) return a.isFeatured ? -1 : 1;
      return b.createdAt.compareTo(a.createdAt);
    });
    return items;
  }

  @override
  Future<Listing> getById(String id) async {
    await Future<void>.delayed(latency);
    final match = MockData.listings.where((l) => l.id == id);
    if (match.isEmpty) throw const NotFoundException();
    return match.first;
  }
}
```

- [ ] **Step 4: Implement village + category mocks**

`lib/data/repositories/mock/mock_village_repository.dart`:
```dart
import '../../models/village.dart';
import '../village_repository.dart';
import 'mock_data.dart';

class MockVillageRepository implements VillageRepository {
  MockVillageRepository({this.latency = const Duration(milliseconds: 200)});
  final Duration latency;

  @override
  Future<List<Village>> getVillages() async {
    await Future<void>.delayed(latency);
    return MockData.villages;
  }
}
```

`lib/data/repositories/mock/mock_category_repository.dart`:
```dart
import '../../models/category.dart';
import '../../models/enums.dart';
import '../category_repository.dart';
import 'mock_data.dart';

class MockCategoryRepository implements CategoryRepository {
  MockCategoryRepository({this.latency = const Duration(milliseconds: 200)});
  final Duration latency;

  @override
  Future<List<Category>> getCategories({ListingKind? kind}) async {
    await Future<void>.delayed(latency);
    final items = MockData.categories.where((c) => kind == null || c.kind == kind).toList();
    items.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    return items;
  }
}
```

- [ ] **Step 5: Run the test to verify it passes**

Run: `flutter test test/data/repositories/mock_listing_repository_test.dart`
Expected: PASS (3 tests).

- [ ] **Step 6: Commit**

```bash
git add lib/data/repositories/mock test/data/repositories
git commit -m "feat(mobile): add mock repositories with simulated latency"
```

---

## Task 7: Dependency injection (get_it)

**Files:**
- Create: `lib/app/di.dart`

- [ ] **Step 1: Create the DI setup**

`lib/app/di.dart`:
```dart
import 'package:get_it/get_it.dart';
import '../core/connectivity/connectivity_service.dart';
import '../data/repositories/category_repository.dart';
import '../data/repositories/listing_repository.dart';
import '../data/repositories/village_repository.dart';
import '../data/repositories/mock/mock_category_repository.dart';
import '../data/repositories/mock/mock_listing_repository.dart';
import '../data/repositories/mock/mock_village_repository.dart';

final getIt = GetIt.instance;

/// Registers repositories + services. SWAP POINT: replace the Mock*
/// implementations with Supabase* here when the backend is ready.
void setupDi() {
  getIt
    ..registerLazySingleton<ListingRepository>(MockListingRepository.new)
    ..registerLazySingleton<VillageRepository>(MockVillageRepository.new)
    ..registerLazySingleton<CategoryRepository>(MockCategoryRepository.new)
    ..registerLazySingleton<ConnectivityService>(ConnectivityServiceImpl.new);
}
```

> NOTE: `ConnectivityService` / `ConnectivityServiceImpl` are created in Task 8. This file will not compile until Task 8 is done — that is expected; do Task 8 next, then analyze.

- [ ] **Step 2: Commit (after Task 8 compiles)**

Defer the commit for this file to Task 8 Step 6.

---

## Task 8: Connectivity service + cubit

**Files:**
- Create: `lib/core/connectivity/connectivity_service.dart`, `connectivity_cubit.dart`
- Test: `test/core/connectivity/connectivity_cubit_test.dart`

- [ ] **Step 1: Write the failing cubit test**

`test/core/connectivity/connectivity_cubit_test.dart`:
```dart
import 'dart:async';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wasalni/core/connectivity/connectivity_cubit.dart';
import 'package:wasalni/core/connectivity/connectivity_service.dart';

class FakeConnectivityService implements ConnectivityService {
  final _controller = StreamController<bool>.broadcast();
  bool online = true;
  void emit(bool value) => _controller.add(value);
  @override
  Stream<bool> get onStatusChange => _controller.stream;
  @override
  Future<bool> isOnline() async => online;
}

void main() {
  blocTest<ConnectivityCubit, ConnectivityStatus>(
    'emits offline then online as the service stream changes',
    build: () => ConnectivityCubit(FakeConnectivityService()..online = true),
    act: (cubit) async {
      final svc = cubit.service as FakeConnectivityService;
      await cubit.init();
      svc.emit(false);
      svc.emit(true);
    },
    expect: () => [
      ConnectivityStatus.online,
      ConnectivityStatus.offline,
      ConnectivityStatus.online,
    ],
  );
}
```

- [ ] **Step 2: Run to verify it fails**

Run: `flutter test test/core/connectivity/connectivity_cubit_test.dart`
Expected: FAIL — files do not exist.

- [ ] **Step 3: Create the connectivity service (interface + real impl)**

`lib/core/connectivity/connectivity_service.dart`:
```dart
import 'package:connectivity_plus/connectivity_plus.dart';

abstract interface class ConnectivityService {
  Stream<bool> get onStatusChange;
  Future<bool> isOnline();
}

class ConnectivityServiceImpl implements ConnectivityService {
  ConnectivityServiceImpl([Connectivity? connectivity])
      : _connectivity = connectivity ?? Connectivity();
  final Connectivity _connectivity;

  bool _isOnline(List<ConnectivityResult> r) =>
      r.isNotEmpty && !(r.length == 1 && r.first == ConnectivityResult.none);

  @override
  Stream<bool> get onStatusChange =>
      _connectivity.onConnectivityChanged.map(_isOnline);

  @override
  Future<bool> isOnline() async => _isOnline(await _connectivity.checkConnectivity());
}
```

- [ ] **Step 4: Create the cubit**

`lib/core/connectivity/connectivity_cubit.dart`:
```dart
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'connectivity_service.dart';

enum ConnectivityStatus { online, offline }

class ConnectivityCubit extends Cubit<ConnectivityStatus> {
  ConnectivityCubit(this.service) : super(ConnectivityStatus.online);

  final ConnectivityService service;
  StreamSubscription<bool>? _sub;

  Future<void> init() async {
    bool online;
    try {
      online = await service.isOnline();
    } catch (_) {
      online = true; // if the platform check fails, assume online (don't block the app)
    }
    emit(online ? ConnectivityStatus.online : ConnectivityStatus.offline);
    _sub = service.onStatusChange.listen(
      (online) => emit(online ? ConnectivityStatus.online : ConnectivityStatus.offline),
    );
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
```

- [ ] **Step 5: Run the test to verify it passes**

Run: `flutter test test/core/connectivity/connectivity_cubit_test.dart`
Expected: PASS.

- [ ] **Step 6: Analyze whole project + commit (incl. di.dart from Task 7)**

Run: `flutter analyze`
Expected: no new issues (di.dart now compiles).
```bash
git add lib/core/connectivity lib/app/di.dart test/core/connectivity
git commit -m "feat(mobile): add connectivity service + cubit and DI wiring"
```

---

## Task 9: Shared state widgets

**Files:**
- Create: `lib/core/widgets/loading_view.dart`, `empty_view.dart`, `error_view.dart`, `offline_banner.dart`
- Test: `test/core/widgets/state_widgets_test.dart`

- [ ] **Step 1: Write the failing widget test**

`test/core/widgets/state_widgets_test.dart`:
```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wasalni/core/widgets/empty_view.dart';
import 'package:wasalni/core/widgets/error_view.dart';

Widget _wrap(Widget child) => MaterialApp(
      locale: const Locale('ar', 'EG'),
      home: Directionality(textDirection: TextDirection.rtl, child: Scaffold(body: child)),
    );

void main() {
  testWidgets('EmptyView shows its message', (tester) async {
    await tester.pumpWidget(_wrap(const EmptyView(message: 'مفيش نتايج')));
    expect(find.text('مفيش نتايج'), findsOneWidget);
  });

  testWidgets('ErrorView shows message and fires onRetry', (tester) async {
    var tapped = false;
    await tester.pumpWidget(_wrap(ErrorView(message: 'حصل خطأ', onRetry: () => tapped = true)));
    expect(find.text('حصل خطأ'), findsOneWidget);
    await tester.tap(find.text('حاول تاني'));
    expect(tapped, true);
  });
}
```

- [ ] **Step 2: Run to verify it fails**

Run: `flutter test test/core/widgets/state_widgets_test.dart`
Expected: FAIL — widget files do not exist.

- [ ] **Step 3: Create LoadingView**

`lib/core/widgets/loading_view.dart`:
```dart
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({super.key});
  @override
  Widget build(BuildContext context) =>
      const Center(child: CircularProgressIndicator(color: AppColors.primary));
}
```

- [ ] **Step 4: Create EmptyView**

`lib/core/widgets/empty_view.dart`:
```dart
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

class EmptyView extends StatelessWidget {
  const EmptyView({super.key, required this.message, this.icon = Icons.inbox_outlined});
  final String message;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 64, color: AppColors.textMuted),
            const SizedBox(height: AppSpacing.md),
            Text(message, style: AppTextStyles.body, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
```

- [ ] **Step 5: Create ErrorView**

`lib/core/widgets/error_view.dart`:
```dart
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

class ErrorView extends StatelessWidget {
  const ErrorView({super.key, required this.message, this.onRetry, this.isOffline = false});
  final String message;
  final VoidCallback? onRetry;
  final bool isOffline;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(isOffline ? Icons.wifi_off_rounded : Icons.error_outline_rounded,
                size: 64, color: AppColors.accent),
            const SizedBox(height: AppSpacing.md),
            Text(message, style: AppTextStyles.body, textAlign: TextAlign.center),
            if (onRetry != null) ...[
              const SizedBox(height: AppSpacing.lg),
              FilledButton(onPressed: onRetry, child: const Text('حاول تاني')),
            ],
          ],
        ),
      ),
    );
  }
}
```

- [ ] **Step 6: Create OfflineBanner**

`lib/core/widgets/offline_banner.dart`:
```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../connectivity/connectivity_cubit.dart';
import '../theme/app_spacing.dart';

class OfflineBanner extends StatelessWidget {
  const OfflineBanner({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectivityCubit, ConnectivityStatus>(
      builder: (context, status) {
        if (status == ConnectivityStatus.online) return const SizedBox.shrink();
        return Material(
          color: Colors.black87,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm, horizontal: AppSpacing.lg),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.wifi_off_rounded, color: Colors.white, size: 18),
                SizedBox(width: AppSpacing.sm),
                Text('مفيش اتصال بالإنترنت',
                    style: TextStyle(fontFamily: 'Cairo', color: Colors.white, fontSize: 14)),
              ],
            ),
          ),
        );
      },
    );
  }
}
```

- [ ] **Step 7: Run the test to verify it passes**

Run: `flutter test test/core/widgets/state_widgets_test.dart`
Expected: PASS (2 tests).

- [ ] **Step 8: Commit**

```bash
git add lib/core/widgets test/core/widgets
git commit -m "feat(mobile): add shared state widgets (loading/empty/error/offline)"
```

---

## Task 10: Navigation shell + app boot

**Files:**
- Create: `lib/features/shell/scaffold_with_nav_bar.dart`
- Create: `lib/features/categories/categories_placeholder.dart`, `favorites/favorites_placeholder.dart`, `account/account_placeholder.dart`
- Create: `lib/app/router.dart`, `lib/app/app.dart`
- Modify: `lib/main.dart`
- Test: `test/app/app_boot_test.dart`

> NOTE: Task 13 replaces the feed branch's placeholder with the real `FeedScreen`. For now the feed tab uses a temporary placeholder so the app boots.

- [ ] **Step 1: Write the failing boot test**

`test/app/app_boot_test.dart`:
```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wasalni/app/app.dart';
import 'package:wasalni/app/di.dart';
import 'package:wasalni/core/connectivity/connectivity_service.dart';

// Widget tests have no platform plugins, so override connectivity with a fake.
class _FakeConn implements ConnectivityService {
  @override
  Stream<bool> get onStatusChange => Stream<bool>.empty();
  @override
  Future<bool> isOnline() async => true;
}

void main() {
  setUp(() async {
    await getIt.reset();
    setupDi();
    getIt.unregister<ConnectivityService>();
    getIt.registerLazySingleton<ConnectivityService>(_FakeConn.new);
  });

  testWidgets('App boots, shows RTL home, and switches tabs', (tester) async {
    await tester.pumpWidget(const App());
    await tester.pumpAndSettle();

    // Home tab title visible.
    expect(find.text('وصلني'), findsWidgets);
    // Bottom nav has 4 destinations.
    expect(find.byType(NavigationBar), findsOneWidget);

    // Tap "حسابي" tab → its placeholder shows.
    await tester.tap(find.text('حسابي'));
    await tester.pumpAndSettle();
    expect(find.text('حسابي — قريباً'), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run to verify it fails**

Run: `flutter test test/app/app_boot_test.dart`
Expected: FAIL — `app.dart` / `di.dart`-wired widgets do not exist.

- [ ] **Step 3: Create the three placeholder tabs**

`lib/features/categories/categories_placeholder.dart`:
```dart
import 'package:flutter/material.dart';

class CategoriesPlaceholder extends StatelessWidget {
  const CategoriesPlaceholder({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(
        body: Center(child: Text('التصنيفات — قريباً', style: TextStyle(fontFamily: 'Cairo'))),
      );
}
```

`lib/features/favorites/favorites_placeholder.dart`:
```dart
import 'package:flutter/material.dart';

class FavoritesPlaceholder extends StatelessWidget {
  const FavoritesPlaceholder({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(
        body: Center(child: Text('المفضلة — قريباً', style: TextStyle(fontFamily: 'Cairo'))),
      );
}
```

`lib/features/account/account_placeholder.dart`:
```dart
import 'package:flutter/material.dart';

class AccountPlaceholder extends StatelessWidget {
  const AccountPlaceholder({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(
        body: Center(child: Text('حسابي — قريباً', style: TextStyle(fontFamily: 'Cairo'))),
      );
}
```

- [ ] **Step 4: Create a temporary feed placeholder**

`lib/features/feed/view/feed_screen.dart` (TEMPORARY — fully replaced in Task 13):
```dart
import 'package:flutter/material.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('وصلني')),
        body: const Center(child: Text('الرئيسية', style: TextStyle(fontFamily: 'Cairo'))),
      );
}
```

- [ ] **Step 5: Create the bottom-nav shell**

`lib/features/shell/scaffold_with_nav_bar.dart`:
```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/widgets/offline_banner.dart';

class ScaffoldWithNavBar extends StatelessWidget {
  const ScaffoldWithNavBar({super.key, required this.navigationShell});
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const OfflineBanner(),
          Expanded(child: navigationShell),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'الرئيسية'),
          NavigationDestination(icon: Icon(Icons.grid_view_outlined), selectedIcon: Icon(Icons.grid_view), label: 'التصنيفات'),
          NavigationDestination(icon: Icon(Icons.favorite_outline), selectedIcon: Icon(Icons.favorite), label: 'المفضلة'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'حسابي'),
        ],
      ),
    );
  }
}
```

- [ ] **Step 6: Create the router**

`lib/app/router.dart`:
```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/account/account_placeholder.dart';
import '../features/categories/categories_placeholder.dart';
import '../features/favorites/favorites_placeholder.dart';
import '../features/feed/view/feed_screen.dart';
import '../features/shell/scaffold_with_nav_bar.dart';

GoRouter createRouter() {
  return GoRouter(
    initialLocation: '/feed',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            ScaffoldWithNavBar(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(path: '/feed', builder: (_, __) => const FeedScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/categories', builder: (_, __) => const CategoriesPlaceholder()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/favorites', builder: (_, __) => const FavoritesPlaceholder()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/account', builder: (_, __) => const AccountPlaceholder()),
          ]),
        ],
      ),
    ],
  );
}
```

- [ ] **Step 7: Create the App widget**

`lib/app/app.dart`:
```dart
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../core/connectivity/connectivity_cubit.dart';
import '../core/connectivity/connectivity_service.dart';
import '../core/theme/app_theme.dart';
import 'di.dart';
import 'router.dart';

class App extends StatefulWidget {
  const App({super.key});
  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final _router = createRouter();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ConnectivityCubit(getIt<ConnectivityService>())..init(),
      child: MaterialApp.router(
        title: 'وصلني',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        routerConfig: _router,
        locale: const Locale('ar', 'EG'),
        supportedLocales: const [Locale('ar', 'EG')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        builder: (context, child) =>
            Directionality(textDirection: TextDirection.rtl, child: child!),
      ),
    );
  }
}
```

- [ ] **Step 8: Rewrite main.dart**

`lib/main.dart` (replace entire file):
```dart
import 'package:flutter/material.dart';
import 'app/app.dart';
import 'app/di.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupDi();
  runApp(const App());
}
```

- [ ] **Step 9: Run the boot test to verify it passes**

Run: `flutter test test/app/app_boot_test.dart`
Expected: PASS.

- [ ] **Step 10: Full analyze + commit**

Run: `flutter analyze`
Expected: `No issues found!`
```bash
git add lib/app lib/features lib/main.dart test/app
git commit -m "feat(mobile): add go_router shell, 4-tab nav, app boot + RTL"
```

---

# PHASE 2 — FEED VERTICAL SLICE

## Task 11: FeedBloc

**Files:**
- Create: `lib/features/feed/bloc/feed_event.dart`, `feed_state.dart`, `feed_bloc.dart`
- Test: `test/features/feed/feed_bloc_test.dart`

- [ ] **Step 1: Write the failing bloc test**

`test/features/feed/feed_bloc_test.dart`:
```dart
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wasalni/core/network/repository_exception.dart';
import 'package:wasalni/data/models/enums.dart';
import 'package:wasalni/data/models/listing.dart';
import 'package:wasalni/data/repositories/listing_repository.dart';
import 'package:wasalni/features/feed/bloc/feed_bloc.dart';
import 'package:wasalni/features/feed/bloc/feed_event.dart';
import 'package:wasalni/features/feed/bloc/feed_state.dart';

class MockListingRepo extends Mock implements ListingRepository {}

Listing _listing(String id) => Listing(
      id: id, kind: ListingKind.service, ownerId: 'o', villageId: 'v_kafr',
      categoryId: 'c', name: 'اسم $id', bio: 'وصف', phoneWhatsapp: '+201000000000',
      createdAt: DateTime.utc(2026, 1, 1));

void main() {
  late MockListingRepo repo;
  setUp(() => repo = MockListingRepo());

  blocTest<FeedBloc, FeedState>(
    'emits [loading, loaded] when repo returns listings',
    build: () {
      when(() => repo.getFeed(villageId: any(named: 'villageId'), kind: any(named: 'kind')))
          .thenAnswer((_) async => [_listing('l1'), _listing('l2')]);
      return FeedBloc(repo);
    },
    act: (bloc) => bloc.add(const FeedRequested(villageId: 'v_kafr')),
    expect: () => [
      const FeedState.loading(),
      isA<FeedLoaded>().having((s) => s.listings.length, 'count', 2),
    ],
  );

  blocTest<FeedBloc, FeedState>(
    'emits [loading, empty] when repo returns nothing',
    build: () {
      when(() => repo.getFeed(villageId: any(named: 'villageId'), kind: any(named: 'kind')))
          .thenAnswer((_) async => []);
      return FeedBloc(repo);
    },
    act: (bloc) => bloc.add(const FeedRequested(villageId: 'v_kafr')),
    expect: () => [const FeedState.loading(), const FeedState.empty()],
  );

  blocTest<FeedBloc, FeedState>(
    'emits [loading, noConnection] on NoConnectionException',
    build: () {
      when(() => repo.getFeed(villageId: any(named: 'villageId'), kind: any(named: 'kind')))
          .thenThrow(const NoConnectionException());
      return FeedBloc(repo);
    },
    act: (bloc) => bloc.add(const FeedRequested(villageId: 'v_kafr')),
    expect: () => [const FeedState.loading(), const FeedState.noConnection()],
  );
}
```

- [ ] **Step 2: Run to verify it fails**

Run: `flutter test test/features/feed/feed_bloc_test.dart`
Expected: FAIL — bloc files do not exist.

- [ ] **Step 3: Create the events**

`lib/features/feed/bloc/feed_event.dart`:
```dart
import '../../../data/models/enums.dart';

// Events don't need value-equality for bloc routing, so no Equatable dependency.
sealed class FeedEvent {
  const FeedEvent();
}

class FeedRequested extends FeedEvent {
  const FeedRequested({required this.villageId, this.kind});
  final String villageId;
  final ListingKind? kind;
}

class FeedRefreshed extends FeedEvent {
  const FeedRefreshed();
}
```

- [ ] **Step 4: Create the state (freezed sealed)**

`lib/features/feed/bloc/feed_state.dart`:
```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../data/models/enums.dart';
import '../../../data/models/listing.dart';

part 'feed_state.freezed.dart';

@freezed
sealed class FeedState with _$FeedState {
  const factory FeedState.loading() = FeedLoading;
  const factory FeedState.loaded(List<Listing> listings, {String? villageId, ListingKind? kind}) = FeedLoaded;
  const factory FeedState.empty() = FeedEmpty;
  const factory FeedState.noConnection() = FeedNoConnection;
  const factory FeedState.error(String message) = FeedError;
}
```

- [ ] **Step 5: Create the bloc**

`lib/features/feed/bloc/feed_bloc.dart`:
```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/network/repository_exception.dart';
import '../../../data/models/enums.dart';
import '../../../data/repositories/listing_repository.dart';
import 'feed_event.dart';
import 'feed_state.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  FeedBloc(this._repo) : super(const FeedState.loading()) {
    on<FeedRequested>(_onRequested);
    on<FeedRefreshed>(_onRefreshed);
  }

  final ListingRepository _repo;
  String? _villageId;
  ListingKind? _kind;

  Future<void> _onRequested(FeedRequested e, Emitter<FeedState> emit) async {
    _villageId = e.villageId;
    _kind = e.kind;
    await _load(emit);
  }

  Future<void> _onRefreshed(FeedRefreshed e, Emitter<FeedState> emit) async {
    if (_villageId != null) await _load(emit);
  }

  Future<void> _load(Emitter<FeedState> emit) async {
    emit(const FeedState.loading());
    try {
      final items = await _repo.getFeed(villageId: _villageId!, kind: _kind);
      emit(items.isEmpty
          ? const FeedState.empty()
          : FeedState.loaded(items, villageId: _villageId, kind: _kind));
    } on NoConnectionException {
      emit(const FeedState.noConnection());
    } on RepositoryException catch (e) {
      emit(FeedState.error(e.message ?? 'حصل خطأ'));
    }
  }
}
```

- [ ] **Step 6: Generate freezed + run the test**

Run:
```bash
dart run build_runner build --force-jit --delete-conflicting-outputs
flutter test test/features/feed/feed_bloc_test.dart
```
Expected: codegen succeeds; 3 tests PASS. (`--force-jit` is required on this machine — see Task 3.)

- [ ] **Step 7: Commit**

```bash
git add lib/features/feed/bloc test/features/feed/feed_bloc_test.dart
git commit -m "feat(mobile): add FeedBloc with loading/loaded/empty/offline/error states"
```

---

## Task 12: ListingCard widget

**Files:**
- Create: `lib/features/feed/widgets/listing_card.dart`
- Test: `test/features/feed/listing_card_test.dart`

- [ ] **Step 1: Write the failing widget test**

`test/features/feed/listing_card_test.dart`:
```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wasalni/data/models/enums.dart';
import 'package:wasalni/data/models/listing.dart';
import 'package:wasalni/features/feed/widgets/listing_card.dart';

Listing _verified() => Listing(
      id: 'l1', kind: ListingKind.service, ownerId: 'o', villageId: 'v', categoryId: 'c',
      name: 'سباك الأسطى', bio: 'وصف', phoneWhatsapp: '+201000000000',
      isVerified: true, createdAt: DateTime.utc(2026, 1, 1));

void main() {
  testWidgets('ListingCard shows name and verified badge', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(body: ListingCard(listing: _verified(), onTap: () {})),
      ),
    ));
    expect(find.text('سباك الأسطى'), findsOneWidget);
    expect(find.byIcon(Icons.verified), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run to verify it fails**

Run: `flutter test test/features/feed/listing_card_test.dart`
Expected: FAIL — `listing_card.dart` does not exist.

- [ ] **Step 3: Implement the card**

`lib/features/feed/widgets/listing_card.dart`:
```dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/listing.dart';

class ListingCard extends StatelessWidget {
  const ListingCard({super.key, required this.listing, required this.onTap});
  final Listing listing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 16 / 10,
              child: _Image(url: listing.logoUrl),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(listing.name,
                            style: AppTextStyles.label,
                            maxLines: 1, overflow: TextOverflow.ellipsis),
                      ),
                      if (listing.isVerified)
                        const Padding(
                          padding: EdgeInsetsDirectional.only(start: AppSpacing.xs),
                          child: Icon(Icons.verified, size: 16, color: AppColors.verified),
                        ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(listing.bio,
                      style: AppTextStyles.caption,
                      maxLines: 2, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Image extends StatelessWidget {
  const _Image({this.url});
  final String? url;
  @override
  Widget build(BuildContext context) {
    final placeholder = Container(
      color: AppColors.border,
      child: const Icon(Icons.storefront, size: 40, color: AppColors.textMuted),
    );
    if (url == null || url!.isEmpty) return placeholder;
    return CachedNetworkImage(
      imageUrl: url!,
      fit: BoxFit.cover,
      placeholder: (_, __) => placeholder,
      errorWidget: (_, __, ___) => placeholder,
    );
  }
}
```

- [ ] **Step 4: Run the test to verify it passes**

Run: `flutter test test/features/feed/listing_card_test.dart`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add lib/features/feed/widgets test/features/feed/listing_card_test.dart
git commit -m "feat(mobile): add ListingCard with verified badge + image fallback"
```

---

## Task 13: FeedScreen (real) + village filter + states

**Files:**
- Replace: `lib/features/feed/view/feed_screen.dart` (the temporary one from Task 10)
- Test: `test/features/feed/feed_screen_test.dart`

- [ ] **Step 1: Write the failing screen test**

`test/features/feed/feed_screen_test.dart`:
```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wasalni/data/repositories/listing_repository.dart';
import 'package:wasalni/data/repositories/village_repository.dart';
import 'package:wasalni/data/repositories/mock/mock_listing_repository.dart';
import 'package:wasalni/data/repositories/mock/mock_village_repository.dart';
import 'package:wasalni/features/feed/bloc/feed_bloc.dart';
import 'package:wasalni/features/feed/bloc/feed_event.dart';
import 'package:wasalni/features/feed/view/feed_screen.dart';

void main() {
  testWidgets('FeedScreen renders listings from the mock repo', (tester) async {
    final ListingRepository listingRepo = MockListingRepository(latency: Duration.zero);
    final VillageRepository villageRepo = MockVillageRepository(latency: Duration.zero);

    await tester.pumpWidget(MaterialApp(
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: BlocProvider(
          create: (_) => FeedBloc(listingRepo)..add(const FeedRequested(villageId: 'v_kafr')),
          child: FeedScreen(villageRepository: villageRepo),
        ),
      ),
    ));
    await tester.pumpAndSettle();

    expect(find.text('سباك الأسطى محمود'), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run to verify it fails**

Run: `flutter test test/features/feed/feed_screen_test.dart`
Expected: FAIL — `FeedScreen` does not accept `villageRepository` / renders placeholder.

- [ ] **Step 3: Implement the real FeedScreen**

`lib/features/feed/view/feed_screen.dart` (replace entire file):
```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/empty_view.dart';
import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/loading_view.dart';
import '../../../data/models/village.dart';
import '../../../data/repositories/village_repository.dart';
import '../bloc/feed_bloc.dart';
import '../bloc/feed_event.dart';
import '../bloc/feed_state.dart';
import '../widgets/listing_card.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key, required this.villageRepository});
  final VillageRepository villageRepository;

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  List<Village> _villages = const [];
  String _selectedVillageId = 'v_kafr';

  @override
  void initState() {
    super.initState();
    _loadVillages();
  }

  Future<void> _loadVillages() async {
    final villages = await widget.villageRepository.getVillages();
    if (!mounted) return;
    setState(() {
      _villages = villages;
      if (villages.isNotEmpty) _selectedVillageId = villages.first.id;
    });
  }

  void _selectVillage(String id) {
    setState(() => _selectedVillageId = id);
    context.read<FeedBloc>().add(FeedRequested(villageId: id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('وصلني')),
      body: Column(
        children: [
          if (_villages.isNotEmpty) _VillageFilter(
            villages: _villages,
            selectedId: _selectedVillageId,
            onSelected: _selectVillage,
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async => context.read<FeedBloc>().add(const FeedRefreshed()),
              child: BlocBuilder<FeedBloc, FeedState>(
                builder: (context, state) => switch (state) {
                  FeedLoading() => const LoadingView(),
                  FeedEmpty() => const EmptyView(message: 'مفيش نشاطات في القرية دي لسه'),
                  FeedNoConnection() => ErrorView(
                      message: 'مفيش اتصال بالإنترنت',
                      isOffline: true,
                      onRetry: () => context.read<FeedBloc>().add(const FeedRefreshed()),
                    ),
                  FeedError(:final message) => ErrorView(
                      message: message,
                      onRetry: () => context.read<FeedBloc>().add(const FeedRefreshed()),
                    ),
                  FeedLoaded(:final listings) => GridView.builder(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: AppSpacing.md,
                        mainAxisSpacing: AppSpacing.md,
                        childAspectRatio: 0.72,
                      ),
                      itemCount: listings.length,
                      itemBuilder: (_, i) => ListingCard(listing: listings[i], onTap: () {}),
                    ),
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VillageFilter extends StatelessWidget {
  const _VillageFilter({required this.villages, required this.selectedId, required this.onSelected});
  final List<Village> villages;
  final String selectedId;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        itemCount: villages.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (_, i) {
          final v = villages[i];
          return ChoiceChip(
            label: Text(v.name),
            selected: v.id == selectedId,
            onSelected: (_) => onSelected(v.id),
          );
        },
      ),
    );
  }
}
```

- [ ] **Step 4: Run the screen test to verify it passes**

Run: `flutter test test/features/feed/feed_screen_test.dart`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add lib/features/feed/view test/features/feed/feed_screen_test.dart
git commit -m "feat(mobile): implement Feed screen (grid + village filter + states)"
```

---

## Task 14: Wire FeedScreen into the shell + manual verification

**Files:**
- Modify: `lib/app/router.dart` (feed branch)

- [ ] **Step 1: Inject repositories into the feed route**

In `lib/app/router.dart`, update the imports and the feed branch to provide the bloc + village repo from `get_it`:

Add imports at top:
```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../app/di.dart';
import '../data/repositories/listing_repository.dart';
import '../data/repositories/village_repository.dart';
import '../features/feed/bloc/feed_bloc.dart';
import '../features/feed/bloc/feed_event.dart';
```

Replace the feed `GoRoute` builder with:
```dart
GoRoute(
  path: '/feed',
  builder: (_, __) => BlocProvider(
    create: (_) => FeedBloc(getIt<ListingRepository>())
      ..add(const FeedRequested(villageId: 'v_kafr')),
    child: FeedScreen(villageRepository: getIt<VillageRepository>()),
  ),
),
```

- [ ] **Step 2: Full analyze + full test suite**

Run:
```bash
flutter analyze
flutter test
```
Expected: `No issues found!` and ALL tests pass (models, mock repo, connectivity, widgets, app boot, feed bloc, listing card, feed screen).

- [ ] **Step 3: Manual run + visual check**

Run: `flutter run` (on an emulator or device).
Verify:
- App opens RTL on the Feed tab with the WASALNI petrol app bar.
- Feed shows a 2-column grid of Kafr El-Maqdam listings; featured/verified ones first; verified badge visible.
- Village filter chips switch between كفر المقدام / تفهنا الأشراف and the grid reloads.
- Pull-to-refresh works.
- Bottom nav switches between the 4 tabs.
- (Optional) Toggle airplane mode → the offline banner appears at the top.

- [ ] **Step 4: Commit**

```bash
git add lib/app/router.dart
git commit -m "feat(mobile): wire Feed into shell with DI-provided repositories"
```

---

## Done — Definition of Complete

- `flutter analyze` clean; `flutter test` all green.
- App boots RTL, 4-tab shell, Feed renders realistic mock data with featured/verified ordering, village filter, pull-to-refresh, all states (loading/empty/offline/error) reachable.
- Architecture pattern proven: UI → FeedBloc → ListingRepository(interface) → Mock impl, swappable via `di.dart`.

**Next plans (later):** Categories + Search (Phase 3a), Listing/Shop/Transport profiles + Product (3b), Soft Cart per-shop + WhatsApp handoff + outbox (3c), Auth/OTP + guest-merge (3d), Account + Registration + Verification + Subscription (3e), then polish (Phase 4).
