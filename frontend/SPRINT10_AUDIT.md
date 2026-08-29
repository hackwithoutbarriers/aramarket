# Audit Sprint 10

## Bloquants identifies

- Authentification et inscription reposaient sur des utilisateurs simulés et `localStorage`.
- Produits, vendeurs, commandes, reviews, commissions et tableaux de bord utilisaient des fallbacks silencieux.
- Le client API n'envoyait pas les cookies Django, ne gerait pas le CSRF et ne renouvelait pas les sessions JWT.
- Les routes metier etaient protegees uniquement par le role local persiste.

## Actions realisees

- Client Axios centralise avec `withCredentials`, CSRF, token en memoire et refresh anti-boucle.
- Auth branchee sur login/register/me/logout backend, sans persistance de donnees sensibles.
- Services critiques relies exclusivement aux endpoints API et reponses paginees/enveloppees.
- Erreurs reseau/serveur normalisees et affichage d'etats d'erreur avec retry.
- Fixtures produits limitees au mode developpement ; configuration production documentee.

## Risques a valider avec Django

- Confirmer les chemins `/auth/*`, le format des enveloppes et les noms des champs utilisateur.
- Configurer CORS, `CSRF_TRUSTED_ORIGINS`, cookies `Secure`/`SameSite` et l'endpoint refresh.
- Ajouter un monitoring (Sentry ou equivalent) et brancher les contextes messagerie/coupons sur leurs endpoints definitifs.
