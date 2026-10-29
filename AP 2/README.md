# AP 2 — Hébergement d'un site avec Docker et Dokploy

**Statut au 29 octobre 2026 : sujet retenu, préparation documentaire réalisée ; infrastructure applicative et site non déployés.**

## Objectif

Déployer et exploiter un site de présentation d'offres de serveurs de jeux sur une VM Linux dédiée, avec Dokploy, des conteneurs Docker et une base de données. La supervision créée en AP 1 sera étendue à cette plateforme.

Le site de [Nexus Games](https://nexus-games.com/) sert de référence fonctionnelle pour le catalogue et la présentation des offres. Le projet utilisera son propre nom, ses textes et ses visuels. Il s'agit d'une démonstration pédagogique : les commandes sont simulées.

La VM AP 2 fait partie d'une architecture de **deux nouvelles VM** : **4 vCPU, 4 Gio RAM et 60 Gio disque**, avec passage à 6 Gio RAM si nécessaire. GLPI et la supervision partagent l'autre VM, côté AP 1. Les identifiants et paramètres réseau proposés sont dans la [feuille de route](../Infrastructure/Feuille-de-route.md#2-deux-vm-supplémentaires-retenues), à vérifier avant création.

## Livrables

| Document | Contenu |
| --- | --- |
| [Feuille de route](../Infrastructure/Feuille-de-route.md) | Ordre, ressources proposées, décisions et prérequis |
| [Dokploy](../Infrastructure/Dokploy/Dokploy.md) | Préparation du serveur et procédure de déploiement à compléter |
| [Site d'hébergement de jeux](Site-hebergement-jeux.md) | Fonctionnalités, données et périmètre de la première version |
| [Plan de validation](Plan-de-validation.md) | Tests, preuves et résultats à renseigner |
| [Supervision](../Infrastructure/Supervision/Grafana-Prometheus.md) | Extension Grafana/Prometheus aux applications |

## Travaux prévus

- [ ] Préparer une VM Linux dédiée et installer Docker/Dokploy.
- [ ] Créer le site et son dépôt source.
- [ ] Déployer le site et la base avec stockage persistant.
- [ ] Configurer DNS, accès HTTP/HTTPS et certificat adapté.
- [ ] Tester le catalogue, les offres et le formulaire.
- [ ] Déployer une mise à jour depuis GitHub.
- [ ] Consulter les logs et revenir à une version applicative précédente.
- [ ] Superviser l'hôte, les conteneurs et la disponibilité HTTP dans Grafana.
- [ ] Compléter les captures, incidents et résultats réels.

## Limites retenues

La première version n'inclut ni paiement réel, ni facturation, ni création automatique de VPS ou de serveurs de jeux, ni panel client de gestion de serveurs. Un serveur de jeu de démonstration reste facultatif après validation du site et selon les ressources disponibles.

La publication Internet n'est pas décidée. Une démonstration interne avec DNS et certificat de laboratoire est possible. Le chantier global de sauvegarde/restauration et la segmentation complète ne sont pas ajoutés au périmètre.

Le sujet reste à faire valider par l'enseignant selon les attendus de l'atelier.

[Projet JCorp](../README.md) · [AP 1](../AP%201/README.md)
