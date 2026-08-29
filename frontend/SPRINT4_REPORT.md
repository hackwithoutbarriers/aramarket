# Sprint 4 - Vendeurs, administration, commissions et notifications

## Architecture

- Contrats stricts pour les statuts d'approbation vendeur, les commissions et les notifications persistantes.
- Services dédiés (`vendor-dashboard`, `admin`, `commission`) : chaque accès API possède un fallback local.
- Les boutiques publiques sont filtrées sur les vendeurs approuvés/actifs.
- `useVendorDashboard` et `useAdminVendors` centralisent les états et mutations des écrans.

## Fonctionnalités

- Dashboard vendeur avec statistiques, commandes, statuts et produits éditables (prix, stock, activation).
- Calcul pur des commissions et totaux vendeur/administrateur.
- `/admin` et `/admin/vendors` protégés par rôle, avec approbation, rejet, suspension et historique d'audit.
- Notifications in-app par utilisateur, stockées dans localStorage, avec cloche et compteur non lu.
- API toast existante conservée sans modification de contrat.

## Validation

- `npm run build` ✅
- Aucun nouveau package ajouté.
