# WASALNI Frontend — Phase 3a: Categories Browse Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax.

**Goal:** Add category browsing — the Categories tab shows a grid of categories; tapping one opens a screen listing that category's active listings in the current village.

**Architecture:** Reuses the proven Feed pattern (UI → Bloc → Repository interface → Mock). Extends `ListingRepository.getFeed` with an optional `categoryId`; the category-listings screen reuses `FeedBloc`. A new `CategoriesBloc` loads the category list. Visual polish is deferred to Phase 4 — keep these screens functional.

**Tech Stack:** flutter_bloc, go_router, get_it, freezed (codegen with `--force-jit`), bloc_test, mocktail.

**Scope:** Categories browse only. Search is Phase 3b (next). Reference spec: `docs/superpowers/specs/2026-05-29-frontend-architecture-design.md`. Builds on the completed Foundation+Feed plan.

**Working directory:** `apps/mobile` (all paths relative to it). **build_runner MUST use `--force-jit`** (Dart 3.10).

---

## File Structure (this plan)

```
apps/mobile/lib/
  data/repositories/listing_repository.dart        # MODIFY: add categoryId to getFeed
  data/repositories/mock/mock_listing_repository.dart  # MODIFY: filter categoryId
  features/feed/bloc/feed_event.dart                # MODIFY: FeedRequested.categoryId
  features/feed/bloc/feed_bloc.dart                 # MODIFY: carry categoryId
  features/categories/bloc/categories_event.dart    # CREATE
  features/categories/bloc/categories_state.dart    # CREATE (freezed sealed)
  features/categories/bloc/categories_bloc.dart     # CREATE
  features/categories/widgets/category_tile.dart    # CREATE
  features/categories/view/categories_screen.dart   # CREATE (replaces placeholder)
  features/categories/view/category_listings_screen.dart  # CREATE
  app/router.dart                                   # MODIFY: categories branch + /category/:id
  (delete) features/categories/categories_placeholder.dart  # remove after wiring
apps/mobile/test/
  data/repositories/mock_listing_repository_test.dart  # MODIFY: categoryId test
  features/categories/categories_bloc_test.dart     # CREATE
  features/categories/categories_screen_test.dart   # CREATE
  features/categories/category_listings_screen_test.dart  # CREATE
```

---

## Task 1: Extend ListingRepository with categoryId filter

**Files:**
- Modify: `lib/data/repositories/listing_repository.dart`
- Modify: `lib/data/repositories/mock/mock_listing_repository.dart`
- Test: `test/data/repositories/mock_listing_repository_test.dart`

- [ ] **Step 1: Add a failing test for categoryId filtering**

Append this test inside the existing `main()` in `test/data/repositories/mock_listing_repository_test.dart` (after the existing `getFeed filters by kind` test):
```dart
  test('getFeed filters by categoryId', () async {
    final repo = MockListingRepository();
    final result = await repo.getFeed(villageId: 'v_kafr', categoryId: 'cat_plumb');
    expect(result, isNotEmpty);
    expect(result.every((l) => l.categoryId == 'cat_plumb'), true);
  });
```

- [ ] **Step 2: Run to verify it fails**

Run: `flutter test test/data/repositories/mock_listing_repository_test.dart`
Expected: FAIL — `getFeed` has no `categoryId` named parameter (compile error).

- [ ] **Step 3: Add `categoryId` to the interface**

In `lib/data/repositories/listing_repository.dart`, change the `getFeed` signature to:
```dart
  Future<List<Listing>> getFeed({
    required String villageId,
    ListingKind? kind,
    String? categoryId,
  });
```
(Leave `getById` unchanged.)

- [ ] **Step 4: Implement the filter in the mock**

In `lib/data/repositories/mock/mock_listing_repository.dart`, replace the `getFeed` method with:
```dart
  @override
  Future<List<Listing>> getFeed({
    required String villageId,
    ListingKind? kind,
    String? categoryId,
  }) async {
    await Future<void>.delayed(latency);
    final items = MockData.listings.where((l) =>
        l.villageId == villageId &&
        l.status == ListingStatus.active &&
        (kind == null || l.kind == kind) &&
        (categoryId == null || l.categoryId == categoryId)).toList();
    // Featured first, then newest.
    items.sort((a, b) {
      if (a.isFeatured != b.isFeatured) return a.isFeatured ? -1 : 1;
      return b.createdAt.compareTo(a.createdAt);
    });
    return items;
  }
```

- [ ] **Step 5: Run the test + full analyze**

Run: `flutter test test/data/repositories/mock_listing_repository_test.dart` → PASS (4 tests).
Run: `flutter analyze` → no issues.

- [ ] **Step 6: Commit**

```bash
git add lib/data/repositories/listing_repository.dart lib/data/repositories/mock/mock_listing_repository.dart test/data/repositories/mock_listing_repository_test.dart
git commit -m "feat(mobile): add categoryId filter to ListingRepository.getFeed"
```

---

## Task 2: Carry categoryId through FeedBloc

**Files:**
- Modify: `lib/features/feed/bloc/feed_event.dart`
- Modify: `lib/features/feed/bloc/feed_bloc.dart`

> No new test: the existing `feed_bloc_test.dart` keeps passing (categoryId defaults to null). This task just threads the param so the category-listings screen can reuse FeedBloc.

- [ ] **Step 1: Add `categoryId` to FeedRequested**

In `lib/features/feed/bloc/feed_event.dart`, replace the `FeedRequested` class with:
```dart
class FeedRequested extends FeedEvent {
  const FeedRequested({required this.villageId, this.kind, this.categoryId});
  final String villageId;
  final ListingKind? kind;
  final String? categoryId;
}
```

- [ ] **Step 2: Thread it through the bloc**

In `lib/features/feed/bloc/feed_bloc.dart`:
- Add a field: after `ListingKind? _kind;` add `String? _categoryId;`
- In `_onRequested`, after `_kind = e.kind;` add `_categoryId = e.categoryId;`
- In `_load`, change the repo call to:
```dart
      final items = await _repo.getFeed(
        villageId: _villageId!,
        kind: _kind,
        categoryId: _categoryId,
      );
```

- [ ] **Step 3: Run feed tests + analyze**

Run: `flutter test test/features/feed/` → all pass (existing bloc + screen tests still green).
Run: `flutter analyze` → no issues.

- [ ] **Step 4: Commit**

```bash
git add lib/features/feed/bloc/feed_event.dart lib/features/feed/bloc/feed_bloc.dart
git commit -m "feat(mobile): thread categoryId through FeedBloc"
```

---

## Task 3: CategoriesBloc

**Files:**
- Create: `lib/features/categories/bloc/categories_event.dart`, `categories_state.dart`, `categories_bloc.dart`
- Test: `test/features/categories/categories_bloc_test.dart`

- [ ] **Step 1: Write the failing bloc test**

`test/features/categories/categories_bloc_test.dart`:
```dart
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wasalni/core/network/repository_exception.dart';
import 'package:wasalni/data/models/category.dart';
import 'package:wasalni/data/models/enums.dart';
import 'package:wasalni/data/repositories/category_repository.dart';
import 'package:wasalni/features/categories/bloc/categories_bloc.dart';
import 'package:wasalni/features/categories/bloc/categories_event.dart';
import 'package:wasalni/features/categories/bloc/categories_state.dart';

class MockCategoryRepo extends Mock implements CategoryRepository {}

Category _cat(String id) => Category(
    id: id, name: 'فئة $id', slug: id, iconName: 'category', kind: ListingKind.service);

void main() {
  late MockCategoryRepo repo;
  setUp(() => repo = MockCategoryRepo());

  blocTest<CategoriesBloc, CategoriesState>(
    'emits [loading, loaded] with categories',
    build: () {
      when(() => repo.getCategories(kind: any(named: 'kind')))
          .thenAnswer((_) async => [_cat('a'), _cat('b')]);
      return CategoriesBloc(repo);
    },
    act: (bloc) => bloc.add(const CategoriesRequested()),
    expect: () => [
      const CategoriesState.loading(),
      isA<CategoriesLoaded>().having((s) => s.categories.length, 'count', 2),
    ],
  );

  blocTest<CategoriesBloc, CategoriesState>(
    'emits [loading, noConnection] on NoConnectionException',
    build: () {
      when(() => repo.getCategories(kind: any(named: 'kind')))
          .thenThrow(const NoConnectionException());
      return CategoriesBloc(repo);
    },
    act: (bloc) => bloc.add(const CategoriesRequested()),
    expect: () => [const CategoriesState.loading(), const CategoriesState.noConnection()],
  );
}
```

- [ ] **Step 2: Run to verify it fails**

Run: `flutter test test/features/categories/categories_bloc_test.dart` → FAIL (files missing).

- [ ] **Step 3: Create the event**

`lib/features/categories/bloc/categories_event.dart`:
```dart
sealed class CategoriesEvent {
  const CategoriesEvent();
}

class CategoriesRequested extends CategoriesEvent {
  const CategoriesRequested();
}
```

- [ ] **Step 4: Create the state (freezed sealed)**

`lib/features/categories/bloc/categories_state.dart`:
```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../data/models/category.dart';

part 'categories_state.freezed.dart';

@freezed
sealed class CategoriesState with _$CategoriesState {
  const factory CategoriesState.loading() = CategoriesLoading;
  const factory CategoriesState.loaded(List<Category> categories) = CategoriesLoaded;
  const factory CategoriesState.noConnection() = CategoriesNoConnection;
  const factory CategoriesState.error(String message) = CategoriesError;
}
```

- [ ] **Step 5: Create the bloc**

`lib/features/categories/bloc/categories_bloc.dart`:
```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/network/repository_exception.dart';
import '../../../data/repositories/category_repository.dart';
import 'categories_event.dart';
import 'categories_state.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  CategoriesBloc(this._repo) : super(const CategoriesState.loading()) {
    on<CategoriesRequested>(_onRequested);
  }

  final CategoryRepository _repo;

  Future<void> _onRequested(CategoriesRequested e, Emitter<CategoriesState> emit) async {
    emit(const CategoriesState.loading());
    try {
      final categories = await _repo.getCategories();
      emit(CategoriesState.loaded(categories));
    } on NoConnectionException {
      emit(const CategoriesState.noConnection());
    } on RepositoryException catch (e) {
      emit(CategoriesState.error(e.message ?? 'حصل خطأ'));
    }
  }
}
```

- [ ] **Step 6: Generate freezed + run the test**

```bash
dart run build_runner build --force-jit --delete-conflicting-outputs
flutter test test/features/categories/categories_bloc_test.dart
```
Expected: codegen ok; 2 tests PASS.

- [ ] **Step 7: Commit**

```bash
git add lib/features/categories/bloc test/features/categories/categories_bloc_test.dart
git commit -m "feat(mobile): add CategoriesBloc (loading/loaded/offline/error)"
```

---

## Task 4: Categories screen + tile (replaces placeholder)

**Files:**
- Create: `lib/features/categories/widgets/category_tile.dart`, `lib/features/categories/view/categories_screen.dart`
- Modify: `lib/app/router.dart` (categories branch → CategoriesScreen)
- Delete: `lib/features/categories/categories_placeholder.dart`
- Test: `test/features/categories/categories_screen_test.dart`

- [ ] **Step 1: Write the failing screen test**

`test/features/categories/categories_screen_test.dart`:
```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:wasalni/data/repositories/category_repository.dart';
import 'package:wasalni/data/repositories/mock/mock_category_repository.dart';
import 'package:wasalni/features/categories/bloc/categories_bloc.dart';
import 'package:wasalni/features/categories/bloc/categories_event.dart';
import 'package:wasalni/features/categories/view/categories_screen.dart';

void main() {
  testWidgets('CategoriesScreen renders category names', (tester) async {
    final CategoryRepository repo = MockCategoryRepository(latency: Duration.zero);
    final router = GoRouter(routes: [
      GoRoute(
        path: '/',
        builder: (_, __) => BlocProvider(
          create: (_) => CategoriesBloc(repo)..add(const CategoriesRequested()),
          child: const CategoriesScreen(),
        ),
      ),
    ]);
    await tester.pumpWidget(MaterialApp.router(
      routerConfig: router,
      builder: (context, child) =>
          Directionality(textDirection: TextDirection.rtl, child: child!),
    ));
    await tester.pumpAndSettle();

    expect(find.text('سباكة'), findsOneWidget);
    expect(find.text('صيدلية'), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run to verify it fails**

Run: `flutter test test/features/categories/categories_screen_test.dart` → FAIL (files missing).

- [ ] **Step 3: Create the category tile**

`lib/features/categories/widgets/category_tile.dart`:
```dart
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/category.dart';

const Map<String, IconData> _categoryIcons = {
  'plumbing': Icons.plumbing,
  'electrical_services': Icons.electrical_services,
  'carpenter': Icons.carpenter,
  'local_pharmacy': Icons.local_pharmacy,
  'storefront': Icons.storefront,
  'electric_rickshaw': Icons.electric_rickshaw,
};

IconData iconForCategory(String name) => _categoryIcons[name] ?? Icons.category_outlined;

class CategoryTile extends StatelessWidget {
  const CategoryTile({super.key, required this.category, required this.onTap});
  final Category category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(iconForCategory(category.iconName), size: 36, color: AppColors.primary),
              const SizedBox(height: AppSpacing.sm),
              Text(category.name,
                  style: AppTextStyles.label, textAlign: TextAlign.center,
                  maxLines: 1, overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ),
    );
  }
}
```

- [ ] **Step 4: Create the categories screen**

`lib/features/categories/view/categories_screen.dart`:
```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/empty_view.dart';
import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/loading_view.dart';
import '../bloc/categories_bloc.dart';
import '../bloc/categories_event.dart';
import '../bloc/categories_state.dart';
import '../widgets/category_tile.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('التصنيفات')),
      body: BlocBuilder<CategoriesBloc, CategoriesState>(
        builder: (context, state) => switch (state) {
          CategoriesLoading() => const LoadingView(),
          CategoriesNoConnection() => ErrorView(
              message: 'مفيش اتصال بالإنترنت',
              isOffline: true,
              onRetry: () => context.read<CategoriesBloc>().add(const CategoriesRequested()),
            ),
          CategoriesError(:final message) => ErrorView(
              message: message,
              onRetry: () => context.read<CategoriesBloc>().add(const CategoriesRequested()),
            ),
          CategoriesLoaded(:final categories) => categories.isEmpty
              ? const EmptyView(message: 'مفيش تصنيفات')
              : GridView.builder(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: AppSpacing.md,
                    mainAxisSpacing: AppSpacing.md,
                  ),
                  itemCount: categories.length,
                  itemBuilder: (context, i) {
                    final cat = categories[i];
                    return CategoryTile(
                      category: cat,
                      onTap: () => context.push('/category/${cat.id}', extra: cat.name),
                    );
                  },
                ),
        },
      ),
    );
  }
}
```

- [ ] **Step 5: Wire the router (categories branch) + delete placeholder**

In `lib/app/router.dart`:
- Add imports:
```dart
import '../features/categories/bloc/categories_bloc.dart';
import '../features/categories/bloc/categories_event.dart';
import '../features/categories/view/categories_screen.dart';
import '../data/repositories/category_repository.dart';
```
- Remove the import of `categories_placeholder.dart`.
- Replace the categories branch's `GoRoute` builder with:
```dart
            GoRoute(
              path: '/categories',
              builder: (context, state) => BlocProvider(
                create: (_) => CategoriesBloc(getIt<CategoryRepository>())
                  ..add(const CategoriesRequested()),
                child: const CategoriesScreen(),
              ),
            ),
```
- Delete the file `lib/features/categories/categories_placeholder.dart`.

- [ ] **Step 6: Run the screen test + app boot test + analyze**

Run:
```bash
flutter test test/features/categories/categories_screen_test.dart
flutter test test/app/app_boot_test.dart
flutter analyze
```
Expected: categories screen test PASS; app boot test still PASS (the boot test taps 'حسابي', unaffected); analyze clean.

> NOTE: the app_boot_test does not reference the categories placeholder text, so removing it is safe. If any test references `'التصنيفات — قريباً'`, update it — but none should.

- [ ] **Step 7: Commit**

```bash
git add lib/features/categories/widgets lib/features/categories/view/categories_screen.dart lib/app/router.dart test/features/categories/categories_screen_test.dart
git rm lib/features/categories/categories_placeholder.dart
git commit -m "feat(mobile): add Categories screen (grid) replacing placeholder"
```

---

## Task 5: Category listings screen + route

**Files:**
- Create: `lib/features/categories/view/category_listings_screen.dart`
- Modify: `lib/app/router.dart` (add top-level `/category/:id` route)
- Test: `test/features/categories/category_listings_screen_test.dart`

- [ ] **Step 1: Write the failing screen test**

`test/features/categories/category_listings_screen_test.dart`:
```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wasalni/data/repositories/listing_repository.dart';
import 'package:wasalni/data/repositories/village_repository.dart';
import 'package:wasalni/data/repositories/mock/mock_listing_repository.dart';
import 'package:wasalni/data/repositories/mock/mock_village_repository.dart';
import 'package:wasalni/features/feed/bloc/feed_bloc.dart';
import 'package:wasalni/features/categories/view/category_listings_screen.dart';

void main() {
  testWidgets('CategoryListingsScreen shows listings for the category', (tester) async {
    final ListingRepository listingRepo = MockListingRepository(latency: Duration.zero);
    final VillageRepository villageRepo = MockVillageRepository(latency: Duration.zero);

    await tester.pumpWidget(MaterialApp(
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: BlocProvider(
          create: (_) => FeedBloc(listingRepo),
          child: CategoryListingsScreen(
            categoryId: 'cat_plumb',
            categoryName: 'سباكة',
            villageRepository: villageRepo,
          ),
        ),
      ),
    ));
    await tester.pumpAndSettle();

    // 'سباك الأسطى محمود' is the plumbing (cat_plumb) listing in v_kafr.
    expect(find.text('سباك الأسطى محمود'), findsOneWidget);
    expect(find.text('سباكة'), findsWidgets); // app bar title
  });
}
```

- [ ] **Step 2: Run to verify it fails**

Run: `flutter test test/features/categories/category_listings_screen_test.dart` → FAIL (file missing).

- [ ] **Step 3: Create the screen**

`lib/features/categories/view/category_listings_screen.dart`:
```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/empty_view.dart';
import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/loading_view.dart';
import '../../../data/repositories/village_repository.dart';
import '../../feed/bloc/feed_bloc.dart';
import '../../feed/bloc/feed_event.dart';
import '../../feed/bloc/feed_state.dart';
import '../../feed/widgets/listing_card.dart';

class CategoryListingsScreen extends StatefulWidget {
  const CategoryListingsScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
    required this.villageRepository,
  });
  final String categoryId;
  final String categoryName;
  final VillageRepository villageRepository;

  @override
  State<CategoryListingsScreen> createState() => _CategoryListingsScreenState();
}

class _CategoryListingsScreenState extends State<CategoryListingsScreen> {
  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final bloc = context.read<FeedBloc>();
    final villages = await widget.villageRepository.getVillages();
    if (!mounted || villages.isEmpty) return;
    bloc.add(FeedRequested(villageId: villages.first.id, categoryId: widget.categoryId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.categoryName)),
      body: BlocBuilder<FeedBloc, FeedState>(
        builder: (context, state) => switch (state) {
          FeedLoading() => const LoadingView(),
          FeedEmpty() => const EmptyView(message: 'مفيش نشاطات في التصنيف ده لسه'),
          FeedNoConnection() => ErrorView(
              message: 'مفيش اتصال بالإنترنت', isOffline: true, onRetry: _load),
          FeedError(:final message) => ErrorView(message: message, onRetry: _load),
          FeedLoaded(:final listings) => GridView.builder(
              padding: const EdgeInsets.all(AppSpacing.md),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: AppSpacing.md,
                mainAxisSpacing: AppSpacing.md,
                childAspectRatio: 0.72,
              ),
              itemCount: listings.length,
              itemBuilder: (context, i) =>
                  ListingCard(listing: listings[i], onTap: () {}),
            ),
        },
      ),
    );
  }
}
```

- [ ] **Step 4: Add the route**

In `lib/app/router.dart`:
- Add imports:
```dart
import '../data/repositories/listing_repository.dart';
import '../data/repositories/village_repository.dart';
import '../features/feed/bloc/feed_bloc.dart';
import '../features/categories/view/category_listings_screen.dart';
```
(Some of these may already be imported from earlier tasks — do not duplicate imports.)
- Add a TOP-LEVEL route (sibling of the `StatefulShellRoute`, inside the same `routes: [ ... ]` list) so it pushes full-screen with a back button:
```dart
      GoRoute(
        path: '/category/:id',
        builder: (context, state) => BlocProvider(
          create: (_) => FeedBloc(getIt<ListingRepository>()),
          child: CategoryListingsScreen(
            categoryId: state.pathParameters['id']!,
            categoryName: state.extra as String? ?? 'التصنيف',
            villageRepository: getIt<VillageRepository>(),
          ),
        ),
      ),
```

- [ ] **Step 5: Run the test + full suite + analyze**

Run:
```bash
flutter test test/features/categories/category_listings_screen_test.dart
flutter test
flutter analyze
```
Expected: new test PASS; entire suite green; analyze clean.

- [ ] **Step 6: Commit**

```bash
git add lib/features/categories/view/category_listings_screen.dart lib/app/router.dart test/features/categories/category_listings_screen_test.dart
git commit -m "feat(mobile): add category listings screen + /category/:id route"
```

---

## Done — Definition of Complete

- `flutter analyze` clean; `flutter test` all green.
- Categories tab shows a 3-column grid of categories with icons; tapping one opens that category's listings (reusing the Feed pattern) with a back button; all states (loading/empty/offline/error) handled.
- `ListingRepository.getFeed` supports `categoryId`; FeedBloc threads it.

**Follow-ups (noted, not in scope):** a global `CurrentVillageCubit` (today Categories-listings uses the first village, like the Feed); visual polish (Phase 4). **Next plan:** Phase 3b — Search.
