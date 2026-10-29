# Dokploy — Plateforme de déploiement

**AP 2 — Planifiée, non installée.**

## Objectif

Préparer une VM Linux dédiée avec Docker et Dokploy pour héberger le site d'offres de serveurs de jeux et sa base de données. Le [cahier des charges du site](../../AP%202/Site-hebergement-jeux.md) décrit les fonctionnalités ; le [plan de validation](../../AP%202/Plan-de-validation.md) décrit la recette.

## Paramètres à relever

| Élément | Valeur |
| --- | --- |
| VM, nom et IP | Proposition dans la [feuille de route](../Feuille-de-route.md), à vérifier |
| Distribution/version Linux | À choisir selon les prérequis |
| Versions Docker et Dokploy | À relever lors de l'installation |
| URL d'administration | À définir |
| URL du site et certificat | À définir selon le contexte interne/public |
| Dépôt source du site et branche | À créer ou choisir |
| Technologie de l'application et de la base | À choisir |
| Volumes persistants | À définir pour les données |
| Accès à la base | Réseau applicatif interne prévu, sans publication inutile sur le LAN |
| Variables et secrets | À configurer dans la plateforme, valeurs absentes du dépôt |

## Étapes prévues

- [ ] Vérifier les ressources et affecter des paramètres réseau libres.
- [ ] Préparer Linux et les accès d'administration nécessaires.
- [ ] Installer Dokploy selon ses prérequis et relever les versions.
- [ ] Créer le projet et son environnement de démonstration.
- [ ] Préparer le dépôt applicatif et sa configuration de déploiement.
- [ ] Déployer la base avec son stockage persistant.
- [ ] Déployer le site et vérifier la connexion à la base.
- [ ] Configurer le nom DNS, le routage HTTP et le certificat adapté.
- [ ] Tester les fonctions du site depuis le poste client.
- [ ] Déployer une modification identifiable depuis GitHub et observer les logs.
- [ ] Revenir à une version applicative connue et vérifier les fonctions.
- [ ] Ajouter le serveur et les conteneurs à la supervision de l'AP 1.

Le retour de version porte d'abord sur une modification visuelle compatible avec la base. Une ancienne image applicative ne restaure pas les données ni une migration de schéma : le test prévu n'utilise pas de migration destructive.

## Preuves attendues

Version de Dokploy, services sains, déploiement réussi, volumes, URL HTTPS côté client, logs applicatifs, mise à jour visible, version rétablie et tableau Grafana. Les captures seront ajoutées dans [images](images/README.md) après réalisation.

## Références

- [Dokploy](https://dokploy.com/)
- [Documentation](https://docs.dokploy.com/)
- [Logs et métriques](https://docs.dokploy.com/docs/core/logs-and-metrics)

[Retour AP 2](../../AP%202/README.md) · [Infrastructure](../README.md)
