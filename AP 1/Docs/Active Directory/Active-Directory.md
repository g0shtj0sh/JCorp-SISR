# Active Directory - AP 1 JCorp

Je présente ici l'installation de mon premier contrôleur de domaine JCorp, avec les captures prises pendant sa configuration.

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

J'utilise ces groupes pour cibler les [GPO](../GPO/README.md). Ils serviront aussi aux droits sur les partages et les applications. Aucun mot de passe n'est publié dans ce dépôt.

## 5. DHCP sur JCORP-DC01

J'ai ajouté le rôle **DHCP** sur `JCORP-DC01`. Dans la console, l'étendue IPv4 du réseau `10.2.101.0/24` et son pool d'adresses de **`10.2.101.11` à `10.2.101.150`** sont visibles. Cette capture montre la plage configurée, pas un bail reçu par un poste client.

![Rôle DHCP sur JCORP-DC01 et pool d'adresses 10.2.101.11 à 10.2.101.150](images/dhcp-etendue-10.2.101.png)

## 6. Stratégies de groupe

J'ai préparé et utilisé le [script de création des GPO](../GPO/JCORP-GPO.ps1) pour appliquer les règles aux OU `Postes`, `Serveurs` et `Utilisateurs`. Elles couvrent le verrouillage des postes, le pare-feu, les mises à jour, les journaux des serveurs, CMD, Regedit et la lecture seule des clés USB pour certains services. Les exceptions CMD et Regedit reposent sur les groupes de la DSI et du développement. Le [détail des GPO](../GPO/README.md) précise les groupes concernés et les prérequis.

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

La prochaine étape est la jonction de la VM Windows 11 au domaine, puis le test de connexion d'un utilisateur et de l'application des GPO avec `gpresult /r`.

