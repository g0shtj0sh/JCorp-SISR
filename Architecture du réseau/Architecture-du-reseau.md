# Architecture du réseau - JCorp

## Référence métier et adaptation

Dans le [scénario RedOne](https://docs.google.com/document/d/13dC98HuGbrRNXuTOotnaGaNbwyVlJhWZ/edit), les services sont séparés par VLAN. Un commutateur de niveau 3 contrôle les échanges entre réseaux, tandis qu'un pare-feu/proxy encadre la sortie vers Internet. Je reprends ce principe de segmentation pour JCorp, avec les plages qui me sont attribuées sur Proxmox.

| Élément | JCorp |
| --- | --- |
| Mes réseaux IP | `10.2.101.0/24` à `10.2.120.0/24` |
| Mes VLAN | 700 à 799 |
| Mes VMID | 700 à 799 |
| Réseau du premier serveur | `10.2.101.0/24` |
| VLAN du premier serveur | 700 |
| Pont Proxmox observé | `vmbr2`, compatible VLAN |
| Contrôleur de domaine | VM 700, `JCORP-DC01`, `10.2.101.10/24` |
| Second contrôleur de domaine | VM 701, `JCORP-DC02`, en cours de création |
| Poste Windows 11 | VM 702, en cours de création |
| Poste Debian | VM 703, en cours de création |
| DHCP | Rôle installé sur `JCORP-DC01`, pool `10.2.101.11` à `10.2.101.150` |
| Passerelle du premier serveur | `10.2.101.1` |

J'ai relié la carte réseau de la VM au pont `vmbr2`, lui-même relié à l'interface physique `eno3`. Au départ, la carte n'avait pas de tag VLAN et la VM ne joignait pas sa passerelle. J'ai ajouté le tag **700** à la carte réseau ; le ping vers **`10.2.101.1`** répond maintenant sans perte. Le routage entre les autres réseaux sera ajouté avec la suite de l'infrastructure.

## Flux prévus

1. Je configurerai les postes clients pour utiliser le DNS du contrôleur de domaine (`10.2.101.10`) et résoudre `ad.jcorp`.
2. Je les joindrai au domaine pour l'authentification et l'application des stratégies.
3. Je définirai les flux entre services et vers Internet selon le rôle des machines.

Les visiteurs médicaux du scénario sont des salariés nomades. Le VLAN « Visiteurs » du dossier RedOne concerne les invités Wi-Fi : ces deux notions ne doivent pas être confondues.

