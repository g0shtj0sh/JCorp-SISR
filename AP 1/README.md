# AP 1 - Suivi du premier atelier JCorp

## Contexte et périmètre

Le dossier [RedOne](https://docs.google.com/document/d/13dC98HuGbrRNXuTOotnaGaNbwyVlJhWZ/edit) sert de référence métier. Pour JCorp, je retiens une infrastructure simple sur Proxmox : un réseau VLAN 700, deux contrôleurs de domaine, DNS, DHCP, les comptes et groupes, les GPO, un poste Windows, un poste Debian et un NAS.

Le périmètre est complété par GLPI pour l'inventaire et le support, puis Grafana/Prometheus pour la supervision. La segmentation complète, le chantier global de sauvegarde/restauration et les autres applications métier restent exclus.

## Documentation

| Sujet | Contenu | État |
| --- | --- | --- |
| [Infrastructure](../Infrastructure/README.md) | Vue globale, avancement, scripts et captures | À jour |
| [Architecture du réseau](../Infrastructure/Architecture-du-reseau.md) | Réseau VLAN 700 et machines virtuelles | À jour |
| [Active Directory, GPO, DHCP et contrôleurs](../Infrastructure/Active%20Directory/Active-Directory-GPO-DHCP-Controleurs-de-domaine.md) | Domaine, DNS, DHCP, OU, comptes et GPO | Opérationnel |
| [TrueNAS](../Infrastructure/TrueNAS/TrueNAS.md) | Stockage, jonction AD, partage Commun, permissions et lecteur S: | Terminé |
| [GLPI](../Infrastructure/GLPI/GLPI.md) | Inventaire du poste pilote et cycle de ticket | Serveur installé, inventaire et ticket à faire |
| [Grafana et Prometheus](../Infrastructure/Supervision/Grafana-Prometheus.md) | Tableaux de bord et alerte testée | Planifié |
| [Feuille de route](../Infrastructure/Feuille-de-route.md) | Ordre des étapes et ressources proposées | Réalisation engagée |
| [Création des VM Linux](../Infrastructure/VM%20Linux/Creation-des-VM-Linux.md) | VM 705 `JCORP-SRV01` et 706 `JCORP-APP01` | Réalisée et vérifiée |
| [Postes utilisateurs](../Infrastructure/Postes%20utilisateurs/Postes-utilisateurs.md) | Installation et configuration des clients | Windows et Debian opérationnels |

## Avancement au 29 octobre 2026

- [x] Premier contrôleur `JCORP-DC01`, VM 700 : domaine `ad.jcorp`, NetBIOS `JCORP`, DNS `10.2.101.10/24`, passerelle `10.2.101.1`.
- [x] OU, groupes et comptes en place ; connexion de Joshua Fernandes validée. Cette validation fonctionnelle ne constitue pas un inventaire individuel de tous les comptes.
- [x] DHCP contrôlé dans la console : bail de `User1.ad.jcorp` en `10.2.101.12`. Options corrigées : routeur `10.2.101.1`, DNS AD `10.2.101.10` seul, suffixe `ad.jcorp`. Captures et limites du contrôle dans la documentation AD/DHCP.
- [x] GPO configurées ; aucune campagne supplémentaire de contrôle des GPO générales demandée pour cette étape.
- [x] Windows 11, VM 701, joint au domaine avec une connexion utilisateur AD fonctionnelle.
- [x] Second contrôleur, VM 703 `DC2-JCorp`, fonctionnel selon la validation de Joshua.
- [x] NAS TrueNAS, VM 704 `JCORP-NAS01`, joint au domaine ; partage Commun et permissions terminés. Joshua confirme les contrôles complémentaires du NAS.
- [x] Lecteur S: déployé par la GPO `JCORP-Utilisateurs-LecteursReseau`, visible et accessible après reconnexion de Joshua.
- [x] Debian, VM 702, joint au domaine dans l'OU `Postes` ; SSSD actif, compte Joshua reconnu et connexion graphique validée.

GLPI/MariaDB et Grafana/Prometheus sont regroupés dans une seule VM Linux de services (**2 vCPU, 4 Gio RAM, 40 Gio disque**), la VM **705 `JCORP-SRV01`**, créée le 12 novembre 2026. La seconde VM, **706 `JCORP-APP01`**, est dédiée à l'hébergement AP 2. Le déroulé de leur création figure dans la [procédure dédiée](../Infrastructure/VM%20Linux/Creation-des-VM-Linux.md).

## Avancement au 12 novembre 2026

- [x] VM **705 `JCORP-SRV01`** (`10.2.101.153/24`) et VM **706 `JCORP-APP01`** (`10.2.101.154/24`) créées, démarrées et contrôlées : Debian 13, IP fixes, résolution interne et externe par le DNS AD, horloge synchronisée, agent invité actif. Aucun service applicatif n'y est installé.

## Compléments AP 1 retenus le 29 octobre 2026

- [x] Installer GLPI. *GLPI **11.0.13** sur `JCORP-SRV01`, Apache 2.4.71, PHP 8.4.27, MariaDB 11.8.6. Intégrité du code validée, actions automatiques déclenchées chaque minute par un timer systemd, page d'authentification joignable depuis le VLAN 700.*
- [ ] Changer les mots de passe des quatre comptes livrés par défaut. **Point de sécurité ouvert.**
- [ ] Inventorier au moins le poste Windows pilote avec GLPI Agent.
- [ ] Créer, attribuer, traiter et résoudre un ticket de démonstration.
- [ ] Installer Grafana, Prometheus et les collecteurs d'une cible Windows et d'une cible Linux.
- [ ] Afficher CPU, RAM, disque et disponibilité.
- [ ] Déclencher puis résoudre une alerte de test ; documenter les résultats.

Le socle est terminé, les deux VM sont en place et GLPI est en service. La prochaine étape est le changement des mots de passe par défaut de GLPI, puis l'installation de GLPI Agent sur le poste pilote. La supervision n'est pas encore installée. Les critères détaillés sont dans les procédures GLPI et supervision.

## Lien avec l'AP 2

L'[AP 2](../AP%202/README.md) prévoit Dokploy et un site d'offres de serveurs de jeux avec sa base de données. La plateforme Grafana de l'AP 1 supervisera ensuite ce serveur, ses conteneurs et la disponibilité du site.
