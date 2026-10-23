# TrueNAS - JCorp

Je mets en place un serveur TrueNAS pour le stockage et les partages de mon infrastructure JCorp. Cette documentation présente la création de la VM et les premières étapes de l'installation. Je la complète au fur et à mesure de la configuration.

## 1. Créer la machine virtuelle

J'ai créé la VM **704**, nommée **`NAS-JCorp`**, sur le nœud Proxmox **`pve`**. L'ISO montée est celle de **TrueNAS Community Edition 25.10.1**.

![Configuration matérielle de la VM TrueNAS 704 avec le VLAN 700](images/truenas-vm704-materiel.png)

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
| Carte réseau | VirtIO, `net0`, pont `vmbr2`, tag VLAN `700` |
| Pare-feu Proxmox sur la carte | Activé |

La capture présente uniquement le disque système de 32 Gio. Les deux disques de données de 64 Gio seront ajoutés séparément pour préparer le pool de stockage. J'ai configuré le tag VLAN **700** sur la carte réseau afin de placer le NAS dans le même réseau que les autres VM JCorp.

## 2. Démarrer sur l'ISO

J'ai démarré la VM depuis l'ISO TrueNAS. Dans le menu **TrueNAS 25.10.1 Console Setup**, je choisis **Install/Upgrade**, puis valide avec **OK** pour lancer l'assistant d'installation.

![Menu de démarrage de l'installation TrueNAS 25.10.1 avec Install Upgrade](images/truenas-install-upgrade.png)

L'installation s'effectue dans cette console, sans bureau graphique à installer dans la VM.

## 3. Choisir le disque système

L'écran **Choose Destination Media** présente le disque **`sda`**, identifié comme **QEMU HARDDISK**, d'une capacité de **32 Gio**. C'est le disque prévu pour installer TrueNAS.

![Choix du disque système sda de 32 Gio dans l'installateur TrueNAS](images/truenas-disque-systeme.png)

Je sélectionne le disque avec la **barre d'espace**, puis je valide avec **OK**. La case est encore vide sur cette capture, prise avant la sélection.

La vue rapprochée ci-dessous montre ce même disque de 32 Gio dans l'écran de sélection :

![Vue rapprochée du disque système de 32 Gio à sélectionner](images/truenas-selection-disque-32gio.png)

Le disque choisi sera effacé lors de l'installation et réservé au système TrueNAS. Il ne servira pas de disque de données pour les partages.

## 4. Choisir le compte d'administration

L'écran **Web UI Authentication Method** propose de définir le compte d'administration pendant l'installation ou de reporter cette configuration à l'interface web.

![Choix de la méthode d'authentification administrative TrueNAS](images/truenas-authentification-admin.png)

Je conserve l'option **1 - Administrative user (`truenas_admin`)**, puis je valide avec **OK**. L'étape suivante demande de définir et de confirmer le mot de passe de ce compte. J'utiliserai ensuite `truenas_admin` pour me connecter à l'interface d'administration TrueNAS.

Ce compte est propre au NAS : il est distinct du compte `JCORP\Administrateur` de mon Active Directory.

## 5. Installer le système sur le disque

Après avoir défini et confirmé le mot de passe de `truenas_admin`, j'ai validé les choix de l'installateur pour lancer l'installation sur le disque système de 32 Gio.

![Installation de TrueNAS : formatage du disque, création du pool de démarrage et extraction des fichiers](images/truenas-installation-systeme.png)

La console affiche les opérations suivantes :

1. **Formatting disk sda** : préparation et formatage du disque système sélectionné.
2. **Creating boot pool** : création du pool ZFS réservé au démarrage de TrueNAS.
3. **Creating dataset** : création du dataset utilisé par le système.
4. **Extracting** : extraction des fichiers de TrueNAS sur le disque.

Je laisse l'installation se terminer sans éteindre la VM. Sur cette capture, l'extraction est encore en cours ; le pool de démarrage est distinct du futur pool de données destiné aux partages.

## 6. Terminer l'installation et retirer l'ISO

L'installateur affiche **Installation Succeeded** et confirme que TrueNAS a été installé sur **`sda`**. Il demande de redémarrer et de retirer le support d'installation.

![Confirmation de la réussite de l'installation TrueNAS sur sda](images/truenas-installation-reussie.png)

Je valide avec **OK** pour revenir au menu de l'installateur. Pour démarrer sur le système installé, la procédure est la suivante :

1. Choisir **Shutdown System** dans le menu de l'installateur et attendre l'arrêt de la VM.
2. Dans Proxmox, ouvrir **VM 704 > Hardware > CD/DVD Drive > Edit**.
3. Sélectionner **Do not use any media**, puis valider.
4. Redémarrer la VM avec **Start**. Si nécessaire, vérifier dans **Options > Boot Order** que le disque `scsi0` est activé pour le démarrage.

TrueNAS doit ensuite démarrer depuis le disque système de 32 Gio, sans relancer l'installateur.

## 7. Configurer l'adresse IP fixe

Après le démarrage de TrueNAS, j'ai ouvert **Configure network interfaces** depuis le menu console. Sur l'interface **`ens18`**, j'ai désactivé l'adressage IPv4 par DHCP et renseigné l'alias **`10.2.101.152/24`**, puis enregistré et appliqué la modification.

![Adresse fixe 10.2.101.152 appliquée sur ens18, en attente de confirmation persistante](images/truenas-ip-fixe.png)

La capture montre `10.2.101.152/24` dans les colonnes **aliases** et **state.aliases**. Le message précise que les changements sont appliqués temporairement et seront annulés à la fin du délai sans confirmation. Pour les conserver, j'appuie sur **`p`** (*persist*), puis sur **`q`** pour revenir au menu principal.

| Paramètre de l'interface | Valeur |
| --- | --- |
| Interface | `ens18` |
| Adresse IPv4 | `10.2.101.152` |
| Préfixe / masque | `/24` / `255.255.255.0` |

Cette adresse est hors du pool DHCP actuel, de `10.2.101.11` à `10.2.101.150`.

## 8. Renseigner les paramètres réseau globaux

Depuis le menu console, j'ai ouvert **Configure network settings** pour définir le nom du NAS, son domaine de recherche, la passerelle et le serveur DNS.

![Paramètres réseau globaux de TrueNAS : nom du NAS, domaine, passerelle et DNS AD](images/truenas-configuration-reseau.png)

| Champ | Valeur renseignée |
| --- | --- |
| `hostname` | `JCORP-NAS01` |
| `domain` | `ad.jcorp` |
| `ipv4gateway` | `10.2.101.1` |
| `ipv6gateway` | Vide |
| `nameserver1` | `10.2.101.10` |
| `nameserver2` et `nameserver3` | Vides |

Je valide ces paramètres avec **Save**. Le DNS pointe vers mon contrôleur de domaine pour permettre la résolution des noms JCorp. Renseigner `ad.jcorp` ici définit le domaine réseau du NAS ; cela ne réalise pas encore sa jonction à Active Directory.

## Suite de la configuration

L'installation est terminée, l'adresse fixe et les paramètres réseau sont renseignés. Je poursuivrai avec le contrôle de l'accès à l'interface web, les deux disques de données et leur pool, avant la jonction à `ad.jcorp` et la création des partages.

[Retour à l'infrastructure](../README.md)
