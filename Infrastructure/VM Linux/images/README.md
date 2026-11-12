# Captures — Création des VM Linux

Ce dossier accompagne la [procédure de création des deux VM Linux](../Creation-des-VM-Linux.md).

## Pourquoi ce dossier est vide

L'intégralité de la création a été réalisée en ligne de commande, par SSH sur l'hyperviseur puis dans les VM. Les preuves sont donc les **sorties de commandes**, reproduites directement dans la procédure : configuration retournée par `qm config`, empreinte de l'image, résultats des tests de résolution et d'horloge, état de l'agent invité.

Une capture d'écran de ces mêmes sorties n'apporterait rien de plus qu'une image du texte déjà présent dans le document, et serait moins vérifiable puisqu'elle ne se relit pas.

## Captures qui pourraient être ajoutées

Si des captures sont demandées, celles-ci montreraient quelque chose que les commandes ne montrent pas :

| Fichier | Contenu | État |
| --- | --- | --- |
| `vm705-materiel-proxmox.png` | Onglet Matériel de la VM 705 dans l'interface Proxmox | Non produite |
| `vm706-materiel-proxmox.png` | Onglet Matériel de la VM 706 dans l'interface Proxmox | Non produite |
| `vm705-cloudinit-proxmox.png` | Onglet Cloud-Init de la VM 705, paramètres réseau appliqués | Non produite |
| `vue-ensemble-vm-jcorp.png` | Les VM 700 à 706 dans l'arborescence Proxmox | Non produite |

Les règles de nomenclature sont les mêmes que pour le reste du projet : format PNG, minuscules, mots séparés par des tirets, aucune information d'authentification visible à l'écran.

[Retour à la procédure](../Creation-des-VM-Linux.md) · [Infrastructure](../../README.md)
