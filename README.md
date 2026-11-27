# JCorp — Infrastructure et hébergement

Je documente l'infrastructure JCorp réalisée sur Proxmox et son évolution au fil de deux ateliers professionnels. Le [dossier RedOne](https://docs.google.com/document/d/13dC98HuGbrRNXuTOotnaGaNbwyVlJhWZ/edit) sert de référence au contexte d'entreprise ; le périmètre technique retenu reste volontairement simple.

| Partie | Objectif | État au 12 novembre 2026 |
| --- | --- | --- |
| [Infrastructure commune](Infrastructure/README.md) | Réseau, AD, DNS, DHCP, GPO, postes et NAS ; documentation des futurs services | Socle terminé ; les deux VM Linux de services sont créées, contrôlées et la première porte GLPI |
| [AP 1](AP%201/README.md) | Administrer le parc, gérer le support avec GLPI et superviser avec Grafana/Prometheus | Socle réalisé, **GLPI et supervision terminés** (inventaire, ticket, tableau de bord et alerte testée) |
| [AP 2](AP%202/README.md) | Déployer avec Dokploy un site de présentation d'offres de serveurs de jeux et sa base | Site Checkpoint v1.0 en ligne à `http://checkpoint.ad.jcorp`, déployé automatiquement par Dokploy ; HTTPS, recette et serveur Minecraft à faire |

## État du socle

- [x] Domaine `ad.jcorp`, DNS, OU, comptes et groupes.
- [x] DHCP contrôlé et options corrigées.
- [x] Windows joint au domaine et lecteur Commun S: fonctionnel.
- [x] Second contrôleur fonctionnel selon la validation de Joshua.
- [x] NAS TrueNAS joint au domaine, partage et permissions terminés.
- [x] Poste Debian joint au domaine ; identité AD contrôlée et connexion graphique validée.
- [x] VM 705 `JCORP-SRV01` et VM 706 `JCORP-APP01` créées sous Debian 13, adressées sur le VLAN 700 et contrôlées.

Les preuves et les limites des contrôles sont précisées dans chaque documentation technique.

## Programme retenu

L'AP 1 ajoute **GLPI** pour l'inventaire et le suivi d'un ticket — réalisé le 12 novembre 2026, avec une machine du parc inventoriée automatiquement et un incident traité de la création à la clôture — ainsi que **Grafana et Prometheus** pour les tableaux de bord et une alerte testée — réalisé le 19 novembre 2026, avec `JCORP-SRV01` et `JCORP-DC01` supervisés et une alerte déclenchée puis résolue lors d'une panne simulée. L'AP 2 ajoute **Dokploy**, un **site web avec une base de données**, un nom DNS et HTTPS, puis la supervision de ces nouveaux services par la plateforme de l'AP 1.

Le site s'inspire du type de catalogue de [Nexus Games](https://nexus-games.com/) : offres de serveurs de jeux, caractéristiques et contact, avec une identité propre au projet. Les commandes sont simulées. Paiement réel et création automatique de VPS ne font pas partie de la première version.

La segmentation complète et un chantier de sauvegarde/restauration de toute l'infrastructure restent exclus. Le retour à une version applicative précédente est en revanche prévu dans la démonstration AP 2.

Le déploiement retenu utilise **deux VM Linux** : une VM commune GLPI/MariaDB/Grafana/Prometheus (**2 vCPU, 4 Gio RAM, 40 Gio**) et une VM Dokploy/site/base (**4 vCPU, 4 Gio RAM, 60 Gio**, extensible à 6 Gio RAM selon besoin). Les contrôleurs AD conservent leurs rôles. Ces deux VM ont été créées le 12 novembre 2026 sous Debian 13 ; leur [procédure de création](Infrastructure/VM%20Linux/Creation-des-VM-Linux.md) détaille les commandes, les écarts avec le plan initial et la recette.

## Préparer la réalisation

La [feuille de route](Infrastructure/Feuille-de-route.md) donne l'ordre des étapes, les ressources, les décisions et les critères de validation. Les étapes 1, 2 et 5 y sont désormais couvertes, totalement ou en partie ; les valeurs encore marquées comme proposées ne constituent ni des réservations ni des installations effectuées.

Mes plages attribuées sur Proxmox restent `10.2.101.0/24` à `10.2.120.0/24`, VLAN **700 à 799**, VMID **700 à 799**. Le réseau utilisé est actuellement `10.2.101.0/24`, VLAN **700**, pont `vmbr2`. Les informations techniques détaillées se trouvent dans l'[architecture](Infrastructure/Architecture-du-reseau.md).
