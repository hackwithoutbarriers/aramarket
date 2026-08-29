# SPRINT 8 — AUDIT INITIAL

Date: 2026-08-28
Auteur: Équipe Frontend (audit automatique)

But du document

- Faire l'état des lieux du code existant relatif au vendeur (routes, composants, services, types, contextes).
- Proposer une architecture et un plan d'évolution pour transformer le vendeur en acteur autonome (Vendor Center).


---

## 1) État actuel (fichiers identifiés)

Routes
- src/router/index.tsx
  - Route existante: `/vendor/dashboard` protégée par `ProtectedRoute role="vendor"`.
  - Routes admin et utilisateur déjà présentes.
- src/router/ProtectedRoute.tsx
  - Gère l'authentification, l'état de chargement et la vérification du rôle.

Composants vendeur
- src/components/vendor/VendorDashboard.tsx  (composant riche, déjà rend un dashboard vendeur basique avec onglets "Mes Produits", "Commandes", "Ajouter Produit")
- src/components/vendor/VendorProducts.tsx
- src/components/vendor/VendorProfile.tsx
- src/components/vendor/VendorCard.tsx

Services
- src/services/vendor-dashboard.service.ts
  - Fournit getStats, getOrders, getProducts, updateProduct, updateOrderStatus, updateShipment, getCommissions.
  - Utilise api client et endpoints ; contient fallbacks stockés en mémoire/localStorage.
  - Note: construction d'URL dans getStats semble incorrecte (``${endpoints.orders}?vendor=${vendorId}/stats``) — à revoir.
- src/services/vendor.service.ts
  - Fournit récupération vendors publics, vendors fallback.
- D'autres services utiles déjà présents : product.service.ts, order.service.ts, commission.service.ts, auth.service.ts

Types
- src/types/vendor.ts (Vendor, VendorApprovalStatus)
- types utiles déjà en place: product.ts, order.ts, auth.ts, api.ts, commission.ts

Contexts / Hooks
- src/contexts/AuthContext.tsx
  - Fournit AuthProvider et useAuth(). Mock users présents (admin, vendor, client). Stocke utilisateur dans localStorage.
- src/contexts/NotificationContext.tsx, CartContext, etc. (contexte notifications utilisé par useVendorDashboard)
- src/hooks/useVendorDashboard.ts
  - Agrège stats, produits, commandes via vendor-dashboard.service et expose des actions (updateProduct, updateOrderStatus, updateShipment).

Observations générales
- Il existe déjà une base fonctionnelle du Vendor Dashboard (VendorDashboard.tsx + hook + service). C'est un bon point de départ.
- Beaucoup de logiques sont encore dans le composant (forms mock, UI + actions directes). L'objectif sera de déplacer la logique métier vers des hooks/services et de structurer les features sous `src/features/vendor/`.
- AuthContext est mocké : l'infrastructure permissions/roles côté frontend existe mais doit être liée à l'API réelle.
- Services contiennent fallbacks et stockage local pour développement, pratique pour prototypage.


---

## 2) Points à corriger / risques identifiés

- vendor-dashboard.service.getStats : l'URL construite semble mal formée (concaténation `?vendor=${vendorId}/stats`). À corriger pour préparer les endpoints Django.
- Les composants (VendorDashboard) contiennent encore logique de formulaire, transformation des données et UI — nécessaire de refactorer en petites pièces et hooks.
- AuthContext utilise des users mock et mot de passe en clair ('password123') — ok pour dev mais à remplacer en sprint ultérieur.
- Tests existants pour order.service mais pas encore de tests dédiés seller flows.
- Routes vendor actuelles se limitent à /vendor/dashboard ; il faudra ajouter routes /vendor/products, /vendor/inventory, /vendor/orders, /vendor/earnings, /vendor/settings.


---

## 3) Architecture choisie (proposition)

Règle: isoler la feature vendor dans `src/features/vendor` afin de regrouper UI, hooks, services et tests par domaine.

Proposition d'arborescence:

src/features/vendor/

├── dashboard/
│   ├── VendorDashboardPage.tsx        # page routeable (/vendor/dashboard)
│   ├── components/                   # widgets du dashboard (KPICard, RecentOrders, Shortcuts)
│   └── hooks/useVendorDashboard.ts   # wrapper qui consomme vendorDashboard.service

├── products/
│   ├── VendorProductsPage.tsx        # /vendor/products
│   ├── ProductList.tsx
│   ├── ProductForm/                  # create/edit form
│   └── hooks/useVendorProducts.ts

├── inventory/
│   ├── InventoryPage.tsx             # /vendor/inventory
│   ├── hooks/useInventory.ts
│   └── components/                   # StockTable, LowStockAlerts

├── orders/
│   ├── VendorOrdersPage.tsx          # /vendor/orders
│   ├── VendorOrderDetail.tsx         # /vendor/orders/:id
│   ├── hooks/useVendorOrders.ts
│   └── components/                   # OrderList, OrderActions

├── earnings/
│   ├── VendorEarningsPage.tsx        # /vendor/earnings
│   └── services/vendorEarnings.service.ts

├── settings/
│   ├── VendorSettingsPage.tsx        # /vendor/settings
│   └── components/                   # Settings forms (profile, prefs)

└── components/
    └── VendorSidebar.tsx             # navigation vendeur

Notes:
- Chaque feature expose une Page component utilisée par le router.
- Hooks encapsulent la logique métier (API calls, state, side-effects) — les composants deviennent purs UI.
- Services (`src/services/vendor*.ts`) gèrent la communication API et la transformation des données.


---

## 4) Plan d'évolution détaillé (mapping Phases -> tâches techniques)

PHASE 1 — Audit (livrable)
- Ce fichier `SPRINT8_AUDIT.md` (fait)

PHASE 2 — Architecture (livrable)
- Créer `src/features/vendor/` avec sous-dossiers listés ci-dessus.
- Déplacer ou recréer progressivement les composants et hooks existants sous cette structure (VendorDashboard, useVendorDashboard).

PHASE 3 — Dashboard (/vendor/dashboard)
- Refactor VendorDashboard -> `src/features/vendor/dashboard/VendorDashboardPage.tsx`.
- Extraire petits composants (KPICard, RecentOrders, QuickActions).
- Assurer affichage stats (sales today/month), commandes en attente, produits actifs, stock faible, note boutique.
- Intégrer graphiques simples (ex: recharts, chartjs si déjà présent — sinon rendre placeholders consommables).

PHASE 4 — Gestion catalogue (/vendor/products)
- Page liste produits: table/listing avec image, nom, catégorie, prix, stock, statut, date création.
- Actions: modifier, supprimer, désactiver.
- Page création `/vendor/products/create` (ProductForm component) avec validation (yup/zod si présent ; sinon simple validation TS + controlled inputs).
- Page édition `/vendor/products/:id/edit`.
- Hook `useVendorProducts` pour fetch/create/update/delete.

PHASE 5 — Inventory (/vendor/inventory)
- Page inventory avec recherche, filtres (rupture, faible stock), édition rapide des quantités.
- Hook `useInventory` appelant vendorInventory.service
- Préparer shape des appels pour s'aligner sur Inventory API Django.

PHASE 6 — Orders (/vendor/orders)
- Page liste commandes vendeur (commande cliente divisée en vendor orders déjà modélisée dans types/order).
- Détail commande + actions de statut (PENDING -> CONFIRMED -> PROCESSING -> SHIPPED -> DELIVERED -> CANCELLED)
- Hook `useVendorOrders` + service `vendorOrder.service.ts`.

PHASE 7 — Earnings (/vendor/earnings)
- Page affichant CA brut, commissions, net, historique ventes.
- Créer `vendorEarnings.service.ts` pour endpoints `GET /vendor/earnings`.

PHASE 8 — Settings (/vendor/settings)
- Page pour modifier nom boutique, logo, bannière, description, localisation, contact, préférences notifications.

PHASE 9 — Services API
- Centraliser services côté `src/services/`:
  - vendorDashboard.service.ts (corriger endpoints et enlever logique UI)
  - vendorProduct.service.ts (CRUD produits vendeur)
  - vendorOrder.service.ts (opérations commandes vendeur)
  - vendorInventory.service.ts (gestion stock)
  - vendorEarnings.service.ts
- Chaque service doit: utiliser `api` client, types TS, gérer erreurs (throw/errors normalisés), et exposer fallbacks uniquement pour dev.

PHASE 10 — Permissions frontend
- VendorProtectedRoute déjà existe; créer `VendorProtectedRoute` ou réutiliser `ProtectedRoute role="vendor"`.
- Couvrir toutes routes `/vendor/*`.

PHASE 11 — UX
- Ajouter `VendorSidebar` (Dashboard, Produits, Commandes, Stock, Revenus, Paramètres).
- Skeletons, empty states, confirmations (modals) pour actions sensibles.
- Responsive design.

PHASE 12 — Tests
- Ajouter tests unit / integration pour parcours critiques :
  - affichage liste produits, création, modification
  - changement statut commande
  - permissions (client refusé / vendeur autorisé)


---

## 5) Fichiers à créer/modifier immédiatement (priorité pour Sprint 8)

- Créer `src/features/vendor/` structure (pages, components, hooks).
- Déplacer/refactor :
  - src/components/vendor/VendorDashboard.tsx -> src/features/vendor/dashboard/VendorDashboardPage.tsx (refactor progressif)
  - src/hooks/useVendorDashboard.ts -> move under feature or re-export
- Créer services dédiés : vendorProduct.service.ts, vendorOrder.service.ts, vendorInventory.service.ts, vendorEarnings.service.ts (peuvent réutiliser vendor-dashboard.service en tant que passerelle temporaire).
- Corriger vendor-dashboard.service.getStats URL et vérifier autres endpoints.
- Ajouter routes dans src/router/index.tsx pour :
  - /vendor/products
  - /vendor/products/create
  - /vendor/products/:id/edit
  - /vendor/inventory
  - /vendor/orders
  - /vendor/orders/:id
  - /vendor/earnings
  - /vendor/settings
  (toutes protégées par role="vendor")


---

## 6) Détails techniques & recommandations

Types & contrats API
- Réutiliser/étendre `src/types/order.ts`, `product.ts`, `vendor.ts` pour couvrir : VendorOrder (sous-commande vendeur), shipment, payout/earnings structures.

Services
- Standardiser enveloppe de réponse (ApiResponse/ PaginatedResponse déjà présents) et unwrap utilitaire centralisé.
- Erreurs: lever (throw) erreurs standardisées pour que hooks/components puissent gérer loading/error.

Hooks
- Hooks encapsulent logique async + notifications + refresh optimisé. Ils retournent { data, loading, error, actions }.

UI
- Éviter logique métier dans composants UI — utiliser handlers fournis par hooks.
- Créer composants réutilisables (KPICard, Table, ModalConfirm, FormField) dans `src/components/ui` si absent.

Tests
- Utiliser mocks pour services et localStorage dans tests.
- Couvrir parcours utilisateur vendeur principaux.

Sécurité
- Vérifier que `ProtectedRoute` redirige correctement et empêche l'accès client.
- Gérer cas où utilisateur est connecté mais n'a pas rôle vendor (redirection et message d'erreur clair).

Build & CI
- Valider `npm run build` localement après changements.


---

## 7) Roadmap Sprint 8 (itération proposée)

Sprint 8 (3-4 semaines approximatif, découpage agile)

Sprint 8 - phase A (jours 1-4)
- Créer structure `src/features/vendor` et déplacer `useVendorDashboard` et `VendorDashboard` en refactor progressif.
- Ajouter routes `/vendor/*` placeholders.
- Corriger bug URL dans vendor-dashboard.service.

Sprint 8 - phase B (jours 5-12)
- Implémenter pages Produits (listing + create + edit) avec hooks/services.
- Tests unitaires basiques pour create/update product.

Sprint 8 - phase C (jours 13-20)
- Implémenter Orders page + actions statut.
- Implémenter Inventory page (édition rapide stock) et alertes faible stock.

Sprint 8 - phase D (jours 21-28)
- Implémenter Earnings + Settings pages.
- UX polishing: VendorSidebar, responsive, skeletons, confirm modals.
- Tests parcours critiques, corriger build issues.


---

## 8) Livrables immédiats (Sprint 8)

- SPRINT8_AUDIT.md  (ce document)
- SPRINT8_REPORT.md (à produire à la fin du sprint, contiendra liste des fichiers modifiés/créés, routes, services, tests)
- PRs par feature (dashboard, products, orders, inventory, earnings, settings)


---

## 9) Observations finales

- La base existante permet une transition rapide vers un vrai Vendor Center : ProtectedRoute, hook vendorDashboard, et services fallback accélèrent le développement.
- Prioriser la séparation UI/logique et la création de services typesafe pour préparer la connexion aux endpoints Django.
- Corriger les petits bugs (endpoint malformed) avant d'étendre.


---

Fin de l'audit initial.
