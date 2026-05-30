# Design — Phase 8: Supabase Data Layer (read + orders)

> **Date:** 2026-05-30
> **Branch:** `002-rebuild-from-zero`
> **Status:** Approved (owner, 2026-05-30)

## Goal

Swap the mock data sources for a real Supabase backend **without touching any screen**. Every screen already talks to a `Repository` interface, so we write a `Supabase*` implementation of each repo and switch it at the single SWAP POINT in `lib/app/di.dart`.

## Resolved decisions (owner, 2026-05-30)

- **Scope:** read repos (villages, categories, listings, products) + order writes. Auth stays mock (`1234`). Verification / favorites / admin tables deferred.
- **Listings shape:** one unified `listings` table with a `kind` column + `attributes jsonb` (per `return_to_zero/قرارات_قاعدة_البيانات.docx`, option A).
- **IDs:** keep the existing text IDs from the mock (`v_kafr`, `l1`, `p1`, `u_demo`…) as `text` primary keys — so the seed matches the current code and orders work immediately. (Real UUIDs come with real auth.)
- **Orders scaffolding:** auth is still mock, so there is no real `auth.uid()`. Orders are written with the seed account's id and an RLS policy that allows `insert` for `anon`. This is explicitly temporary — tightened to `auth.uid() = user_id` when real auth lands.
- **Existing project:** continue on the current Supabase project (it is effectively empty — only placeholder migrations/seed). Clean any stray tables with SQL if needed; do not recreate the project.

## Architecture

```
Screens → Repository interface (unchanged) → Supabase*Repository → SupabaseClient → Postgres
                                              ↑ swapped in di.dart (SWAP POINT)
```

### 1. SQL migration — `supabase/migrations/<ts>_data_layer.sql`

Replaces the placeholder migration. Contains, in order:

1. **Extensions:** `uuid-ossp` (already), `pg_trgm` (for Arabic name/bio search).
2. **Enums:** `listing_kind` (`service`,`shop`,`transport`), `listing_status` (`draft`,`pending`,`active`,`rejected`,`suspended`,`deactivated`,`expired`), `listing_plan` (`free`,`prime`) — values match `lib/data/models/enums.dart` exactly.
3. **Tables** (text PKs to match seed/mock):

| table | columns |
|---|---|
| `villages` | `id text pk`, `name text`, `governorate text`, `markaz text` |
| `categories` | `id text pk`, `name text`, `slug text`, `icon_name text`, `kind listing_kind`, `sort_order int default 0` |
| `profiles` | `id text pk`, `phone text`, `display_name text`, `village_id text null refs villages`, `created_at timestamptz default now()` |
| `listings` | `id text pk`, `kind listing_kind`, `owner_id text refs profiles`, `village_id text refs villages`, `category_id text refs categories`, `name text`, `bio text`, `phone_whatsapp text`, `logo_url text null`, `status listing_status default 'active'`, `is_verified bool default false`, `is_featured bool default false`, `plan listing_plan default 'free'`, `is_temporarily_closed bool default false`, `attributes jsonb default '{}'`, `created_at timestamptz` |
| `products` | `id text pk`, `listing_id text refs listings`, `name text`, `description text`, `price_egp numeric`, `image_url text null`, `is_available bool default true`, `sort_order int default 0` |
| `order_intents` | `id text pk`, `user_id text refs profiles`, `shop_id text`, `shop_name text`, `shop_phone text`, `message text`, `total_egp numeric`, `item_count int`, `created_at timestamptz default now()` |

4. **Indexes:** `listings(village_id, status)`, `listings(category_id)`, `products(listing_id)`, GIN trigram on `listings.name` + `listings.bio` for search.
5. **RLS** (enable on all):
   - `villages`, `categories`, `listings`, `products`, `profiles`: `select` policy `using (true)` for `anon` + `authenticated`. No insert/update/delete.
   - `order_intents`: `insert` policy `with check (true)` for `anon` — **TEMPORARY** (commented: tighten to `auth.uid()::text = user_id` with real auth). No select from the app.

### 2. Seed — `supabase/seed.sql`

Exact rows from `lib/data/repositories/mock/mock_data.dart`: 2 villages, 6 categories, 8 listings, 7 products — plus seed profiles for the listing owners (`u1`–`u8`) and the demo account (`u_demo`, phone `+201000000000`, name `أحمد`). Idempotent (`on conflict (id) do nothing`) so re-running is safe.

### 3. Supabase client — `lib/core/supabase/supabase_init.dart`

`initSupabase()` reads `SUPABASE_URL` + `SUPABASE_ANON_KEY` from `.env` (via `flutter_dotenv`, already a dep) and calls `Supabase.initialize`. Called in `main()` before `setupDi()`. A `supabaseClient` getter exposes `Supabase.instance.client`.

### 4. Supabase repositories — `lib/data/repositories/supabase/`

One file per repo, each implementing the existing interface:
- `supabase_village_repository.dart`, `supabase_category_repository.dart`, `supabase_listing_repository.dart`, `supabase_product_repository.dart`, `supabase_order_repository.dart`.
- Each wraps client calls in try/catch → maps `SocketException`/network errors to `NoConnectionException`, empty single-row fetches to `NotFoundException` (same contract the mocks throw).
- Query shapes mirror the mock logic: feed filters `village_id` + `status='active'` (+ optional `kind`/`category_id`), featured-first then newest; search uses `ilike`/trigram on name+bio; products filter `listing_id`.

### 5. Mappers — `lib/data/repositories/supabase/mappers.dart`

Pure functions `villageFromRow`, `categoryFromRow`, `listingFromRow`, `productFromRow`, and `orderIntentToRow`. Convert snake_case JSON ↔ freezed models, parse enums from strings, parse timestamps. **Unit-tested** (the one piece with real logic worth testing in CI).

### 6. DI swap — `lib/app/di.dart`

At the SWAP POINT, replace the four read mocks + the order mock with the Supabase versions. `MockAuthRepository` stays. Keep the mock repo files in the tree (still used by existing widget/unit tests).

## Error handling

Supabase/Postgres errors are translated to the existing `RepositoryException` subtypes so screens (feed/search/detail/products/cart) handle them unchanged: no-internet → offline view + retry, not-found → not-found view, other → generic error view.

## Testing

- **Mappers:** unit tests for every `*FromRow` / `toRow` (enum parsing, nulls, timestamps).
- **Existing suite (140 tests):** stays green — they use the mock repos directly, untouched.
- **No live-Supabase integration tests in CI** (flaky, needs network/keys). Verification is manual: run the web build and confirm the feed/categories/products load from real data, and that sending an order inserts a row in `order_intents`.
- **Gate:** `flutter analyze` clean + full suite green.

## Out of scope (deferred)

Real Supabase auth + tightened order RLS, verification (encrypted ID images), favorites, admin/audit tables, listing photos gallery, app_settings. These are the remaining 6 of the 12 planned tables.
