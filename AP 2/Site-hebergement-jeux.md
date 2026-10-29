# Site d'offres de serveurs de jeux — Cahier des charges

**Prévu pour l'AP 2 — développement non commencé.**

## Besoin

Présenter des offres d'hébergement de serveurs de jeux dans un site accessible depuis un poste client, puis démontrer leur déploiement et leur exploitation avec Dokploy. [Nexus Games](https://nexus-games.com/) est une référence fonctionnelle, pas une charte graphique à reproduire.

## Première version attendue

| Page ou fonction | Contenu attendu | Validation |
| --- | --- | --- |
| Accueil | Présentation du projet et accès au catalogue | Navigation lisible sur ordinateur et mobile |
| Catalogue | Quelques offres de jeux et de VPS fictifs | Offres chargées depuis la base |
| Fiche offre | Jeu, CPU/RAM/disque, prix de démonstration et caractéristiques | Informations cohérentes avec le catalogue |
| Demande simulée/contact | Offre choisie, nom, adresse de contact, message | Saisie validée et demande enregistrée |
| Confirmation | Résumé et indication explicite de simulation | Aucun paiement ou serveur réel créé |

Pas de comptes clients ni d'espace d'administration à développer dans la première version. Le catalogue peut être initialisé avec des données de démonstration. Les demandes de test utilisent des données fictives.

## Architecture applicative proposée

Un service web applicatif expose le site et son formulaire ; un service de base de données conserve le catalogue et les demandes. Le serveur Dokploy gère le déploiement et l'accès par nom. La technologie web et le moteur de base restent à choisir avant le développement.

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

- [ ] Nom du site et identité visuelle.
- [ ] Liste des offres fictives et visuels utilisables.
- [ ] Technologie du site et moteur de base.
- [ ] Dépôt et méthode de déclenchement des déploiements.
- [ ] URL interne ou domaine public ; méthode de certificat.
- [ ] Versions, variables nécessaires et volumes.

[Retour AP 2](README.md) · [Recette](Plan-de-validation.md)
