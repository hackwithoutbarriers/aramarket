# Audit backend Django / contrat API AraMarket

Date de l'audit : 2026-08-28

## Périmètre et méthode

L'audit porte sur `backend/` et compare les routes, modèles, serializers,
permissions et réglages avec `frontend/DJANGO_API_CONTRACT.md`.
Les constats sont issus de la lecture des fichiers présents dans le dépôt.

Les commandes `manage.py check` et `manage.py showmigrations --plan` n'ont pas pu
être exécutées : le virtualenv fourni (`backend/venv/`) ne contient pas
Django (`ModuleNotFoundError: No module named 'django'`). Le dépôt contient les
fichiers de migration `__init__.py` uniquement, sans migration applicative.

## Synthèse

- Structure présente : `users`, `products`, `orders`, `cart`, `utils`.
- Structure absente du backend : reviews, commissions, audit vendeur, dashboard
  admin/vendor, catégories admin, endpoints utilisateurs admin.
- L'authentification est basée sur `django-rest-knox`, pas sur le flux JWT +
  cookie refresh attendu par le frontend. `/auth/refresh/` et `/auth/me/` sont
  absents ; le backend expose `/auth/user/`.
- Les fichiers `apps/users/serializers.py`, `apps/users/managers.py` et le client
  Axios frontend contiennent des séquences `******` à la place de code. Cela
  empêche l'exécution/compilation et doit être traité avant une intégration.
- Les serializers utilisent `fields = '__all__'` ou des noms Django (`created_at`,
  `user_type`, `is_approved`) au lieu de l'objet contractuel camelCase.
- Aucun mécanisme de transformation camelCase global n'est configuré.
- CORS autorise des origines locales en dur et les credentials, mais
  `CSRF_TRUSTED_ORIGINS` n'est pas configuré. `FRONTEND_URL` n'est pas utilisé.
- Les permissions sont incomplètes : les vendors sont traités comme admins pour
  les commandes, et la plupart des contrôles d'appartenance vendor ne couvrent
  pas les lectures ou les routes attendues.
- Les notifications backend n'existent pas ; le frontend les conserve en
  `localStorage`, conformément à la dette indiquée dans le README frontend.

## Inventaire technique

### Applications, modèles et migrations

| Application | Modèles présents | Migrations applicatives |
| --- | --- | --- |
| users | `User`, `VendorProfile` | Absentes |
| products | `Category`, `Product`, `ProductImage`, `ProductOption`, `ProductOptionValue` | Absentes |
| orders | `Order`, `OrderItem`, `Payment` | Absentes |
| cart | `Cart`, `CartItem` | Absentes |

`AUTH_USER_MODEL = 'users.User'` est configuré. La base par défaut est PostgreSQL
et dépend d'un serveur et de variables `.env` non vérifiés dans cet audit.

### Authentification et utilisateurs

- `REST_FRAMEWORK.DEFAULT_AUTHENTICATION_CLASSES` utilise
  `knox.auth.TokenAuthentication`.
- Le login et l'inscription renvoient `{ user, token }`, pas `{ data: User,
  access? }`.
- L'inscription attend `first_name`, `last_name`, `user_type` et
  `password_confirm`, alors que le contrat attend `name`, `role: "client"` et
  `permissions`.
- Le modèle expose `user_type` (`customer`, et non `client`), `created_at` et
  `is_email_verified`; il ne fournit pas l'objet contractuel `name`, `role`,
  `permissions`, `createdAt`, `isVerified`.
- `/auth/logout/` existe via Knox, mais `/auth/me/` et `/auth/refresh/` sont
  absents. `/auth/user/` existe à la place de `/auth/me/`.
- La présence d'un cookie refresh/session n'est pas implémentée dans les vues
  observées.

## Matrice des endpoints contractuels

### Auth

| Endpoint attendu | Existe ? | Conforme au contrat ? | Écarts constatés |
| --- | --- | --- | --- |
| `POST /auth/login/` | Oui | Non | Knox, réponse `{user, token}`, serializer invalide (`******`), pas d'enveloppe `data` ni cookie refresh. |
| `POST /auth/register/` | Oui | Non | Payload et rôles divergents, réponse non conforme, serializer/manager invalides. |
| `POST /auth/logout/` | Oui | Partiel | Vue Knox ; invalide un token Knox, sans garantie de cookie refresh/session. |
| `GET /auth/me/` | Non | Non | `/auth/user/` existe à la place. |
| `POST /auth/refresh/` | Non | Non | Aucun refresh JWT/cookie. |

### Products

| Endpoint attendu | Existe ? | Conforme au contrat ? | Écarts constatés |
| --- | --- | --- | --- |
| `GET /products/` | Oui | Partiel | Pagination DRF probable, filtres Django (`search`, `ordering`, `min_price`) plutôt que `query`, `filters`, `sortBy`; seuls produits publiés. |
| `GET /products/{id}/` | Oui | Partiel | Lecture publique seulement et serializer snake_case/`__all__`. |
| `POST /products/` | Non | Non | Seule route de création sous `/products/vendor/products/`. |
| `PATCH /products/{id}/` | Non | Non | Seule route de modification sous `/products/vendor/products/{id}/`. |
| `DELETE /products/{id}/` | Non | Non | Seule route de suppression sous `/products/vendor/products/{id}/`, avec permission incomplète. |

### Vendors

| Endpoint attendu | Existe ? | Conforme au contrat ? | Écarts constatés |
| --- | --- | --- | --- |
| `GET /vendors/` | Non | Non | Route actuelle sous `/auth/vendors/`, filtrée `is_approved=True`. |
| `GET /vendors/{id}/` | Non | Non | Route actuelle sous `/auth/vendors/{id}/`. |
| `GET /vendors/{id}/products/` | Non | Non | Aucune route ; route non équivalente sous `/products/vendor/products/`. |
| `GET /vendor/dashboard/?vendor={id}` | Non | Non | Aucun dashboard ni calcul `productCount`, `sales`, `orderCount`, `conversionRate`, `commissionTotal`. |

### Orders

| Endpoint attendu | Existe ? | Conforme au contrat ? | Écarts constatés |
| --- | --- | --- | --- |
| `GET /orders/` | Oui | Partiel | Client filtré, mais admin et vendor voient toutes les commandes ; serializer `__all__`. |
| `GET /orders/{id}/` | Oui | Partiel | Contrôle propriétaire/admin ; vendor non restreint à ses produits. |
| `POST /orders/` | Oui | Non | Création ne traite pas explicitement une commande complète checkout ni ses items. |
| `PATCH /orders/{id}/` | Oui | Non | `RetrieveUpdateAPIView` accepte implicitement de nombreux champs ; aucun contrôle de transition/vendor. |
| `POST /orders/{id}/cancel/` | Non | Non | Route absente. |

### Reviews

| Endpoint attendu | Existe ? | Conforme au contrat ? | Écarts constatés |
| --- | --- | --- | --- |
| `GET /reviews/?target_type=...&target_id=...` | Non | Non | Application, modèle, serializer et vue absents. |
| `POST /reviews/` | Non | Non | Absent ; aucun contrôle auteur/commande. |

### Admin

| Endpoint attendu | Existe ? | Conforme au contrat ? | Écarts constatés |
| --- | --- | --- | --- |
| `GET /admin/dashboard/` | Non | Non | Seul l'admin Django HTML `/admin/` est déclaré. |
| `GET/PATCH /admin/vendors/` | Non | Non | Aucun endpoint, approbation/audit absents. |
| `GET/PATCH /admin/products/` | Non | Non | Aucun endpoint ni statut admin. |
| `GET /admin/orders/` | Non | Non | Absent. |
| `GET/PATCH /admin/users/` | Non | Non | Absent. |
| `GET /admin/vendor-audits/` | Non | Non | Modèle et endpoint absents. |
| `GET/POST/PATCH/DELETE /admin/categories/` | Non | Non | Seule lecture publique `/api/products/categories/`; aucune gestion admin. |

### Vendor Center

| Endpoint attendu | Existe ? | Conforme au contrat ? | Écarts constatés |
| --- | --- | --- | --- |
| `GET /vendors/{id}/products/` | Non | Non | Absent. |
| `PATCH /products/{id}/` | Non | Non | Absent à l'emplacement contractuel. |
| `GET /orders/?vendor={id}` | Oui | Non | Paramètre `vendor` ignoré ; un vendor reçoit toutes les commandes. |
| `PATCH /orders/{id}/` | Oui | Non | Pas de filtrage par vendor ni de champs transporteur/suivi/date estimée dédiés. |
| `GET /commissions/?vendor={id}` | Non | Non | Modèle, app et endpoint absents. |
| `GET /commissions/totals/` | Non | Non | Absent. |

## Sérialisation, pagination et erreurs

- DRF est configuré avec `PageNumberPagination` et `PAGE_SIZE = 20`. Les vues
  `ListAPIView` utiliseront donc la forme `{count, next, previous, results}`,
  mais aucune convention n'est documentée/garantie pour les routes futures.
- Les serializers existants exposent majoritairement `fields = '__all__'` :
  ils exposent les noms de modèles en snake_case et des champs internes.
- Aucun `djangorestframework-camel-case`, renderer/parser global, ou mapping
  explicite couvrant le contrat n'est configuré.
- Les erreurs DRF natives peuvent préserver les champs de validation, mais aucune
  enveloppe commune `{message, details}` n'est mise en place.
- Les champs `DateTimeField` Django sont compatibles ISO 8601 avec les réglages
  DRF par défaut, mais la conformité globale ne peut pas être garantie tant que
  les serializers contractuels n'existent pas.

## CORS, CSRF et connexion frontend

- `CORS_ALLOW_CREDENTIALS = True` est présent.
- Les origines `localhost:3000`, `127.0.0.1:3000`, `localhost:5173` et
  `127.0.0.1:5173` sont codées en dur.
- `CSRF_TRUSTED_ORIGINS` est absent.
- `FRONTEND_URL` est présent dans `.env.example` mais n'est pas utilisé par
  `settings.py`.
- Le frontend pointe déjà `VITE_API_URL` vers `http://localhost:8000/api` dans
  `.env.development` et `.env.example`.
- Le client Axios est configuré avec `withCredentials`, mais son code contient
  également `******`, ce qui bloque la compilation et empêche de valider le flux.

## Notifications

Aucun modèle, serializer, endpoint ou tâche backend de notification n'a été
trouvé. Le frontend utilise encore son contexte/localStorage ; la persistance
backend reste une option distincte, hors implémentation proposée ci-dessous.

## Plan de correctifs priorisé (à valider avant implémentation)

### Bloquant

| Priorité | Action | Effort | Fichiers/apps concernés | Risque |
| --- | --- | --- | --- | --- |
| B1 | Rendre le projet exécutable : corriger les séquences `******`, installer/restaurer les dépendances déclarées et générer les premières migrations. | M | `apps/users/*`, `frontend/src/api/client.ts`, virtualenv, migrations | Moyen : révèle les écarts de schéma existants. |
| B2 | Remplacer Knox par le flux JWT attendu (accès en mémoire, refresh en cookie, login/register/logout/me/refresh conformes). | L | `settings.py`, `apps/users/*`, URLs | Élevé : impacte toutes les sessions. |
| B3 | Déclarer les routes API contractuelles manquantes et configurer CORS/CSRF depuis l'environnement. | L | `araMarket/urls.py`, nouvelles apps, `settings.py`, `.env.example` | Élevé : surface API et sécurité. |

### Important

| Priorité | Action | Effort | Fichiers/apps concernés | Risque |
| --- | --- | --- | --- | --- |
| I1 | Introduire une convention camelCase unique et des serializers contractuels (`User`, `Product`, `Vendor`, `Order`, `Review`, `Category`). | L | serializers communs et apps métier | Élevé : change les payloads consommés. |
| I2 | Implémenter Products/Vendors/Orders/Reviews avec filtres, pagination, checkout, annulation et restrictions par rôle/propriétaire. | L | `apps/products`, `apps/orders`, nouvelles apps | Élevé : logique métier et stock. |
| I3 | Implémenter Vendor Center : dashboard, commandes vendor et commissions/totaux. | L | nouvelle app commissions, `apps/orders`, routes vendor | Moyen/élevé : calculs financiers. |
| I4 | Implémenter Admin Center : dashboard, vendors + raisons/audit, produits, commandes, utilisateurs, catégories. | L | nouvelle app admin ou module dédié | Élevé : opérations sensibles et permissions. |
| I5 | Ajouter des tests DRF ciblés pour chaque endpoint et chaque rôle, y compris réponses d'erreur. | L | suite de tests backend | Faible : augmente la couverture sans changer le runtime. |

### Secondaire

| Priorité | Action | Effort | Fichiers/apps concernés | Risque |
| --- | --- | --- | --- | --- |
| S1 | Ajouter les réglages cookie/CSRF de production et documenter les variables locales. | S | `settings.py`, `.env.example`, README backend | Faible. |
| S2 | Évaluer séparément une persistance `Notification` backend pour remplacer `localStorage`. | M | nouvelle app notifications, frontend | Moyen : changement de comportement et de schéma. |
| S3 | Ajouter monitoring et paiement réel. | L | hors périmètre actuel | Élevé, explicitement hors scope de cette intégration. |

## Décision attendue

La Phase 3 ne doit commencer qu'après validation de ce plan. La persistance des
notifications (S2) est volontairement exclue du périmètre par défaut et devra
faire l'objet d'une validation séparée.
