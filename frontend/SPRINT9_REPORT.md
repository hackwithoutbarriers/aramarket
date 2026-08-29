# Sprint 9 — Admin Center

## Fonctionnalités ajoutées

- Dashboard global avec KPIs, commandes récentes et alertes.
- Supervision des vendeurs avec recherche, filtres et actions de statut.
- Validation, refus et masquage des produits.
- Vue globale des commandes et des utilisateurs avec recherche.
- Gestion catégories réutilisée et paramètres plateforme.
- Sidebar admin responsive et états vides/chargement.
- Toutes les routes `/admin/*` protégées par authentification et rôle `admin`.

## Fichiers principaux créés/modifiés

- `src/features/admin/AdminCenter.tsx`
- `src/features/admin/AdminShell.tsx`
- `src/features/admin/AdminDashboardPage.tsx`
- `src/features/admin/AdminCollectionPages.tsx`
- `src/features/admin/AdminCenter.test.tsx`
- `src/types/admin.ts`
- `src/router/index.tsx`, `src/AppRoutes.tsx`, `src/api/endpoints.ts`

## Routes ajoutées

`/admin/dashboard`, `/admin/vendors`, `/admin/products`, `/admin/orders`, `/admin/users`, `/admin/categories`, `/admin/settings`

## Services ajoutés

`adminDashboard.service.ts`, `adminVendor.service.ts`, `adminProduct.service.ts`, `adminOrder.service.ts`, `adminUser.service.ts`

## Points restant pour Sprint 10

- Brancher les endpoints Django définitifs et les permissions serveur.
- Finaliser l'authentification, les paiements, notifications et analytics.
- Ajouter pagination serveur, détails dédiés et observabilité production.
