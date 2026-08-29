# Render deployment guide

This project is configured to deploy on Render as two services:

- Backend API: `aramarket-api`
- Frontend static app: `aramarket`
- Postgres database: `aramarket-db`

The public frontend domain is:

- `https://aramarket.onrender.com`

The public backend domain is:

- `https://aramarket-api.onrender.com`

## 1. Import the project on Render

- Create a new Render Blueprint using the root `render.yaml` file.
- Render will create a Postgres database automatically and configure the web/static services.

## 2. Confirm environment variables

The following values are already set in `render.yaml` and should be kept in sync with your Supabase and project settings:

- `SUPABASE_URL`
- `SUPABASE_PUBLISHABLE_KEY`
- `SUPABASE_SECRET_KEY`
- `SUPABASE_JWKS_URL`
- `FRONTEND_URL=https://aramarket.onrender.com`
- `CSRF_TRUSTED_ORIGINS=https://aramarket.onrender.com,https://aramarket-api.onrender.com,...`
- `VITE_API_URL=https://aramarket-api.onrender.com/api`

## 3. Run migrations

After the backend service is deployed:

```bash
python manage.py migrate
python manage.py createsuperuser
```

## 4. Final checks

- Open the frontend URL: `https://aramarket.onrender.com`
- Confirm the API responds at `https://aramarket-api.onrender.com/` and `/api/products/`.
- Confirm the app loads without the previous React hook runtime issue.
- Confirm the auth flow can use Supabase or the Django fallback.

## 5. Deployment notes

- Set `DEBUG=False` in production.
- Keep `FRONTEND_URL` aligned with the public frontend domain.
- Keep `VITE_API_URL` aligned with the public backend domain.
- The Postgres connection is provided via `DATABASE_URL`, which is supported in the Django settings.
