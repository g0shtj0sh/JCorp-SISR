# GPO JCorp

J'ai preparé [JCORP-GPO.ps1](JCORP-GPO.ps1) pour créer les GPO sur `ad.jcorp` et les relier aux OU `Postes`, `Serveurs` et `Utilisateurs`. Le script vérifie le domaine, les OU et les groupes avant toute création. Il peut être relancé sans multiplier les GPO ni les liens.

Depuis Windows PowerShell 5.1, avec un compte administrateur du domaine :

```powershell
.\JCORP-GPO.ps1 -WhatIf
.\JCORP-GPO.ps1
```

Le script prévoit le verrouillage après 10 minutes, le pare-feu, les mises à jour automatiques à 03:00, l'augmentation de la taille des journaux des serveurs, le blocage de CMD et Regedit pour les utilisateurs standards, ainsi que la lecture seule des supports USB pour la RH, la comptabilité, le juridique et la direction. `GG_DSI` et `GG_Developpement` gardent CMD ; seule `GG_DSI` garde Regedit. Pour ces exceptions, les liens ont une priorité supérieure et les GPO d'autorisation ne s'appliquent qu'aux groupes prévus.

La configuration LAPS est facultative : `-ConfigureLaps` crée sa GPO seulement si le schéma Windows LAPS existe déjà. Je dois d'abord configurer les droits d'écriture des ordinateurs sur leur OU et les droits de lecture des mots de passe pour les administrateurs habilités. Le script ne fait pas d'extension de schéma.

La GPO de lecteurs réseau attend la création des partages et leurs chemins UNC. Je l'ajouterai quand ces chemins seront définis, sans inventer de serveur de fichiers. Les GPO de limitation des réglages Windows, de blocage des macros Office venant d'Internet et de limitation générale des logiciels ne font pas partie de ce script.

Ces GPO de postes ne s'appliqueront qu'après la jonction d'un poste à `ad.jcorp` et son placement dans l'OU `Postes`. Je vérifierai le résultat avec `gpupdate /force` puis `gpresult /r` sur ce poste. Les stratégies de mots de passe du domaine restent à gérer au niveau du domaine, pas dans l'OU `Utilisateurs`.

