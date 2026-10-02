# Architecture du réseau - JCorp

## Référence métier et adaptation

Dans le [scénario RedOne](https://docs.google.com/document/d/13dC98HuGbrRNXuTOotnaGaNbwyVlJhWZ/edit), les services sont séparés par VLAN. Un commutateur de niveau 3 contrôle les échanges entre réseaux, tandis qu'un pare-feu/proxy encadre la sortie vers Internet. Je reprends ce principe de segmentation pour JCorp, avec les plages qui me sont attribuées sur Proxmox.

| Élément | JCorp |
| --- | --- |
| Mes réseaux IP | `10.2.101.0/24` à `10.2.120.0/24` |
| Mes VLAN | 700 à 799 |
| Mes VMID | 700 à 799 |
| Réseau du premier serveur | `10.2.101.0/24` |
| VLAN prévu pour le premier serveur | 700 |
| Pont Proxmox observé | `vmbr2`, compatible VLAN |
| Contrôleur de domaine | VM 700, `JCORP-DC01`, `10.2.101.10/24` |

J'ai relié la carte réseau de la VM au pont `vmbr2`, lui-même relié à l'interface physique `eno3`. Sur la capture matérielle, la carte affiche `bridge=vmbr2` sans tag VLAN. La passerelle et le routage entre les réseaux seront configurés avec la suite de l'infrastructure.

## Flux prévus

1. Je configurerai les postes clients pour utiliser le DNS du contrôleur de domaine (`10.2.101.10`) et résoudre `ad.jcorp`.
2. Je les joindrai au domaine pour l'authentification et l'application des stratégies.
3. Je définirai les flux entre services et vers Internet selon le rôle des machines.

Les visiteurs médicaux du scénario sont des salariés nomades. Le VLAN « Visiteurs » du dossier RedOne concerne les invités Wi-Fi : ces deux notions ne doivent pas être confondues.

