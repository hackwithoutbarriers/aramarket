# Guide de test local AraMarket

## Lancer l'application

Backend (PowerShell) :

```powershell
Set-Location C:\Users\HWB\Desktop\AraMarket\backend
.\venv\Scripts\Activate.ps1
pip install -r requirements.txt
Copy-Item .env.example .env
python manage.py migrate
python manage.py seed_demo_data
python manage.py runserver
```

Frontend (dans un autre terminal PowerShell) :

```powershell
Set-Location "C:\Users\HWB\Desktop\AraMarket\frontend"
npm install
npm run dev
```

Ouvrir `http://localhost:5173`. Les identifiants sont dans
[SEED_CREDENTIALS.md](./SEED_CREDENTIALS.md), avec le mot de passe
`DemoPass123!`.

## Scénario client

1. Créer un compte client, se connecter, recharger la page puis vérifier
   `/auth/me/`; se déconnecter et vérifier que l'accès authentifié disparaît.
2. Se reconnecter avec `client.one@aramarket.local`, parcourir le catalogue,
   utiliser recherche, filtre, tri et pagination, puis ouvrir une fiche produit.
3. Ajouter `Last-Mile Backpack` au panier et passer commande avec une adresse.
   Vérifier que son stock passe de 1 à 0 et qu'un nouvel achat est refusé.
4. Consulter les commandes puis annuler une commande encore `pending`.
5. Avec le compte seedé, ouvrir l'avis du produit livré et déposer une note.
   Essayer ensuite un produit jamais acheté ou un identifiant inexistant :
   l'API doit répondre `400`.

## Scénario vendor

1. Se connecter avec `vendor.approved@aramarket.local`. Le dashboard doit
   afficher 3 produits, 2 commandes liées au magasin, des ventes incluant la
   commande livrée et une commission de 8.99.
2. Créer, modifier et réapprovisionner un produit. Vérifier que les commandes
   visibles appartiennent à ce vendor.
3. Tenter de modifier l'une des commandes d'un autre vendor (si elle existe) :
   l'API doit refuser l'accès. Tester aussi une transition de statut invalide.
4. Se connecter avec `vendor.pending@aramarket.local` : dashboard, produits et
   commandes vendor doivent être refusés jusqu'à approbation.

## Scénario admin

1. Se connecter avec `admin.demo@aramarket.local`, consulter le dashboard et
   vérifier les compteurs, les produits, commandes et catégories.
2. Approuver le vendor pending avec une raison vide ou le rejeter avec une
   raison ; vérifier l'entrée correspondante dans `/api/admin/vendor-audits/`.
3. Modifier le statut d'un produit, désactiver un utilisateur et effectuer le
   CRUD d'une catégorie.

## Contrôles négatifs et configuration vérifiée

- Un client reçoit `403` sur les routes `/api/vendor/` et `/api/admin/`.
- Un vendor reçoit `403` sur les routes `/api/admin/`.
- `FRONTEND_URL` est lu par `araMarket/settings.py` et alimente CORS ainsi que
  CSRF ; les origines localhost et 127.0.0.1 sur le port 5173 sont présentes.
- En l'absence de `DB_ENGINE`, le test local utilise SQLite (`db.sqlite3`) ;
  `migrate` et `makemigrations --check --dry-run` doivent réussir.
- Les listes DRF utilisent `{count, next, previous, results}`, y compris
  produits, commandes, avis, vendors et listes admin.
- Les séquences `******` ont été supprimées du code backend et frontend.
- Le cookie refresh est HttpOnly, `SameSite=Lax`, limité à `/api/auth/`, et
  Axios utilise `withCredentials` ainsi que `X-CSRFToken`.

Le paiement réel, PostgreSQL et une validation navigateur automatisée restent
des vérifications d'infrastructure distinctes ; le scénario ci-dessus est
prévu pour être exécuté dans un navigateur local réel.
