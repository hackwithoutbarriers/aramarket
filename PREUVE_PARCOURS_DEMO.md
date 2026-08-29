# Preuve du parcours de démonstration

Date du contrôle navigateur : 29/08/2026. Navigateur réel sur `http://localhost:5173`, backend Django sur `http://localhost:8000`.

## Parcours client

1. Connexion réussie avec `client.one@aramarket.local`.
2. Catalogue ouvert (`/products`).
3. Fiche `Drift Calm Candle` ouverte (`/product/87`), boutique `Astera Wellness`.
4. Fiche `Ridge Trail Hat` ouverte (`/product/84`), boutique `North Peak`.
5. Les deux articles ont été ajoutés au panier. Le panier affichait 2 articles et un total de `$59.00`.
6. Checkout rempli et commande créée. L’interface a affiché « Commande confirmée — Votre commande a été enregistrée avec succès. »
7. Dans le compte (`/profile`, relié à l’historique réel), la commande `AM-3F1A6FFFE49D` était visible avec `2 article(s) · $59.00`, statut `En attente`.
8. Sur `/product/87`, onglet `Reviews` ouvert : `Avis (1) · 5.0/5`, auteur `Demo Client`, commentaire « Parfum très discret et agréable pour le soir. »

## Candidature vendeur

1. Nouveau compte créé via l’interface d’inscription : `candidate.20260829@aramarket.test`.
2. `BecomeVendorPage` utilisée avec la boutique `Atelier Démo`.
3. Message réellement affiché : « Vendor application submitted and is pending approval. »
4. Côté admin `/admin/vendors`, la ligne `Atelier Démo` apparaissait en `PENDING`.

## Vendeur

1. Connexion réussie avec `vendor.lumiere@aramarket.local`.
2. Dashboard `/vendor/dashboard` affiché avec 3 produits, €313.00 de ventes et 2 commandes.
3. Onglet commandes affiché : commande 38 (`Arden Leather Tote`) en `pending`, commande 33 livrée.
4. Changement réel de la commande 38 vers `Confirmée` réussi ; l’interface affichait `confirmed`.
5. Une tentative directe `pending` → `Expédiée` a été refusée par l’API en `409 Conflict` ; aucun statut incohérent n’a été retenu.
6. Édition d’un produit et répercussion du statut vendeur vers le compte client non vérifiées dans ce parcours.

## Admin

1. Connexion admin réussie avec `admin.demo@aramarket.local`.
2. La candidature `Atelier Démo` a été approuvée dans `/admin/vendors`; la ligne est passée à `APPROVED`.
3. L’URL demandée `/admin/vendor-audits/` a affiché « Page introuvable ». L’entrée d’audit dans cette vue n’est donc pas prouvée.

## Écarts corrigés pendant le contrôle

- Le seed backend ne démarrait pas à cause de marqueurs syntaxiques résiduels ; seuls ces marqueurs ont été retirés et les mots de passe des nouveaux comptes rétablis.
- La recherche catalogue plantait sur une catégorie absente ; normalisation défensive ajoutée dans `SearchBar`.
- L’historique `/profile` affichait des commandes fictives ; il utilise maintenant `OrdersPage` et l’API réelle.
- Les avis paginés provoquaient `reviews.map is not a function` ; le service accepte maintenant les réponses `{ results: [...] }`.

## Points non validés

Le suivi vendeur → client, l’édition produit vendeur et la présence d’une entrée dans `/admin/vendor-audits/` ne sont pas déclarés validés : ils n’ont pas été observés avec succès dans le navigateur à cet instant.

## Vérifications complémentaires du 29/08/2026

1. **Audits admin** : le backend expose `GET /api/admin/vendor-audits/` (réponse paginée `200` après authentification), tandis que `/admin/vendor-audits/` était uniquement une route frontend manquante. La route frontend et une vue tableau minimale ont été ajoutées. Après approbation, l’API retourne une entrée `approved` pour `Atelier Démo` (vendeur `39`), visible dans le tableau.
2. **Statut commande vendeur → client** : après actualisation via `GET /api/orders/38/` avec le compte client concerné, la commande `AM-INV-1006` retourne `status: confirmed`. La propagation est donc effective, sans correction supplémentaire.
3. **Édition produit vendeur → catalogue client** : le vendeur a modifié `Arden Leather Tote` (`74`) de `125.00` à `126.00`. La valeur `126.00` est retournée par le catalogue public. La fiche publique renvoyait toutefois `500` pour un visiteur anonyme ; le filtre backend a été corrigé pour ne pas comparer `AnonymousUser` à une clé étrangère. Après correction, `GET /api/products/74/` retourne `200` et `price: 126.0`.
4. **Dashboard vendeur fraîchement approuvé** : connexion du compte `candidate.20260829@aramarket.test` et appel du dashboard : `productCount: 0`, `sales: 0`, `orderCount: 0`, `conversionRate: 0`. Aucun `NaN`, `undefined` ou erreur n’est produit ; l’affichage frontend utilise déjà `0` en valeur de repli.
