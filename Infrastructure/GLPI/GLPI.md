# GLPI — Inventaire et assistance

**AP 1 — Planifié, non installé.** GLPI complète le socle AD et NAS avec la gestion du parc et des demandes d'assistance.

## Objectif et périmètre

Inventorier au moins le poste Windows pilote avec GLPI Agent, puis présenter le cycle complet d'un ticket : création par un demandeur, attribution à un technicien, traitement et résolution. L'intégration LDAP à Active Directory est une extension à étudier après ce premier fonctionnement ; elle n'est pas un prérequis du premier test.

## Paramètres à renseigner pendant la réalisation

| Élément | Valeur |
| --- | --- |
| VM, nom et IP | Proposition dans la [feuille de route](../Feuille-de-route.md), à vérifier |
| Distribution et version | À choisir |
| Version GLPI et GLPI Agent | À relever |
| Serveur web, PHP et base | À choisir selon les prérequis GLPI |
| URL et certificat | À définir |
| Poste pilote | VM 701 Windows, à confirmer au lancement |
| Date et opérateur | À renseigner |

## Étapes prévues

- [ ] Vérifier les prérequis et préparer la VM.
- [ ] Installer la base, les dépendances et GLPI selon la documentation de la version choisie.
- [ ] Configurer l'URL, les accès administrateur, demandeur et technicien.
- [ ] Installer et configurer GLPI Agent sur le poste pilote.
- [ ] Déclencher un inventaire et vérifier le nom, l'OS et les caractéristiques remontées.
- [ ] Créer un ticket de démonstration avec un compte demandeur.
- [ ] Attribuer, traiter et résoudre ce ticket avec un compte technicien.
- [ ] Documenter les paramètres, écarts et résultats réels.

## Recette attendue et preuves

| Contrôle | Résultat attendu | Preuve à prendre |
| --- | --- | --- |
| Accès au service | Page GLPI accessible depuis un poste client | Accueil avec URL |
| Inventaire | Poste pilote reconnu avec des informations cohérentes | Fiche du poste et date de collecte |
| Demande | Ticket identifiable et contenu lisible | Ticket créé |
| Traitement | Technicien attribué, suivi et résolution visibles | Historique du ticket |

Aucun résultat n'est encore validé. Les futures captures sont conservées dans [images](images/README.md).

## Références

- [Documentation GLPI](https://glpi-install.readthedocs.io/)
- [Documentation GLPI Agent](https://glpi-agent.readthedocs.io/)

[Retour AP 1](../../AP%201/README.md) · [Infrastructure](../README.md)
