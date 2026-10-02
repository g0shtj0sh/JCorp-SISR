# AP 1 - Active Directory JCorp

## Contexte et objectif

Je pars du dossier [RedOne](https://docs.google.com/document/d/13dC98HuGbrRNXuTOotnaGaNbwyVlJhWZ/edit), qui décrit un siège avec plusieurs services : direction, DSI, administration, communication, développement, commercial et recherche. Le projet prévoit notamment un réseau segmenté, un annuaire centralisé, DNS, DHCP et des applications métier. Le scénario mentionne plus de 350 terminaux au siège et 540 visiteurs médicaux ; ces chiffres donnent l'échelle du projet.

Pour JCorp, je commence l'AP 1 par la configuration de mon environnement Proxmox, du premier contrôleur de domaine, de DNS et des comptes Active Directory. Les autres services viendront compléter cette même infrastructure dans la suite du projet.

## Documentation

| Sujet | Contenu | État |
| --- | --- | --- |
| [Architecture du réseau](../Architecture%20du%20r%C3%A9seau/Architecture-du-reseau.md) | Architecture commune aux AP 1 et AP 2 | En cours |
| [Active Directory](Docs/Active%20Directory/Active-Directory.md) | VM, domaine, DNS, DHCP, OU, groupes et comptes | En cours |
| [GPO](Docs/GPO/README.md) | Script et règles de stratégies de groupe | En cours |

## Avancement

- J'ai installé le serveur `JCORP-DC01` sur la VM 700, créé le domaine `ad.jcorp` (`JCORP` en NetBIOS) et configuré DNS avec l'adresse `10.2.101.10/24`. Les diagnostics AD/DNS ont réussi après la correction de l'adressage.
- J'ai créé les OU des services et 17 groupes globaux de sécurité. La documentation AD contient une capture de cette étape.
- J'ai préparé un script de création de 42 comptes aux noms inventés, soit trois par service, avec leurs groupes. La documentation distingue ce script de la configuration visible sur les captures.
- J'ai ajouté le rôle DHCP sur `JCORP-DC01` et créé une étendue pour `10.2.101.0/24`, avec un pool de `10.2.101.11` à `10.2.101.150`. Une capture de la console est dans la documentation AD.
- J'ai ajouté les GPO de postes, de serveurs et d'utilisateurs avec des exceptions fondées sur les groupes. Leur script et leurs paramètres sont documentés dans le dossier GPO.
- Je prépare trois nouvelles VM : `701` pour `JCORP-DC02`, le second contrôleur de domaine ; `702` pour un poste utilisateur Windows 11 ; `703` pour un poste utilisateur Debian. Leur installation et leurs tests sont en cours.
- La suite du projet portera sur la jonction des postes au domaine, la réplication AD, les partages, les sauvegardes et les autres services prévus pour JCorp.


