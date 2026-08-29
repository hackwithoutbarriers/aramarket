# Rapport Sprint 2 - AraMarket

## Analyse initiale

Le Sprint 1 fournissait deja le routeur React Router, le client Axios, les services metier, les types initiaux et les contextes globaux. Le catalogue existant etait riche cote UX, mais les vendeurs n'etaient exposes que comme deux champs sur un produit. Il manquait une decouverte des boutiques, une vitrine publique et la recuperation des produits par vendeur.

## Fonctionnalites ajoutees

- Catalogue vendeur enrichi avec identite de boutique, logo, couverture, statut, verification, note, avis, localisation et compteurs.
- Produit centralise dans `src/types/product.ts`, avec vendeur obligatoire, categorie optionnelle par identifiant et objet vendeur resumable.
- Service vendeur complet : liste, detail et produits d'un vendeur via les futurs endpoints Django REST, avec fallback hors ligne centralise.
- Page `/vendors` : recherche de boutiques, vendeurs populaires, skeleton de chargement et etat vide.
- Page `/vendor/:id` : profil boutique, statistiques, description et catalogue vendeur.
- Navigation bidirectionnelle Produit -> Boutique et Boutique -> Produit.
- Vendeur visible sur les cartes produit, le detail produit et les lignes du panier.
- Preparation du panier multi-vendeur avec `vendorId` et `vendorName` sur `CartItem`, sans modifier le checkout.

## Fichiers crees ou modifies

### Crees

- `SPRINT2_AUDIT.md`
- `src/components/VendorsPage.tsx`
- `src/components/VendorStorePage.tsx`
- `src/components/vendor/VendorCard.tsx`
- `src/components/vendor/VendorProfile.tsx`
- `src/components/vendor/VendorProducts.tsx`
- `SPRINT2_REPORT.md`

### Modifies

- `src/types/product.ts`, `src/types/vendor.ts`, `src/types/category.ts`
- `src/api/endpoints.ts`, `src/services/vendor.service.ts`
- `src/router/index.tsx`, `src/App.tsx`
- `src/components/ProductCard.tsx`, `ProductsPage.tsx`, `ProductDetailPage.tsx`
- `src/components/Navigation.tsx`, `src/components/CartPage.tsx`

## Choix d'architecture

Les composants affichent et composent les donnees, tandis que `vendorService` porte l'acces API et la normalisation des reponses paginees ou enveloppees. Les fixtures de demonstration sont dans le service afin de permettre une experience locale sans creer de mocks dans les composants. Le routeur conserve l'orchestration existante de `App.tsx` pour limiter le risque de regression pendant ce sprint.

## Difficultes rencontrees

- Le backend Django n'etant pas necessairement disponible localement, les parcours vendeur auraient ete inutilisables sans fallback. Celui-ci est donc limite au service et remplace naturellement les donnees quand l'API sera connectee.
- Le type `Product` etait duplique dans `ProductCard`; il a ete centralise pour eviter que les contrats catalogue et UI divergent.
- Le panier actuel reste volontairement plat pour ne pas anticiper le checkout, mais ses lignes portent desormais la cle vendeur necessaire au futur regroupement.

## Recommandations Sprint 3

1. Connecter `vendorService` et `productService` aux serializers Django avec pagination et filtres cote serveur.
2. Introduire un `CartContext` persistant, avec regroupement par vendeur et calcul des frais par boutique.
3. Ajouter les commandes, le stock reserve, le checkout et le paiement avec etats de chargement/retry explicites.
4. Remplacer progressivement l'orchestration de page dans `App.tsx` par des routes composables et des hooks de donnees.
5. Ajouter des tests de service et de navigation pour les reponses API paginees, les vendeurs inconnus et les boutiques vides.

## Validation

`npm run build` passe avec succes. Vite signale uniquement un avertissement preexistant de taille de bundle superieure a 500 kB.
