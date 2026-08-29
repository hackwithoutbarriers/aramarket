# PRET POUR DÉMO — AraMarket

## Résumé

Statut : GO

Le projet est désormais reproductible depuis un environnement propre, la base de démonstration se réinitialise sans réinstallation, et le script de démo de [GUIDE_DEMO_INVESTISSEURS.md](GUIDE_DEMO_INVESTISSEURS.md) tient la route en conditions réelles.

## 1) Nombre de tests réel (backend / frontend)

- Backend : 11 tests passés sur 11 (`python manage.py test`)
- Frontend : 11 tests passés sur 11 (`npm run test`)

### Ce qu’il s’est passé sur le rapport antérieur

- Le compte “4 tests backend” était un mauvais total de rapport, pas un vrai effondrement de la suite : la suite Django actuelle exécute 11 tests et passe entièrement.
- Côté frontend, l’ancienne exécution échouait avec un faux négatif de Vitest : 9 tests passés, puis 1 erreur non gérée “Timeout waiting for worker to respond”. La cause n’était pas des tests cassés, mais une configuration de worker Windows instable (forks/single-fork). La configuration a été corrigée pour utiliser un pool de threads stable, ce qui donne 11 tests passés sans erreur de runner.

## 2) Test de reproductibilité en environnement propre

Validation effectuée en suivant le guide sans correction manuelle non documentée :

- nouveau virtualenv backend (`venv_clean`)
- `pip install -r requirements.txt`
- suppression de `.env` puis recréation uniquement à partir de `.env.example`
- `python manage.py migrate`
- `python manage.py seed_demo_data`
- `npm install` frontend propre
- copie de `.env.example` vers `.env` côté frontend
- `npm run dev -- --host 0.0.0.0`

Résultat :

- backend démarré proprement
- données de démonstration générées sans intervention manuelle
- frontend installé proprement
- app accessible et fonctionnelle sur http://localhost:5173
- aucune étape cachée ou correctif manuscrit non documenté nécessaire

## 3) Commande de remise à zéro sans réinstallation

Commande documentée et validée :

```powershell
Set-Location C:\Users\HWB\Desktop\AraMarket\backend
.\venv\Scripts\Activate.ps1
python manage.py seed_demo_data --reset
```

Cette commande remet la base à zéro puis reseed le jeu de démo. Elle est utile avant chaque répétition ou avant une vraie présentation.

## 4) Documentation de démo mise à jour

- Le guide mentionne désormais explicitement la vérification de l’audit vendeur via `/admin/vendor-audits/` après approbation d’un vendeur.
- Le guide ne référence plus d’état de données obsolète ; les statuts et comptes seedés restent cohérents avec la base actuelle.

## 5) Répétition générale chronométrée

Exécution de bout en bout dans l’environnement reconstruit (login client, navigation produits, ajout panier, navigation panier, login admin, visite admin/vendors) :

- durée mesurée : environ 42,7 secondes
- résultat : OK, sans blocage fonctionnel majeur

### Accrocs mineurs identifiés

- bruit de console initial : plusieurs requêtes API 401 sur les routes protégées avant authentification, ce qui est normal tant qu’un utilisateur non connecté ouvre la page.
- 404 de ressource ponctuel sur un asset distant / image non chargée : n’empêche pas le flux principal, mais vaut un petit signal d’attention avant la présentation live.
- le front est fluide dans l’ensemble ; l’interface n’a pas montré d’hésitation notable pendant la séquence de démo.

## Conclusion

Le projet est prêt pour la démonstration : redémarrage propre, remise à zéro fiable, tests réels validés, script de démo exécuté avec succès. Les points ci-dessus sont des détails mineurs à connaître, pas des blocages.
