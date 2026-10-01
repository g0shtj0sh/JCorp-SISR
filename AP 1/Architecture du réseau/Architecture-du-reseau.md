# Architecture du réseau - AP 1

## Référence métier et adaptation

Dans le [scénario RedOne](https://docs.google.com/document/d/13dC98HuGbrRNXuTOotnaGaNbwyVlJhWZ/edit), les services sont séparés par VLAN. Un commutateur de niveau 3 contrôle les échanges entre réseaux, tandis qu'un pare-feu/proxy encadre la sortie vers Internet. JCorp reprend le **principe de segmentation** dans le laboratoire Proxmox, avec les plages réellement attribuées à Joshua.

| Élément | JCorp AP 1 |
| --- | --- |
| Réseaux IP réservés | `10.2.101.0/24` à `10.2.120.0/24` |
| VLAN réservés | 700 à 799 |
| VMID réservés | 700 à 799 |
| Réseau du premier serveur | `10.2.101.0/24` |
| VLAN prévu pour le premier serveur | 700 ; tag non visible sur la carte de la VM lors du contrôle |
| Pont Proxmox observé | `vmbr2`, compatible VLAN |
| Contrôleur de domaine | VM 700, `JCORP-DC01`, `10.2.101.10/24` |

Le pont `vmbr2` est relié à l'interface physique `eno3`. La capture matérielle de la VM affiche `bridge=vmbr2` sans `tag=700` ; son affectation effective au VLAN 700 doit donc être confirmée. La passerelle du réseau `10.2.101.0/24` et les règles de routage entre VLAN ne sont pas encore documentées comme opérationnelles. Elles devront être vérifiées avant l'accès des postes situés sur d'autres réseaux.

## Flux à valider

1. Les postes clients doivent résoudre `ad.jcorp` par le DNS du contrôleur de domaine (`10.2.101.10`).
2. Ils doivent joindre le contrôleur de domaine pour l'authentification et l'application des stratégies.
3. Les flux entre services et vers Internet devront être définis selon les rôles des machines ; les plages réservées ne signifient pas que tous les VLAN sont déjà créés.

Les visiteurs médicaux du scénario sont des salariés nomades. Le VLAN « Visiteurs » du dossier RedOne concerne les invités Wi-Fi : ces deux notions ne doivent pas être confondues.

