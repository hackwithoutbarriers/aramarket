# Rapport d'intégration AraMarket

Date : 2026-08-28

## Résultat

Le backend Django a été aligné sur le contrat API du frontend :

- authentification `login`, `register`, `logout`, `me`, `refresh` ;
- JWT d'accès court en mémoire côté frontend et refresh token HttpOnly rotatif
  persisté en base ;
- payload utilisateur camelCase (`createdAt`, `isVerified`, `role`,
  `permissions`) ;
- catalogue produits, vendeurs publics et produits d'un vendeur ;
- commandes checkout, filtrage vendeur, mise à jour, annulation ;
- avis produits/vendeurs ;
- dashboard vendeur et commissions ;
- dashboard et opérations administrateur (vendeurs, produits, commandes,
  utilisateurs, catégories, audits) ;
- permissions DRF par authentification, rôle et propriété ;
- pagination DRF avec `limit` pour les collections produits ;
- CORS avec credentials et `CSRF_TRUSTED_ORIGINS` configurable ;
- migrations initiales et migration `RefreshSession`.

Les écarts snake_case/camelCase sont traités dans les serializers explicites,
sans exposer `fields = "__all__"` sur les réponses contractuelles.

## Fichiers et applications ajoutés ou adaptés

- `backend/apps/users/` : authentification JWT, serializers contractuels,
  profil vendeur, audit vendeur, sessions refresh.
- `backend/apps/products/` : statuts, champs frontend, filtres et
  routes publiques/vendor.
- `backend/apps/orders/` : champs livraison, checkout transactionnel,
  stock et annulation.
- `backend/apps/reviews/` : modèle, serializer, endpoints et tests.
- `backend/apps/commissions/` : modèle, endpoints et totaux.
- `backend/apps/admin_api/` : endpoints Admin Center et dashboard vendor.
- `backend/araMarket/settings.py` et `araMarket/urls.py` :
  configuration et branchement des routes.
- `backend/apps/*/migrations/` : migrations applicatives.

## Validation effectuée

Backend, depuis `backend` :

```text
python manage.py check                         OK
python manage.py makemigrations --check --dry-run  OK
python manage.py migrate --noinput              OK
python manage.py test                           6 tests OK
```

Le smoke test `GET /api/products/` après migration retourne `200` avec la
pagination `{count, next, previous, results}`.

Frontend, depuis `frontend` :

```text
npm run test   7 fichiers / 11 tests OK
npm run build  OK
```

Le frontend utilise déjà `VITE_API_URL=http://localhost:8000/api` dans
`.env.development` et `.env.example`, avec `withCredentials`, token d'accès en
mémoire et header CSRF.

## Lancement local

### Backend

```powershell
Set-Location C:\Users\HWB\Desktop\AraMarket\backend
.\venv\Scripts\Activate.ps1
pip install -r requirements.txt
Copy-Item .env.example .env
python manage.py migrate
python manage.py createsuperuser
python manage.py runserver
```

Pour PostgreSQL, définir `DB_ENGINE=django.db.backends.postgresql` ainsi que
`DB_NAME`, `DB_USER`, `DB_PASSWORD`, `DB_HOST` et `DB_PORT`. En développement,
l'absence de `DB_ENGINE` utilise SQLite.

### Frontend

```powershell
Set-Location "C:\Users\HWB\Desktop\AraMarket\frontend"
npm install
npm run dev
```

Le frontend est alors disponible sur `http://localhost:5173` et l'API sur
`http://localhost:8000/api`.

## Déploiement

Avant déploiement :

1. définir une vraie `SECRET_KEY` et `DEBUG=False` ;
2. définir `ALLOWED_HOSTS` ;
3. définir `FRONTEND_URL` et `CSRF_TRUSTED_ORIGINS` avec les origines HTTPS ;
4. utiliser PostgreSQL et exécuter `python manage.py migrate` ;
5. exécuter `python manage.py collectstatic --noinput` ;
6. servir Django avec un serveur WSGI/ASGI et HTTPS ;
7. conserver `CORS_ALLOW_CREDENTIALS=True` uniquement avec des origines
   explicitement autorisées.

Le refresh token est désormais en base et ne dépend pas de la mémoire d'un
processus unique. Les tests de charge, la configuration du reverse proxy et les
secrets d'environnement restent à effectuer dans l'infrastructure cible.

## Dette technique hors périmètre

- Les notifications restent dans le `localStorage` frontend ; leur persistance
  backend n'est pas nécessaire au contrat actuel et reste une évolution séparée.
- Le paiement réel, le monitoring/alerting, la messagerie temps réel et les
  tâches asynchrones ne sont pas implémentés dans cette intégration.
- Un parcours manuel navigateur avec données métier réalistes est recommandé
  après provisionnement de PostgreSQL, création d'un client/vendor/admin et
  chargement des catégories/produits.
