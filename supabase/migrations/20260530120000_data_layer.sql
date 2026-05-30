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
