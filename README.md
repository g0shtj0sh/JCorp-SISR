# JCorp

Je documente ici l'infrastructure JCorp, construite progressivement au fil des deux ateliers professionnels. L'AP 2 poursuit le même projet et ajoute des services au socle mis en place pendant l'AP 1. Je m'appuie sur le [dossier RedOne](https://docs.google.com/document/d/13dC98HuGbrRNXuTOotnaGaNbwyVlJhWZ/edit) pour définir les besoins de l'entreprise.

Je regroupe dans [Infrastructure](Infrastructure) la documentation technique commune à tout le projet : réseau, Active Directory, DNS, DHCP, GPO et contrôleurs de domaine. Les dossiers AP 1 et AP 2 présentent le suivi des ateliers.

| Partie | Contenu | État |
| --- | --- | --- |
| [Infrastructure](Infrastructure) | Réseau, Active Directory, DNS, DHCP, GPO, contrôleurs de domaine, scripts et captures | En cours |
| [AP 1](AP%201) | Objectifs et suivi du premier atelier | En cours |
| AP 2 | Objectifs et suivi du second atelier | À venir |

## Informations utiles

| Information | Valeur |
| --- | --- |
| Domaine Active Directory | `ad.jcorp` |
| Serveur AD / DNS / DHCP | `JCORP-DC01` - `10.2.101.10` |
| Passerelle réseau | `10.2.101.1` |
| Mot de passe commun du projet | `JCorp-123` |

## Ma partie sur Proxmox

Selon le [document de répartition Proxmox](https://docs.google.com/document/d/1TRtCmhZaJJRo_nsAT4BwWSqLR0Czhhl84VtjxAoNYOA/edit?tab=t.0), les réseaux internes **`10.2.101.0/24` à `10.2.120.0/24`**, les **VLAN 700 à 799** et les **VMID 700 à 799** me sont réservés pour réaliser mon infrastructure. J'ai créé mon premier contrôleur de domaine sur la **VM 700**, avec l'adresse **`10.2.101.10`**.

Je détaille la configuration et les étapes réalisées dans le dossier [Infrastructure](Infrastructure).

