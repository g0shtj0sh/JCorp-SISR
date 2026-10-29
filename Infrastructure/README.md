# Infrastructure JCorp

Je regroupe ici les configurations techniques de mon projet JCorp, communes aux AP 1 et AP 2. Cette infrastructure évolue au fil des ateliers : réseau, machines virtuelles, services de domaine et services ajoutés par la suite.

| Documentation | Contenu | État |
| --- | --- | --- |
| [TrueNAS](TrueNAS/TrueNAS.md) | VM 704, stockage, jonction AD, partage Commun et lecteur S: par GPO | Opérationnel |
| [Postes utilisateurs](Postes%20utilisateurs/Postes-utilisateurs.md) | Windows 11 joint au domaine ; Debian à finaliser | En cours |
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
- [ ] Terminer la jonction de Debian au domaine, dans la prochaine étape.

La segmentation complète, les sauvegardes et restaurations, les applications métier et les services supplémentaires sont hors du périmètre retenu pour cette infrastructure simplifiée. Leur absence ne constitue pas une tâche restante de cette étape.

## Scripts

| Script | Utilisation |
| --- | --- |
| [JCORP-Reset-AD.ps1](Active%20Directory/JCORP-Reset-AD.ps1) | Réinitialisation de la structure JCorp et création des comptes et groupes |
| [JCORP-GPO.ps1](GPO/JCORP-GPO.ps1) | Création des stratégies de groupe et des liens vers les OU |

Les captures de la documentation AD, DHCP et GPO sont conservées dans le sous-dossier `Active Directory/images`.

[Présentation du projet](../README.md) - [Suivi AP 1](../AP%201/README.md)
