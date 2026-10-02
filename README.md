# JCorp - Infrastructure SISR

Je documente ici l'infrastructure JCorp, construite progressivement au fil des deux ateliers professionnels. L'AP 2 poursuit le même projet et ajoute des services au socle mis en place pendant l'AP 1. Je m'appuie sur le [dossier RedOne](https://docs.google.com/document/d/13dC98HuGbrRNXuTOotnaGaNbwyVlJhWZ/edit) pour définir les besoins de l'entreprise.

L'[architecture du réseau](Architecture%20du%20r%C3%A9seau/Architecture-du-reseau.md) se trouve à la racine, car elle concerne l'ensemble de JCorp.

| Atelier | Contenu | État |
| --- | --- | --- |
| [AP 1](AP%201/README.md) | Mise en place initiale, avec le premier contrôleur de domaine et l'Active Directory | En cours |
| AP 2 | Suite de l'infrastructure et ajout des autres services | À venir |

## Ma partie sur Proxmox

Selon le [document de répartition Proxmox](https://docs.google.com/document/d/1TRtCmhZaJJRo_nsAT4BwWSqLR0Czhhl84VtjxAoNYOA/edit?tab=t.0), les réseaux internes **`10.2.101.0/24` à `10.2.120.0/24`**, les **VLAN 700 à 799** et les **VMID 700 à 799** me sont réservés pour réaliser mon infrastructure. J'ai créé mon premier contrôleur de domaine sur la **VM 700**, avec l'adresse **`10.2.101.10`**.

Je détaille les étapes réalisées dans le dossier [AP 1](AP%201/README.md).

