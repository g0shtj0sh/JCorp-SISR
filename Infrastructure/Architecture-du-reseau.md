# Architecture du réseau - JCorp

Cette architecture fait partie de mon [infrastructure commune](README.md). La configuration AD, DNS, DHCP et GPO est présentée dans la [documentation des services de domaine](Active%20Directory/Active-Directory-GPO-DHCP-Controleurs-de-domaine.md).

## Référence métier et adaptation

Dans le [scénario RedOne](https://docs.google.com/document/d/13dC98HuGbrRNXuTOotnaGaNbwyVlJhWZ/edit), les services sont séparés par VLAN. Un commutateur de niveau 3 contrôle les échanges entre réseaux, tandis qu'un pare-feu/proxy encadre la sortie vers Internet. Pour cette réalisation simplifiée, j'utilise le VLAN 700 et le réseau `10.2.101.0/24`. Les autres plages restent attribuées mais leur segmentation complète est hors périmètre.

| Élément | JCorp |
| --- | --- |
| Mes réseaux IP | `10.2.101.0/24` à `10.2.120.0/24` |
| Mes VLAN | 700 à 799 |
| Mes VMID | 700 à 799 |
| Réseau du premier serveur | `10.2.101.0/24` |
| VLAN du premier serveur | 700 |
| Pont Proxmox observé | `vmbr2`, compatible VLAN |
| Contrôleur de domaine | VM 700, `JCORP-DC01`, `10.2.101.10/24` |
| Poste Windows 11 | VM 701, `User1-JCorp-Windows`, joint au domaine, bail DHCP `10.2.101.12`, lecteur S: Commun fonctionnel |
| Poste Debian | VM 702, `User2-JCorp-Debian`, Debian installé, pont `vmbr2` et VLAN 700 |
| Second contrôleur de domaine | VM 703, `DC2-JCorp`, fonctionnel selon la validation de Joshua |
| NAS TrueNAS | VM 704, `NAS-JCorp`, TrueNAS CE 25.10.1 joint au domaine, partage Commun et GPO du lecteur S: opérationnels, IP fixe `10.2.101.152/24` renseignée, pont `vmbr2` et VLAN 700 |
| DHCP | Rôle installé sur `JCORP-DC01`, pool `10.2.101.11` à `10.2.101.150` |
| Passerelle du premier serveur | `10.2.101.1` |

J'ai relié la carte réseau de la VM au pont `vmbr2`, lui-même relié à l'interface physique `eno3`. Au départ, la carte n'avait pas de tag VLAN et la VM ne joignait pas sa passerelle. J'ai ajouté le tag **700** à la carte réseau ; le ping vers **`10.2.101.1`** répond maintenant sans perte. La segmentation complète entre les autres réseaux n'est pas retenue pour cette réalisation.

## Fonctionnement retenu

1. Le DHCP de `JCORP-DC01` est configuré pour distribuer les adresses du pool `10.2.101.11–10.2.101.150`, la passerelle `10.2.101.1`, le DNS AD `10.2.101.10` et le suffixe `ad.jcorp`. Les options ont été contrôlées et corrigées le 29 octobre 2026.
2. Le poste Windows est joint au domaine pour l'authentification et les GPO. La jonction de Debian reste la prochaine étape.
3. Le NAS fixe `10.2.101.152` expose le partage Commun ; la GPO monte `\\JCORP-NAS01.ad.jcorp\Commun` en S: pour les utilisateurs de l'OU Utilisateurs.

Les sauvegardes/restaurations, les applications métier et les services supplémentaires sont exclus du périmètre actuel.

Les visiteurs médicaux du scénario sont des salariés nomades. Le VLAN « Visiteurs » du dossier RedOne concerne les invités Wi-Fi : ces deux notions ne doivent pas être confondues.

