-- MN Tech Cell - estrutura do Supabase
-- Execute no SQL Editor do projeto Supabase.

create table if not exists public.categories (
  id text primary key,
  owner_id uuid not null references auth.users(id) on delete cascade,
  name text not null,
  parent_id text null references public.categories(id) on delete set null,
  created_at timestamptz not null default now()
);

create table if not exists public.products (
  id text primary key,
  owner_id uuid not null references auth.users(id) on delete cascade,
  name text not null,
  category_id text null references public.categories(id) on delete set null,
  sku text null,
  qty integer not null default 0 check (qty >= 0),
  min_qty integer not null default 0 check (min_qty >= 0),
  cost_price numeric(12,2) not null default 0,
  sale_price numeric(12,2) not null default 0,
  created_at timestamptz not null default now()
);

create table if not exists public.movements (
  id text primary key,
  owner_id uuid not null references auth.users(id) on delete cascade,
  product_id text not null references public.products(id) on delete restrict,
  type text not null check (type in ('in','out')),
  qty integer not null check (qty > 0),
  cost_price numeric(12,2) not null default 0,
  sale_price numeric(12,2) not null default 0,
  timestamp timestamptz not null default now()
);

create index if not exists products_sku_idx on public.products (sku) where sku is not null and sku <> '';
create index if not exists categories_owner_id_idx on public.categories(owner_id);
create index if not exists products_owner_id_idx on public.products(owner_id);
create index if not exists movements_owner_id_idx on public.movements(owner_id);
create index if not exists products_category_id_idx on public.products (category_id);
create index if not exists movements_product_id_idx on public.movements (product_id);
create index if not exists movements_timestamp_idx on public.movements ("timestamp" desc);

alter table public.categories enable row level security;
alter table public.products enable row level security;
alter table public.movements enable row level security;

-- Cada cliente acessa somente os dados vinculados à própria conta.
revoke all privileges on table public.categories, public.products, public.movements from anon;
revoke all privileges on table public.categories, public.products, public.movements from authenticated;
grant select, insert, update, delete on table public.categories, public.products, public.movements to authenticated;

drop policy if exists "mntech_categories_anon_all" on public.categories;
drop policy if exists "mntech_products_anon_all" on public.products;
drop policy if exists "mntech_movements_anon_all" on public.movements;
drop policy if exists "mntech_categories_authenticated_all" on public.categories;
drop policy if exists "mntech_products_authenticated_all" on public.products;
drop policy if exists "mntech_movements_authenticated_all" on public.movements;
drop policy if exists mntech_categories_owner_all on public.categories;
drop policy if exists mntech_products_owner_all on public.products;
drop policy if exists mntech_movements_owner_all on public.movements;

create policy mntech_categories_owner_all on public.categories
  for all to authenticated using ((select auth.uid()) = owner_id)
  with check ((select auth.uid()) = owner_id);
create policy mntech_products_owner_all on public.products
  for all to authenticated using ((select auth.uid()) = owner_id)
  with check ((select auth.uid()) = owner_id);
create policy mntech_movements_owner_all on public.movements
  for all to authenticated using ((select auth.uid()) = owner_id)
  with check ((select auth.uid()) = owner_id);

-- Realtime: enable categories, products and movements in supabase_realtime.
