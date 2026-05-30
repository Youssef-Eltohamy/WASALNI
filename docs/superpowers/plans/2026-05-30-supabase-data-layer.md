# Phase 8: Supabase Data Layer — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the four read mocks (villages, categories, listings, products) and the order-write mock with real Supabase implementations, behind the existing repository interfaces, without changing any screen.

**Architecture:** A SQL migration + seed create the 6 tables (text PKs matching the mock IDs) with public-read RLS and a temporary anon-insert policy for orders. A Supabase client initialises from `.env`. Five `Supabase*Repository` classes implement the existing interfaces via pure JSON↔model mappers, and are swapped in at the `di.dart` SWAP POINT. Mock repos stay for the existing test suite.

**Tech Stack:** Flutter, `supabase_flutter ^2.10`, `flutter_dotenv ^5.2`, freezed models, get_it. Tests: flutter_test (mapper unit tests). DB: Postgres (Supabase), SQL migration applied via the Supabase SQL editor (copy-paste).

**Spec:** `docs/superpowers/specs/2026-05-30-supabase-data-layer-design.md`

**Conventions:** all flutter commands from `D:\programing\wasalni\apps\mobile`; if a stale `D:\programing\wasalni\.git\index.lock` appears, delete it and retry. Existing exceptions live in `lib/core/network/repository_exception.dart` (`NoConnectionException`, `NotFoundException`, `ServerException`). Enums in `lib/data/models/enums.dart`: `ListingKind {service, shop, transport}`, `ListingStatus {draft, pending, active, rejected, suspended, deactivated, expired}`, `ListingPlan {free, prime}`.

**Manual step flagged for the owner:** Tasks 1 & 2 produce SQL files; the owner runs them once in the Supabase SQL editor (the plan says exactly when). Task 3 needs the `.env` to contain `SUPABASE_URL` + `SUPABASE_ANON_KEY`.

---

## File Structure

**SQL (repo root `supabase/`)**
- `migrations/<timestamp>_data_layer.sql` — *new*: extensions, enums, 6 tables, indexes, RLS.
- `seed.sql` — *replace placeholder*: profiles + villages + categories + listings + products rows.

**Flutter (`apps/mobile/lib/`)**
- `core/supabase/supabase_init.dart` — *new*: `initSupabase()` + `supabaseClient` getter.
- `data/repositories/supabase/mappers.dart` — *new*: row↔model pure functions.
- `data/repositories/supabase/supabase_village_repository.dart` — *new*.
- `data/repositories/supabase/supabase_category_repository.dart` — *new*.
- `data/repositories/supabase/supabase_listing_repository.dart` — *new*.
- `data/repositories/supabase/supabase_product_repository.dart` — *new*.
- `data/repositories/supabase/supabase_order_repository.dart` — *new*.
- `main.dart` — *modify*: `await initSupabase()` before `setupDi()`.
- `app/di.dart` — *modify*: swap the 5 repos at the SWAP POINT.

**Tests (`apps/mobile/test/`)**
- `data/repositories/supabase/mappers_test.dart` — *new*: unit tests for every mapper.

---

### Task 1: SQL migration (schema + RLS)

**Files:**
- Create: `supabase/migrations/20260530120000_data_layer.sql`

- [ ] **Step 1: Write the migration**

Create `supabase/migrations/20260530120000_data_layer.sql` with exactly:

```sql
-- ============================================================
-- WASALNI — Data layer: villages, categories, profiles,
-- listings (unified), products, order_intents.
-- Text PKs match the app's seed IDs. Public read; orders insert
-- is TEMPORARILY open to anon (auth is still mock) — tighten to
-- auth.uid()::text = user_id when real auth lands.
-- ============================================================

create extension if not exists "uuid-ossp";
create extension if not exists pg_trgm;

-- Enums (values mirror lib/data/models/enums.dart) -----------
do $$ begin
  create type listing_kind as enum ('service','shop','transport');
exception when duplicate_object then null; end $$;

do $$ begin
  create type listing_status as enum
    ('draft','pending','active','rejected','suspended','deactivated','expired');
exception when duplicate_object then null; end $$;

do $$ begin
  create type listing_plan as enum ('free','prime');
exception when duplicate_object then null; end $$;

-- Tables -----------------------------------------------------
create table if not exists villages (
  id text primary key,
  name text not null,
  governorate text not null,
  markaz text not null
);

create table if not exists categories (
  id text primary key,
  name text not null,
  slug text not null,
  icon_name text not null,
  kind listing_kind not null,
  sort_order int not null default 0
);

create table if not exists profiles (
  id text primary key,
  phone text not null,
  display_name text not null default '',
  village_id text references villages(id),
  created_at timestamptz not null default now()
);

create table if not exists listings (
  id text primary key,
  kind listing_kind not null,
  owner_id text references profiles(id),
  village_id text not null references villages(id),
  category_id text not null references categories(id),
  name text not null,
  bio text not null default '',
  phone_whatsapp text not null,
  logo_url text,
  status listing_status not null default 'active',
  is_verified boolean not null default false,
  is_featured boolean not null default false,
  plan listing_plan not null default 'free',
  is_temporarily_closed boolean not null default false,
  attributes jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now()
);

create table if not exists products (
  id text primary key,
  listing_id text not null references listings(id),
  name text not null,
  description text not null default '',
  price_egp numeric not null,
  image_url text,
  is_available boolean not null default true,
  sort_order int not null default 0
);

create table if not exists order_intents (
  id text primary key,
  user_id text references profiles(id),
  shop_id text not null,
  shop_name text not null,
  shop_phone text not null,
  message text not null,
  total_egp numeric not null,
  item_count int not null,
  created_at timestamptz not null default now()
);

-- Indexes ----------------------------------------------------
create index if not exists idx_listings_village_status on listings(village_id, status);
create index if not exists idx_listings_category on listings(category_id);
create index if not exists idx_products_listing on products(listing_id);
create index if not exists idx_listings_name_trgm on listings using gin (name gin_trgm_ops);
create index if not exists idx_listings_bio_trgm on listings using gin (bio gin_trgm_ops);

-- RLS --------------------------------------------------------
alter table villages       enable row level security;
alter table categories     enable row level security;
alter table profiles       enable row level security;
alter table listings       enable row level security;
alter table products       enable row level security;
alter table order_intents  enable row level security;

-- Public read on catalogue + profiles
create policy "public read villages"   on villages   for select using (true);
create policy "public read categories" on categories for select using (true);
create policy "public read profiles"   on profiles   for select using (true);
create policy "public read listings"   on listings   for select using (true);
create policy "public read products"   on products   for select using (true);

-- TEMPORARY: anyone can insert an order intent (auth still mock).
-- TODO(real-auth): replace with  with check (auth.uid()::text = user_id)  + a select policy.
create policy "temp anon insert orders" on order_intents for insert with check (true);
```

- [ ] **Step 2: Verify it parses locally (lint only, no DB needed)**

There is no local Postgres in CI. Visually confirm the SQL is balanced (every `create` terminated, `do $$ ... $$` blocks closed). No command to run.

- [ ] **Step 3: Commit**
```bash
git add supabase/migrations/20260530120000_data_layer.sql
git commit -m "feat(db): Supabase schema migration — 6 tables, indexes, public-read RLS"
```

- [ ] **Step 4: OWNER MANUAL STEP (document, do not block)**

Add to the PROGRESS file (Task 8) a note that the owner must paste this file into the Supabase SQL editor (project `nseuurovkxymrwxamftz`) and run it once. The agent cannot run it (no DB access from CI).

---

### Task 2: Seed data

**Files:**
- Modify (replace placeholder): `supabase/seed.sql`

- [ ] **Step 1: Write the seed**

Replace `supabase/seed.sql` entirely with (rows mirror `lib/data/repositories/mock/mock_data.dart`; owner profiles `u1`–`u8` + demo `u_demo`):

```sql
-- ============================================================
-- WASALNI — Seed data (mirrors mock_data.dart). Idempotent.
-- ============================================================

insert into villages (id, name, governorate, markaz) values
  ('v_kafr','كفر المقدام','الدقهلية','ميت غمر'),
  ('v_tahna','تفهنا الأشراف','الدقهلية','أجا')
on conflict (id) do nothing;

insert into categories (id, name, slug, icon_name, kind, sort_order) values
  ('cat_plumb','سباكة','plumbing','plumbing','service',1),
  ('cat_elec','كهرباء','electric','electrical_services','service',2),
  ('cat_carp','نجارة','carpentry','carpenter','service',3),
  ('cat_pharm','صيدلية','pharmacy','local_pharmacy','shop',4),
  ('cat_groc','بقالة','grocery','storefront','shop',5),
  ('cat_tuktuk','توك توك','tuktuk','electric_rickshaw','transport',6)
on conflict (id) do nothing;

insert into profiles (id, phone, display_name, created_at) values
  ('u_demo','+201000000000','أحمد','2026-01-01T00:00:00Z'),
  ('u1','+201000000001','مالك 1','2026-01-01T00:00:00Z'),
  ('u2','+201000000002','مالك 2','2026-01-01T00:00:00Z'),
  ('u3','+201000000003','مالك 3','2026-01-01T00:00:00Z'),
  ('u4','+201000000004','مالك 4','2026-01-01T00:00:00Z'),
  ('u5','+201000000005','مالك 5','2026-01-01T00:00:00Z'),
  ('u6','+201000000006','مالك 6','2026-01-01T00:00:00Z'),
  ('u7','+201000000007','مالك 7','2026-01-01T00:00:00Z'),
  ('u8','+201000000008','مالك 8','2026-01-01T00:00:00Z')
on conflict (id) do nothing;

insert into listings
  (id, kind, owner_id, village_id, category_id, name, bio, phone_whatsapp,
   status, is_verified, is_featured, plan, created_at) values
  ('l1','service','u1','v_kafr','cat_plumb','سباك الأسطى محمود','سباكة وتسليك وتركيب سخانات','+201000000001','active',true,true,'prime','2026-01-02T00:00:00Z'),
  ('l2','service','u2','v_kafr','cat_elec','كهربائي العمدة','تأسيس وصيانة كهرباء المنازل','+201000000002','active',true,false,'free','2026-01-03T00:00:00Z'),
  ('l3','service','u3','v_kafr','cat_carp','نجار الخير','موبيليا وأبواب وشبابيك','+201000000003','active',false,false,'free','2026-01-04T00:00:00Z'),
  ('l4','shop','u4','v_kafr','cat_pharm','صيدلية الشفاء','أدوية ومستلزمات طبية — توصيل متاح','+201000000004','active',true,true,'free','2026-01-05T00:00:00Z'),
  ('l5','shop','u5','v_kafr','cat_groc','بقالة أبو أحمد','كل لوازم البيت','+201000000005','active',false,false,'free','2026-01-06T00:00:00Z'),
  ('l6','transport','u6','v_kafr','cat_tuktuk','توك توك الصاوي','نقل داخل القرية والعزب المجاورة','+201000000006','active',false,false,'free','2026-01-07T00:00:00Z'),
  ('l7','shop','u7','v_tahna','cat_groc','سوبر ماركت تفهنا','بقالة وخضار وفاكهة','+201000000007','active',true,false,'free','2026-01-08T00:00:00Z'),
  ('l8','service','u8','v_tahna','cat_plumb','سباك تفهنا','صيانة سريعة','+201000000008','active',false,false,'free','2026-01-09T00:00:00Z')
on conflict (id) do nothing;

insert into products (id, listing_id, name, description, price_egp, is_available) values
  ('p1','l4','بنادول إكسترا','علبة 24 قرص',35,true),
  ('p2','l4','فوار فيتامين سي','10 أكياس',45,true),
  ('p3','l4','كمامات طبية','علبة 50',30,false),
  ('p4','l5','زيت عافية 1 لتر','زيت دوار الشمس',60,true),
  ('p5','l5','سكر 1 كيلو','سكر أبيض',30,true),
  ('p6','l5','شاي العروسة','علبة 250 جرام',40,true),
  ('p7','l7','أرز مصري 1 كيلو','أرز شعير',35,true)
on conflict (id) do nothing;
```

- [ ] **Step 2: Commit**
```bash
git add supabase/seed.sql
git commit -m "feat(db): seed data mirroring mock_data (villages, categories, listings, products, profiles)"
```

- [ ] **Step 3: OWNER MANUAL STEP (document)**

Note in PROGRESS that the owner runs `seed.sql` in the SQL editor after the migration.

---

### Task 3: Supabase client init

**Files:**
- Create: `apps/mobile/lib/core/supabase/supabase_init.dart`
- Modify: `apps/mobile/lib/main.dart`

- [ ] **Step 1: Write the init helper**

Create `apps/mobile/lib/core/supabase/supabase_init.dart`:

```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Initialises the Supabase client from `.env` (SUPABASE_URL + SUPABASE_ANON_KEY).
/// Call once in main() before setupDi().
Future<void> initSupabase() async {
  await dotenv.load(fileName: '.env');
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );
}

/// The shared Supabase client.
SupabaseClient get supabaseClient => Supabase.instance.client;
```

- [ ] **Step 2: Wire it into main()**

Replace `apps/mobile/lib/main.dart` with:

```dart
import 'package:flutter/material.dart';
import 'app/app.dart';
import 'app/di.dart';
import 'core/supabase/supabase_init.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initSupabase();
  setupDi();
  runApp(const App());
}
```

- [ ] **Step 3: Confirm `.env` has the keys**

The `.env` (gitignored, at `apps/mobile/.env`) must contain:
```
SUPABASE_URL=https://nseuurovkxymrwxamftz.supabase.co
SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5zZXV1cm92a3h5bXJ3eGFtZnR6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzkxNDk4MTUsImV4cCI6MjA5NDcyNTgxNX0.XBy2WVKB2GelSCF4KIHQ9lJMxHLmY34hkoaWUpWacPM
```
If a key line is missing, add it (do NOT commit `.env`; it is gitignored).

- [ ] **Step 4: analyze + full suite (tests must stay green — they don't init Supabase)**
```bash
flutter analyze
flutter test
```
Expected: clean + 140 passing. (Tests use mock repos and never call `initSupabase`.)

- [ ] **Step 5: Commit**
```bash
git add apps/mobile/lib/core/supabase/supabase_init.dart apps/mobile/lib/main.dart
git commit -m "feat(supabase): client init from .env, wired into main()"
```

---

### Task 4: Mappers (row ↔ model) + unit tests

**Files:**
- Create: `apps/mobile/lib/data/repositories/supabase/mappers.dart`
- Test: `apps/mobile/test/data/repositories/supabase/mappers_test.dart`

- [ ] **Step 1: Write the failing test**

Create `apps/mobile/test/data/repositories/supabase/mappers_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:wasalni/data/models/enums.dart';
import 'package:wasalni/data/models/order_intent.dart';
import 'package:wasalni/data/repositories/supabase/mappers.dart';

void main() {
  test('villageFromRow maps all fields', () {
    final v = villageFromRow({
      'id': 'v_kafr', 'name': 'كفر المقدام',
      'governorate': 'الدقهلية', 'markaz': 'ميت غمر',
    });
    expect(v.id, 'v_kafr');
    expect(v.name, 'كفر المقدام');
    expect(v.markaz, 'ميت غمر');
  });

  test('categoryFromRow parses kind enum + sort_order', () {
    final c = categoryFromRow({
      'id': 'cat_plumb', 'name': 'سباكة', 'slug': 'plumbing',
      'icon_name': 'plumbing', 'kind': 'service', 'sort_order': 1,
    });
    expect(c.kind, ListingKind.service);
    expect(c.sortOrder, 1);
  });

  test('listingFromRow parses enums, bools, timestamp, null logo', () {
    final l = listingFromRow({
      'id': 'l1', 'kind': 'shop', 'owner_id': 'u4', 'village_id': 'v_kafr',
      'category_id': 'cat_pharm', 'name': 'صيدلية الشفاء', 'bio': 'أدوية',
      'phone_whatsapp': '+201000000004', 'logo_url': null,
      'status': 'active', 'is_verified': true, 'is_featured': true,
      'plan': 'prime', 'is_temporarily_closed': false,
      'created_at': '2026-01-05T00:00:00Z',
    });
    expect(l.kind, ListingKind.shop);
    expect(l.status, ListingStatus.active);
    expect(l.plan, ListingPlan.prime);
    expect(l.isVerified, isTrue);
    expect(l.logoUrl, isNull);
    expect(l.createdAt.year, 2026);
  });

  test('productFromRow parses price as double + availability', () {
    final p = productFromRow({
      'id': 'p1', 'listing_id': 'l4', 'name': 'بنادول', 'description': 'علبة',
      'price_egp': 35, 'image_url': null, 'is_available': false, 'sort_order': 0,
    });
    expect(p.priceEgp, 35.0);
    expect(p.isAvailable, isFalse);
    expect(p.listingId, 'l4');
  });

  test('orderIntentToRow round-trips the fields the table needs', () {
    final intent = OrderIntent(
      id: 'l4-123', shopId: 'l4', shopName: 'صيدلية', shopPhone: '+20100',
      message: 'طلب', totalEgp: 80, itemCount: 2,
      createdAt: DateTime.utc(2026, 1, 5),
    );
    final row = orderIntentToRow(intent, userId: 'u_demo');
    expect(row['id'], 'l4-123');
    expect(row['user_id'], 'u_demo');
    expect(row['shop_id'], 'l4');
    expect(row['total_egp'], 80);
    expect(row['item_count'], 2);
  });
}
```

- [ ] **Step 2: Run → fails (mappers.dart doesn't exist)**

Run: `flutter test test/data/repositories/supabase/mappers_test.dart`
Expected: compile error (URI doesn't resolve).

- [ ] **Step 3: Write the mappers**

Create `apps/mobile/lib/data/repositories/supabase/mappers.dart`:

```dart
import '../../models/category.dart';
import '../../models/enums.dart';
import '../../models/listing.dart';
import '../../models/order_intent.dart';
import '../../models/product.dart';
import '../../models/village.dart';

typedef Row = Map<String, dynamic>;

ListingKind _kind(String v) => ListingKind.values.byName(v);
ListingStatus _status(String v) => ListingStatus.values.byName(v);
ListingPlan _plan(String v) => ListingPlan.values.byName(v);
double _toDouble(Object? v) => (v as num).toDouble();

Village villageFromRow(Row r) => Village(
      id: r['id'] as String,
      name: r['name'] as String,
      governorate: r['governorate'] as String,
      markaz: r['markaz'] as String,
    );

Category categoryFromRow(Row r) => Category(
      id: r['id'] as String,
      name: r['name'] as String,
      slug: r['slug'] as String,
      iconName: r['icon_name'] as String,
      kind: _kind(r['kind'] as String),
      sortOrder: (r['sort_order'] as num?)?.toInt() ?? 0,
    );

Listing listingFromRow(Row r) => Listing(
      id: r['id'] as String,
      kind: _kind(r['kind'] as String),
      ownerId: (r['owner_id'] as String?) ?? '',
      villageId: r['village_id'] as String,
      categoryId: r['category_id'] as String,
      name: r['name'] as String,
      bio: (r['bio'] as String?) ?? '',
      phoneWhatsapp: r['phone_whatsapp'] as String,
      logoUrl: r['logo_url'] as String?,
      status: _status(r['status'] as String),
      isVerified: (r['is_verified'] as bool?) ?? false,
      isFeatured: (r['is_featured'] as bool?) ?? false,
      plan: _plan(r['plan'] as String),
      isTemporarilyClosed: (r['is_temporarily_closed'] as bool?) ?? false,
      createdAt: DateTime.parse(r['created_at'] as String),
    );

Product productFromRow(Row r) => Product(
      id: r['id'] as String,
      listingId: r['listing_id'] as String,
      name: r['name'] as String,
      description: (r['description'] as String?) ?? '',
      priceEgp: _toDouble(r['price_egp']),
      imageUrl: r['image_url'] as String?,
      isAvailable: (r['is_available'] as bool?) ?? true,
      sortOrder: (r['sort_order'] as num?)?.toInt() ?? 0,
    );

Row orderIntentToRow(OrderIntent i, {required String userId}) => {
      'id': i.id,
      'user_id': userId,
      'shop_id': i.shopId,
      'shop_name': i.shopName,
      'shop_phone': i.shopPhone,
      'message': i.message,
      'total_egp': i.totalEgp,
      'item_count': i.itemCount,
      'created_at': i.createdAt.toIso8601String(),
    };
```

- [ ] **Step 4: Run → passes; analyze**
```bash
flutter test test/data/repositories/supabase/mappers_test.dart
flutter analyze
```
Expected: 5 pass, analyze clean.

- [ ] **Step 5: Commit**
```bash
git add apps/mobile/lib/data/repositories/supabase/mappers.dart apps/mobile/test/data/repositories/supabase/mappers_test.dart
git commit -m "feat(supabase): row<->model mappers + unit tests"
```

---

### Task 5: Village + Category + Product repos

**Files:**
- Create: `apps/mobile/lib/data/repositories/supabase/supabase_village_repository.dart`
- Create: `apps/mobile/lib/data/repositories/supabase/supabase_category_repository.dart`
- Create: `apps/mobile/lib/data/repositories/supabase/supabase_product_repository.dart`

**Context:** These three are the simplest (no search). Each takes a `SupabaseClient`, queries a table, maps rows, and translates errors. Postgrest throws `PostgrestException` on server errors and `SocketException`/`ClientException` on network failure. We translate any error to the existing `RepositoryException` subtypes so screens behave exactly as with the mocks. `getProductById` returns `NotFoundException` when no row matches.

- [ ] **Step 1: Write the village repo**

Create `apps/mobile/lib/data/repositories/supabase/supabase_village_repository.dart`:

```dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/network/repository_exception.dart';
import '../../models/village.dart';
import '../village_repository.dart';
import 'mappers.dart';

class SupabaseVillageRepository implements VillageRepository {
  SupabaseVillageRepository(this._client);
  final SupabaseClient _client;

  @override
  Future<List<Village>> getVillages() async {
    try {
      final rows = await _client.from('villages').select().order('name');
      return rows.map((r) => villageFromRow(r)).toList();
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (_) {
      throw const NoConnectionException();
    }
  }
}
```

- [ ] **Step 2: Write the category repo**

Create `apps/mobile/lib/data/repositories/supabase/supabase_category_repository.dart`:

```dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/network/repository_exception.dart';
import '../../models/category.dart';
import '../../models/enums.dart';
import '../category_repository.dart';
import 'mappers.dart';

class SupabaseCategoryRepository implements CategoryRepository {
  SupabaseCategoryRepository(this._client);
  final SupabaseClient _client;

  @override
  Future<List<Category>> getCategories({ListingKind? kind}) async {
    try {
      var query = _client.from('categories').select();
      if (kind != null) query = query.eq('kind', kind.name);
      final rows = await query.order('sort_order');
      return rows.map((r) => categoryFromRow(r)).toList();
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (_) {
      throw const NoConnectionException();
    }
  }
}
```

- [ ] **Step 3: Write the product repo**

Create `apps/mobile/lib/data/repositories/supabase/supabase_product_repository.dart`:

```dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/network/repository_exception.dart';
import '../../models/product.dart';
import '../product_repository.dart';
import 'mappers.dart';

class SupabaseProductRepository implements ProductRepository {
  SupabaseProductRepository(this._client);
  final SupabaseClient _client;

  @override
  Future<List<Product>> getProducts({required String shopId}) async {
    try {
      final rows = await _client
          .from('products')
          .select()
          .eq('listing_id', shopId)
          .order('sort_order');
      return rows.map((r) => productFromRow(r)).toList();
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (_) {
      throw const NoConnectionException();
    }
  }

  @override
  Future<Product> getProductById(String id) async {
    try {
      final row =
          await _client.from('products').select().eq('id', id).maybeSingle();
      if (row == null) throw const NotFoundException();
      return productFromRow(row);
    } on NotFoundException {
      rethrow;
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (_) {
      throw const NoConnectionException();
    }
  }
}
```

- [ ] **Step 4: analyze (no unit tests — these are thin DB wrappers verified manually in Task 8)**
```bash
flutter analyze
```
Expected: clean.

- [ ] **Step 5: Commit**
```bash
git add apps/mobile/lib/data/repositories/supabase/supabase_village_repository.dart apps/mobile/lib/data/repositories/supabase/supabase_category_repository.dart apps/mobile/lib/data/repositories/supabase/supabase_product_repository.dart
git commit -m "feat(supabase): village, category, product repositories"
```

---

### Task 6: Listing repo (feed + search + getById)

**Files:**
- Create: `apps/mobile/lib/data/repositories/supabase/supabase_listing_repository.dart`

**Context:** Mirrors `MockListingRepository`: `getFeed` filters `village_id` + `status='active'` (+ optional `kind`, `category_id`), ordered featured-first then newest; `getById` throws `NotFoundException` when missing; `search` matches name OR bio case-insensitively within a village (empty query → empty list, same as the mock). Postgrest's `.or()` takes a comma-separated filter string; `ilike` with `%query%` does the contains match (trigram index speeds it up).

- [ ] **Step 1: Write the listing repo**

Create `apps/mobile/lib/data/repositories/supabase/supabase_listing_repository.dart`:

```dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/network/repository_exception.dart';
import '../../models/enums.dart';
import '../../models/listing.dart';
import '../listing_repository.dart';
import 'mappers.dart';

class SupabaseListingRepository implements ListingRepository {
  SupabaseListingRepository(this._client);
  final SupabaseClient _client;

  @override
  Future<List<Listing>> getFeed({
    required String villageId,
    ListingKind? kind,
    String? categoryId,
  }) async {
    try {
      var query = _client
          .from('listings')
          .select()
          .eq('village_id', villageId)
          .eq('status', 'active');
      if (kind != null) query = query.eq('kind', kind.name);
      if (categoryId != null) query = query.eq('category_id', categoryId);
      // Featured first, then newest.
      final rows = await query
          .order('is_featured', ascending: false)
          .order('created_at', ascending: false);
      return rows.map((r) => listingFromRow(r)).toList();
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (_) {
      throw const NoConnectionException();
    }
  }

  @override
  Future<Listing> getById(String id) async {
    try {
      final row =
          await _client.from('listings').select().eq('id', id).maybeSingle();
      if (row == null) throw const NotFoundException();
      return listingFromRow(row);
    } on NotFoundException {
      rethrow;
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (_) {
      throw const NoConnectionException();
    }
  }

  @override
  Future<List<Listing>> search({
    required String villageId,
    required String query,
  }) async {
    final q = query.trim();
    if (q.isEmpty) return const [];
    try {
      final rows = await _client
          .from('listings')
          .select()
          .eq('village_id', villageId)
          .eq('status', 'active')
          .or('name.ilike.%$q%,bio.ilike.%$q%');
      return rows.map((r) => listingFromRow(r)).toList();
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (_) {
      throw const NoConnectionException();
    }
  }
}
```

- [ ] **Step 2: analyze**
```bash
flutter analyze
```
Expected: clean.

- [ ] **Step 3: Commit**
```bash
git add apps/mobile/lib/data/repositories/supabase/supabase_listing_repository.dart
git commit -m "feat(supabase): listing repository (feed, search, getById)"
```

---

### Task 7: Order repo + DI swap

**Files:**
- Create: `apps/mobile/lib/data/repositories/supabase/supabase_order_repository.dart`
- Modify: `apps/mobile/lib/app/di.dart`

**Context:** The order repo inserts one `order_intents` row using the demo seed id as `user_id` (auth is still mock — see spec scaffolding note). When real auth lands, the user id comes from the session and the temporary RLS tightens. After this task the four read repos + order repo all point at Supabase; `MockAuthRepository` stays.

- [ ] **Step 1: Write the order repo**

Create `apps/mobile/lib/data/repositories/supabase/supabase_order_repository.dart`:

```dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/network/repository_exception.dart';
import '../../models/order_intent.dart';
import '../order_repository.dart';
import 'mappers.dart';

class SupabaseOrderRepository implements OrderRepository {
  SupabaseOrderRepository(this._client);
  final SupabaseClient _client;

  /// Seed account id used while auth is still mock. Replaced by the real
  /// session user id when Supabase auth lands.
  static const _demoUserId = 'u_demo';

  @override
  Future<void> recordIntent(OrderIntent intent) async {
    try {
      await _client
          .from('order_intents')
          .insert(orderIntentToRow(intent, userId: _demoUserId));
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (_) {
      throw const NoConnectionException();
    }
  }
}
```

- [ ] **Step 2: Swap the repos in di.dart**

In `apps/mobile/lib/app/di.dart`:

(a) Add imports next to the existing repo imports:
```dart
import '../core/supabase/supabase_init.dart';
import '../data/repositories/supabase/supabase_category_repository.dart';
import '../data/repositories/supabase/supabase_listing_repository.dart';
import '../data/repositories/supabase/supabase_order_repository.dart';
import '../data/repositories/supabase/supabase_product_repository.dart';
import '../data/repositories/supabase/supabase_village_repository.dart';
```

(b) Replace these five registration lines:
```dart
    ..registerLazySingleton<ListingRepository>(MockListingRepository.new)
    ..registerLazySingleton<VillageRepository>(MockVillageRepository.new)
    ..registerLazySingleton<CategoryRepository>(MockCategoryRepository.new)
    ..registerLazySingleton<ProductRepository>(MockProductRepository.new)
```
…and the order line:
```dart
    ..registerLazySingleton<OrderRepository>(MockOrderRepository.new)
```
with:
```dart
    ..registerLazySingleton<ListingRepository>(() => SupabaseListingRepository(supabaseClient))
    ..registerLazySingleton<VillageRepository>(() => SupabaseVillageRepository(supabaseClient))
    ..registerLazySingleton<CategoryRepository>(() => SupabaseCategoryRepository(supabaseClient))
    ..registerLazySingleton<ProductRepository>(() => SupabaseProductRepository(supabaseClient))
    ..registerLazySingleton<OrderRepository>(() => SupabaseOrderRepository(supabaseClient))
```
Keep `AuthRepository` on `MockAuthRepository.new`. Leave the now-unused `Mock*Repository` imports for the read repos **only if** analyze complains about unused imports — if it does, remove the specific unused mock imports (`mock_listing_repository`, `mock_village_repository`, `mock_category_repository`, `mock_product_repository`, `mock_order_repository`). The mock files themselves stay (tests import them directly).

- [ ] **Step 3: analyze + full suite**
```bash
flutter analyze
flutter test
```
Expected: clean + 145 passing (140 existing + 5 mapper tests). Tests don't hit Supabase — they construct mock repos directly.

- [ ] **Step 4: Commit**
```bash
git add apps/mobile/lib/data/repositories/supabase/supabase_order_repository.dart apps/mobile/lib/app/di.dart
git commit -m "feat(supabase): order repository + swap read/order repos to Supabase in DI"
```

---

### Task 8: Manual verification + PROGRESS

**Files:**
- Create: `docs/superpowers/plans/PROGRESS-phase8-supabase-data.md`

- [ ] **Step 1: Owner runs the SQL (manual, gated)**

Tell the owner to, in the Supabase dashboard (project `nseuurovkxymrwxamftz`) → SQL Editor:
1. Paste & run `supabase/migrations/20260530120000_data_layer.sql`.
2. Paste & run `supabase/seed.sql`.
3. Confirm in Table Editor that `listings` has 8 rows, `products` 7, `categories` 6, `villages` 2, `profiles` 9.

- [ ] **Step 2: Build & run the web preview**

From `apps/mobile`:
```bash
flutter build web --no-tree-shake-icons
py -3 serve_web.py
```
Open `http://127.0.0.1:8080`. Verify against **real data**:
- Feed shows the 6 Kafr listings (featured first), village filter switches to Tahna's 2.
- Categories screen shows 6 categories.
- A shop (صيدلية الشفاء) shows its 3 products; كمامات shows unavailable.
- Search "سباك" returns the plumbers.
- Add a product to cart → send order → a new row appears in `order_intents` (check Table Editor).

- [ ] **Step 3: Write PROGRESS**

Create `docs/superpowers/plans/PROGRESS-phase8-supabase-data.md` recording: tasks done, the two SQL files the owner ran, the manual smoke results, final test count, and the deferred items (real auth + tighten order RLS, remaining 6 tables). Note the temporary anon-insert order policy explicitly as tech-debt.

- [ ] **Step 4: Commit**
```bash
git add docs/superpowers/plans/PROGRESS-phase8-supabase-data.md
git commit -m "docs: Phase 8 progress — Supabase data layer live + manual smoke"
```

- [ ] **Step 5: Final review**

Dispatch a code-review subagent over the whole Phase 8 diff. Verify: enums/columns match Dart models; RLS is read-only on catalogue + temporary anon-insert on orders (with the TODO); mappers handle nulls; repos translate errors to the existing exceptions; DI swap complete; `AuthRepository` still mock; analyze clean + suite green.

---

## Self-Review

**Spec coverage:**
- Migration (extensions, enums, 6 tables, indexes, RLS) → Task 1 ✅
- Seed mirroring mock_data → Task 2 ✅
- Supabase client from `.env` + main() → Task 3 ✅
- Mappers + unit tests → Task 4 ✅
- 4 read repos → Tasks 5, 6 ✅
- Order repo (anon insert, demo user id) → Task 7 ✅
- DI swap, auth stays mock, mocks kept for tests → Task 7 ✅
- Error translation to existing exceptions → Tasks 5, 6, 7 ✅
- Manual verification (no live CI tests) → Task 8 ✅

**Placeholder scan:** none — every step has full SQL/Dart/commands.

**Type consistency:** mapper names (`villageFromRow`, `categoryFromRow`, `listingFromRow`, `productFromRow`, `orderIntentToRow`) are identical across Task 4 (definition + tests) and Tasks 5–7 (callers). Repo class names match the DI imports in Task 7. Enum `.name` strings (`service`/`shop`/`transport`, `active`, `free`/`prime`) match the SQL enum values in Task 1 and `enums.dart`. Column names in mappers (snake_case) match the migration columns exactly.

**Note on `query` reassignment (Tasks 5–6):** the postgrest builder is reassigned via `var query = ...; query = query.eq(...)`. This compiles because `.select()` returns a `PostgrestFilterBuilder` and `.eq()` returns the same type; `.order()` (a transform) is only applied inline in the final `await`, never reassigned to the filter var — correct per supabase_flutter 2.x.
