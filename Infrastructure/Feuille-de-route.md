# Feuille de route JCorp

**Statut : préparation documentaire, 29 octobre 2026.** Cette feuille de route décrit les travaux acceptés pour les AP 1 et AP 2. Aucun nouveau service ou aucune nouvelle VM n'a été installé pendant cette préparation.

## 1. Ordre de réalisation

| Étape | Travail | Critère pour passer à la suite |
| --- | --- | --- |
| 1 — terminé | Jonction du poste Debian existant | Membre du domaine dans l'OU Postes, résolution AD/Internet, identité et test de jonction validés ; connexion graphique confirmée |
| 2 | Vérifier les ressources Proxmox et les paramètres disponibles | VMID/IP libres, RAM/CPU/disque disponibles, sortie réseau et résolution DNS confirmées |
| 3 | Installer GLPI et son agent sur un poste pilote | Poste visible dans l'inventaire et ticket créé, attribué puis résolu |
| 4 | Installer Prometheus, Grafana et les collecteurs nécessaires | Mesures réelles de Windows et Linux, tableau lisible et alerte déclenchée puis résolue |
| 5 | Préparer la VM Linux et installer Dokploy | Accès d'administration fonctionnel et premier déploiement sain |
| 6 | Créer puis déployer le site et sa base | Catalogue et formulaire fonctionnels, données persistantes après redéploiement |
| 7 | Configurer DNS/HTTPS et intégrer la supervision | URL fonctionnelle depuis un client, certificat valide dans le contexte retenu et disponibilité surveillée |
| 8 | Réaliser la démonstration et terminer les preuves | Mise à jour depuis GitHub, consultation des logs et retour applicatif à une version connue |

## 2. Deux VM supplémentaires retenues

**Décision validée le 29 octobre 2026 : créer deux VM Linux sans interface graphique.** GLPI, sa base MariaDB, Grafana et Prometheus partagent la VM de services AP 1. Docker/Dokploy, le site et sa base applicative utilisent une seconde VM, dédiée à l'AP 2. Cette décision remplace la proposition initiale de trois VM.

| VM prévue | Services | VMID proposé | Nom proposé | IP proposée | Ressources de départ retenues |
| --- | --- | --- | --- | --- | --- |
| Services AP 1 | GLPI, MariaDB, Grafana, Prometheus | 705 | JCORP-SRV01 | 10.2.101.153/24 | 2 vCPU, 4 Gio RAM (4096 Mio), disque 40 Gio |
| Hébergement AP 2 | Docker, Dokploy, site et base du site | 706 | JCORP-APP01 | 10.2.101.154/24 | 4 vCPU, 4 Gio RAM (4096 Mio), disque 60 Gio ; passage à 6 Gio (6144 Mio) si les mesures ou les builds le nécessitent |

**Référence pour la future création des « deux VM » : reprendre ce tableau et vérifier d'abord les ressources disponibles sur Proxmox.** Les tailles sont des budgets de départ pour un petit laboratoire, pas des exigences officielles ni une capacité mesurée. Vérifier les prérequis des versions retenues avant installation.

Les VMID, noms et IP restent proposés, non contrôlés ni réservés. L'ancien projet de VM 707 n'est plus nécessaire à cette architecture. Les IP proposées sont hors du pool DHCP `10.2.101.11–10.2.101.150` ; vérifier leur disponibilité avant affectation.

Paramètres réseau prévus pour les deux VM : pont `vmbr2`, VLAN 700, passerelle `10.2.101.1`, DNS AD `10.2.101.10`, masque `/24`. Distribution Linux et versions à choisir selon les prérequis à jour. Le stockage Proxmox et les autres options matérielles seront confirmés lors de la création selon les capacités disponibles.

### Compromis et optimisation

- Les contrôleurs de domaine gardent leurs rôles AD/DNS/DHCP ; GLPI sera installé sur la VM Linux de services.
- La supervision reste séparée de Dokploy : l'arrêt de la VM AP 2 peut être observé depuis la VM AP 1.
- L'arrêt de la VM AP 1 coupe simultanément GLPI et la supervision ; ce compromis est accepté pour le laboratoire.
- La VM Debian 702 reste un poste utilisateur. Les postes clients Windows et Debian peuvent être arrêtés hors des tests et démonstrations.
- Dimensionner la rétention Prometheus selon l'espace réellement disponible et observer CPU, RAM et disque avant d'augmenter ou de réduire les allocations.
- TrueNAS conserve son rôle de stockage. Aucune modification des VM existantes n'est réalisée par cette décision documentaire.

## 3. Décisions à prendre avant installation

- [ ] Vérifier la mémoire, les CPU et le stockage réellement disponibles.
- [ ] Vérifier puis affecter les deux VMID, noms et IP.
- [ ] Choisir les versions Linux et applicatives compatibles ; les consigner.
- [ ] Définir les URL internes : propositions `glpi.ad.jcorp`, `grafana.ad.jcorp`, `dokploy.ad.jcorp` et `games.ad.jcorp`, non créées à ce stade.
- [ ] Définir le contexte du site : démonstration interne ou publication Internet autorisée. L'installation ne suppose pas une ouverture automatique vers Internet.
- [ ] Choisir le certificat : autorité de laboratoire approuvée par les clients pour les noms internes, ou domaine public maîtrisé et méthode de validation adaptée. Un nom `.jcorp` interne ne recevra pas un certificat public classique.
- [ ] Choisir le nom du site, son identité visuelle et la technologie du site et de sa base.
- [ ] Faire valider les sujets des AP par l'enseignant avant de figer les livrables.

## 4. Supervision entre les deux AP

En AP 1, Prometheus collecte les métriques des machines pilotes ; Grafana les affiche et porte les alertes retenues. En AP 2, la même supervision est étendue au serveur Dokploy et à ses conteneurs, avec un contrôle HTTP du site.

Le tableau Dokploy reste utile à l'exploitation des applications et peut aussi proposer des notifications. Grafana apporte ici une vue commune à l'infrastructure et aux applications. Le choix exact des collecteurs et de l'intégration Dokploy sera arrêté selon les versions installées.

## 5. Méthode documentaire

Chaque procédure distingue **prévu**, **réalisé** et **vérifié**. Elle conserve les versions, paramètres effectivement appliqués, étapes, résultat attendu, résultat observé, incidents et corrections.

Les captures sont ajoutées après les actions, avec une légende décrivant ce qu'elles prouvent. Les dossiers images contiennent pour le moment un guide de collecte, pas des captures fictives. Les secrets et jetons ne sont pas conservés dans les procédures ou captures.

Les critères de recette de l'AP 2 figurent dans son [plan de validation](../AP%202/Plan-de-validation.md).
