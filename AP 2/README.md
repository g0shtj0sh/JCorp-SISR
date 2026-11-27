# AP 2 — Hébergement d'un site avec Docker et Dokploy

**Statut au 27 novembre 2026 : site Checkpoint v1.1 en ligne à `http://checkpoint.ad.jcorp`, relié à sa base et redéployé automatiquement à chaque commit ; commande avec paiement simulé et pages légales conformes ; espace client fictif avec panel de serveur et support traçable ; recette T01, T02 et T04 à T10 réussie ; HTTPS, supervision et serveur Minecraft restent à faire.**

## Objectif

JCorp est une entreprise fictive d'hébergement de serveurs de jeux. Sa marque grand public s'appelle **Checkpoint**. L'AP 2 déploie et exploite, sur une VM Linux dédiée et avec Dokploy :

- le **site Checkpoint** : catalogue de serveurs de jeux, de VPS et d'hébergement de bots, fiches avec configurateur, demande simulée, avec sa base de données ;
- un **serveur de jeu Minecraft** de démonstration, le produit vendu sur le site, auquel un joueur se connecte réellement.

La supervision créée en AP 1 sera étendue à cette plateforme.

Le site de [Nexus Games](https://nexus-games.com/) sert de référence fonctionnelle pour le catalogue et la présentation des offres. Le projet utilisera son propre nom, ses textes et ses visuels. Il s'agit d'une démonstration pédagogique : les commandes sont simulées.

La VM AP 2 fait partie d'une architecture de **deux VM**, créées le 12 novembre 2026 : la VM **706 `JCORP-APP01`**, `10.2.101.154/24`, **4 vCPU, 4 Gio RAM et 60 Gio disque**, avec passage à 6 Gio RAM si nécessaire. GLPI et la supervision partagent l'autre VM, la 705, côté AP 1. Le déroulé de création, les écarts et la recette figurent dans la [procédure dédiée](../Infrastructure/VM%20Linux/Creation-des-VM-Linux.md).

## Livrables

| Document | Contenu |
| --- | --- |
| [Feuille de route](../Infrastructure/Feuille-de-route.md) | Ordre, ressources proposées, décisions et prérequis |
| [Déploiement de Checkpoint](Deploiement-Checkpoint.md) | Projet, base, dépôt, application, nom DNS, liaison à la base, déploiement automatique et contenu de la v1.0 |
| [Dokploy](../Infrastructure/Dokploy/Dokploy.md) | Docker et Dokploy installés le 26 novembre 2026 |
| [Site d'hébergement de jeux](Site-hebergement-jeux.md) | Cahier des charges, offres retenues et décisions prises |
| [Plan de validation](Plan-de-validation.md) | Tests, preuves et résultats à renseigner |
| [Supervision](../Infrastructure/Supervision/Grafana-Prometheus.md) | Extension Grafana/Prometheus aux applications |

## Travaux prévus

- [x] Préparer une VM Linux dédiée. *VM 706 `JCORP-APP01`, Debian 13, créée et contrôlée le 12 novembre 2026.*
- [x] Installer Docker et Dokploy sur cette VM. *Docker 29.10.1 depuis le dépôt officiel, Dokploy v0.31.4, compte administrateur créé le 26 novembre 2026.*
- [x] Arrêter le nom, les technologies et le périmètre. *Checkpoint, Next.js et PostgreSQL, Dokploy seul, serveur Minecraft de démonstration, le 19 novembre 2026.*
- [x] Créer le site et son dépôt source. *[g0shtj0sh/checkpoint](https://github.com/g0shtj0sh/checkpoint), Next.js 16.4.6.*
- [x] Déployer le site et la base avec stockage persistant. *PostgreSQL 18 sans port publié, site relié par `DATABASE_URL`, le 26 novembre 2026.*
- [ ] Configurer DNS, accès HTTP/HTTPS et certificat adapté. *DNS et HTTP faits (`checkpoint.ad.jcorp`) ; HTTPS à faire.*
- [x] Tester le catalogue, les offres et le formulaire. *T04, T05 et T06 réussis le 27 novembre 2026.*
- [x] Ajouter le paiement simulé, les pages légales, l'espace client et son panel de serveur. *Le 27 novembre 2026.*
- [ ] Déployer un serveur Minecraft avec Dokploy et s'y connecter depuis un client.
- [x] Déployer une mise à jour depuis GitHub. *Automatique à chaque commit ; T07 et T08 réussis le 27 novembre 2026.*
- [x] Consulter les logs et revenir à une version applicative précédente. *T09 et T10 réussis le 27 novembre 2026.*
- [ ] Superviser l'hôte, les conteneurs et la disponibilité HTTP dans Grafana.
- [ ] Compléter les captures, incidents et résultats réels.

## Limites retenues

Le 27 novembre 2026, les noms de domaine et le VPS Pterodactyl ont été retirés de l'offre : le second faisait doublon avec les serveurs de jeux, les premiers sortaient du métier d'hébergeur de jeux.

Le site n'effectue aucun paiement réel et ne crée aucun serveur à la commande. Le panel de l'espace client est développé dans le site, sans Pterodactyl, et son serveur est simulé. Le serveur de jeu est créé par l'administrateur dans Dokploy ; le lien entre une commande du site et ce serveur est simulé.

La publication Internet n'est pas décidée. Une démonstration interne avec DNS et certificat de laboratoire est possible. Le chantier global de sauvegarde/restauration et la segmentation complète ne sont pas ajoutés au périmètre.

## Choix techniques du 19 novembre 2026

### Nom : Checkpoint

Le *checkpoint* est le point où un jeu sauvegarde la progression du joueur. Pour un hébergeur, le nom promet que les serveurs et les mondes de ses clients sont protégés. Il reste compréhensible par un public non joueur. Respawn Hosting et Spawnpoint ont été envisagés ; Respawn est aussi le nom d'un studio connu, ce qui pouvait prêter à confusion.

### Plateforme de déploiement : Dokploy

| Plateforme | Points forts | Limites | Décision |
| --- | --- | --- | --- |
| **Dokploy** | Interface moderne, déploiement depuis GitHub, Docker Compose, retour arrière, bases gérées, notifications Discord, métriques par conteneur | Version 0.x ; une partie du code est sous licence *source-available*, libre en test, soumise à licence commerciale en production | **Retenu** |
| Coolify | Fonctions les plus étendues, entièrement Apache 2.0 | Interface plus chargée, besoins équivalents (2 Go de RAM) | Alternative crédible |
| CapRover | Ancien (2017), stable, le plus léger (1 Go de RAM) | Interface datée, Docker Compose partiellement pris en charge | Écarté |
| Portainer | Gestion de conteneurs | Pas de déploiement depuis Git | Hors sujet |

Dokploy demande 2 Go de RAM et 30 Go de disque ; la VM 706 en dispose de 4 et 60. La limite de licence ne concerne pas une démonstration pédagogique, mais elle est notée : en production réelle, Coolify serait l'équivalent entièrement libre.

### Serveur de jeu : Dokploy plutôt que Pelican

Les hébergeurs de jeux utilisent généralement un panel dédié comme **Pelican**, successeur open source de Pterodactyl, qui sépare le panel des nœuds de jeu. Je ne le retiens pas : il ajoute une plateforme et une VM à exploiter, alors que Dokploy sait déjà déployer n'importe quel conteneur. Le serveur Minecraft sera déployé dans Dokploy par un fichier Docker Compose basé sur l'image communautaire `itzg/minecraft-server`.

Deux contraintes sont identifiées :

- **Port du jeu.** Le proxy Traefik de Dokploy route le trafic HTTP/HTTPS. Minecraft utilise un protocole propre sur TCP 25565, qui sera publié directement par le fichier Compose.
- **Mémoire.** Dokploy, le site, PostgreSQL et Minecraft sur 4 Go de RAM sera juste. Le passage à 6 Go prévu par la feuille de route sera décidé sur mesure, à partir des graphiques Grafana.

### Site : Next.js et PostgreSQL

Next.js produit un site moderne, rendu côté serveur, dans un seul conteneur ; c'est d'ailleurs la technologie du site de référence. PostgreSQL est proposé comme base gérée par Dokploy, avec sauvegarde planifiable.

Le sujet reste à faire valider par l'enseignant selon les attendus de l'atelier.

[Projet JCorp](../README.md) · [AP 1](../AP%201/README.md)
