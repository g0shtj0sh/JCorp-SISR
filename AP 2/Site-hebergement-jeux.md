# Checkpoint — Cahier des charges du site

**Réalisé pour l'AP 2 — version 1.0.0 en ligne au 27 novembre 2026 ; HTTPS et recette formelle restent à faire.**

## Besoin

Présenter des offres d'hébergement de serveurs de jeux dans un site accessible depuis un poste client, puis démontrer leur déploiement et leur exploitation avec Dokploy. [Nexus Games](https://nexus-games.com/) est une référence fonctionnelle, pas une charte graphique à reproduire.

## Première version attendue

| Page ou fonction | Contenu attendu | Validation | Réalisé |
| --- | --- | --- | --- |
| Accueil | Présentation du projet et accès au catalogue | Navigation lisible sur ordinateur et mobile | Oui |
| Catalogue | Quelques offres de jeux et de VPS fictifs | Offres chargées depuis la base | Oui : 19 jeux, 2 VPS, bot Discord |
| Fiche offre | Jeu, CPU/RAM/disque, prix de démonstration et caractéristiques | Informations cohérentes avec le catalogue | Oui, avec configurateur |
| Demande simulée/contact | Offre choisie, nom, adresse de contact, message | Saisie validée et demande enregistrée | Oui, testé (T05, T06) |
| Confirmation | Résumé et indication explicite de simulation | Aucun paiement ou serveur réel créé | Oui, testé (T05) |
| Paiement simulé | Choix du moyen de paiement, passage de la commande à l'état payé | Aucun numéro de carte demandé | Ajouté le 27/11, testé |
| Pages légales | Mentions légales, CGV, confidentialité conformes | Exigences de la LCEN, du Code de la consommation et du RGPD | Ajouté le 27/11 |
| Espace client | Compte fictif, serveurs, factures, support traçable, paramètres, panel de serveur | Navigation type application web | Ajouté le 27/11, testé |

La première version ne prévoyait ni compte client ni espace d'administration ; un espace client de démonstration, sans authentification, a été ajouté le 27 novembre 2026. Le catalogue peut être initialisé avec des données de démonstration. Les demandes de test utilisent des données fictives.

## Architecture applicative proposée

Un service web applicatif expose le site et son formulaire ; un service de base de données conserve le catalogue et les demandes. Le serveur Dokploy gère le déploiement et l'accès par nom. Le service web est écrit en **Next.js** ; la base est **PostgreSQL**, créée comme base gérée dans Dokploy.

| Données minimales | Exemples de champs |
| --- | --- |
| Offre | identifiant, nom, catégorie/jeu, description, CPU, RAM, stockage, prix indicatif, actif |
| Demande | identifiant, offre choisie, nom fictif, contact fictif, message, date |

Le service web valide les entrées et accède à la base avec un compte applicatif. Les identifiants de base restent dans les variables de déploiement. Les demandes ne doivent pas être exposées dans les pages publiques.

## Déploiement et exploitation attendus

- Version du site identifiable par tag ou commit.
- Configuration de déploiement reproductible et documentée.
- Base persistante après redéploiement.
- URL DNS et HTTPS dans le contexte choisi.
- Journaux exploitables sans secrets.
- Mise à jour puis retour à une version connue sur un changement sans migration destructive.
- Contrôle HTTP et métriques visibles dans Grafana.

## Décisions ouvertes

- [x] Nom du site. *Checkpoint.*
- [x] Identité visuelle. *Logo « drapeau-étape », palette noyer et beige, police Geist, le 27 novembre 2026.*
- [x] Liste des offres fictives et visuels utilisables. *17 jeux et 2 annoncés, VPS Linux et Windows, bot Discord ; images officielles des éditeurs et illustrations générées, sources sur la page Crédits.*
- [x] Technologie du site et moteur de base. *Next.js et PostgreSQL.*
- [x] Dépôt et méthode de déclenchement des déploiements. *Dépôt public g0shtj0sh/checkpoint ; la VM interroge GitHub chaque minute et déclenche Dokploy.*
- [ ] URL interne ou domaine public ; méthode de certificat. *URL interne `checkpoint.ad.jcorp` ; certificat à choisir.*
- [x] Versions, variables nécessaires et volumes. *Node 22, Next.js 16.4.6, PostgreSQL 18 ; variables `DATABASE_URL` et `PROMETHEUS_URL` dans Dokploy ; volume de la base géré par Dokploy.*

[Retour AP 2](README.md) · [Recette](Plan-de-validation.md)
