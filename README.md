# JCorp - Infrastructure SISR

Ce dépôt documente les deux ateliers professionnels (AP) de JCorp. Le scénario métier et les besoins de l'AP 1 sont adaptés du [dossier RedOne](https://docs.google.com/document/d/13dC98HuGbrRNXuTOotnaGaNbwyVlJhWZ/edit). L'infrastructure réalisée porte le nom **JCorp**.

| Atelier | Contenu | État |
| --- | --- | --- |
| [AP 1](AP%201/README.md) | Socle réseau, virtualisation et services de base ; documentation de l'Active Directory | En cours |
| AP 2 | Réservé pour la suite du projet | À venir |

## Environnement Proxmox attribué à Joshua

Selon le [document de répartition Proxmox](https://docs.google.com/document/d/1TRtCmhZaJJRo_nsAT4BwWSqLR0Czhhl84VtjxAoNYOA/edit?tab=t.0), Joshua dispose des réseaux internes **`10.2.101.0/24` à `10.2.120.0/24`**, des identifiants **VLAN 700 à 799** et des identifiants **VM Proxmox 700 à 799**. Le premier contrôleur de domaine JCorp utilise la **VM 700** et l'adresse **`10.2.101.10`**. Le VLAN 700 est prévu pour son réseau, mais son tag sur la carte de la VM reste à vérifier : il n'apparaît pas sur la capture matérielle actuelle. Cette attribution constitue la part du laboratoire utilisée pour son travail ; elle ne décrit pas à elle seule le routage ou les services des autres équipes.

Les étapes et captures présentes dans l'AP 1 indiquent ce qui a été constaté sur JCorp. Les fonctionnalités envisagées restent signalées comme telles tant qu'elles n'ont pas été vérifiées.

