# Rapport Sprint 5 - Recherche, avis et fulfillment

## Audit initial

- `ProductsPage` avait deja une recherche locale (nom, categorie, marque, description, tags), des filtres categorie/prix/promotion/stock, un tri nom/prix/note et une pagination. Toute cette logique etait toutefois dans le composant, sans vendeur, nouveaute/popularite ni parametres de service.
- `VendorsPage` avait uniquement une recherche texte sur le nom, la description et la localisation.
- `VendorOrder` contenait `status` et `deliveryStatus`, mais le cycle n'etait pas coherent : `processing`, `out_for_delivery`, `returned` et `refunded` coexistaient avec le cycle demande, sans informations de transport. Le dashboard vendeur permettait seulement une notification generique et la vue admin des commandes etait un placeholder.
- Un ancien `ReviewContext`/`ReviewSystem` existait deja, mais avec un contrat produit riche et des avis mockes, une verification d'achat forcee a `true`, et des donnees de note statiques dans les cartes. Il ne gerait pas les avis vendeur et ne respectait pas le contrat cible `Review`.

## Corrections apportees

- Centralisation de la recherche/du filtrage/du tri catalogue dans `useProductSearch`.
- Ajout du filtre vendeur et des tris nouveaute/popularite, sans supprimer les filtres existants.
- Ajout du contrat `Review`, du service API + fallback local et du hook cible. Les nouveaux composants n'utilisent plus les avis statiques de la page detail.
- Extension de `VendorOrder` avec les metadonnees de livraison et synchronisation de `status`/`deliveryStatus` lors des mises a jour vendeur.
- Remplacement du placeholder admin par une vue des sous-commandes locales et de leur suivi.

## Architecture choisie

Les appels Django restent limites aux services (`productService`, `reviewService`, `vendorDashboardService`). Les hooks portent l'etat et les regles UI (`useProductSearch`, `useReviews`, `useVendorDashboard`). Le fallback reste localStorage/mocks, sans transporteur externe.

## Fonctionnalites ajoutees

- Recherche texte et filtres categorie, prix, vendeur, stock, promotion, compteur et etat vide existants.
- Tri par prix, nouveaute, popularite et note.
- Avis produit et vendeur avec moyenne, compteur, formulaire connecte et unicite auteur/cible.
- Affichage des avis calcules dans les cartes produit/vendeur et les pages detail/boutique.
- Cycle vendeur `pending -> confirmed -> shipped -> delivered`, annulation, saisie transporteur/numero de suivi et notification client lorsque l'identifiant client est disponible.
- Suivi par sous-commande dans le detail client et vue globale admin.

## Fichiers crees ou modifies

Crees : `src/types/review.ts`, `src/services/review.service.ts`, `src/hooks/useReviews.ts`, `src/hooks/useProductSearch.ts`, `src/components/ReviewSection.tsx`.

Modifies : `src/types/order.ts`, `src/services/product.service.ts`, `src/services/vendor-dashboard.service.ts`, `src/hooks/useVendorDashboard.ts`, `src/components/ProductsPage.tsx`, `src/components/ProductCard.tsx`, `src/components/vendor/VendorCard.tsx`, `src/components/ProductDetailPage.tsx`, `src/components/VendorStorePage.tsx`, `src/components/OrderDetailPage.tsx`, `src/components/vendor/VendorDashboard.tsx`, `src/components/admin/AdminDashboard.tsx`.

## Decisions techniques

- Pas de nouvelle dependance.
- Le contrat historique de `ReviewContext` est conserve pour compatibilite des surfaces existantes, tandis que le nouveau flux Sprint 5 utilise le contrat cible versionne localement.
- La verification d'achat n'est pas inventee : le formulaire est reserve aux utilisateurs connectes, et l'absence de preuve de commande exploitable est documentee comme limite.
- Les filtres ne sont pas persistes dans l'URL dans ce sprint.

## Limites restantes

- Le backend Django et les APIs transporteur ne sont pas connectes.
- La notification client ne peut etre adressee que si `VendorOrder.userId` est fourni par la source de donnees.
- Les notes initiales de `Product`/`Vendor` restent des valeurs historiques tant qu'aucun avis Sprint 5 n'existe ; les nouvelles cartes preferent les moyennes calculees lorsqu'elles sont disponibles.
- Pas de moderation des avis.
- La recherche vendeur n'a pas ete refondue en hook dedie et la persistance URL reste a faire.

## Preparation Sprint 6 (ce qui merite d'etre fait tout de suite)

1. Connecter les endpoints Django pour produits, avis, commandes et sous-commandes, avec DTO de dates coherent.
2. Ajouter `userId` et les droits de commande cote backend afin de valider l'achat avant publication d'un avis.
3. Persister les criteres catalogue dans la query string et ajouter une pagination serveur.
4. Ajouter moderation, signalement et reponse vendeur dans le nouveau modele d'avis.
5. Ajouter tests unitaires des transitions fulfillment et des criteres `useProductSearch`.
