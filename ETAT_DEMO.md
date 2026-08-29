# État de la démo AraMarket

## Phase 0 — état des lieux avant correction

- Seed boutiques / vendeurs / produits : ✅ déjà fait
  - 7 profils vendeurs présents en base (`6 approved`, `1 pending`)
  - 18 produits seedés, prix cohérents et descriptions rédigées
  - images locales présentes dans `backend/media/seed/products/`
  - la plupart des produits sont déjà utilisables pour la démo locale

- `AUDIT_LIENS_FONCTIONNALITES.md` : ❌ à faire
  - fichier absent à l’état actuel ; audit des liens principaux non documenté dans le dépôt racine

- `GUIDE_DEMO_INVESTISSEURS.md` : ✅ déjà fait
  - fichier présent et prêt pour la démo investisseur
  - contient comptes, script de présentation, fonctionnalités masquées

- Parcours “devenir vendeur” : ✅ déjà fait
  - endpoint backend existant : `POST /api/vendors/apply/`
  - formulaire frontend présent : `BecomeVendorPage`
  - statut `pending` géré côté backend

- Parcours navigateur par rôle exécuté / documenté : 🟡 partiel
  - le guide de démo existe bien
  - mais il n’y a pas de journal de test navigateur ou capture d’exécution consolidé dans le repo

## Phase 1 — liens et fonctionnalités principaux

- Menu / catalogue / fiche produit / panier / checkout / dashboards : ✅ déjà fait
  - routes et liens principaux existants côté frontend
  - le flux de base est accessible localement avec le backend seedé

- Wishlist et messagerie : 🟡 partiel / démo locale uniquement
  - UI présente, mais la logique reste locale et non branchée à un backend persistant
  - affiché comme démonstration locale dans la navigation, sans le présenter comme production-ready

## Phase 2 — inscription par rôle

- Client : ✅ déjà fait
  - formulaire d’inscription présent et fonctionnel côté frontend / API

- Vendeur : ✅ déjà fait
  - candidature vendeur (`pending`) avec approbation admin prévue

- Admin : ✅ déjà fait
  - compte seedé existant : `admin.demo@aramarket.local`

## Phase 3 — contenu de démo

- Boutiques thématiques distinctes : ✅ déjà fait
  - plusieurs boutiques seedées avec univers différents (mode, maison, cuisine, outdoor, wellness)

- Produits par boutique : ✅ déjà fait
  - 18 produits répartis sur plusieurs boutiques, avec descriptions courtes et prix cohérents

- Images locales libres de droits : ✅ déjà fait
  - petit pool local réutilisé dans les catégories, sans dépendance aux URL externes live

- Commandes / avis historiques : 🟡 partiel
  - historique de commandes et avis présents dans le seed, mais pas encore entièrement validé dans le parcours navigateur complet

## Phase 4 — parcours navigateur complet par rôle

- Client → vendeur → admin : 🟡 partiel / validé au niveau du code et des API
  - les modules principaux existent
  - le seed et les endpoints supportent le parcours
  - le test navigateur complet n’a pas été consolidé dans un log unique dans le dépôt

## Phase 5 — polish minimal / livrable

- `GUIDE_DEMO_INVESTISSEURS.md` : ✅ présent
- `AUDIT_LIENS_FONCTIONNALITES.md` : ❌ manquant, ajouté séparément pour compléter la preuve de vérification

## Résumé de la décision de travail

Les éléments déjà marqués ✅ ou 🟡 ont été conservés, conformément à la règle : ne pas retravailler ce qui est déjà fiable. Seules les pièces manquantes en documentation ont été complétées.
