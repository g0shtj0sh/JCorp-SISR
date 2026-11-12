# GLPI — Inventaire et assistance

**AP 1 — VM prête depuis le 12 novembre 2026, GLPI non installé.** GLPI complète le socle AD et NAS avec la gestion du parc et des demandes d'assistance.

## Objectif et périmètre

Inventorier au moins le poste Windows pilote avec GLPI Agent, puis présenter le cycle complet d'un ticket : création par un demandeur, attribution à un technicien, traitement et résolution. L'intégration LDAP à Active Directory est une extension à étudier après ce premier fonctionnement ; elle n'est pas un prérequis du premier test.

GLPI et sa base MariaDB sont regroupés avec Grafana et Prometheus dans la VM de services AP 1 : **2 vCPU, 4 Gio RAM, 40 Gio disque**, Debian 13 sans interface graphique. Cette VM existe depuis le 12 novembre 2026 — VMID **705**, nom **`JCORP-SRV01`**, IP **`10.2.101.153/24`** — et son déroulé de création est documenté à part ([procédure](../VM%20Linux/Creation-des-VM-Linux.md)). GLPI n'est pas installé sur un contrôleur de domaine. Voir la [décision des deux VM](../Feuille-de-route.md#2-deux-vm-supplémentaires-retenues).

La compatibilité de la pile a été vérifiée avant de retenir la distribution : GLPI 11 exige **PHP 8.2 minimum et MariaDB 10.6 minimum**, quand Debian 13 livre PHP 8.4 et MariaDB 11. Le point méritait d'être contrôlé en amont, car une version de PHP trop récente pour la version de GLPI aurait imposé de réinstaller la VM.

## Paramètres à renseigner pendant la réalisation

| Élément | Valeur |
| --- | --- |
| VM, nom et IP | VM **705**, `JCORP-SRV01`, `10.2.101.153/24`, passerelle `10.2.101.1`, DNS `10.2.101.10` |
| Distribution et version | **Debian 13 trixie**, noyau `6.12.116+deb13-amd64`, sans interface graphique |
| Version GLPI et GLPI Agent | À relever à l'installation ; GLPI 11 retenu |
| Serveur web, PHP et base | **Apache 2, PHP 8.4, MariaDB 11** retenus ; versions exactes à relever |
| URL et certificat | Proposition `glpi.ad.jcorp`, enregistrement DNS non créé, certificat à définir |
| Poste pilote | VM 701 `User1-JCorp-Windows`, à confirmer au lancement |
| Date et opérateur | VM préparée le 12 novembre 2026 ; installation GLPI à venir |

## Étapes prévues

- [x] Vérifier les prérequis et préparer la VM. *VM 705 créée et contrôlée le 12 novembre 2026 ; prérequis PHP et MariaDB de GLPI 11 vérifiés contre les versions de Debian 13.*
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
