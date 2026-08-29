# Sprint 11 - Audit frontend

## État actuel

Architecture React/TypeScript + Vite structurée par API, services, contextes, composants, features et routeur. Axios centralise l'authentification, le refresh et CSRF. Les pages lourdes sont lazy-loadées. Le build production est fonctionnel.

## Points corrigés

- Protection des pages compte, wishlist et messagerie par authentification.
- Ajout de `/account` vers les commandes.
- Suppression des chiffres fictifs et des fallbacks silencieux des services Admin.
- Données de démonstration limitées au développement ; catégories chargées via le service API.
- Échec API admin affiché explicitement au lieu d'une réussite simulée.
- Tests isolés des appels réseau de chargement des produits.
- Variables d'environnement harmonisées et documentées.

## Problèmes restants

- Coupons, messagerie et historique d'évaluations n'ont pas encore de services API dédiés et restent des écrans à brancher au backend.
- Les mutations locales de catégories/messages/coupons ne sont pas persistées.
- Les pages de collections admin pourraient recevoir une présentation d'erreur plus détaillée.

## Recommandations backend

- Implémenter les contrats de [DJANGO_API_CONTRACT.md](./DJANGO_API_CONTRACT.md), notamment enveloppes/pagination et statuts.
- Configurer JWT refresh, CORS credentials et CSRF.
- Faire respecter les rôles et permissions côté serveur.
- Ajouter endpoints persistants pour coupons, conversations, templates, avis et catégories.
