# Audit des liens et fonctionnalités principales

## Vérification rapide de la démo locale

### 1. Navigation principale
- Accueil / landing : présent
- Catalogue produits : présent
- Liste des boutiques : présent
- Connexion / inscription : présent
- Panier : présent
- Checkout : présent
- Compte client / commandes : présent
- Dashboard vendeur : présent
- Dashboard admin : présent

### 2. Fiches produits et boutique
- Route produit par identifiant : présente
- Fiche produit avec image, prix, avis et détails : présente
- Vue boutique vendeur / produits boutique : présente

### 3. Parcours client
- Ajout panier : fonctionnel dans le flux de démonstration
- Checkout : présent, avec validation de commande côté backend
- Historique commandes : confirmé manuellement le 29/08/2026 dans le compte client après une commande réelle (statut « En attente »)
- Avis produit : confirmé manuellement le 29/08/2026 sur une fiche produit (avis seedé affiché)

### 4. Parcours vendeur
- Dashboard vendeur : présent
- Gestion produit : présente
- Suivi des commandes : interface présente ; répercussion vendeur → compte client non confirmée lors du contrôle du 29/08/2026
- Validation des statuts commande : supportée

### 5. Parcours admin
- Dashboard admin : présent
- Liste des vendeurs : présente
- Approbation / rejet de vendeur : supportée
- Historique d’audit : supporté via `vendor-audits/`

### 6. Fonctionnalités masquées ou non persistées
- Wishlist : UI présente, mais mode démo local uniquement
- Messagerie : UI présente, mais mock / local-only pour la démo
- Ces éléments doivent être montrés comme démo UX, pas comme fonctionnalités backend complètes

### 7. Conclusion
Le périmètre central de la marketplace locale est en place et exploitable pour une démo investisseur localement ; les éléments de wishlist et messagerie restent des zones de maquette démonstrative plutôt que des fonctions backend complètes.

Contrôle manuel réel effectué le 29/08/2026 : avis seedé et historique client confirmés ; le suivi vendeur vers client et la route `/admin/vendor-audits/` restent à corriger ou à vérifier.
