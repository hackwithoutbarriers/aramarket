# Sprint 3 - Panier, checkout et commandes

## Audit initial

- Le panier et ses handlers etaient stockes dans `AppContent`.
- `CartPage` recevait un tableau plat via props et recalculait subtotal, livraison, taxe et total.
- `CheckoutPage` ne collectait pas les informations client et simulait la commande avec une alerte.
- Le modele `Order` existait partiellement, mais `order.service.ts` ne proposait pas l'annulation et dependait uniquement de l'API.
- La persistance etait absente pour le panier ; les composants ne partageaient pas de contrat central.

## Architecture choisie

- `CartContext` est la source unique de verite du panier.
- `types/cart.ts` definit `CartItem`, `VendorCartGroup` et `Cart`, avec `productId`, vendeur, prix et subtotal.
- `useCart` expose les operations UI : ajout, quantite, suppression, vidage et totaux.
- Les donnees sont stockees sous `aramarket_cart_guest` ou `aramarket_cart_<userId>`. Le panier invite est fusionne a la connexion.
- Les groupes vendeurs sont derives des lignes et ne sont jamais dupliques dans plusieurs composants.
- `order.service.ts` reste l'adaptateur Django (`GET/POST /orders/`) et fournit une persistance locale de secours tant que l'API n'est pas disponible.
- `payment.service.ts` prepare le contrat provider sans integrer de PSP reel.

## Fonctionnalites ajoutees

- Panier persistant au refresh et apres fermeture de l'application.
- Ajout, modification de quantite, suppression et panier vide.
- Affichage groupe par boutique avec total par vendeur et total global.
- Checkout `/checkout` protege, avec nom, telephone, adresse, ville et validation.
- Resume checkout groupe par vendeur.
- Creation de commande avec items, sous-commandes vendeur, statut et metadonnees paiement.
- Historique `/account/orders` et detail `/account/orders/:id`.
- Suivi de statut et annulation d'une commande locale ou distante.
- Etats de chargement et messages d'erreur explicites.

## Fichiers crees ou modifies

- Crees : `src/types/cart.ts`, `src/contexts/CartContext.tsx`, `src/hooks/useCart.ts`.
- Crees : `src/hooks/useOrders.ts`, `src/components/OrdersPage.tsx`, `src/components/OrderDetailPage.tsx`.
- Cree : `src/services/payment.service.ts`.
- Modifies : `src/App.tsx`, `src/components/CartPage.tsx`, `src/components/CheckoutPage.tsx`, `src/router/index.tsx`, `src/types/order.ts`, `src/services/order.service.ts`.

## Decisions techniques

- Les montants restent en nombres dans les contrats metier et sont formates uniquement dans l'UI.
- Le fallback local rend le parcours demonstrable sans masquer le futur contrat API.
- Le statut global et les statuts vendeur sont separes pour preparer le traitement fulfillment multi-vendeur.
- Aucun fournisseur de paiement reel n'est appele ; `provider`, `paymentStatus` et `transactionId` sont deja prevus.

## Limites restantes

- Le backend Django et l'authentification serveur ne sont pas encore connectes.
- Le fallback local ne remplace pas la validation serveur, la reservation de stock ni l'idempotence.
- Les frais de livraison et taxes sont encore des regles frontend simplifiees.
- Les statuts vendeur sont initialises a `pending` et attendent le futur workflow vendeur.
- Aucun test automatisé n'est configure dans le projet ; la validation actuelle est le build Vite et les diagnostics TypeScript.

## Preparation Sprint 4

Les contrats `VendorOrder`, `OrderItem`, `PaymentIntent` et les endpoints de commande permettent d'ajouter le dashboard vendeur, les ventes par vendeur, le stock, le traitement livraison, les commissions et les controles d'administration sans refaire le panier ou le checkout.
