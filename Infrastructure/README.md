# Infrastructure JCorp

Je regroupe ici les configurations techniques de mon projet JCorp, communes aux AP 1 et AP 2. Cette infrastructure évolue au fil des ateliers : réseau, machines virtuelles, services de domaine et services ajoutés par la suite.

| Documentation | Contenu | État |
| --- | --- | --- |
| [Feuille de route](Feuille-de-route.md) | Ordre AP 1/AP 2, ressources proposées et décisions | Préparée, étape 5 en cours |
| [Création des VM Linux](VM%20Linux/Creation-des-VM-Linux.md) | VM 705 `JCORP-SRV01` et 706 `JCORP-APP01`, image cloud, cloud-init et recette | Réalisée et vérifiée |
| [GLPI](GLPI/GLPI.md) | Inventaire et assistance, AP 1 | **Terminé** — GLPI 11.0.13, inventaire et cycle de ticket démontrés |
| [Grafana et Prometheus](Supervision/Grafana-Prometheus.md) | Supervision commune aux deux AP | Planifiés, non installés |
| [Dokploy](Dokploy/Dokploy.md) | Déploiement du site et de sa base, AP 2 | Planifié, non installé |
| [TrueNAS](TrueNAS/TrueNAS.md) | VM 704, stockage, jonction AD, partage Commun et lecteur S: par GPO | Opérationnel |
| [Postes utilisateurs](Postes%20utilisateurs/Postes-utilisateurs.md) | Windows 11 et Debian joints au domaine, connexions AD validées | Opérationnels |
| [Architecture du réseau](Architecture-du-reseau.md) | Plages IP, VLAN, pont Proxmox et machines virtuelles | En cours |
| [Active Directory, GPO, DHCP et contrôleurs de domaine](Active%20Directory/Active-Directory-GPO-DHCP-Controleurs-de-domaine.md) | Domaine, DNS, OU, comptes, DHCP, GPO et second contrôleur | Opérationnel |

## Périmètre et avancement retenus

Je conserve une infrastructure simple : Proxmox, réseau VLAN 700, deux contrôleurs de domaine, DNS, DHCP, comptes et groupes, GPO, un poste Windows, un poste Debian et un NAS TrueNAS.

- [x] Domaine `ad.jcorp`, DNS, OU, comptes et groupes opérationnels ; connexion du compte Joshua Fernandes validée.
- [x] DHCP contrôlé : bail Windows visible, passerelle et DNS AD corrigés dans les options de l'étendue.
- [x] GPO configurées ; pas de campagne supplémentaire de tests des GPO générales prévue pour cette étape.
- [x] Windows 11 joint au domaine et connexion d'un utilisateur AD validée.
- [x] Second contrôleur de domaine fonctionnel, selon la validation de Joshua ; aucun nouveau diagnostic de réplication n'est présenté ici.
- [x] NAS, partage Commun et permissions terminés ; Joshua confirme les contrôles complémentaires du NAS.
- [x] Lecteur Commun S: déployé par GPO et ouvert avec succès après reconnexion.
- [x] Debian VM 702 joint à `ad.jcorp` dans l'OU `Postes` ; SSSD, identité AD et connexion graphique validés.

- [x] VM 705 `JCORP-SRV01` et VM 706 `JCORP-APP01` créées le 12 novembre 2026 : Debian 13, IP fixes, résolution par le DNS AD, agent invité actif. Aucun service installé dessus à ce stade.

Le programme est complété le 29 octobre 2026 :

- [x] AP 1 : GLPI pour l'inventaire et le cycle d'un ticket. *Réalisé le 12 novembre 2026 : GLPI 11.0.13 sur `JCORP-SRV01`, actions automatiques en service, comptes par défaut sécurisés, GLPI Agent 1.21 remontant l'inventaire de `JCORP-DC01`, ticket n° 1 créé, attribué, résolu et clos.*
- [ ] AP 1 : Grafana/Prometheus pour les métriques Windows/Linux et une alerte testée.
- [ ] AP 2 : Dokploy pour déployer un site d'offres de serveurs de jeux et sa base.
- [ ] AP 2 : DNS/HTTPS, mise à jour depuis GitHub, logs, retour de version applicative et extension de la supervision.

Les deux VM qui accueilleront ces services sont en place ; aucune de ces nouvelles installations applicatives n'est en revanche effectuée. La segmentation complète, le chantier global de sauvegarde/restauration et les autres applications métier restent exclus. Paiement réel et création automatique de VPS ne font pas partie de la première version du site.

## Scripts

| Script | Utilisation |
| --- | --- |
| [JCORP-Reset-AD.ps1](Active%20Directory/JCORP-Reset-AD.ps1) | Réinitialisation de la structure JCorp et création des comptes et groupes |
| [JCORP-GPO.ps1](GPO/JCORP-GPO.ps1) | Création des stratégies de groupe et des liens vers les OU |

Les captures de la documentation AD, DHCP et GPO sont conservées dans le sous-dossier `Active Directory/images`.

[Présentation du projet](../README.md) - [Suivi AP 1](../AP%201/README.md)
