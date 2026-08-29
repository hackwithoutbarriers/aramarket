# Contrat API Django - AraMarket Frontend

Base URL : `VITE_API_URL` (exemple `/api`). Les réponses de collection peuvent être un tableau direct, `{ "data": [...] }` ou une pagination DRF `{ "count", "next", "previous", "results" }`. Les dates doivent être ISO 8601.

## Auth

| Endpoint | Méthode | Payload | Réponse attendue |
| --- | --- | --- | --- |
| `/auth/login/` | POST | `{ email, password }` | `{ data: User, access?: string }` |
| `/auth/register/` | POST | `{ email, password, name, role: "client", permissions }` | `{ data: User, access?: string }` |
| `/auth/logout/` | POST | aucun | `204` ou enveloppe JSON |
| `/auth/me/` | GET | aucun | `User` ou `{ data: User }` |
| `/auth/refresh/` | POST | cookie refresh | `{ access: string }` |

`User` contient `id`, `email`, `name`, `role` (`client`, `vendor`, `admin`), `permissions`, `createdAt` et `isVerified`.

## Products

| Endpoint | Méthode | Contrat |
| --- | --- | --- |
| `/products/` | GET | filtres `query`, `filters`, `sortBy`, `page`, `limit`; collection paginée |
| `/products/{id}/` | GET | `Product` |
| `/products/` | POST | champs produit du formulaire vendeur; `Product` créé |
| `/products/{id}/` | PATCH | champs modifiés; `Product` |
| `/products/{id}/` | DELETE | `204` |

## Vendors

| Endpoint | Méthode | Contrat |
| --- | --- | --- |
| `/vendors/` | GET | collection de vendeurs publics, avec statut d'approbation |
| `/vendors/{id}/` | GET | `Vendor` |
| `/vendors/{id}/products/` | GET | collection de `Product` |
| `/vendor/dashboard/?vendor={id}` | GET | `{ productCount, sales, orderCount, conversionRate, commissionTotal }` |

## Orders

| Endpoint | Méthode | Payload / réponse |
| --- | --- | --- |
| `/orders/` | GET | collection de `Order` |
| `/orders/{id}/` | GET | `Order` |
| `/orders/` | POST | commande complète du checkout; `Order` créé |
| `/orders/{id}/` | PATCH | `{ status, deliveryStatus }` ou suivi; `Order` |
| `/orders/{id}/cancel/` | POST | commande annulée; `Order` |

## Reviews

| Endpoint | Méthode | Payload / réponse |
| --- | --- | --- |
| `/reviews/?target_type={type}&target_id={id}` | GET | collection de `Review` |
| `/reviews/` | POST | `{ targetType, targetId, authorId, authorName, rating, comment }`; `Review` |

## Admin

| Endpoint | Méthode | Contrat |
| --- | --- | --- |
| `/admin/dashboard/` | GET | KPIs, commandes récentes, alertes et files d'attente |
| `/admin/vendors/` | GET/PATCH | collection; PATCH `{ approvalStatus, reason? }` |
| `/admin/products/` | GET/PATCH | collection; PATCH `{ status }` |
| `/admin/orders/` | GET | collection de commandes administrables |
| `/admin/users/` | GET/PATCH | collection; PATCH `{ isActive }` |
| `/admin/vendor-audits/` | GET | historique des actions vendeur |
| `/admin/categories/` | GET/POST/PATCH/DELETE | catégories et demandes de catégories |

## Vendor Center

| Endpoint | Méthode | Contrat |
| --- | --- | --- |
| `/vendors/{id}/products/` | GET | produits du vendeur |
| `/products/{id}/` | PATCH | mise à jour produit/stock |
| `/orders/?vendor={id}` | GET | commandes du vendeur |
| `/orders/{id}/` | PATCH | statut, transporteur, suivi et date estimée |
| `/commissions/?vendor={id}` | GET | commissions du vendeur |
| `/commissions/totals/` | GET | `{ total, payout }` |

## Règles transverses

- Utiliser les statuts HTTP standards (`400`, `401`, `403`, `404`, `409`, `422`, `500`).
- Les erreurs peuvent fournir `{ message, details }`; les erreurs de validation doivent conserver les champs.
- Activer CORS avec credentials pour l'origine frontend et configurer CSRF trusted origins.
- Les endpoints protégés doivent appliquer les permissions Django, pas seulement le filtrage frontend.
