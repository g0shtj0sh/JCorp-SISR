# Active Directory, GPO, DHCP et contrôleurs de domaine - JCorp

Je présente ici l'installation de mon premier contrôleur de domaine JCorp, la configuration DHCP et les GPO, avec les captures prises dans mon infrastructure. Cette documentation appartient à l'[infrastructure commune du projet](../README.md) et évolue au fil des ateliers.

## 1. Créer la machine virtuelle

J'ai créé mon serveur AD sur Proxmox avec le **VMID 700**. Sa carte réseau utilise le pont `vmbr2` avec le tag **VLAN 700**. La première capture montre la VM et le Gestionnaire de serveur Windows ; la seconde montre les paramètres matériels avant l'ajout du tag VLAN.

![VM 700 JCorp dans Proxmox, avec le Gestionnaire de serveur Windows](images/proxmox-vm700.png)

![Configuration matérielle actuelle de la VM 700 dans Proxmox](images/proxmox-vm700-materiel.png)

Je n'ai pas conservé de capture des écrans de création de la VM ni de l'installation initiale de Windows.

## 2. Fixer le nom et l'adresse du serveur

J'ai nommé le serveur Windows **`JCORP-DC01`** et configuré l'adresse **`10.2.101.10/24`**. Son DNS préféré pointe vers son propre service DNS. J'ai renseigné **`10.2.101.1`** comme passerelle, selon les indications de mon administrateur réseau. Lors du premier diagnostic, le serveur utilisait encore une adresse automatique `169.254.x.x`, ce qui empêchait la résolution du domaine. J'ai configuré l'adresse fixe, actualisé les enregistrements DNS et relancé les diagnostics avec succès. Après l'ajout du tag VLAN 700, le ping de la passerelle répond avec **0 % de perte**.

| Paramètre | Valeur constatée |
| --- | --- |
| Nom Windows | `JCORP-DC01` |
| Adresse IPv4 | `10.2.101.10` |
| Masque | `255.255.255.0` |
| DNS du serveur | `10.2.101.10` ou boucle locale selon la configuration du contrôleur |
| Passerelle | `10.2.101.1` |

## 3. Installer AD DS et DNS, puis créer le domaine

J'ai installé les rôles **Services de domaine Active Directory (AD DS)** et **DNS** depuis le Gestionnaire de serveur, puis promu le serveur comme premier contrôleur de la forêt **`ad.jcorp`**. Le nom court NetBIOS est **`JCORP`**.

La sortie ci-dessous confirme le nom du serveur et le domaine. J'ai corrigé l'adresse IP après ce premier contrôle.

![Vérification du nom JCORP-DC01 et du domaine ad.jcorp dans PowerShell](images/identite-domaine.png)

Après la correction réseau, les contrôles `dcdiag` des services et du DNS ont réussi.

Le second contrôleur sur la VM Proxmox **703**, nommée `DC2-JCorp`, est fonctionnel selon la validation de Joshua. Aucun nouveau contrôle de réplication n'a été exécuté pendant la vérification DHCP du 29 octobre 2026.

## 4. Organiser les unités d'organisation et les groupes

J'ai placé les cinq OU principales **directement sous `ad.jcorp`** : `Administration`, `Groupes`, `Postes`, `Serveurs` et `Utilisateurs`. Les OU des services se trouvent dans `Utilisateurs`. Le contrôleur de domaine reste dans l'OU système `Domain Controllers`.

![OU principales visibles directement sous le domaine](images/ou-racine.png)

Dans la console Active Directory, on voit les OU des services sous `Utilisateurs` et le compte Léa Dubois dans `Juridique`.

![OU de services et compte juridique dans la console actuelle](images/ou-services-actuel.png)

J'ai créé **17 groupes globaux de sécurité** : un par service et trois pour les fonctions commerciales (visiteur médical, délégué régional et responsable de secteur). La capture suivante montre le résultat de cette première exécution.

![Première exécution du script et total de 17 groupes](images/groupes-17.png)

J'ai aussi préparé une [version actualisée du script](JCORP-Reset-AD.ps1) pour créer **trois comptes aux noms inventés par service**, soit 42 comptes, et les ajouter aux groupes correspondants. Les trois comptes commerciaux reçoivent également leur groupe de fonction. Le script contrôle les objets présents avant de recréer la structure et demande le mot de passe au lancement.

| Type d'objet | Prévu par le script actualisé |
| --- | ---: |
| OU principales | 5 |
| OU de service | 14 |
| Groupes de sécurité | 17 |
| Comptes nominatifs fictifs | 42 |

Les comptes et groupes sont désormais retenus comme opérationnels ; la connexion de Joshua Fernandes a été validée. Le tableau décrit le contenu prévu par le script, sans constituer une vérification individuelle de chacun des 42 comptes.

J'utilise ces groupes pour cibler les GPO. Ils serviront aussi aux droits sur les partages et les applications. Les principales informations réseau sont indiquées dans le [README principal](../../README.md).

## 5. DHCP sur JCORP-DC01

J'ai ajouté le rôle **DHCP** sur `JCORP-DC01`. Dans la console, l'étendue IPv4 du réseau `10.2.101.0/24` et son pool d'adresses de **`10.2.101.11` à `10.2.101.150`** sont visibles. Cette capture montre la plage configurée, pas un bail reçu par un poste client.

![Rôle DHCP sur JCORP-DC01 et pool d'adresses 10.2.101.11 à 10.2.101.150](images/dhcp-etendue-10.2.101.png)

### Contrôle DHCP du 29 octobre 2026

Depuis Proxmox, j'ai ouvert la console DHCP de la VM 700, puis `JCORP-DC01 > IPv4 > Étendue > Baux d'adresses`. Un bail DHCP est visible pour **User1.ad.jcorp**, en **10.2.101.12**, avec une expiration affichée au **6 novembre 2026 à 11:54:24**.

![Bail DHCP du poste Windows User1 en 10.2.101.12](images/dhcp-baux-adresses.png)

La liste contient aussi d'anciens baux `truenas-installer.local` et `JCORP-NAS01`. Leur présence ne prouve pas que ces adresses sont encore utilisées. Le NAS est désormais configuré en IP fixe `10.2.101.152`.

Dans **Options d'étendue**, le contrôle initial montre `006 Serveurs DNS = 10.2.101.10, 8.8.8.8` et `015 Nom de domaine DNS = ad.jcorp`. Aucune option routeur n'est définie, y compris dans les options de serveur consultées.

![Options d'étendue avant correction : deux DNS et aucune passerelle](images/dhcp-options-etendue-controle.png)

J'ai ouvert **Configurer les options**, ajouté **003 Routeur = 10.2.101.1**, puis retiré **8.8.8.8** de **006 Serveurs DNS** pour conserver uniquement le DNS du domaine. Après validation avec **OK** et actualisation de la console, les trois options enregistrées sont visibles :

| Option | Valeur finale |
| --- | --- |
| 003 Routeur | `10.2.101.1` |
| 006 Serveurs DNS | `10.2.101.10` |
| 015 Nom de domaine DNS | `ad.jcorp` |

![Options d'étendue enregistrées et actualisées après correction](images/dhcp-options-etendue-corrigees.jpg)

Le contrôle valide le bail Windows enregistré sur le serveur et la persistance des options corrigées. Aucun renouvellement forcé ni nouveau relevé réseau côté client n'a été effectué après cette correction ; ces captures ne prouvent donc pas encore la réception des nouvelles options par le poste. Elles seront prises en compte lors du renouvellement du bail.

## 6. Stratégies de groupe

J'ai préparé et utilisé le [script de création des GPO](../GPO/JCORP-GPO.ps1) pour les relier aux OU `Postes`, `Serveurs` et `Utilisateurs`. Avant de créer quoi que ce soit, il vérifie le domaine `ad.jcorp`, ces trois OU et les groupes nécessaires. Je peux le relancer sans multiplier les GPO ni les liens.

Depuis Windows PowerShell 5.1, avec un compte administrateur du domaine, j'utilise :

```powershell
.\JCORP-GPO.ps1 -WhatIf
.\JCORP-GPO.ps1
```

| Cible | Règles créées |
| --- | --- |
| Postes | Verrouillage après 10 minutes, pare-feu Windows, mises à jour automatiques à 03:00 |
| Serveurs placés dans `OU=Serveurs` | Taille des journaux Windows portée à 64 Mio |
| Utilisateurs | CMD et Regedit bloqués par défaut |
| `GG_DSI` | CMD et Regedit autorisés par des GPO d'exception prioritaires |
| `GG_Developpement` | CMD autorisé par une GPO d'exception prioritaire |
| `GG_RH`, `GG_Comptabilite`, `GG_Juridique`, `GG_Direction` | Lecture des supports USB autorisée, écriture bloquée |

Les exceptions reposent sur les groupes AD : le script ne cible pas des personnes par leur nom. Le contrôleur de domaine `JCORP-DC01` reste dans l'OU système `Domain Controllers`, donc la GPO liée à `OU=Serveurs` ne s'applique pas à lui.

Dans la console **Gestion de stratégie de groupe**, je vois les neuf GPO `JCORP-*` créées dans `ad.jcorp` : trois pour les postes, une pour les serveurs et cinq pour les utilisateurs. Cette capture historique prouve leur présence dans le domaine. Le poste Windows est maintenant joint au domaine ; aucune campagne supplémentaire de tests des GPO générales n'est prévue dans le périmètre retenu.

![GPO JCorp visibles dans la console Gestion de stratégie de groupe](images/gpo-jcorp-console.png)

La configuration **Windows LAPS** est facultative : `-ConfigureLaps` crée sa GPO uniquement si le schéma Windows LAPS existe déjà. Je dois d'abord préparer les droits d'écriture des ordinateurs et les droits de lecture des mots de passe pour les administrateurs habilités. Le script ne modifie pas le schéma AD.

J'ai ensuite ajouté une dixième GPO JCorp, **JCORP-Utilisateurs-LecteursReseau**, liée à l'OU **Utilisateurs**. Elle mappe **S:** vers `\\JCORP-NAS01.ad.jcorp\Commun` avec l'action **Mettre à jour** et **Reconnecter**. Après fermeture et réouverture de la session de Joshua Fernandes, le lecteur apparaît et son ouverture fonctionne. Les paramètres et captures sont dans la [documentation TrueNAS](../TrueNAS/TrueNAS.md#déployer-le-lecteur-par-gpo). Les GPO limitant les réglages Windows, bloquant les macros Office venant d'Internet ou limitant de manière générale les logiciels ne font pas partie de ce script.

Les GPO de postes nécessitent la jonction à `ad.jcorp` et le placement dans `OU=Postes`. Les commandes `gpupdate /force` et `gpresult /r` restent des moyens de diagnostic si nécessaire ; elles n'ont pas été réexécutées pendant ce contrôle DHCP. Les stratégies de mots de passe du domaine se configurent au niveau du domaine, et non dans l'OU `Utilisateurs`.

Pour afficher la liste réelle des GPO créées sur le domaine depuis Windows PowerShell, j'utilise :

```powershell
Import-Module GroupPolicy
Get-GPO -All -Domain ad.jcorp | Where-Object DisplayName -like 'JCORP-*' | Sort-Object DisplayName | Select-Object DisplayName, Id
```

## 7. Vérifications à conserver

J'utilise les commandes suivantes sur le contrôleur de domaine pour contrôler le nom du serveur, le réseau, le domaine et l'annuaire :

```powershell
hostname
ipconfig /all
Get-ADDomain | Select-Object DNSRoot, NetBIOSName
dcdiag /test:Advertising /test:Services /test:DNS
```

Windows 11 est joint au domaine, la connexion utilisateur et le lecteur S: sont fonctionnels. Le NAS est terminé selon les contrôles documentés et la validation complémentaire de Joshua. La prochaine étape est la jonction du poste Debian ; elle n'est pas commencée pendant cette intervention. Le programme est ensuite complété par GLPI et Grafana/Prometheus en AP 1, puis Dokploy et un site avec sa base en AP 2. Ces services sont planifiés, pas encore installés ; voir la [feuille de route](../Feuille-de-route.md). La segmentation complète, le chantier global de sauvegarde/restauration et les autres applications restent exclus.

