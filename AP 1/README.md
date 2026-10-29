# AP 1 - Suivi du premier atelier JCorp

## Contexte et périmètre

Le dossier [RedOne](https://docs.google.com/document/d/13dC98HuGbrRNXuTOotnaGaNbwyVlJhWZ/edit) sert de référence métier. Pour JCorp, je retiens une infrastructure simple sur Proxmox : un réseau VLAN 700, deux contrôleurs de domaine, DNS, DHCP, les comptes et groupes, les GPO, un poste Windows, un poste Debian et un NAS.

La segmentation complète, les sauvegardes/restaurations, les applications métier et les services supplémentaires ne font pas partie du périmètre retenu.

## Documentation

| Sujet | Contenu | État |
| --- | --- | --- |
| [Infrastructure](../Infrastructure/README.md) | Vue globale, avancement, scripts et captures | À jour |
| [Architecture du réseau](../Infrastructure/Architecture-du-reseau.md) | Réseau VLAN 700 et machines virtuelles | À jour |
| [Active Directory, GPO, DHCP et contrôleurs](../Infrastructure/Active%20Directory/Active-Directory-GPO-DHCP-Controleurs-de-domaine.md) | Domaine, DNS, DHCP, OU, comptes et GPO | Opérationnel |
| [TrueNAS](../Infrastructure/TrueNAS/TrueNAS.md) | Stockage, jonction AD, partage Commun, permissions et lecteur S: | Terminé |
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

La configuration et la documentation technique du poste Debian ne sont pas modifiées pendant ce contrôle DHCP. La suite du travail portera sur ce poste.
