-- Demo seed data for Supabase local/prod testing
-- Run after the schema is created

insert into public.catalogues (name, description, image_url, is_active, name_key, icon)
values
  ('Electronics', 'Consumer electronics and accessories', 'https://images.unsplash.com/...', true, 'electronics', 'cpu'),
  ('Fashion', 'Clothing and lifestyle essentials', 'https://images.unsplash.com/...', true, 'fashion', 'shirt'),
  ('Home & Garden', 'Home improvement and living essentials', 'https://images.unsplash.com/...', true, 'home-garden', 'home')
on conflict do nothing;

-- Example profiles should be created through Supabase Auth users.
-- In real use, create the auth users first and let the trigger generate public.profiles automatically.
