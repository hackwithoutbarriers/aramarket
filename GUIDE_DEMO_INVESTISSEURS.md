# Guide de démo investisseurs AraMarket

## 1. Lancer le projet localement

Backend (PowerShell) :

```powershell
Set-Location C:\Users\HWB\Desktop\AraMarket\backend
.\venv\Scripts\Activate.ps1
python manage.py migrate
python manage.py seed_demo_data --reset
python manage.py runserver 0.0.0.0:8000
```

Si l’état de démonstration a été altéré pendant une session, remettre le jeu de données à zéro sans réinstaller :

```powershell
Set-Location C:\Users\HWB\Desktop\AraMarket\backend
.\venv\Scripts\Activate.ps1
python manage.py seed_demo_data --reset
```

Frontend (PowerShell séparé) :

```powershell
Set-Location "C:\Users\HWB\Desktop\AraMarket\frontend"
npm install
npm run dev -- --host 0.0.0.0
```

Ouvrir :

```text
http://localhost:5173
```

Mot de passe commun pour les comptes de démonstration :

```text
DemoPass123!
```

## 2. Comptes de démonstration

| Rôle | Email | Statut attendu |
|---|---|---|
| Admin | `admin.demo@aramarket.local` | superuser |
| Vendeur approuvé | `vendor.lumiere@aramarket.local` | boutique `Lumière & Co` |
| Vendeur approuvé | `vendor.atelier@aramarket.local` | boutique `Atelier Sora` |
| Vendeur approuvé | `vendor.terra@aramarket.local` | boutique `Terra Kitchen` |
| Vendeur approuvé | `vendor.northpeak@aramarket.local` | boutique `North Peak` |
| Vendeur approuvé | `vendor.astera@aramarket.local` | boutique `Astera Wellness` |
| Vendeur en attente | `vendor.pending@aramarket.local` | boutique `Boulevard Studio` en `pending` |
| Client | `client.one@aramarket.local` | client actif |
| Client | `client.two@aramarket.local` | client actif |
| Client démo | `demo.client1@aramarket.test` | client actif pour la démo live |
| Client démo | `demo.client2@aramarket.test` | client actif pour la démo live |
| Candidat vendeur démo | `demo.vendor.applicant@aramarket.test` | candidature vendeur prête à être approuvée |

## 3. Présentation de la démo : script conseillé

### 3.1. Vue d’ensemble de la marketplace

1. Ouvrir la landing / catalogue, montrer la recherche, les catégories, les boutiques et le cadre premium.
2. Pointer la présence de plusieurs vendeurs distincts : mode, décoration, alimentation, outdoor, wellness.
3. Mettre en avant le fait que les données sont réelles et seedées localement, avec plusieurs produits et visuels par boutique.

### 3.2. Parcours client

1. Créer un compte client sur la page d’inscription, puis se connecter.
2. Utiliser `demo.client1@aramarket.test` ou `client.one@aramarket.local` pour mettre en scène le parcours sans friction.
3. Rechercher un produit puis filtrer par catégorie ; ouvrir au moins 2 fiches produits de boutiques différentes.
4. Ajouter des articles de 2 boutiques distinctes au panier.
5. Aller au checkout et finaliser une commande avec une adresse facturation/livraison.
6. Vérifier l’historique des commandes et la commande visible dans le compte client.
7. Déposer un avis sur un produit livré.
8. Ajouter un produit à la wishlist si l’on décide de la montrer ; si l’on évite cette zone, la présenter comme démo locale non persistée.
9. Se déconnecter.

### 3.3. Parcours vendeur

1. Se connecter avec `vendor.lumiere@aramarket.local` ou `vendor.terra@aramarket.local`.
2. Montrer le dashboard vendeur avec chiffres cohérents, produits et commandes réelles.
3. Ouvrir la gestion de produit, modifier un article et vérifier la mise à jour du stock ou du prix.
4. Mettre à jour une commande reçue en changeant le statut de commande.
5. Montrer la vue commissions / revenus et le volume de ventes.
6. Se déconnecter.

### 3.4. Parcours admin

1. Se connecter avec `admin.demo@aramarket.local`.
2. Montrer le dashboard global avec ventes, commandes, vendeurs approvés, catgories.
3. Créer ou utiliser la candidature vendeur `demo.vendor.applicant@aramarket.test` via le parcours public `Devenir vendeur`.
4. Dans l’admin, aller dans la liste des vendeurs et approver la candidature.
5. Vérifier ensuite que le vendeur est visible et approuvé côté boutique / vendeur.
6. Bonus : ouvrir `/admin/vendor-audits/` pour vérifier l’historique d’audit de la décision admin.
7. Vérifier la gestion des catégories / utilisateurs et un dernier indicateur marketplace.

### 3.5. Storytelling recommandé pour l’investisseur

- “Nous avons une marketplace multi-vendeurs locale, avec un catalogue riche et des ventes réelles seedées.”
- “Un client peut parcourir des boutiques différentes et passer commande sans friction.”
- “Un vendeur reçoit des commandes, met à jour son stock et voit ses revenus / commissions.”
- “Un admin valide les vendeurs et supervise la plateforme.”

## 4. Fonctionnalités volontairement masquées pour la démo

Les éléments ci-dessous existent dans le front, mais ils ne sont pas part du périmètre de démonstration live, car ils ne sont pas branchés à un backend persistant ou sont purement visuels :

- Wishlist : présente en interface, mais stockée localement dans le navigateur et non synchronisée avec le backend.
- Messagerie : simulation front-end, sans conversation backend réelle ni notifications persistées.
- Tout flux de partage social / lien public de wishlist : présent seulement dans le front local, sans service dédié.

En pratique : durant la démo, ne pas présenter la wishlist ni la messagerie comme des fonctionnalités “production-ready”. Les montrer comme des maquettes UX de démonstration ou les éviter complètement.

## 5. Points de vigilance de la démo

- Vérifier le lancement backend + frontend avant de passer en démonstration.
- Utiliser les comptes seedés plutôt que créer des comptes au hasard.
- Ne pas présenter comme “backend réel” les fonctionnalités UI-only.
- Pour les comptes client, privilégier `demo.client1@aramarket.test` et `demo.client2@aramarket.test` pour une preuve claire de l’inscription client.
- Pour la candidature vendeur, utiliser le flux public `Devenir vendeur` puis valider côté admin.

## 6. Commandes utiles

Vérification rapide du backend :

```powershell
Set-Location C:\Users\HWB\Desktop\AraMarket\backend
.\venv\Scripts\Activate.ps1
python manage.py test
```

Vérification rapide du frontend :

```powershell
Set-Location "C:\Users\HWB\Desktop\AraMarket\frontend"
npm run test
npm run build
```
