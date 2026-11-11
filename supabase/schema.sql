-- MN Tech Cell - estrutura do Supabase
-- Execute no SQL Editor do projeto Supabase.

create table if not exists public.categories (
  id text primary key,
  name text not null,
  parent_id text null references public.categories(id) on delete set null,
  created_at timestamptz not null default now()
);

create table if not exists public.products (
  id text primary key,
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
  product_id text not null references public.products(id) on delete restrict,
  type text not null check (type in ('in','out')),
  qty integer not null check (qty > 0),
  cost_price numeric(12,2) not null default 0,
  sale_price numeric(12,2) not null default 0,
  timestamp timestamptz not null default now()
);

create index if not exists products_sku_idx on public.products (sku);
create index if not exists products_category_id_idx on public.products (category_id);
create index if not exists movements_product_id_idx on public.movements (product_id);
create index if not exists movements_timestamp_idx on public.movements ("timestamp" desc);

alter table public.categories enable row level security;
alter table public.products enable row level security;
alter table public.movements enable row level security;

-- Somente usuários autenticados podem consultar ou alterar dados.
drop policy if exists "mntech_categories_anon_all" on public.categories;
drop policy if exists "mntech_products_anon_all" on public.products;
drop policy if exists "mntech_movements_anon_all" on public.movements;
drop policy if exists "mntech_categories_authenticated_all" on public.categories;
drop policy if exists "mntech_products_authenticated_all" on public.products;
drop policy if exists "mntech_movements_authenticated_all" on public.movements;

create policy "mntech_categories_authenticated_all" on public.categories
  for all to authenticated using (true) with check (true);
create policy "mntech_products_authenticated_all" on public.products
  for all to authenticated using (true) with check (true);
create policy "mntech_movements_authenticated_all" on public.movements
  for all to authenticated using (true) with check (true);

-- No painel Supabase, habilite Realtime para categories, products e movements
-- em Database > Publications > supabase_realtime.
