# Sprint 11 - Rapport Release Candidate

## Corrections effectuées

- Routes compte et communication protégées par authentification.
- Fallbacks fictifs admin supprimés ; erreurs API rendues visibles.
- Données de démonstration isolées du build production.
- Chargement des catégories raccordé au service API.
- Configuration `.env` et documentation frontend complétées.

## Fichiers importants

- `src/router/index.tsx`, `src/AppRoutes.tsx`
- `src/api/`, `src/services/`, `src/contexts/`
- `README.md`, `DJANGO_API_CONTRACT.md`, `SPRINT11_AUDIT.md`

## Validation

- `npm run build` : réussi.
- `npm run test` : réussi (6 fichiers, 11 tests).

## État final

Le frontend est une base Release Candidate stable pour l'intégration Django. Les parcours client, vendeur et admin sont routés et protégés ; la production ne charge plus les jeux de données de démonstration critiques.

## Points backend nécessaires

Voir le contrat API dédié. Les priorités sont l'authentification/refresh, les permissions serveur, les commandes, puis la persistance des coupons et de la messagerie.
