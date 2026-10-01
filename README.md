# JCorp - Infrastructure SISR

Je documente ici mes deux ateliers professionnels (AP) pour l'infrastructure JCorp. Pour l'AP 1, je m'appuie sur le [dossier RedOne](https://docs.google.com/document/d/13dC98HuGbrRNXuTOotnaGaNbwyVlJhWZ/edit) pour définir les besoins de l'entreprise.

| Atelier | Contenu | État |
| --- | --- | --- |
| [AP 1](AP%201/README.md) | Socle réseau, virtualisation et services de base ; documentation de l'Active Directory | En cours |
| AP 2 | Réservé pour la suite du projet | À venir |

## Ma partie sur Proxmox

Selon le [document de répartition Proxmox](https://docs.google.com/document/d/1TRtCmhZaJJRo_nsAT4BwWSqLR0Czhhl84VtjxAoNYOA/edit?tab=t.0), les réseaux internes **`10.2.101.0/24` à `10.2.120.0/24`**, les **VLAN 700 à 799** et les **VMID 700 à 799** me sont réservés pour réaliser mon infrastructure. J'ai créé mon premier contrôleur de domaine sur la **VM 700**, avec l'adresse **`10.2.101.10`**.

Je détaille les étapes réalisées dans le dossier [AP 1](AP%201/README.md).

