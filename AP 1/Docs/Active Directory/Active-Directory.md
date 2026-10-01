# Active Directory — AP 1 JCorp

Cette page présente le premier contrôleur de domaine JCorp, avec de courtes étapes et des captures issues de l'installation. Elle suit le format de la [documentation AD de l'ancien projet](https://github.com/g0shtj0sh/GSB-Jcorp/blob/main/Docs/Active%20Directory/Active-Directory.md), mais décrit les paramètres de la nouvelle infrastructure.

## 1. Créer la machine virtuelle

Le serveur AD est hébergé sur Proxmox sous le **VMID 700**. Sa carte réseau utilise le pont `vmbr2`. Le VLAN 700 est réservé à Joshua, mais la capture matérielle actuelle n'affiche pas de `tag=700` sur cette carte : ce point reste à vérifier. La première capture montre la VM 700 et le Gestionnaire de serveur Windows après installation ; la seconde montre ses paramètres matériels.

![VM 700 JCorp dans Proxmox, avec le Gestionnaire de serveur Windows](images/proxmox-vm700.png)

![Configuration matérielle actuelle de la VM 700 dans Proxmox](images/proxmox-vm700-materiel.png)

L'installation initiale de Windows et les écrans de création de la VM n'ont pas été capturés pour cette AP. Les anciens écrans VMware du dépôt GSB-Jcorp ne représentent pas Proxmox JCorp.

## 2. Fixer le nom et l'adresse du serveur

Le serveur Windows est nommé **`JCORP-DC01`**. Il utilise l'adresse **`10.2.101.10/24`** ; son DNS préféré pointe vers son propre service DNS. Lors du premier diagnostic, il avait encore une adresse automatique `169.254.x.x`, qui empêchait une résolution correcte du domaine. L'adresse fixe a été configurée, puis les enregistrements DNS ont été actualisés et les diagnostics ont réussi.

| Paramètre | Valeur constatée |
| --- | --- |
| Nom Windows | `JCORP-DC01` |
| Adresse IPv4 | `10.2.101.10` |
| Masque | `255.255.255.0` |
| DNS du serveur | `10.2.101.10` ou boucle locale selon la configuration du contrôleur |
| Passerelle | Aucune à ce stade |

## 3. Installer AD DS et DNS, puis créer le domaine

Les rôles **Services de domaine Active Directory (AD DS)** et **DNS** ont été installés avec le Gestionnaire de serveur. Le serveur a ensuite été promu comme premier contrôleur d'une nouvelle forêt nommée **`ad.jcorp`**, avec **`JCORP`** comme nom court NetBIOS.

La sortie ci-dessous confirme le nom du serveur et le domaine. Elle provient d'un contrôle effectué pendant l'installation ; l'adresse IP a été corrigée ensuite.

![Vérification du nom JCORP-DC01 et du domaine ad.jcorp dans PowerShell](images/identite-domaine.png)

Après la correction réseau, les contrôles `dcdiag` des services et du DNS ont réussi. Un poste client joint au domaine reste à documenter.

## 4. Organiser les unités d'organisation et les groupes

Les cinq OU principales sont placées **directement sous `ad.jcorp`** : `Administration`, `Groupes`, `Postes`, `Serveurs` et `Utilisateurs`. Les OU des services se trouvent dans `Utilisateurs`. Le contrôleur de domaine reste dans l'OU système `Domain Controllers`.

![OU principales visibles directement sous le domaine](images/ou-racine.png)

La capture actuelle de la console montre également les OU de services sous `Utilisateurs` et le compte Léa Dubois dans `Juridique`. Elle ne prouve pas encore la présence des 42 comptes du script actualisé.

![OU de services et compte juridique dans la console actuelle](images/ou-services-actuel.png)

La première automatisation a créé **17 groupes globaux de sécurité** : un par service, ainsi que trois groupes pour les fonctions commerciales (visiteur médical, délégué régional et responsable de secteur). La capture suivante montre le total de 17 groupes à cette étape.

![Première exécution du script et total de 17 groupes](images/groupes-17.png)

Une [version actualisée du script](JCORP-Reset-AD.ps1) prépare **trois comptes aux noms inventés par service**, soit 42 comptes, et affecte chacun au groupe correspondant. Les trois comptes commerciaux reçoivent aussi leur groupe de fonction. Le script contrôle les objets existants avant la remise à zéro et s'arrête s'il trouve un objet inattendu. Il demande le mot de passe à l'exécution afin de ne pas le publier dans le dépôt. **L'exécution de cette version à 42 comptes n'est pas encore confirmée par une capture ou un relevé du serveur.**

| Type d'objet | Prévu par le script actualisé |
| --- | ---: |
| OU principales | 5 |
| OU de service | 14 |
| Groupes de sécurité | 17 |
| Comptes nominatifs fictifs | 42 |

Les groupes organisent les appartenances. Les droits sur les partages et applications seront attribués lorsque ces ressources seront créées. Aucun mot de passe n'est publié dans ce dépôt.

## 5. Vérifications à conserver

Sur le contrôleur de domaine, les commandes suivantes permettent de vérifier le nom, le réseau, le domaine et l'annuaire :

```powershell
hostname
ipconfig /all
Get-ADDomain | Select-Object DNSRoot, NetBIOSName
dcdiag /test:Advertising /test:Services /test:DNS
```

Après exécution du script actualisé, il faudra vérifier les **42 comptes**, leurs OU et leurs appartenances, puis ajouter une capture des résultats. La jonction d'un poste client et les tests de connexion utilisateur constitueront la prochaine preuve fonctionnelle.

