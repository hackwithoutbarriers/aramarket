# Stockage de l'authentification

Le frontend actuel n'a pas encore de backend Django : l'adaptateur de démonstration
persiste uniquement l'objet utilisateur dans `localStorage` sous la clé `user`. Aucun
jeton d'accès réel n'est généré ou envoyé sur le réseau à ce stade.

Cette persistance est pratique pour le prototype, mais `localStorage` est lisible par
tout script exécuté dans l'origine et doit donc être considérée comme exposée en cas
de XSS. Elle ne doit pas être conservée pour la mise en production.

Lors de l'intégration Django, la stratégie retenue est un access token conservé en
mémoire uniquement, avec renouvellement par endpoint dédié et cookie `HttpOnly`,
`Secure`, `SameSite` pour le refresh token. Les appels Axios devront renouveler la
session sur expiration et déconnecter l'utilisateur si le refresh échoue.
