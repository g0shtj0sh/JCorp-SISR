# TrueNAS - JCorp

Je mets en place un serveur TrueNAS pour le stockage et les partages de mon infrastructure JCorp. Cette documentation présente la création de la VM et les premières étapes de l'installation. Je la complète au fur et à mesure de la configuration.

## 1. Créer la machine virtuelle

J'ai créé la VM **704**, nommée **`NAS-JCorp`**, sur le nœud Proxmox **`pve`**. L'ISO montée est celle de **TrueNAS Community Edition 25.10.1**.

![Configuration matérielle initiale de la VM TrueNAS 704 dans Proxmox](images/truenas-vm704-materiel.png)

| Élément | Configuration visible |
| --- | --- |
| VMID et nom Proxmox | `704`, `NAS-JCorp` |
| Mémoire vive | 10 Gio, ballooning désactivé |
| Processeur | 2 vCPU, 1 socket et 2 cœurs, type `x86-64-v2-AES` |
| BIOS | SeaBIOS |
| Type de machine | `i440fx` |
| Contrôleur SCSI | VirtIO SCSI single |
| Disque système | 32 Gio, `scsi0`, stockage `Raid5-VMs`, IO thread activé |
| ISO | TrueNAS CE 25.10.1 sur le stockage `local` |
| Carte réseau | VirtIO, `net0`, pont `vmbr2` |
| Pare-feu Proxmox sur la carte | Activé |

La capture présente uniquement le disque système de 32 Gio. Les deux disques de données de 64 Gio seront ajoutés séparément pour préparer le pool de stockage. Aucun tag VLAN n'apparaît encore dans la ligne de la carte réseau : je dois renseigner **700** pour placer le NAS dans le même réseau que les autres VM JCorp.

## 2. Démarrer sur l'ISO

J'ai démarré la VM depuis l'ISO TrueNAS. Dans le menu **TrueNAS 25.10.1 Console Setup**, je choisis **Install/Upgrade**, puis valide avec **OK** pour lancer l'assistant d'installation.

![Menu de démarrage de l'installation TrueNAS 25.10.1 avec Install Upgrade](images/truenas-install-upgrade.png)

L'installation s'effectue dans cette console, sans bureau graphique à installer dans la VM.

## 3. Choisir le disque système

L'écran **Choose Destination Media** présente le disque **`sda`**, identifié comme **QEMU HARDDISK**, d'une capacité de **32 Gio**. C'est le disque prévu pour installer TrueNAS.

![Choix du disque système sda de 32 Gio dans l'installateur TrueNAS](images/truenas-disque-systeme.png)

Je sélectionne le disque avec la **barre d'espace**, puis je valide avec **OK**. La case est encore vide sur cette capture, prise avant la sélection.

Le disque choisi sera effacé lors de l'installation et réservé au système TrueNAS. Il ne servira pas de disque de données pour les partages.

## Suite de la configuration

Je poursuivrai avec le compte d'administration et la fin de l'installation, puis le retrait de l'ISO et le démarrage sur le disque système. Je configurerai ensuite le réseau, les deux disques de données et leur pool, avant l'intégration à `ad.jcorp` et la création des partages.

[Retour à l'infrastructure](../README.md)
