-- AraMarket Supabase schema
-- Apply this in the Supabase SQL editor connected to the target project.

create extension if not exists pgcrypto;

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  email text not null unique,
  first_name text,
  last_name text,
  phone_number text,
  address text,
  user_type text not null default 'customer' check (user_type in ('customer', 'vendor', 'admin')),
  permissions jsonb not null default '[]'::jsonb,
  is_email_verified boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.sellers (
  id bigserial primary key,
  profile_id uuid not null unique references public.profiles(id) on delete cascade,
  store_name text not null,
  store_description text,
  store_logo text,
  is_approved boolean not null default false,
  approval_status text not null default 'pending' check (approval_status in ('pending', 'approved', 'rejected', 'suspended')),
  rejection_reason text,
  approved_at timestamptz,
  suspended_at timestamptz,
  rating numeric(2,1) not null default 0.0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.catalogues (
  id bigserial primary key,
  name text not null,
  description text,
  image_url text,
  is_active boolean not null default true,
  name_key text,
  icon text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.products (
  id bigserial primary key,
  seller_id bigint not null references public.sellers(id) on delete cascade,
  catalogue_id bigint references public.catalogues(id) on delete set null,
  name text not null,
  description text not null,
  price numeric(10,2) not null,
  compare_price numeric(10,2),
  cost_per_item numeric(10,2),
  sku text unique,
  barcode text,
  quantity integer not null default 0,
  is_published boolean not null default false,
  is_featured boolean not null default false,
  can_backorder boolean not null default false,
  requires_shipping boolean not null default true,
  weight numeric(6,2),
  rating numeric(2,1) not null default 0.0,
  review_count integer not null default 0,
  brand text,
  sub_category text,
  features jsonb not null default '[]'::jsonb,
  specifications jsonb not null default '{}'::jsonb,
  tags jsonb not null default '[]'::jsonb,
  shipping_info jsonb not null default '{}'::jsonb,
  status text not null default 'published' check (status in ('draft', 'published', 'archived')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.product_images (
  id bigserial primary key,
  product_id bigint not null references public.products(id) on delete cascade,
  image_url text not null,
  alt_text text,
  is_default boolean not null default false,
  created_at timestamptz not null default now()
);

create table if not exists public.product_options (
  id bigserial primary key,
  product_id bigint not null references public.products(id) on delete cascade,
  name text not null
);

create table if not exists public.product_option_values (
  id bigserial primary key,
  option_id bigint not null references public.product_options(id) on delete cascade,
  value text not null,
  price_modifier numeric(10,2) not null default 0.0,
  quantity integer not null default 0
);

create table if not exists public.custom_category_requests (
  id bigserial primary key,
  product_id bigint not null references public.products(id) on delete cascade,
  seller_id bigint not null references public.sellers(id) on delete cascade,
  requested_category text not null,
  requested_sub_category text,
  description text,
  status text not null default 'pending' check (status in ('pending', 'approved', 'rejected')),
  created_at timestamptz not null default now(),
  reviewed_at timestamptz,
  reviewed_by uuid references public.profiles(id),
  admin_notes text
);

create table if not exists public.carts (
  id bigserial primary key,
  profile_id uuid not null unique references public.profiles(id) on delete cascade,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.cart_items (
  id bigserial primary key,
  cart_id bigint not null references public.carts(id) on delete cascade,
  product_id bigint not null references public.products(id) on delete cascade,
  variant_id bigint references public.product_option_values(id) on delete set null,
  quantity integer not null default 1,
  added_at timestamptz not null default now(),
  unique(cart_id, product_id, variant_id)
);

create table if not exists public.orders (
  id bigserial primary key,
  profile_id uuid not null references public.profiles(id) on delete cascade,
  order_number text not null unique,
  status text not null default 'pending' check (status in ('pending', 'confirmed', 'processing', 'shipped', 'out_for_delivery', 'delivered', 'cancelled', 'refunded', 'returned')),
  payment_status text not null default 'pending' check (payment_status in ('pending', 'paid', 'failed', 'refunded')),
  subtotal numeric(10,2) not null,
  tax numeric(10,2) not null default 0.0,
  shipping_cost numeric(10,2) not null default 0.0,
  total numeric(10,2) not null,
  discount numeric(10,2) not null default 0.0,
  currency text not null default 'USD',
  payment_method text not null default 'cash_on_delivery',
  shipping_address jsonb not null,
  billing_address jsonb,
  note text,
  carrier text,
  tracking_number text,
  shipped_at timestamptz,
  delivered_at timestamptz,
  estimated_delivery_date timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.order_items (
  id bigserial primary key,
  order_id bigint not null references public.orders(id) on delete cascade,
  product_id bigint not null references public.products(id),
  variant_id bigint references public.product_option_values(id) on delete set null,
  quantity integer not null,
  price numeric(10,2) not null,
  total numeric(10,2) not null
);

create table if not exists public.payments (
  id bigserial primary key,
  order_id bigint not null unique references public.orders(id) on delete cascade,
  method text not null,
  amount numeric(10,2) not null,
  transaction_id text,
  status text not null default 'pending',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.reviews (
  id bigserial primary key,
  profile_id uuid not null references public.profiles(id) on delete cascade,
  product_id bigint references public.products(id) on delete cascade,
  seller_id bigint references public.sellers(id) on delete cascade,
  rating integer not null check (rating between 1 and 5),
  title text,
  description text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.profiles (
    id,
    email,
    first_name,
    last_name,
    user_type,
    permissions,
    is_email_verified
  )
  values (
    new.id,
    new.email,
    split_part(coalesce(new.raw_user_meta_data ->> 'full_name', ''), ' ', 1),
    nullif(trim(substr(coalesce(new.raw_user_meta_data ->> 'full_name', ''), length(split_part(coalesce(new.raw_user_meta_data ->> 'full_name', ''), ' ', 1)) + 2)), ''),
    coalesce(new.raw_user_meta_data ->> 'role', 'customer'),
    coalesce(new.raw_user_meta_data ->> 'permissions', '[]')::jsonb,
    coalesce(new.email_confirmed_at is not null, false)
  )
  on conflict (id) do update set
    email = excluded.email,
    first_name = excluded.first_name,
    last_name = excluded.last_name,
    user_type = excluded.user_type,
    permissions = excluded.permissions,
    is_email_verified = excluded.is_email_verified,
    updated_at = now();

  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
after insert on auth.users
for each row execute procedure public.handle_new_user();

create or replace function public.update_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

create trigger profiles_updated_at
before update on public.profiles
for each row execute procedure public.update_updated_at();

create trigger sellers_updated_at
before update on public.sellers
for each row execute procedure public.update_updated_at();

create trigger catalogues_updated_at
before update on public.catalogues
for each row execute procedure public.update_updated_at();

create trigger products_updated_at
before update on public.products
for each row execute procedure public.update_updated_at();

create trigger carts_updated_at
before update on public.carts
for each row execute procedure public.update_updated_at();

create trigger orders_updated_at
before update on public.orders
for each row execute procedure public.update_updated_at();

create trigger reviews_updated_at
before update on public.reviews
for each row execute procedure public.update_updated_at();

alter table public.profiles enable row level security;
alter table public.sellers enable row level security;
alter table public.catalogues enable row level security;
alter table public.products enable row level security;
alter table public.product_images enable row level security;
alter table public.product_options enable row level security;
alter table public.product_option_values enable row level security;
alter table public.carts enable row level security;
alter table public.cart_items enable row level security;
alter table public.orders enable row level security;
alter table public.order_items enable row level security;
alter table public.payments enable row level security;
alter table public.reviews enable row level security;

create policy "Profiles are viewable by everyone" on public.profiles
for select using (true);

create policy "Users can update their own profile" on public.profiles
for update using (auth.uid() = id)
with check (auth.uid() = id);

create policy "Users can insert their own profile" on public.profiles
for insert with check (auth.uid() = id);

create policy "Sellers are viewable by everyone" on public.sellers
for select using (true);

create policy "Seller can manage their own store" on public.sellers
for all
using (profile_id = auth.uid())
with check (profile_id = auth.uid());

create policy "Catalogues are viewable by everyone" on public.catalogues
for select using (true);

create policy "Catalogues are manageable by admins" on public.catalogues
for all
using (exists (
  select 1 from public.profiles p where p.id = auth.uid() and p.user_type = 'admin'
))
with check (exists (
  select 1 from public.profiles p where p.id = auth.uid() and p.user_type = 'admin'
));

create policy "Products are viewable by everyone" on public.products
for select using (true);

create policy "Seller can manage their own products" on public.products
for all
using (
  seller_id in (
    select id from public.sellers where profile_id = auth.uid()
  )
)
with check (
  seller_id in (
    select id from public.sellers where profile_id = auth.uid()
  )
);

create policy "Product images are viewable by everyone" on public.product_images
for select using (true);

create policy "Seller can manage their own product images" on public.product_images
for all
using (
  product_id in (
    select id from public.products where seller_id in (
      select id from public.sellers where profile_id = auth.uid()
    )
  )
)
with check (
  product_id in (
    select id from public.products where seller_id in (
      select id from public.sellers where profile_id = auth.uid()
    )
  )
);

create policy "All can view carts" on public.carts
for select using (true);

create policy "User can manage own cart" on public.carts
for all
using (profile_id = auth.uid())
with check (profile_id = auth.uid());

create policy "User can manage own cart items" on public.cart_items
for all
using (
  cart_id in (
    select id from public.carts where profile_id = auth.uid()
  )
)
with check (
  cart_id in (
    select id from public.carts where profile_id = auth.uid()
  )
);

create policy "Orders are viewable by owner or admin" on public.orders
for select using (
  profile_id = auth.uid()
  or exists (
    select 1 from public.profiles p where p.id = auth.uid() and p.user_type = 'admin'
  )
);

create policy "Users can create their own orders" on public.orders
for insert with check (profile_id = auth.uid());

create policy "Order items are viewable by owner or admin" on public.order_items
for select using (
  order_id in (
    select id from public.orders where profile_id = auth.uid()
  )
  or exists (
    select 1 from public.profiles p where p.id = auth.uid() and p.user_type = 'admin'
  )
);

create policy "Payments are viewable by owner or admin" on public.payments
for select using (
  order_id in (
    select id from public.orders where profile_id = auth.uid()
  )
  or exists (
    select 1 from public.profiles p where p.id = auth.uid() and p.user_type = 'admin'
  )
);

create policy "Reviews are viewable by everyone" on public.reviews
for select using (true);

create policy "Users can manage own reviews" on public.reviews
for all
using (profile_id = auth.uid())
with check (profile_id = auth.uid());
