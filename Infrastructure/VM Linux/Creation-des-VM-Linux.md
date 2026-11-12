# Création des deux VM Linux de services

**Statut : réalisé et vérifié le 12 novembre 2026.** Les deux VM Linux décidées le 29 octobre 2026 sont créées, démarrées et contrôlées. Aucun service applicatif n'est encore installé dessus : GLPI, la supervision et Dokploy font l'objet de leurs propres procédures.

## Objectif

Créer les deux machines virtuelles Linux prévues par la [feuille de route](../Feuille-de-route.md#2-deux-vm-supplémentaires-retenues), étape 5 de l'ordre de réalisation, et les amener à un état utilisable : système installé, adressage fixe sur le VLAN 700, résolution par le DNS Active Directory et accès d'administration fonctionnel.

| VM | VMID | Nom | IP | Ressources | Rôle prévu |
| --- | --- | --- | --- | --- | --- |
| Services AP 1 | 705 | `JCORP-SRV01` | `10.2.101.153/24` | 2 vCPU, 4096 Mio, 40 Gio | GLPI, MariaDB, Grafana, Prometheus |
| Hébergement AP 2 | 706 | `JCORP-APP01` | `10.2.101.154/24` | 4 vCPU, 4096 Mio, 60 Gio | Docker, Dokploy, site et sa base |

Les VMID, noms et IP proposés le 29 octobre sont désormais **affectés** et non plus seulement proposés.

## Contexte matériel relevé

L'hyperviseur est partagé avec le reste de la promotion : il porte une soixantaine de machines virtuelles appartenant à plusieurs projets. Les valeurs ci-dessous ont été relevées au moment de la création, pour situer le coût des deux nouvelles VM dans l'ensemble.

| Élément | Valeur relevée le 12 novembre 2026 |
| --- | --- |
| Hôte | `pve`, `pve-manager/9.0.3`, noyau `6.14.8-2-pve` |
| Processeurs | 64 cœurs logiques |
| Mémoire physique | 503 Gio, dont 277 Gio libres et 303 Gio disponibles |
| Mémoire allouée aux VM | 359 924 Mio, soit environ 351 Gio répartis sur une soixantaine de VM |
| Stockage retenu | `Raid5-VMs`, LVM-thin, 5,42 Tio au total, 3,9 Tio disponibles, 28 % utilisés |
| Autres stockages | `local` (répertoire, 21,5 Gio disponibles), `local-lvm` (LVM-thin, 758 Gio disponibles) |

Les 8 Gio de mémoire et les 100 Gio de disque ajoutés par les deux VM représentent une part négligeable de ces capacités.

**Limite de ce relevé :** l'étape 2 de la feuille de route prévoyait un contrôle préalable des ressources comme condition de passage. Ce contrôle n'a pas été mené comme une vérification formelle : l'hôte étant manifestement surdimensionné pour le besoin, les chiffres ont été relevés en passant, au moment de la création. La mémoire allouée dépasse déjà d'ailleurs la mémoire physique — 351 Gio alloués pour 503 Gio installés reste confortable, mais l'hyperviseur autorise ce dépassement sans garantir que toutes les VM puissent tourner simultanément. Ce point n'est pas de mon ressort puisque la plateforme est partagée.

Le stockage `Raid5-VMs` a été retenu parce que c'est celui des VM JCorp existantes, la VM 702 notamment. Garder le même stockage évite d'éparpiller le projet sur plusieurs volumes aux caractéristiques différentes.

## Écart assumé : image cloud au lieu de l'installateur

La procédure initialement envisagée passait par l'ISO *netinst* de Debian et l'installateur graphique, dans la console `noVNC`. J'ai retenu à la place l'**image cloud officielle Debian** pilotée par **cloud-init**.

| | ISO *netinst* | Image cloud et cloud-init |
| --- | --- | --- |
| Installation du système | une trentaine d'écrans à renseigner par VM | aucune, l'image est déjà installée |
| Configuration réseau | saisie manuelle dans l'installateur | injectée au premier démarrage |
| Reproductibilité | difficile à rejouer à l'identique | les commandes sont la procédure |
| Risque d'écart entre les deux VM | réel, saisie manuelle deux fois | nul, mêmes commandes paramétrées |

L'image cloud est le format prévu par Debian pour l'automatisation ; c'est la même distribution, livrée préinstallée. L'écart à retenir porte sur le **partitionnement** : l'image impose une partition unique, étendue automatiquement à la taille du disque, au lieu d'un schéma choisi à la main. Pour deux VM de laboratoire sans contrainte de cloisonnement des données, ce choix n'a pas de conséquence.

## Accès à l'hyperviseur

L'interface web de Proxmox présente un certificat TLS auto-signé, que le navigateur utilisé refuse sans possibilité de dérogation. L'administration est donc passée par **SSH**, ce qui convient d'autant mieux que toutes les opérations qui suivent sont des commandes.

L'authentification par mot de passe était seule active. Une clé publique `ed25519` a été ajoutée au compte `root` de l'hôte :

```bash
ssh root@192.168.100.2 "mkdir -p /root/.ssh && chmod 700 /root/.ssh && echo '<cle_publique>' >> /root/.ssh/authorized_keys && chmod 600 /root/.ssh/authorized_keys"
```

L'opération ajoute une ligne sans écraser le fichier existant et se révoque en supprimant cette ligne. La clé privée correspondante ne quitte pas le poste d'administration.

## Récupération et vérification de l'image

```bash
cd /var/lib/vz/template/iso
wget -O debian-13-generic-amd64.qcow2 \
  https://cloud.debian.org/images/cloud/trixie/latest/debian-13-generic-amd64.qcow2
wget -O SHA512SUMS https://cloud.debian.org/images/cloud/trixie/latest/SHA512SUMS
sha512sum -c --ignore-missing SHA512SUMS
```

**Résultat observé :** image de 417 Mio, `debian-13-generic-amd64.qcow2: OK`.

La vérification de l'empreinte n'est pas une formalité : cette image devient le système de deux serveurs. Contrairement à un paquet installé par APT, elle n'est couverte par aucune signature vérifiée automatiquement, et c'est le seul contrôle qui atteste que le fichier reçu est bien celui publié par Debian.

**Incident de parcours :** la première tentative visait `debian-13-genericcloud-amd64.qcow2` et a renvoyé une erreur HTTP 404 en créant un fichier vide. Le répertoire `latest` de Debian 13 ne publie pas cette variante ; le nom correct est `debian-13-generic-amd64.qcow2`. Un `wget` silencieux masque ce genre d'échec : le fichier existe, il est simplement vide. C'est le `ls -lh` qui l'a révélé.

## Création de JCORP-SRV01

```bash
IMG=/var/lib/vz/template/iso/debian-13-generic-amd64.qcow2

qm create 705 --name JCORP-SRV01 --ostype l26 --cores 2 --sockets 1 --cpu host --memory 4096 \
  --net0 virtio,bridge=vmbr2,tag=700,firewall=1 \
  --scsihw virtio-scsi-single --serial0 socket --agent enabled=1 --onboot 1

qm disk import 705 $IMG Raid5-VMs --format raw
qm set 705 --scsi0 Raid5-VMs:vm-705-disk-0,iothread=1,discard=on,ssd=1
qm disk resize 705 scsi0 40G
qm set 705 --ide2 Raid5-VMs:cloudinit --boot order=scsi0
qm set 705 --ciuser administrateur --sshkeys /root/.ssh/authorized_keys \
  --ipconfig0 ip=10.2.101.153/24,gw=10.2.101.1 --nameserver 10.2.101.10 --searchdomain ad.jcorp
```

### Pourquoi ces options

| Option | Raison |
| --- | --- |
| `--cpu host` | expose le jeu d'instructions réel du processeur au lieu d'un modèle générique, ce qui profite à PHP et à MariaDB. Le prix est l'impossibilité de migrer à chaud vers un hôte au processeur différent : sans objet sur un nœud unique. |
| `virtio-scsi-single` et `iothread=1` | donnent au disque son propre fil d'exécution pour les entrées-sorties. MariaDB et Prometheus écrivent beaucoup ; sans cela leurs écritures bloquent le reste de la machine virtuelle. |
| `discard=on` et `ssd=1` | permettent au stockage LVM-thin de récupérer l'espace des fichiers supprimés dans la VM. Sans `discard`, le volume *thin* ne cesse de grossir même quand la VM libère de la place. |
| `--agent enabled=1` | active le canal QEMU Guest Agent côté hyperviseur. Il ne sert qu'une fois le paquet installé **dans** la VM, ce qui a donné lieu à l'incident décrit plus bas. |
| `--onboot 1` | fait redémarrer la VM avec l'hôte. `JCORP-SRV01` portera la supervision : elle doit revenir seule après une coupure, sinon la supervision est absente précisément quand on en a besoin. |
| `--serial0 socket` | ajoute une console série, accessible par `qm terminal`, qui reste utilisable si le réseau de la VM tombe. |
| `tag=700` et `firewall=1` | reprennent exactement la configuration réseau des VM JCorp existantes : étiquetage du VLAN au niveau de la carte, pont `vmbr2`. |
| `--ipconfig0`, `--nameserver`, `--searchdomain` | remplacent la saisie manuelle du réseau dans l'installateur. Le DNS pointe sur le contrôleur de domaine, pas sur un résolveur public : c'est lui qui résout `ad.jcorp`. |

L'image importée pèse 3,0 Gio une fois convertie en brut ; `qm disk resize` porte le volume à 40 Gio, et le système étend sa partition au premier démarrage.

## Création de JCORP-APP01

Mêmes commandes, trois valeurs changent : `--cores 4`, le disque à `60G` et l'adresse `10.2.101.154/24`.

```bash
qm create 706 --name JCORP-APP01 --ostype l26 --cores 4 --sockets 1 --cpu host --memory 4096 \
  --net0 virtio,bridge=vmbr2,tag=700,firewall=1 \
  --scsihw virtio-scsi-single --serial0 socket --agent enabled=1 --onboot 1

qm disk import 706 $IMG Raid5-VMs --format raw
qm set 706 --scsi0 Raid5-VMs:vm-706-disk-0,iothread=1,discard=on,ssd=1
qm disk resize 706 scsi0 60G
qm set 706 --ide2 Raid5-VMs:cloudinit --boot order=scsi0
qm set 706 --ciuser administrateur --sshkeys /root/.ssh/authorized_keys \
  --ipconfig0 ip=10.2.101.154/24,gw=10.2.101.1 --nameserver 10.2.101.10 --searchdomain ad.jcorp
```

Les deux VM obtiennent une adresse MAC distincte attribuée par Proxmox, `BC:24:11:13:8A:A5` pour la 705 et `BC:24:11:76:9D:38` pour la 706, dans la même plage que les VM JCorp existantes.

## Premier démarrage

```bash
qm start 705
qm start 706
```

## Incident 1 — l'agent invité n'est pas dans l'image

J'avais annoncé que l'image Debian *generic* embarquait `qemu-guest-agent`, au motif qu'elle est destinée à tourner sur n'importe quel hyperviseur. C'est faux : après démarrage, `qm agent 705 ping` répond `QEMU guest agent is not running` sur les deux VM.

La conséquence n'était pas seulement cosmétique. L'option `--agent enabled=1` activait bien le canal côté hyperviseur, mais sans paquet en face il ne transporte rien : Proxmox n'affiche pas l'adresse IP des VM, l'arrêt propre ne fonctionne pas, et surtout je n'avais **aucun moyen de joindre les deux machines** pour vérifier que cloud-init avait fait son travail.

Le paquet a été installé après coup, une fois le réseau joignable. La leçon à retenir est que `--agent enabled=1` déclare une intention côté hyperviseur, pas une capacité côté invité : les deux moitiés doivent être présentes.

## Incident 2 — l'hôte ne route pas vers le VLAN 700

L'hyperviseur porte bien l'interface `vlan700@vmbr2`, mais **sans adresse IPv4** et sans route vers `10.2.101.0/24`. C'est logique : l'hôte fournit le pont aux VM, il n'est pas lui-même membre du réseau JCorp. Combiné à l'incident précédent, cela ne laissait aucun chemin vers les deux nouvelles VM.

Une adresse temporaire a été ajoutée à l'hôte, sur le VLAN 700 uniquement et hors du pool DHCP `10.2.101.11–150` :

```bash
ip addr add 10.2.101.5/24 dev vlan700
```

Cette commande n'est pas persistante — elle disparaît au redémarrage de l'hôte — et ne modifie aucun fichier de configuration de l'hyperviseur partagé. Elle a permis de contrôler la joignabilité puis d'administrer les VM par SSH :

| Adresse | Rôle | Résultat |
| --- | --- | --- |
| `10.2.101.1` | passerelle | répond |
| `10.2.101.10` | `JCORP-DC01`, DNS AD | répond |
| `10.2.101.153` | `JCORP-SRV01` | répond |
| `10.2.101.154` | `JCORP-APP01` | répond |

La réponse des deux nouvelles adresses est la **première preuve que cloud-init a appliqué l'adressage fixe**, puisque aucune intervention n'a eu lieu dans les VM à ce stade.

L'adresse a été **retirée** une fois l'agent invité installé, `qm guest exec` offrant dès lors un canal qui ne dépend plus d'elle :

```bash
ip addr del 10.2.101.5/24 dev vlan700
```

Après retrait, l'hôte ne possède plus aucune route vers `10.2.101.0/24`.

## Configuration appliquée dans les VM

```bash
sudo timedatectl set-timezone Europe/Paris
sudo apt-get update
sudo apt-get install -y qemu-guest-agent
sudo systemctl enable --now qemu-guest-agent
```

Le fuseau horaire de l'image cloud est `Etc/UTC`. Laissé tel quel, il aurait décalé d'une heure les horodatages des tickets GLPI et des métriques Prometheus par rapport aux contrôleurs de domaine et aux postes, rendant toute corrélation d'incident fausse sans que rien ne le signale. `Europe/Paris` est donc appliqué sur les deux VM.

## Recette

| Contrôle | Résultat attendu | Résultat observé | Conforme |
| --- | --- | --- | --- |
| VMID libres avant création | 705 et 706 non attribués | `705 libre`, `706 libre` | Oui |
| Intégrité de l'image | empreinte SHA-512 conforme | `OK` | Oui |
| Création des VM | configuration conforme aux valeurs retenues | `qm config` conforme pour les deux | Oui |
| Démarrage | les deux VM en cours d'exécution | `status: running` | Oui |
| Système installé | Debian 13 | `Debian GNU/Linux 13 (trixie)`, noyau `6.12.116+deb13-amd64` | Oui |
| Nom d'hôte | `JCORP-SRV01` et `JCORP-APP01` | conformes | Oui |
| Adressage fixe | `.153` et `.154` sur `eth0` | conformes | Oui |
| Extension du disque | 40 Gio et 60 Gio utilisables | `40G` dont 37 Gio libres ; `59G` dont 56 Gio libres | Oui |
| Mémoire vue par le système | environ 4 Gio | 3,8 Gio sur les deux | Oui |
| Fin de cloud-init | aucune erreur | `status: done` sur les deux | Oui |
| Résolution interne | `ad.jcorp` résolu par le DNS AD | `ad.jcorp` et `JCORP-DC01.ad.jcorp` → `10.2.101.10` | Oui |
| Résolution externe | un nom public résolu | `deb.debian.org` résolu | Oui |
| Suffixe de recherche | `ad.jcorp` | présent dans `/etc/resolv.conf` | Oui |
| Horloge | synchronisée, fuseau français | synchronisée, `Europe/Paris (CET, +0100)` | Oui |
| Agent invité | actif et joignable depuis l'hyperviseur | `active`, `qm agent ping` réussi sur les deux | Oui |
| Démarrage automatique | VM relancées avec l'hôte | `onboot: 1` sur les deux | Non vérifié |
| Retrait de l'IP temporaire | plus aucune route vers le VLAN 700 | aucune route restante | Oui |

Le disque de 59 Gio annoncé par le système pour une allocation de 60 Gio correspond à la différence habituelle entre gibioctets et gigaoctets, à laquelle s'ajoute l'espace de la table de partitions ; ce n'est pas un défaut d'extension.

## Limites et points ouverts

**Aucun mot de passe n'est défini sur les deux VM.** L'accès repose uniquement sur la clé SSH injectée par cloud-init. C'est un choix défendable — une clé ne se devine pas, contrairement à un mot de passe de laboratoire — mais il a une conséquence directe : la console `noVNC` et la console série sont inutilisables, puisqu'elles réclament un mot de passe. Si le réseau d'une VM tombe, elle devient inaccessible. Poser un mot de passe sur le compte local, par `qm set <vmid> --cipassword` depuis l'hyperviseur ou par `passwd` depuis une session SSH, reste à faire.

**Le redémarrage automatique n'a pas été éprouvé.** `onboot: 1` est bien présent dans la configuration, mais aucune VM n'a été redémarrée pour le vérifier, et l'hôte étant partagé il n'est pas question de le redémarrer pour l'occasion.

**La synchronisation d'horloge ne pointe pas sur le domaine.** Les VM se synchronisent sur les serveurs de temps publics de Debian, non sur `JCORP-DC01`. L'écart observé est nul et sans conséquence aujourd'hui, mais si ces machines sont un jour jointes au domaine, l'authentification Kerberos exige un écart inférieur à cinq minutes avec le contrôleur : la source de temps devra alors être changée.

**Aucune capture d'écran n'accompagne cette procédure.** L'intégralité du travail a été réalisée en ligne de commande et les preuves sont les sorties des commandes, reproduites dans ce document. Des captures de la console `noVNC` ou de l'interface Proxmox pourront être ajoutées dans [images](images/README.md) ; elles montreraient moins que les sorties elles-mêmes.

**Les deux VM ne sont pas jointes au domaine** et aucune n'a de rôle actif : ce sont des systèmes nus prêts à recevoir leurs services. La jonction au domaine n'est un prérequis ni de GLPI ni de Dokploy, et n'est pas retenue à ce stade.

## Suite

| Étape | Document |
| --- | --- |
| Installer GLPI et MariaDB sur `JCORP-SRV01` | [GLPI](../GLPI/GLPI.md) |
| Installer Prometheus et Grafana sur `JCORP-SRV01` | [Grafana et Prometheus](../Supervision/Grafana-Prometheus.md) |
| Installer Docker et Dokploy sur `JCORP-APP01` | [Dokploy](../Dokploy/Dokploy.md) |

## Références

- [Images cloud officielles Debian](https://cloud.debian.org/images/cloud/)
- [Documentation cloud-init de Proxmox VE](https://pve.proxmox.com/wiki/Cloud-Init_Support)
- [Manuel de `qm`](https://pve.proxmox.com/pve-docs/qm.1.html)

[Infrastructure](../README.md) · [Feuille de route](../Feuille-de-route.md) · [Suivi AP 1](../../AP%201/README.md) · [Suivi AP 2](../../AP%202/README.md)
