# Postes utilisateurs - JCorp

Je regroupe ici la mise en place de mes postes utilisateurs Debian et Windows 11. Je complète cette documentation au fur et à mesure des configurations et des tests.

| Poste | VMID | Nom dans Proxmox | Avancement |
| --- | --- | --- | --- |
| Debian | 702 | `User2-JCorp-Debian` | Système installé, configuration réseau et intégration au domaine à suivre |
| Windows 11 | 701 | `User1-JCorp-Windows` | Installation en cours |

## 1. Poste Debian

J'ai créé la VM **702**, nommée **`User2-JCorp-Debian`**, sur le nœud Proxmox `pve`, puis installé Debian. La capture ci-dessous présente son matériel et confirme que sa carte réseau utilise le pont `vmbr2` avec le **VLAN 700**.

![Caractéristiques matérielles de la VM Debian 702 dans Proxmox](images/debian-vm702-materiel.png)

### Caractéristiques de la VM

| Élément | Configuration |
| --- | --- |
| Mémoire vive | 2 Gio |
| Processeur | 2 vCPU, 1 socket et 2 cœurs ; type `x86-64-v2-AES` |
| BIOS | SeaBIOS |
| Type de machine | `i440fx` |
| Contrôleur SCSI | VirtIO SCSI single |
| Disque système | 32 Gio, `scsi0`, stockage `Raid5-VMs`, IO thread activé |
| ISO montée | `debian-13.3.0-amd64-netinst.iso`, sur le stockage `local` |
| Carte réseau | VirtIO, `net0` |
| Pont réseau et VLAN | `vmbr2`, tag `700` |
| Pare-feu Proxmox sur la carte | Activé |
| Adresse MAC | `BC:24:11:A1:7E:96` |

### Suite de la configuration

Je poursuivrai avec le contrôle de l'adresse IP, de la passerelle et du DNS, puis l'intégration au domaine `ad.jcorp` et un test de connexion avec un compte utilisateur du domaine.

## 2. Poste Windows 11

J'ai créé la VM **701**, nommée **`User1-JCorp-Windows`** dans Proxmox. L'installation de Windows 11 est en cours. J'ajouterai ses caractéristiques et les captures de configuration au fil de sa mise en place.

La suite comprendra la jonction au domaine `ad.jcorp`, le placement du poste dans l'OU `Postes`, puis les tests de connexion et d'application des GPO.

[Retour à l'infrastructure](../README.md)
