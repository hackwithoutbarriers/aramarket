# Supabase setup for AraMarket

This folder contains the database schema and seed scripts needed to deploy the marketplace data model in Supabase.

## 1) Apply the schema

Open the Supabase SQL editor and run:

- `supabase/schema.sql`

This will create the tables needed for:
- sellers
- catalogues
- products
- product images/options/variants
- categories requests
- cart and orders
- payments and reviews
- profile sync from `auth.users`

## 2) Add the service role key

Set the backend and deployment environment with:

```env
SUPABASE_URL=https://<project>.supabase.co
SUPABASE_PUBLISHABLE_KEY=<anon-or-publishable-key>
SUPABASE_SECRET_KEY=<service-role-key>
SUPABASE_JWKS_URL=https://<project>.supabase.co/auth/v1/.well-known/jwks.json
SUPABASE_SERVICE_ROLE_KEY=<service-role-key>
```

## 3) Seed demo data

After the schema is applied, run:

- `supabase/seed.sql`

## 4) Notes

- The project uses Supabase Auth and expects a `public.profiles` row for each authenticated user.
- The trigger in `schema.sql` creates the profile automatically when a user signs up in Supabase Auth.
- For production, replace the open development policies with stricter access rules once the app lifecycle is finalized.
