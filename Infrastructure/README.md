# Infrastructure JCorp

Je regroupe ici les configurations techniques de mon projet JCorp, communes aux AP 1 et AP 2. Cette infrastructure évolue au fil des ateliers : réseau, machines virtuelles, services de domaine et services ajoutés par la suite.

| Documentation | Contenu | État |
| --- | --- | --- |
| [TrueNAS](TrueNAS/TrueNAS.md) | VM 704, installation du NAS et préparation du stockage | En cours |
| [Postes utilisateurs](Postes%20utilisateurs/Postes-utilisateurs.md) | VM Debian et Windows 11, caractéristiques et suivi de configuration | En cours |
| [Architecture du réseau](Architecture-du-reseau.md) | Plages IP, VLAN, pont Proxmox et machines virtuelles | En cours |
| [Active Directory, GPO, DHCP et contrôleurs de domaine](Active%20Directory/Active-Directory-GPO-DHCP-Controleurs-de-domaine.md) | Installation, domaine, DNS, OU, comptes, DHCP, GPO et captures | En cours |

## Scripts

| Script | Utilisation |
| --- | --- |
| [JCORP-Reset-AD.ps1](Active%20Directory/JCORP-Reset-AD.ps1) | Réinitialisation de la structure JCorp et création des comptes et groupes |
| [JCORP-GPO.ps1](GPO/JCORP-GPO.ps1) | Création des stratégies de groupe et des liens vers les OU |

Les captures de la documentation AD, DHCP et GPO sont conservées dans le sous-dossier `Active Directory/images`.

[Présentation du projet](../README.md) - [Suivi AP 1](../AP%201/README.md)
