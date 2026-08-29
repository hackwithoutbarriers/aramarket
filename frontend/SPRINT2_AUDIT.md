# Audit Sprint 2 - AraMarket

## Etat actuel

- **Architecture** : React + TypeScript, React Router, Axios centralise dans `src/api`, services metier dans `src/services` et types dans `src/types`.
- **Catalogue** : `App.tsx` fournit encore un catalogue de demonstration a `ProductsPage`, qui gere recherche, filtres, tri, pagination, vue grille/liste et quick view.
- **Produit** : `ProductCard` et `ProductDetailPage` sont reutilisables, mais `ProductCard` redefinit localement le type `Product` et le vendeur est seulement represente par `vendorId` / `vendorName`.
- **Vendeur** : `vendor.service.ts` sait lister et charger un vendeur, mais ne sait pas recuperer les produits d'un vendeur. Aucun espace vendeur public ni page de decouverte n'existe.
- **Categories** : `CategoryContext`, `category.service.ts` et les types de categories sont deja presents. Le catalogue filtre actuellement sur le libelle texte de la categorie.
- **Etat global** : les contextes panier, favoris, avis, authentification, notifications et localisation existent. Le panier actuel est plat et ne porte pas encore de regroupement vendeur.
- **UI** : composants UI de type shadcn et `lucide-react` sont disponibles. Les styles globaux utilisent Tailwind et une palette existante bleu/jaune.

## Architecture retenue

1. Conserver `App.tsx` comme orchestrateur de navigation pendant ce sprint afin de preserver les flux existants.
2. Enrichir les contrats `Product`, `Vendor` et `Category` avec des champs publics extensibles et des identifiants Django compatibles.
3. Faire passer les donnees vendeur par `vendorService`, avec normalisation des reponses paginees/API et fallback de demonstration hors ligne dans le service, jamais dans les composants.
4. Ajouter `VendorCard`, `VendorProfile`, `VendorProducts`, une page `/vendors` et une page `/vendor/:id`.
5. Faire naviguer explicitement Produit -> Boutique et Boutique -> Produit avec les routes deja gerees par React Router.
6. Preparer le panier via `vendorId` et `vendorName` sur `CartItem`, sans implementer le checkout multi-vendeur.

## Changements prevus

- Evoluer les types metier et centraliser le type `Product`.
- Completer les endpoints et le service vendeur (`GET /vendors`, `GET /vendors/:id/`, `GET /vendors/:id/products/`).
- Afficher le vendeur sur chaque carte et sur le detail produit.
- Creer la decouverte des boutiques et la vitrine vendeur publique, avec recherche, etats de chargement et etat vide.
- Ajouter les routes et les liens de navigation marketplace.
- Verifier le resultat avec `npm run build`.
