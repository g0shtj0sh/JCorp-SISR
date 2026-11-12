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
| `07-ticket-cree-demandeur.png` | Ticket créé depuis le compte demandeur | Non produite |
| `08-ticket-attribue-technicien.png` | Ticket attribué, vu depuis le compte technicien | Non produite |
| `09-ticket-resolu-historique.png` | Ticket résolu et son historique de suivi | Non produite |
| `10-actions-automatiques.png` | Tableau des actions automatiques et de leur dernière exécution | Non produite |

Une remarque sur la capture `05` : elle prouve que le service tourne, **pas** que l'inventaire fonctionne. Au moment où elle a été prise, l'agent n'envoyait rien, faute d'URL de serveur active. C'est précisément ce que la procédure explique, et la capture sert à illustrer ce piège plutôt qu'à valider l'étape.

## Règles retenues

Les mêmes que pour le reste du projet : format PNG, nom en minuscules avec des tirets, la commande ou l'écran **et** son résultat visibles sur la même capture, une légende décrivant ce qu'elle prouve.

Deux précautions propres à GLPI : **aucun mot de passe visible**, et attention aux comptes par défaut — une capture prise avant leur changement ne doit pas laisser deviner les identifiants utilisés. Une liste de captures prévues ne vaut pas validation.

[Retour à la procédure](../GLPI.md) · [Infrastructure](../../README.md)
