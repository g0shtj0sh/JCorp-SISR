# Captures — GLPI

Ce dossier accompagne la [procédure GLPI](../GLPI.md).

## Pourquoi il est encore vide

L'installation du 12 novembre 2026 a été menée **entièrement en ligne de commande**, sur une VM sans interface graphique. Les preuves de cette phase sont donc les sorties de commandes, reproduites dans la procédure : versions relevées, liste des extensions PHP, résultat du contrôle de prérequis, validation de l'intégrité du code source, code de réponse HTTP et état du *timer* systemd. Une capture de ces mêmes sorties n'apporterait rien de plus et serait moins vérifiable, puisqu'elle ne se relit pas.

Les captures redeviennent nécessaires **à partir de l'interface web**, qui ne peut pas être prouvée autrement.

## Captures à produire

| Fichier | Contenu attendu | État |
| --- | --- | --- |
| `01-acces-glpi-poste-client.png` | Page d'authentification atteinte depuis la VM 701, avec l'URL visible | Non produite |
| `02-prerequis-interface.png` | Page de contrôle de la configuration dans GLPI | Non produite |
| `03-agent-installe-poste.png` | GLPI Agent installé sur le poste pilote, version visible | Non produite |
| `04-inventaire-poste.png` | Fiche du poste Windows avec système, matériel et date de collecte | Non produite |
| `05-ticket-cree-demandeur.png` | Ticket créé depuis le compte demandeur | Non produite |
| `06-ticket-attribue-technicien.png` | Ticket attribué, vu depuis le compte technicien | Non produite |
| `07-ticket-resolu-historique.png` | Ticket résolu et son historique de suivi | Non produite |
| `08-actions-automatiques.png` | Tableau des actions automatiques et de leur dernière exécution | Non produite |

## Règles retenues

Les mêmes que pour le reste du projet : format PNG, nom en minuscules avec des tirets, la commande ou l'écran **et** son résultat visibles sur la même capture, une légende décrivant ce qu'elle prouve.

Deux précautions propres à GLPI : **aucun mot de passe visible**, et attention aux comptes par défaut — une capture prise avant leur changement ne doit pas laisser deviner les identifiants utilisés. Une liste de captures prévues ne vaut pas validation.

[Retour à la procédure](../GLPI.md) · [Infrastructure](../../README.md)
