# WASALNI Frontend — Phase 3b: Search Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development. Steps use checkbox (`- [ ]`) syntax.

**Goal:** Add search — a search field (opened from the Feed app bar) that finds active listings in the current village by name/description, with results, empty, loading, and offline states.

**Architecture:** Reuses the proven pattern (UI → Bloc → Repository interface → Mock). Adds `ListingRepository.search(...)` + a new `SearchBloc`. Results render with the existing `ListingCard`.

**Tech Stack:** flutter_bloc, go_router, get_it, freezed (`--force-jit`), bloc_test, mocktail.

**Scope:** Search only. Builds on Foundation+Feed and Phase 3a. Visual polish deferred to Phase 4. Reference spec: `docs/superpowers/specs/2026-05-29-frontend-architecture-design.md`.

**Working dir:** `apps/mobile`. **build_runner MUST use `--force-jit`** (Dart 3.10).

---

## File Structure (this plan)

```
apps/mobile/lib/
  data/repositories/listing_repository.dart           # MODIFY: add search()
  data/repositories/mock/mock_listing_repository.dart  # MODIFY: implement search()
  features/search/bloc/search_event.dart               # CREATE
  features/search/bloc/search_state.dart               # CREATE (freezed sealed)
  features/search/bloc/search_bloc.dart                # CREATE
  features/search/view/search_screen.dart              # CREATE
  features/feed/view/feed_screen.dart                  # MODIFY: search icon in app bar
  app/router.dart                                      # MODIFY: /search route
apps/mobile/test/
  data/repositories/mock_listing_repository_test.dart  # MODIFY: search tests
  features/search/search_bloc_test.dart                # CREATE
  features/search/search_screen_test.dart              # CREATE
```

---

## Task 1: ListingRepository.search()

**Files:**
- Modify: `lib/data/repositories/listing_repository.dart`, `lib/data/repositories/mock/mock_listing_repository.dart`
- Test: `test/data/repositories/mock_listing_repository_test.dart`

- [ ] **Step 1: Add failing tests.** Append inside the existing `main()` in `test/data/repositories/mock_listing_repository_test.dart`:
```dart
  test('search finds active listings by name in the village', () async {
    final repo = MockListingRepository();
    final result = await repo.search(villageId: 'v_kafr', query: 'سباك');
    expect(result, isNotEmpty);
    expect(result.any((l) => l.name == 'سباك الأسطى محمود'), true);
    expect(result.every((l) => l.villageId == 'v_kafr'), true);
  });

  test('search returns empty when nothing matches', () async {
    final repo = MockListingRepository();
    final result = await repo.search(villageId: 'v_kafr', query: 'zzzznope');
    expect(result, isEmpty);
  });
```

- [ ] **Step 2: Run → FAIL:** `flutter test test/data/repositories/mock_listing_repository_test.dart` (no `search` method).

- [ ] **Step 3: Add to interface.** In `lib/data/repositories/listing_repository.dart`, add to the `ListingRepository` interface (after `getById`):
```dart
  /// Active listings in [villageId] whose name or description contains [query].
  Future<List<Listing>> search({required String villageId, required String query});
```

- [ ] **Step 4: Implement in mock.** In `lib/data/repositories/mock/mock_listing_repository.dart`, add this method to `MockListingRepository`:
```dart
  @override
  Future<List<Listing>> search({required String villageId, required String query}) async {
    await Future<void>.delayed(latency);
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return const [];
    return MockData.listings.where((l) =>
        l.villageId == villageId &&
        l.status == ListingStatus.active &&
        (l.name.toLowerCase().contains(q) || l.bio.toLowerCase().contains(q))).toList();
  }
```

- [ ] **Step 5: Run tests + analyze.** `flutter test test/data/repositories/mock_listing_repository_test.dart` → PASS (6 tests). `flutter analyze` → clean.

- [ ] **Step 6: Commit.**
```bash
git add lib/data/repositories/listing_repository.dart lib/data/repositories/mock/mock_listing_repository.dart test/data/repositories/mock_listing_repository_test.dart
git commit -m "feat(mobile): add ListingRepository.search (name/description match)"
```

> NOTE: Arabic normalization (diacritics/hamza) is a deliberate follow-up; basic case-insensitive substring match is enough for this phase.

---

## Task 2: SearchBloc

**Files:**
- Create: `lib/features/search/bloc/search_event.dart`, `search_state.dart`, `search_bloc.dart`
- Test: `test/features/search/search_bloc_test.dart`

- [ ] **Step 1: Failing bloc test** `test/features/search/search_bloc_test.dart`:
```dart
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wasalni/core/network/repository_exception.dart';
import 'package:wasalni/data/models/enums.dart';
import 'package:wasalni/data/models/listing.dart';
import 'package:wasalni/data/repositories/listing_repository.dart';
import 'package:wasalni/features/search/bloc/search_bloc.dart';
import 'package:wasalni/features/search/bloc/search_event.dart';
import 'package:wasalni/features/search/bloc/search_state.dart';

class MockListingRepo extends Mock implements ListingRepository {}

Listing _listing(String id) => Listing(
      id: id, kind: ListingKind.service, ownerId: 'o', villageId: 'v_kafr',
      categoryId: 'c', name: 'اسم $id', bio: 'وصف', phoneWhatsapp: '+201000000000',
      createdAt: DateTime.utc(2026, 1, 1));

void main() {
  late MockListingRepo repo;
  setUp(() => repo = MockListingRepo());

  blocTest<SearchBloc, SearchState>(
    'emits [loading, loaded] when results found',
    build: () {
      when(() => repo.search(villageId: any(named: 'villageId'), query: any(named: 'query')))
          .thenAnswer((_) async => [_listing('l1')]);
      return SearchBloc(repo);
    },
    act: (bloc) => bloc.add(const SearchQueryChanged(villageId: 'v_kafr', query: 'سباك')),
    expect: () => [
      const SearchState.loading(),
      isA<SearchLoaded>().having((s) => s.results.length, 'count', 1),
    ],
  );

  blocTest<SearchBloc, SearchState>(
    'emits [loading, empty] when no results',
    build: () {
      when(() => repo.search(villageId: any(named: 'villageId'), query: any(named: 'query')))
          .thenAnswer((_) async => []);
      return SearchBloc(repo);
    },
    act: (bloc) => bloc.add(const SearchQueryChanged(villageId: 'v_kafr', query: 'xyz')),
    expect: () => [const SearchState.loading(), const SearchState.empty()],
  );

  blocTest<SearchBloc, SearchState>(
    'emits [initial] when query is blank',
    build: () => SearchBloc(repo),
    act: (bloc) => bloc.add(const SearchQueryChanged(villageId: 'v_kafr', query: '   ')),
    expect: () => [const SearchState.initial()],
  );

  blocTest<SearchBloc, SearchState>(
    'emits [loading, noConnection] on NoConnectionException',
    build: () {
      when(() => repo.search(villageId: any(named: 'villageId'), query: any(named: 'query')))
          .thenThrow(const NoConnectionException());
      return SearchBloc(repo);
    },
    act: (bloc) => bloc.add(const SearchQueryChanged(villageId: 'v_kafr', query: 'سباك')),
    expect: () => [const SearchState.loading(), const SearchState.noConnection()],
  );
}
```

> NOTE on the blank-query case: the bloc's initial state is `SearchInitial`. A blank query emits `SearchInitial` again. bloc emits it because the bloc has not emitted before (`_emitted` is false on the first emit), so `[SearchInitial]` is the expected emitted list. This test passes with the implementation below.

- [ ] **Step 2: Run → FAIL:** `flutter test test/features/search/search_bloc_test.dart`

- [ ] **Step 3: `lib/features/search/bloc/search_event.dart`:**
```dart
sealed class SearchEvent {
  const SearchEvent();
}

class SearchQueryChanged extends SearchEvent {
  const SearchQueryChanged({required this.villageId, required this.query});
  final String villageId;
  final String query;
}
```

- [ ] **Step 4: `lib/features/search/bloc/search_state.dart`:**
```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../data/models/listing.dart';

part 'search_state.freezed.dart';

@freezed
sealed class SearchState with _$SearchState {
  const factory SearchState.initial() = SearchInitial;
  const factory SearchState.loading() = SearchLoading;
  const factory SearchState.loaded(List<Listing> results) = SearchLoaded;
  const factory SearchState.empty() = SearchEmpty;
  const factory SearchState.noConnection() = SearchNoConnection;
  const factory SearchState.error(String message) = SearchError;
}
```

- [ ] **Step 5: `lib/features/search/bloc/search_bloc.dart`:**
```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/network/repository_exception.dart';
import '../../../data/repositories/listing_repository.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc(this._repo) : super(const SearchState.initial()) {
    on<SearchQueryChanged>(_onQueryChanged);
  }

  final ListingRepository _repo;

  Future<void> _onQueryChanged(SearchQueryChanged e, Emitter<SearchState> emit) async {
    final q = e.query.trim();
    if (q.isEmpty) {
      emit(const SearchState.initial());
      return;
    }
    emit(const SearchState.loading());
    try {
      final results = await _repo.search(villageId: e.villageId, query: q);
      emit(results.isEmpty ? const SearchState.empty() : SearchState.loaded(results));
    } on NoConnectionException {
      emit(const SearchState.noConnection());
    } on RepositoryException catch (e) {
      emit(SearchState.error(e.message ?? 'حصل خطأ'));
    }
  }
}
```

- [ ] **Step 6: Codegen + test:**
```bash
dart run build_runner build --force-jit --delete-conflicting-outputs
flutter test test/features/search/search_bloc_test.dart
```
Expected: codegen ok; 4 tests PASS.

- [ ] **Step 7: Commit.**
```bash
git add lib/features/search/bloc test/features/search/search_bloc_test.dart
git commit -m "feat(mobile): add SearchBloc (initial/loading/loaded/empty/offline/error)"
```

---

## Task 3: Search screen + route + Feed app-bar entry

**Files:**
- Create: `lib/features/search/view/search_screen.dart`
- Modify: `lib/features/feed/view/feed_screen.dart` (search icon), `lib/app/router.dart` (/search route)
- Test: `test/features/search/search_screen_test.dart`

- [ ] **Step 1: Failing screen test** `test/features/search/search_screen_test.dart`:
```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wasalni/data/repositories/listing_repository.dart';
import 'package:wasalni/data/repositories/village_repository.dart';
import 'package:wasalni/data/repositories/mock/mock_listing_repository.dart';
import 'package:wasalni/data/repositories/mock/mock_village_repository.dart';
import 'package:wasalni/features/search/bloc/search_bloc.dart';
import 'package:wasalni/features/search/view/search_screen.dart';

void main() {
  testWidgets('SearchScreen shows results as the user types', (tester) async {
    final ListingRepository listingRepo = MockListingRepository(latency: Duration.zero);
    final VillageRepository villageRepo = MockVillageRepository(latency: Duration.zero);

    await tester.pumpWidget(MaterialApp(
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: BlocProvider(
          create: (_) => SearchBloc(listingRepo),
          child: SearchScreen(villageRepository: villageRepo),
        ),
      ),
    ));
    await tester.pumpAndSettle(); // load village

    await tester.enterText(find.byType(TextField), 'سباك');
    await tester.pumpAndSettle();

    expect(find.text('سباك الأسطى محمود'), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run → FAIL:** `flutter test test/features/search/search_screen_test.dart`

- [ ] **Step 3: `lib/features/search/view/search_screen.dart`:**
```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/empty_view.dart';
import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/loading_view.dart';
import '../../../data/repositories/village_repository.dart';
import '../../feed/widgets/listing_card.dart';
import '../bloc/search_bloc.dart';
import '../bloc/search_event.dart';
import '../bloc/search_state.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, required this.villageRepository});
  final VillageRepository villageRepository;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  String? _villageId;

  @override
  void initState() {
    super.initState();
    _loadVillage();
  }

  Future<void> _loadVillage() async {
    final villages = await widget.villageRepository.getVillages();
    if (!mounted || villages.isEmpty) return;
    setState(() => _villageId = villages.first.id);
  }

  void _onChanged(String query) {
    final v = _villageId;
    if (v == null) return;
    context.read<SearchBloc>().add(SearchQueryChanged(villageId: v, query: query));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          autofocus: true,
          onChanged: _onChanged,
          style: const TextStyle(color: Colors.white, fontFamily: 'Cairo', fontSize: 16),
          cursorColor: Colors.white,
          decoration: const InputDecoration(
            hintText: 'ابحث عن خدمة أو محل...',
            hintStyle: TextStyle(color: Colors.white70, fontFamily: 'Cairo'),
            border: InputBorder.none,
          ),
        ),
      ),
      body: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) => switch (state) {
          SearchInitial() => const EmptyView(message: 'ابحث بالاسم أو الفئة', icon: Icons.search),
          SearchLoading() => const LoadingView(),
          SearchEmpty() => const EmptyView(message: 'مفيش نتائج للبحث ده'),
          SearchNoConnection() =>
            const ErrorView(message: 'مفيش اتصال بالإنترنت', isOffline: true),
          SearchError(:final message) => ErrorView(message: message),
          SearchLoaded(:final results) => GridView.builder(
              padding: const EdgeInsets.all(AppSpacing.md),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: AppSpacing.md,
                mainAxisSpacing: AppSpacing.md,
                childAspectRatio: 0.72,
              ),
              itemCount: results.length,
              itemBuilder: (context, i) =>
                  ListingCard(listing: results[i], onTap: () {}),
            ),
        },
      ),
    );
  }
}
```

- [ ] **Step 4: Run the screen test → PASS:** `flutter test test/features/search/search_screen_test.dart`

- [ ] **Step 5: Add the search icon to the Feed app bar.** In `lib/features/feed/view/feed_screen.dart`:
- Add the import (with the other imports): `import 'package:go_router/go_router.dart';`
- Replace the `AppBar(title: const Text('وصلني'))` line with:
```dart
      appBar: AppBar(
        title: const Text('وصلني'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => context.push('/search'),
          ),
        ],
      ),
```

- [ ] **Step 6: Add the /search route.** In `lib/app/router.dart`:
- Add import: `import '../features/search/bloc/search_bloc.dart';` and `import '../features/search/view/search_screen.dart';` (`ListingRepository`, `VillageRepository`, `flutter_bloc`, `getIt` are already imported).
- Add a top-level `GoRoute` as a SIBLING of the `StatefulShellRoute` (next to the `/category/:id` route):
```dart
      GoRoute(
        path: '/search',
        builder: (context, state) => BlocProvider(
          create: (_) => SearchBloc(getIt<ListingRepository>()),
          child: SearchScreen(villageRepository: getIt<VillageRepository>()),
        ),
      ),
```

- [ ] **Step 7: Full suite + analyze:**
```bash
flutter test
flutter analyze
```
Expected: ALL tests pass (the feed_screen_test still passes — the search icon's `onPressed` is not tapped, so no router is needed in that test); analyze clean.

- [ ] **Step 8: Commit.**
```bash
git add lib/features/search/view/search_screen.dart lib/features/feed/view/feed_screen.dart lib/app/router.dart test/features/search/search_screen_test.dart
git commit -m "feat(mobile): add Search screen + /search route + Feed search icon"
```

---

## Done — Definition of Complete

- `flutter analyze` clean; `flutter test` all green.
- Tapping the search icon in the Feed app bar opens a search screen; typing filters active listings in the current village by name/description; initial/loading/empty/offline states handled; results use `ListingCard`.

**Follow-ups (noted):** Arabic text normalization (diacritics/hamza); debounce search input; global `CurrentVillageCubit` (search uses the first village, like Feed/Categories). **Next plan:** Phase 3c — Listing/Shop/Transport profiles + Product detail.
