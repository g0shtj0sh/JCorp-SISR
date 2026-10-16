# Postes utilisateurs - JCorp

Je regroupe ici la mise en place de mes postes utilisateurs Debian et Windows 11. Je complète cette documentation au fur et à mesure des configurations et des tests.

| Poste | VMID | Nom dans Proxmox | Avancement |
| --- | --- | --- | --- |
| Debian | 702 | `User2-JCorp-Debian` | Réseau et résolution DNS validés, jonction au domaine à suivre |
| Windows 11 | 701 | `User1-JCorp-Windows` | Système installé, jonction au domaine à suivre |

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

### Configurer le DNS du domaine

Mon poste Debian utilise l'adresse `10.2.101.11/24`. J'ai conservé l'adressage automatique et configuré NetworkManager pour utiliser le DNS de mon contrôleur de domaine, `10.2.101.10`, avec le suffixe de recherche `ad.jcorp`.

```bash
CONN=$(nmcli -g GENERAL.CONNECTION device show ens18)
sudo nmcli connection modify "$CONN" ipv4.ignore-auto-dns yes ipv4.dns "10.2.101.10" ipv4.dns-search "ad.jcorp"
sudo nmcli connection up "$CONN"
```

L'option `ipv4.ignore-auto-dns yes` empêche les DNS reçus par DHCP de remplacer celui que j'ai choisi. La connexion est ensuite réactivée pour appliquer la configuration.

![Configuration du DNS AD et réactivation de la connexion réseau dans Debian](images/debian-configuration-dns.png)

### Vérifier la résolution et l'accès au contrôleur

J'ai contrôlé le DNS utilisé, la résolution du nom du serveur et la communication avec son adresse IP :

```bash
cat /etc/resolv.conf
getent hosts jcorp-dc01.ad.jcorp
ping -c 3 10.2.101.10
```

Le fichier `/etc/resolv.conf` contient `search ad.jcorp` et `nameserver 10.2.101.10`. Le nom `jcorp-dc01.ad.jcorp` est résolu en `10.2.101.10`. Les trois requêtes ping reçoivent une réponse, avec **0 % de perte**. Le poste peut donc résoudre le nom de mon contrôleur de domaine et le joindre sur le réseau.

![Résolution DNS du contrôleur JCorp et test ping réussi depuis Debian](images/debian-tests-dns-ping.png)

### Installer les outils de jonction au domaine

J'ai lancé l'installation des outils nécessaires à l'intégration de Debian dans mon Active Directory :

```bash
sudo apt update
sudo apt install realmd sssd-ad sssd-tools adcli libnss-sss libpam-sss samba-common-bin
```

`realmd` permet de découvrir et de joindre le domaine, `adcli` participe à la création du compte ordinateur dans AD, et SSSD fournit l'accès aux identités et à l'authentification du domaine. Les modules NSS et PAM permettent à Debian d'utiliser ces comptes pour les connexions.

![Installation en cours des paquets pour joindre Debian au domaine AD](images/debian-installation-outils-ad.png)

Sur cette capture, j'ai confirmé l'installation et APT est encore en cours de téléchargement. Les lignes `Ign` ne prouvent pas que l'installation a réussi : je dois attendre le résultat final et le retour de l'invite de commande avant de continuer.

### Découvrir le domaine (étape suivante)

Une fois les paquets installés, je lancerai :

```bash
realm discover ad.jcorp
```

Le résultat attendu doit identifier le domaine `ad.jcorp` et indiquer `server-software: active-directory`.

### Joindre Debian au domaine (à effectuer)

Je joindrai le poste directement à l'OU `Postes` avec un compte administrateur du domaine :

```bash
sudo realm join --user=Administrateur --computer-ou="OU=Postes,DC=ad,DC=jcorp" ad.jcorp
```

Je saisirai le mot de passe du compte AD uniquement à l'invite de commande, sans l'inscrire dans la commande.

### Préparer et tester une connexion AD (à effectuer)

J'activerai la création automatique du dossier personnel lors de la première connexion :

```bash
sudo pam-auth-update --enable mkhomedir
```

Je contrôlerai ensuite la jonction et la reconnaissance d'un compte existant dans AD :

```bash
realm list
id 'jfernandes@ad.jcorp'
```

Enfin, je fermerai ma session graphique et sélectionnerai « Autre utilisateur » pour tester une connexion avec `jfernandes@ad.jcorp` et son mot de passe AD. La jonction et la connexion seront validées à partir de leurs résultats, puis documentées avec leurs captures.

## 2. Poste Windows 11

J'ai créé la VM **701**, nommée **`User1-JCorp-Windows`** dans Proxmox. L'installation de Windows 11 est terminée. J'ajouterai ses caractéristiques et les captures de configuration au fil de sa mise en place.

La suite comprendra la jonction au domaine `ad.jcorp`, le placement du poste dans l'OU `Postes`, puis les tests de connexion et d'application des GPO.

[Retour à l'infrastructure](../README.md)
