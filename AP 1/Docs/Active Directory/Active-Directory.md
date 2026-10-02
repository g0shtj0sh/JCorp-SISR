# Active Directory - AP 1 JCorp

Je présente ici l'installation de mon premier contrôleur de domaine JCorp, avec les captures prises pendant sa configuration.

## 1. Créer la machine virtuelle

J'ai créé mon serveur AD sur Proxmox avec le **VMID 700**. Sa carte réseau utilise le pont `vmbr2`. La première capture montre la VM et le Gestionnaire de serveur Windows ; la seconde montre les paramètres matériels. La carte réseau n'affiche pas de tag VLAN sur cette capture.

![VM 700 JCorp dans Proxmox, avec le Gestionnaire de serveur Windows](images/proxmox-vm700.png)

![Configuration matérielle actuelle de la VM 700 dans Proxmox](images/proxmox-vm700-materiel.png)

Je n'ai pas conservé de capture des écrans de création de la VM ni de l'installation initiale de Windows.

## 2. Fixer le nom et l'adresse du serveur

J'ai nommé le serveur Windows **`JCORP-DC01`** et configuré l'adresse **`10.2.101.10/24`**. Son DNS préféré pointe vers son propre service DNS. Mon administrateur réseau m'a indiqué **`10.2.101.1`** comme passerelle. Lors du premier diagnostic, le serveur utilisait encore une adresse automatique `169.254.x.x`, ce qui empêchait la résolution du domaine. J'ai configuré l'adresse fixe, actualisé les enregistrements DNS et relancé les diagnostics avec succès.

| Paramètre | Valeur constatée |
| --- | --- |
| Nom Windows | `JCORP-DC01` |
| Adresse IPv4 | `10.2.101.10` |
| Masque | `255.255.255.0` |
| DNS du serveur | `10.2.101.10` ou boucle locale selon la configuration du contrôleur |
| Passerelle indiquée par l'administrateur réseau | `10.2.101.1` |

## 3. Installer AD DS et DNS, puis créer le domaine

J'ai installé les rôles **Services de domaine Active Directory (AD DS)** et **DNS** depuis le Gestionnaire de serveur, puis promu le serveur comme premier contrôleur de la forêt **`ad.jcorp`**. Le nom court NetBIOS est **`JCORP`**.

La sortie ci-dessous confirme le nom du serveur et le domaine. J'ai corrigé l'adresse IP après ce premier contrôle.

![Vérification du nom JCORP-DC01 et du domaine ad.jcorp dans PowerShell](images/identite-domaine.png)

Après la correction réseau, les contrôles `dcdiag` des services et du DNS ont réussi. Je documenterai ensuite la jonction d'un poste client au domaine.

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

J'utiliserai ces groupes pour attribuer les droits sur les partages et les applications lors de leur mise en place. Aucun mot de passe n'est publié dans ce dépôt.

## 5. Vérifications à conserver

J'utilise les commandes suivantes sur le contrôleur de domaine pour contrôler le nom du serveur, le réseau, le domaine et l'annuaire :

```powershell
hostname
ipconfig /all
Get-ADDomain | Select-Object DNSRoot, NetBIOSName
dcdiag /test:Advertising /test:Services /test:DNS
```

Après l'exécution du script actualisé, je contrôlerai les **42 comptes**, leurs OU et leurs appartenances, puis j'ajouterai une capture du résultat. Je poursuivrai avec la jonction d'un poste client et les tests de connexion des utilisateurs.

