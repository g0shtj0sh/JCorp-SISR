# AP 2 — Plan de validation et preuves

**T01 et T02 réussis le 26 novembre 2026 ; T04 et T08 constatés en usage les 26 et 27 novembre, à formaliser avec leurs captures ; les autres tests sont à faire.** Les preuves sont dans la [procédure de déploiement](Deploiement-Checkpoint.md).

Avant la recette, consigner les versions Linux, Docker, Dokploy, application et base, le commit testé, l'URL, la date et l'opérateur.

| ID | Contrôle | Résultat attendu | État |
| --- | --- | --- | --- |
| T01 | Déployer depuis le dépôt source | Déploiement réussi, services sains | **Réussi le 26/11/2026** : commit `4882a99`, après l'incident Node 18 ([procédure](Deploiement-Checkpoint.md#étape-6--application-dans-dokploy)) |
| T02 | Ouvrir le site depuis le client | Nom DNS résolu et page accessible | **Réussi le 26/11/2026** : `http://checkpoint.ad.jcorp` depuis la VM 701 |
| T03 | Vérifier HTTPS | Certificat valide et approuvé dans le contexte retenu | À faire |
| T04 | Consulter le catalogue et une offre | Contenu issu de la base, données cohérentes | Constaté : 19 jeux, 2 VPS et le bot lus en base ; capture à produire |
| T05 | Envoyer une demande simulée valide | Confirmation et enregistrement en base | À faire |
| T06 | Envoyer un formulaire incomplet | Erreurs compréhensibles, absence d'enregistrement invalide | À faire |
| T07 | Redéployer l'application | Offres et demande précédente conservées | À faire |
| T08 | Déployer une modification visuelle depuis GitHub | Nouveau commit identifié et modification visible | Constaté : 24 déploiements automatiques ; capture à produire |
| T09 | Consulter les journaux | Requête ou démarrage identifiable, aucun secret visible | À faire |
| T10 | Rétablir la version précédente | Ancien rendu retrouvé, site et base toujours fonctionnels | À faire |
| T11 | Consulter Grafana | Mesures hôte/conteneurs et contrôle HTTP présents | À faire |
| T12 | Simuler l'arrêt du site | Alerte après la durée configurée puis résolution après relance | À faire |
| T13 | Déployer le serveur Minecraft dans Dokploy | Conteneur sain, port 25565 joignable | À faire |
| T14 | Se connecter au serveur depuis un client Minecraft | Connexion réussie au monde de démonstration | À faire |
| T15 | Observer la mémoire de la VM avec le jeu actif | Marge suffisante ou passage à 6 Go justifié par les mesures | À faire |

T12 porte sur le site de démonstration, pas sur les services AD/DNS/DHCP. T10 utilise une modification compatible avec la base et ne prétend pas tester une restauration de données.

## Résultat à renseigner pour chaque test

- Date, opérateur et versions/commit.
- Étapes exactes et résultat observé.
- Réussite, échec ou blocage, avec référence de capture.
- Incident éventuel, correction puis nouveau résultat.

## Captures à conserver

| Nom proposé | Preuve |
| --- | --- |
| 01-dokploy-projet.png | Projet et services |
| 02-deploiement-reussi.png | Statut du déploiement et version |
| 03-site-https.png | Page et URL HTTPS |
| 04-catalogue-offre.png | Offre fonctionnelle |
| 05-demande-simulee.png | Confirmation du formulaire |
| 06-donnees-persistantes.png | Données de test après redéploiement |
| 07-mise-a-jour.png | Nouvelle version visible |
| 08-logs.png | Journaux utiles |
| 09-retour-version.png | Version rétablie |
| 10-supervision.png | Métriques et disponibilité |
| 11-alerte.png | Alerte déclenchée |
| 12-alerte-resolue.png | Retour à la normale |

Les preuves applicatives iront dans [images](images/README.md). Les paramètres Dokploy et de supervision restent documentés dans leurs dossiers techniques respectifs. Ne joindre des liens d'images dans les procédures qu'une fois les fichiers réellement présents.

[Retour AP 2](README.md)
