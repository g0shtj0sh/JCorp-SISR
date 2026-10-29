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
| [GLPI](../Infrastructure/GLPI/GLPI.md) | Inventaire du poste pilote et cycle de ticket | Planifié |
| [Grafana et Prometheus](../Infrastructure/Supervision/Grafana-Prometheus.md) | Tableaux de bord et alerte testée | Planifié |
| [Feuille de route](../Infrastructure/Feuille-de-route.md) | Ordre des étapes et ressources proposées | Préparée |
| [Postes utilisateurs](../Infrastructure/Postes%20utilisateurs/Postes-utilisateurs.md) | Installation et configuration des clients | Jonction Debian à finaliser |

## Avancement au 29 octobre 2026

- [x] Premier contrôleur `JCORP-DC01`, VM 700 : domaine `ad.jcorp`, NetBIOS `JCORP`, DNS `10.2.101.10/24`, passerelle `10.2.101.1`.
- [x] OU, groupes et comptes en place ; connexion de Joshua Fernandes validée. Cette validation fonctionnelle ne constitue pas un inventaire individuel de tous les comptes.
- [x] DHCP contrôlé dans la console : bail de `User1.ad.jcorp` en `10.2.101.12`. Options corrigées : routeur `10.2.101.1`, DNS AD `10.2.101.10` seul, suffixe `ad.jcorp`. Captures et limites du contrôle dans la documentation AD/DHCP.
- [x] GPO configurées ; aucune campagne supplémentaire de contrôle des GPO générales demandée pour cette étape.
- [x] Windows 11, VM 701, joint au domaine avec une connexion utilisateur AD fonctionnelle.
- [x] Second contrôleur, VM 703 `DC2-JCorp`, fonctionnel selon la validation de Joshua.
- [x] NAS TrueNAS, VM 704 `JCORP-NAS01`, joint au domaine ; partage Commun et permissions terminés. Joshua confirme les contrôles complémentaires du NAS.
- [x] Lecteur S: déployé par la GPO `JCORP-Utilisateurs-LecteursReseau`, visible et accessible après reconnexion de Joshua.
- [ ] Finaliser la jonction de Debian, VM 702, au domaine lors de la prochaine étape.

## Compléments AP 1 retenus le 29 octobre 2026

- [ ] Installer GLPI et inventorier au moins le poste Windows pilote avec GLPI Agent.
- [ ] Créer, attribuer, traiter et résoudre un ticket de démonstration.
- [ ] Installer Grafana, Prometheus et les collecteurs d'une cible Windows et d'une cible Linux.
- [ ] Afficher CPU, RAM, disque et disponibilité.
- [ ] Déclencher puis résoudre une alerte de test ; documenter les résultats.

Ces services ne sont pas encore installés. La prochaine action technique reste la jonction Debian, avant les nouvelles VM. Les critères détaillés sont dans les procédures GLPI et supervision.

## Lien avec l'AP 2

L'[AP 2](../AP%202/README.md) prévoit Dokploy et un site d'offres de serveurs de jeux avec sa base de données. La plateforme Grafana de l'AP 1 supervisera ensuite ce serveur, ses conteneurs et la disponibilité du site.
