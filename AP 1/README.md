# AP 1 - Socle infrastructure JCorp

## Contexte et objectif

Le dossier de référence [RedOne](https://docs.google.com/document/d/13dC98HuGbrRNXuTOotnaGaNbwyVlJhWZ/edit) décrit un siège regroupant direction, DSI, fonctions administratives, communication, développement, commercial et recherche. Il prévoit un réseau segmenté, un annuaire centralisé, DNS, DHCP, des applications métier et des accès adaptés aux personnels mobiles. Le scénario mentionne plus de 350 terminaux au siège et 480 visiteurs médicaux en métropole, plus 60 outre-mer ; ce sont des données de contexte, **pas le nombre de machines déjà déployées dans l'AP**.

Pour JCorp, l'AP 1 vise d'abord un socle opérationnel sur Proxmox : réseau propre à l'équipe, premier contrôleur de domaine et DNS, organisation des identités et premiers tests. Les autres services seront documentés après leur installation.

## Documentation

| Sujet | Contenu | État |
| --- | --- | --- |
| [Architecture du réseau](Architecture%20du%20r%C3%A9seau/Architecture-du-reseau.md) | Réservations, VLAN, adressage et flux connus | En cours |
| [Active Directory](Docs/Active%20Directory/Active-Directory.md) | VM, domaine, DNS, OU, groupes et comptes | En cours |

## Réalisé et à vérifier

- **Constaté :** VM 700 sur Proxmox, serveur `JCORP-DC01`, domaine `ad.jcorp` (`JCORP` en NetBIOS), DNS et adresse `10.2.101.10/24`. Les diagnostics AD/DNS ont réussi après la correction de l'adressage.
- **Constaté :** création des OU de services et de 17 groupes globaux de sécurité ; voir la capture de la première exécution dans la documentation AD.
- **Script préparé :** réinitialisation contrôlée de cette structure et création de 42 comptes nominatifs fictifs, soit trois par service. Son exécution sur le serveur doit être confirmée avant de présenter les 42 comptes comme déployés.
- **À documenter après réalisation :** poste client joint au domaine, GPO, partages, deuxième contrôleur de domaine, sauvegardes et autres applications utiles au scénario.


