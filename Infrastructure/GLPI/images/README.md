# Captures — GLPI

Ce dossier accompagne la [procédure GLPI](../GLPI.md).

## Pourquoi la phase serveur n'a pas de captures

L'installation du 12 novembre 2026 a été menée **entièrement en ligne de commande**, sur une VM sans interface graphique. Les preuves de cette phase sont donc les sorties de commandes, reproduites dans la procédure : versions relevées, liste des extensions PHP, résultat du contrôle de prérequis, validation de l'intégrité du code source, code de réponse HTTP et état du *timer* systemd. Une capture de ces mêmes sorties n'apporterait rien de plus et serait moins vérifiable, puisqu'elle ne se relit pas.

Les captures redeviennent nécessaires **à partir de l'interface web**, qui ne peut pas être prouvée autrement.

## Captures à produire

| Fichier | Contenu attendu | État |
| --- | --- | --- |
| `01-acces-glpi-poste-client.png` | Page d'authentification atteinte depuis un poste du VLAN, URL visible | Non produite |
| `02-prerequis-interface.png` | Page de contrôle de la configuration dans GLPI, versions visibles | Non produite |
| `03-agent-telechargement.png` | Récupération de GLPI Agent 1.21 depuis les publications du projet | **Produite** |
| `04-agent-assistant-installation.png` | Assistant d'installation de GLPI Agent 1.21 | **Produite** |
| `05-agent-service-actif.png` | `sc query glpi-agent` renvoyant `STATE : 4 RUNNING` | **Produite** |
| `06-inventaire-machine.png` | Fiche de la machine inventoriée : système, matériel, date de collecte | Non produite |
| `07-ticket-cree-demandeur.png` | Ticket vu depuis le compte demandeur, interface Self-Service | **Produite** |
| `08-ticket-vue-administrateur.png` | Le même ticket depuis le compte super-administrateur | **Produite** |
| `09-ticket-resolu-historique.png` | Suivis du technicien avant correction, dates de résolution et de clôture | **Produite** |
| `10-ticket-solution-cloture.png` | Solution enregistrée et ticket clos après correction | **Produite** |
| `11-tableau-de-bord-valeurs-demo.png` | Tableau de bord affichant des chiffres sans rapport avec la base | **Produite** |
| `12-actions-automatiques.png` | Tableau des actions automatiques et de leur dernière exécution | Non produite |

## Deux captures qui illustrent un piège plutôt qu'une réussite

La capture `05` prouve que le service de l'agent tourne, **pas** que l'inventaire fonctionne. Au moment où elle a été prise, l'agent n'envoyait rien, faute d'URL de serveur active.

La capture `11` montre un tableau de bord annonçant 1 500 tickets alors que la base n'en contient qu'un seul. Elle ne documente pas un état du parc, elle documente le fait que cet affichage ne mesure rien de réel.

Ces deux images servent la démonstration par ce qu'elles trompent, pas par ce qu'elles valident. Une relecture rapide pourrait leur faire dire le contraire : la procédure précise le contexte de chacune.

## Règles retenues

Les mêmes que pour le reste du projet : format PNG, nom en minuscules avec des tirets, la commande ou l'écran **et** son résultat visibles sur la même capture, une légende décrivant ce qu'elle prouve.

Deux précautions propres à GLPI : **aucun mot de passe visible**, et attention aux comptes par défaut — une capture prise avant leur changement ne doit pas laisser deviner les identifiants utilisés. Une liste de captures prévues ne vaut pas validation.

[Retour à la procédure](../GLPI.md) · [Infrastructure](../../README.md)
