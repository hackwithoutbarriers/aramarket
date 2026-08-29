# AraMarket Frontend

Frontend de la marketplace multi-vendeurs AraMarket, développé avec React et TypeScript. Cette version constitue la Release Candidate à intégrer au backend Django.

## Fonctionnalités

### Client

- Catalogue, recherche, catégories et vendeurs
- Fiche produit, panier et checkout
- Compte, commandes, wishlist et messagerie

### Vendor Center

- Dashboard vendeur
- Gestion des produits, stock, commandes et revenus

### Admin Center

- Supervision des vendeurs, produits, utilisateurs et commandes
- Catégories et indicateurs marketplace

## Stack technique

- React 18, TypeScript, Vite
- React Router, Axios
- Tailwind CSS et composants Radix UI
- Vitest, Testing Library et jsdom

## Architecture

```text
src/
  api/        Client Axios, endpoints et normalisation des erreurs
  services/   Accès aux domaines API
  features/   Modules métier (notamment Admin Center)
  components/ Pages et composants réutilisables
  contexts/   Auth, panier, wishlist, catégories, coupons et messages
  hooks/      Logique réutilisable et recherche
  types/      Contrats TypeScript
  router/     Routes et protection par rôle
```

## Installation

```bash
npm install
```

## Configuration

Copier `.env.example` pour le développement ou `.env.production.example` pour la production :

```dotenv
VITE_API_URL=http://localhost:8000/api
VITE_APP_NAME=AraMarket
VITE_ENVIRONMENT=development
```

`VITE_API_URL` doit pointer vers la racine `/api` du backend. Aucune clé secrète ne doit être exposée dans une variable `VITE_*`.

## Développement local

```bash
npm run dev
```

## Tests

```bash
npm run test
```

## Build production

```bash
npm run build
npm run preview
```

Le build utilise le lazy loading des pages et sépare les dépendances lourdes en chunks (`react`, `router`, `radix`, graphiques, icônes).

## Connexion au backend Django

Les endpoints, payloads et réponses attendus sont détaillés dans [DJANGO_API_CONTRACT.md](./DJANGO_API_CONTRACT.md).

- Authentification : JWT d'accès en mémoire et cookie de session/refresh avec `withCredentials`
- CSRF : le cookie `csrftoken` est envoyé comme `X-CSRFToken` sur les requêtes
- CORS : autoriser l'origine du frontend et les credentials côté Django
- Les erreurs HTTP sont normalisées dans `src/api/errors.ts`

## Variables d'environnement

| Variable | Développement | Production |
| --- | --- | --- |
| `VITE_API_URL` | URL API locale | URL API publique |
| `VITE_APP_NAME` | `AraMarket` | `AraMarket` |
| `VITE_ENVIRONMENT` | `development` | `production` |

## Roadmap

### Déjà réalisé

- Marketplace client, espace vendeur et espace administrateur
- Panier, commandes, avis et architecture de services API
- Protection des routes par authentification et rôle

### À venir côté intégration

- Backend Django
- Paiement réel
- Notifications persistées et monitoring

## Release Candidate

Avant livraison, exécuter `npm run test` puis `npm run build`. Les données de démonstration sont limitées au mode développement ; la production attend les réponses des services Django.
