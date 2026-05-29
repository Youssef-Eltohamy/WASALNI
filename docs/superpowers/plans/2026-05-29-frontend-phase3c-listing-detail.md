# WASALNI Frontend — Phase 3c: Listing Detail + Contact Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development. Steps use checkbox (`- [ ]`) syntax.

**Goal:** Make listing cards tappable → a unified detail/profile screen (works for service/shop/transport) showing name, verified badge, description, and **working WhatsApp + Call buttons** (the core of the product).

**Architecture:** Reuses the proven pattern. Adds a `ContactLauncher` util (phone → E.164, `wa.me`/`tel:` via `url_launcher`, with graceful fallback) and a `ListingDetailBloc` (loads a listing by id, so deep-links work). The detail screen renders common fields; rich kind-specific content (shop products, provider portfolio) is a later phase.

**Tech Stack:** flutter_bloc, go_router, get_it, freezed (`--force-jit`), url_launcher, bloc_test, mocktail.

**Scope:** Listing detail + contact actions. Product detail / shop products / provider portfolio gallery are deferred to a later sub-phase. Reference spec: `docs/superpowers/specs/2026-05-29-frontend-architecture-design.md` (§13 external handoffs).

**Working dir:** `apps/mobile`. **build_runner MUST use `--force-jit`** (Dart 3.10).

> NOTE on the model: the current `Listing` has `phoneWhatsapp` but no separate `phoneCall` and no `lat/lng`. So: WhatsApp + Call both use `phoneWhatsapp`; a Maps button is NOT added this phase (no coordinates yet — a noted follow-up).

---

## File Structure (this plan)

```
apps/mobile/
  pubspec.yaml                                       # MODIFY: add url_launcher
  lib/core/launch/contact_launcher.dart              # CREATE
  lib/features/listing_detail/bloc/listing_detail_event.dart   # CREATE
  lib/features/listing_detail/bloc/listing_detail_state.dart   # CREATE (freezed)
  lib/features/listing_detail/bloc/listing_detail_bloc.dart    # CREATE
  lib/features/listing_detail/view/listing_detail_screen.dart  # CREATE
  lib/app/router.dart                                # MODIFY: /listing/:id route
  lib/features/feed/view/feed_screen.dart            # MODIFY: card onTap → push
  lib/features/categories/view/category_listings_screen.dart  # MODIFY: card onTap
  lib/features/search/view/search_screen.dart        # MODIFY: card onTap
  test/core/launch/contact_launcher_test.dart        # CREATE
  test/features/listing_detail/listing_detail_bloc_test.dart   # CREATE
  test/features/listing_detail/listing_detail_screen_test.dart # CREATE
```

---

## Task 1: ContactLauncher util + url_launcher

**Files:**
- Modify: `pubspec.yaml` (add `url_launcher`)
- Create: `lib/core/launch/contact_launcher.dart`
- Test: `test/core/launch/contact_launcher_test.dart`

- [ ] **Step 1: Add url_launcher**

Run (from `apps/mobile`): `flutter pub add url_launcher`
Expected: pubspec gains `url_launcher`; `flutter pub get` succeeds.

- [ ] **Step 2: Write the failing unit test** `test/core/launch/contact_launcher_test.dart`:
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:wasalni/core/launch/contact_launcher.dart';

void main() {
  group('toE164', () {
    test('keeps an already-normalized number', () {
      expect(toE164('+201000000001'), '+201000000001');
    });
    test('converts a local 0-prefixed number', () {
      expect(toE164('01000000001'), '+201000000001');
    });
    test('converts Arabic-Indic digits', () {
      expect(toE164('٠١٠٠٠٠٠٠٠٠١'), '+201000000001');
    });
    test('strips spaces and separators', () {
      expect(toE164('0100 000 0001'), '+201000000001');
    });
  });
}
```

- [ ] **Step 3: Run → FAIL:** `flutter test test/core/launch/contact_launcher_test.dart` (file missing).

- [ ] **Step 4: Create the util** `lib/core/launch/contact_launcher.dart`:
```dart
import 'package:url_launcher/url_launcher.dart';

const _arabicDigits = '٠١٢٣٤٥٦٧٨٩';

/// Normalizes an Egyptian phone number to E.164 (`+20...`).
/// Accepts already-E.164, `00`-prefixed, local `0`-prefixed, or bare numbers,
/// and converts Arabic-Indic digits to ASCII. Strips spaces/dashes/parens.
String toE164(String raw) {
  final buf = StringBuffer();
  for (final ch in raw.trim().split('')) {
    final ai = _arabicDigits.indexOf(ch);
    if (ai >= 0) {
      buf.write(ai);
    } else if (ch == '+' || (ch.codeUnitAt(0) >= 0x30 && ch.codeUnitAt(0) <= 0x39)) {
      buf.write(ch);
    }
  }
  final s = buf.toString();
  if (s.startsWith('+')) return s;
  if (s.startsWith('00')) return '+${s.substring(2)}';
  if (s.startsWith('0')) return '+20${s.substring(1)}';
  if (s.startsWith('20')) return '+$s';
  return '+20$s';
}

/// Launches external contact channels. Returns false if the channel can't be opened
/// (e.g. WhatsApp not installed), so the caller can show a fallback.
class ContactLauncher {
  const ContactLauncher();

  Future<bool> whatsapp(String phone, {String? message}) {
    final number = toE164(phone).replaceFirst('+', '');
    final suffix = (message == null || message.isEmpty)
        ? ''
        : '?text=${Uri.encodeComponent(message)}';
    return _launch(Uri.parse('https://wa.me/$number$suffix'));
  }

  Future<bool> call(String phone) => _launch(Uri.parse('tel:${toE164(phone)}'));

  Future<bool> _launch(Uri uri) async {
    if (await canLaunchUrl(uri)) {
      return launchUrl(uri, mode: LaunchMode.externalApplication);
    }
    return false;
  }
}
```

- [ ] **Step 5: Run the test + analyze:** `flutter test test/core/launch/contact_launcher_test.dart` → PASS (4 tests). `flutter analyze` → clean.

- [ ] **Step 6: Commit**
```bash
git add pubspec.yaml pubspec.lock lib/core/launch/contact_launcher.dart test/core/launch/contact_launcher_test.dart
git commit -m "feat(mobile): add ContactLauncher (E.164 + wa.me/tel via url_launcher)"
```

---

## Task 2: ListingDetailBloc

**Files:**
- Create: `lib/features/listing_detail/bloc/listing_detail_event.dart`, `listing_detail_state.dart`, `listing_detail_bloc.dart`
- Test: `test/features/listing_detail/listing_detail_bloc_test.dart`

- [ ] **Step 1: Failing bloc test** `test/features/listing_detail/listing_detail_bloc_test.dart`:
```dart
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wasalni/core/network/repository_exception.dart';
import 'package:wasalni/data/models/enums.dart';
import 'package:wasalni/data/models/listing.dart';
import 'package:wasalni/data/repositories/listing_repository.dart';
import 'package:wasalni/features/listing_detail/bloc/listing_detail_bloc.dart';
import 'package:wasalni/features/listing_detail/bloc/listing_detail_event.dart';
import 'package:wasalni/features/listing_detail/bloc/listing_detail_state.dart';

class MockListingRepo extends Mock implements ListingRepository {}

Listing _listing(String id) => Listing(
      id: id, kind: ListingKind.service, ownerId: 'o', villageId: 'v_kafr',
      categoryId: 'c', name: 'اسم $id', bio: 'وصف', phoneWhatsapp: '+201000000000',
      createdAt: DateTime.utc(2026, 1, 1));

void main() {
  late MockListingRepo repo;
  setUp(() => repo = MockListingRepo());

  blocTest<ListingDetailBloc, ListingDetailState>(
    'emits [loading, loaded] when found',
    build: () {
      when(() => repo.getById(any())).thenAnswer((_) async => _listing('l1'));
      return ListingDetailBloc(repo);
    },
    act: (bloc) => bloc.add(const ListingDetailRequested('l1')),
    expect: () => [
      const ListingDetailState.loading(),
      isA<ListingDetailLoaded>().having((s) => s.listing.id, 'id', 'l1'),
    ],
  );

  blocTest<ListingDetailBloc, ListingDetailState>(
    'emits [loading, error] when not found',
    build: () {
      when(() => repo.getById(any())).thenThrow(const NotFoundException());
      return ListingDetailBloc(repo);
    },
    act: (bloc) => bloc.add(const ListingDetailRequested('nope')),
    expect: () => [const ListingDetailState.loading(), isA<ListingDetailError>()],
  );

  blocTest<ListingDetailBloc, ListingDetailState>(
    'emits [loading, noConnection] on NoConnectionException',
    build: () {
      when(() => repo.getById(any())).thenThrow(const NoConnectionException());
      return ListingDetailBloc(repo);
    },
    act: (bloc) => bloc.add(const ListingDetailRequested('l1')),
    expect: () => [const ListingDetailState.loading(), const ListingDetailState.noConnection()],
  );
}
```

- [ ] **Step 2: Run → FAIL:** `flutter test test/features/listing_detail/listing_detail_bloc_test.dart`

- [ ] **Step 3: `lib/features/listing_detail/bloc/listing_detail_event.dart`:**
```dart
sealed class ListingDetailEvent {
  const ListingDetailEvent();
}

class ListingDetailRequested extends ListingDetailEvent {
  const ListingDetailRequested(this.id);
  final String id;
}
```

- [ ] **Step 4: `lib/features/listing_detail/bloc/listing_detail_state.dart`:**
```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../data/models/listing.dart';

part 'listing_detail_state.freezed.dart';

@freezed
sealed class ListingDetailState with _$ListingDetailState {
  const factory ListingDetailState.loading() = ListingDetailLoading;
  const factory ListingDetailState.loaded(Listing listing) = ListingDetailLoaded;
  const factory ListingDetailState.noConnection() = ListingDetailNoConnection;
  const factory ListingDetailState.error(String message) = ListingDetailError;
}
```

- [ ] **Step 5: `lib/features/listing_detail/bloc/listing_detail_bloc.dart`:**
```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/network/repository_exception.dart';
import '../../../data/repositories/listing_repository.dart';
import 'listing_detail_event.dart';
import 'listing_detail_state.dart';

class ListingDetailBloc extends Bloc<ListingDetailEvent, ListingDetailState> {
  ListingDetailBloc(this._repo) : super(const ListingDetailState.loading()) {
    on<ListingDetailRequested>(_onRequested);
  }

  final ListingRepository _repo;

  Future<void> _onRequested(
      ListingDetailRequested e, Emitter<ListingDetailState> emit) async {
    emit(const ListingDetailState.loading());
    try {
      final listing = await _repo.getById(e.id);
      emit(ListingDetailState.loaded(listing));
    } on NoConnectionException {
      emit(const ListingDetailState.noConnection());
    } on RepositoryException catch (e) {
      emit(ListingDetailState.error(e.message ?? 'حصل خطأ'));
    }
  }
}
```

- [ ] **Step 6: Codegen + test:**
```bash
dart run build_runner build --force-jit --delete-conflicting-outputs
flutter test test/features/listing_detail/listing_detail_bloc_test.dart
```
Expected: codegen ok; 3 tests PASS.

- [ ] **Step 7: Commit**
```bash
git add lib/features/listing_detail/bloc test/features/listing_detail/listing_detail_bloc_test.dart
git commit -m "feat(mobile): add ListingDetailBloc (loading/loaded/offline/error)"
```

---

## Task 3: Listing detail screen + route + tappable cards

**Files:**
- Create: `lib/features/listing_detail/view/listing_detail_screen.dart`
- Modify: `lib/app/router.dart` (/listing/:id), `lib/features/feed/view/feed_screen.dart`, `lib/features/categories/view/category_listings_screen.dart`, `lib/features/search/view/search_screen.dart` (card onTap)
- Test: `test/features/listing_detail/listing_detail_screen_test.dart`

- [ ] **Step 1: Failing screen test** `test/features/listing_detail/listing_detail_screen_test.dart`:
```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wasalni/data/repositories/listing_repository.dart';
import 'package:wasalni/data/repositories/mock/mock_listing_repository.dart';
import 'package:wasalni/features/listing_detail/bloc/listing_detail_bloc.dart';
import 'package:wasalni/features/listing_detail/bloc/listing_detail_event.dart';
import 'package:wasalni/features/listing_detail/view/listing_detail_screen.dart';

void main() {
  testWidgets('ListingDetailScreen shows the listing and a WhatsApp button', (tester) async {
    final ListingRepository repo = MockListingRepository(latency: Duration.zero);

    await tester.pumpWidget(MaterialApp(
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: BlocProvider(
          create: (_) => ListingDetailBloc(repo)..add(const ListingDetailRequested('l1')),
          child: const ListingDetailScreen(),
        ),
      ),
    ));
    await tester.pumpAndSettle();

    expect(find.text('سباك الأسطى محمود'), findsOneWidget); // l1 name
    expect(find.text('تواصل واتساب'), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run → FAIL:** `flutter test test/features/listing_detail/listing_detail_screen_test.dart`

- [ ] **Step 3: Create the screen** `lib/features/listing_detail/view/listing_detail_screen.dart`:
```dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/launch/contact_launcher.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/loading_view.dart';
import '../../../data/models/listing.dart';
import '../bloc/listing_detail_bloc.dart';
import '../bloc/listing_detail_event.dart';
import '../bloc/listing_detail_state.dart';

class ListingDetailScreen extends StatelessWidget {
  const ListingDetailScreen({super.key, this.launcher = const ContactLauncher()});
  final ContactLauncher launcher;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ListingDetailBloc, ListingDetailState>(
        builder: (context, state) => switch (state) {
          ListingDetailLoading() =>
            const Scaffold(body: LoadingView()),
          ListingDetailNoConnection() => Scaffold(
              appBar: AppBar(),
              body: const ErrorView(message: 'مفيش اتصال بالإنترنت', isOffline: true),
            ),
          ListingDetailError(:final message) => Scaffold(
              appBar: AppBar(),
              body: ErrorView(message: message),
            ),
          ListingDetailLoaded(:final listing) => _DetailBody(listing: listing, launcher: launcher),
        },
      ),
    );
  }
}

class _DetailBody extends StatelessWidget {
  const _DetailBody({required this.listing, required this.launcher});
  final Listing listing;
  final ContactLauncher launcher;

  Future<void> _whatsapp(BuildContext context) async {
    final ok = await launcher.whatsapp(
      listing.phoneWhatsapp,
      message: 'أنا لقيتك على وصلني و بتواصل معاك بخصوص: ',
    );
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تعذّر فتح واتساب — اتأكد إنه متنصّب')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 200,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            background: (listing.logoUrl == null || listing.logoUrl!.isEmpty)
                ? Container(color: AppColors.border,
                    child: const Icon(Icons.storefront, size: 64, color: AppColors.textMuted))
                : CachedNetworkImage(imageUrl: listing.logoUrl!, fit: BoxFit.cover),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: Text(listing.name, style: AppTextStyles.headline)),
                    if (listing.isVerified)
                      const Icon(Icons.verified, color: AppColors.verified),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(listing.bio, style: AppTextStyles.body),
                const SizedBox(height: AppSpacing.xl),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        style: FilledButton.styleFrom(backgroundColor: AppColors.whatsapp),
                        onPressed: () => _whatsapp(context),
                        icon: const Icon(Icons.chat),
                        label: const Text('تواصل واتساب'),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => launcher.call(listing.phoneWhatsapp),
                        icon: const Icon(Icons.call),
                        label: const Text('اتصال'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
```

- [ ] **Step 4: Run the screen test → PASS:** `flutter test test/features/listing_detail/listing_detail_screen_test.dart`

- [ ] **Step 5: Add the route.** In `lib/app/router.dart`:
- Add imports: `import '../features/listing_detail/bloc/listing_detail_bloc.dart';`, `import '../features/listing_detail/bloc/listing_detail_event.dart';`, `import '../features/listing_detail/view/listing_detail_screen.dart';`
- Add a top-level `GoRoute` (sibling of the shell route, next to `/category/:id` and `/search`):
```dart
      GoRoute(
        path: '/listing/:id',
        builder: (context, state) => BlocProvider(
          create: (_) => ListingDetailBloc(getIt<ListingRepository>())
            ..add(ListingDetailRequested(state.pathParameters['id']!)),
          child: const ListingDetailScreen(),
        ),
      ),
```

- [ ] **Step 6: Make cards navigate.** In each of these three files, change the `ListingCard(... onTap: () {})` to push the detail route. Add `import 'package:go_router/go_router.dart';` to any file that doesn't already import it (feed_screen.dart already does; category_listings_screen.dart and search_screen.dart do NOT — add it there).
  - `lib/features/feed/view/feed_screen.dart`: change `itemBuilder: (ctx, idx) => ListingCard(listing: listings[idx], onTap: () {})` so `onTap: () => ctx.push('/listing/${listings[idx].id}')`.
  - `lib/features/categories/view/category_listings_screen.dart`: change `itemBuilder: (context, i) => ListingCard(listing: listings[i], onTap: () {})` so `onTap: () => context.push('/listing/${listings[i].id}')`.
  - `lib/features/search/view/search_screen.dart`: change `itemBuilder: (context, i) => ListingCard(listing: results[i], onTap: () {})` so `onTap: () => context.push('/listing/${results[i].id}')`.

- [ ] **Step 7: Full suite + analyze:**
```bash
flutter test
flutter analyze
```
Expected: ALL tests pass (the feed/category/search screen tests don't tap cards, so `context.push` is never invoked in them — no router needed there); analyze clean. If `unnecessary_underscores` or unused-import lints appear, fix only those.

- [ ] **Step 8: Commit**
```bash
git add lib/features/listing_detail/view/listing_detail_screen.dart lib/app/router.dart lib/features/feed/view/feed_screen.dart lib/features/categories/view/category_listings_screen.dart lib/features/search/view/search_screen.dart test/features/listing_detail/listing_detail_screen_test.dart
git commit -m "feat(mobile): add listing detail screen + /listing/:id route + tappable cards"
```

---

## Done — Definition of Complete

- `flutter analyze` clean; `flutter test` all green.
- Tapping any listing card (Feed, category listings, search results) opens a detail screen with the listing's name, verified badge, description, and working WhatsApp + Call buttons (WhatsApp opens `wa.me` with a default Arabic message; falls back to a snackbar if WhatsApp isn't available).
- `ListingDetailBloc` loads by id (supports deep-links); `ContactLauncher` normalizes Egyptian phones to E.164.

**Follow-ups (noted):** add `lat/lng` + `phoneCall` to the model → Maps button + separate call number; rich kind-specific content (shop products + product detail, provider portfolio gallery, transport vehicle/area); global `CurrentVillageCubit`; visual polish (Phase 4). **Next plan:** shop products + product detail, or the Soft Cart.
