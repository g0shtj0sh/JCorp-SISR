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

## 2. Machines supplémentaires proposées

Je sépare GLPI, la supervision et l'hébergement afin que l'arrêt du serveur d'applications ne coupe pas la supervision. Cette répartition est une proposition à ajuster selon les ressources du laboratoire.

| Rôle proposé | VMID proposé | Nom proposé | IP proposée | Point de départ pour les ressources |
| --- | --- | --- | --- | --- |
| GLPI | 705 | JCORP-GLPI01 | 10.2.101.153/24 | 2 vCPU, 4 Gio RAM, 40 Gio disque |
| Grafana et Prometheus | 706 | JCORP-MON01 | 10.2.101.154/24 | 2 vCPU, 4 Gio RAM, 40 Gio disque |
| Docker et Dokploy | 707 | JCORP-APP01 | 10.2.101.155/24 | 4 vCPU, 8 Gio RAM, 60 Gio disque |

Ces tailles sont un budget initial de laboratoire, pas des exigences officielles ni une capacité mesurée. Vérifier les prérequis de chaque version avant installation. Les VMID, noms et IP n'ont pas encore été contrôlés ni réservés. Les IP proposées sont hors du pool DHCP `10.2.101.11–10.2.101.150` ; cela ne garantit pas leur disponibilité.

Paramètres envisagés : pont `vmbr2`, VLAN 700, passerelle `10.2.101.1`, DNS `10.2.101.10`. La distribution Linux et les versions seront choisies selon les prérequis à jour. Le poste utilisateur Debian VM 702 conserve son rôle et ne devient pas le serveur d'hébergement.

## 3. Décisions à prendre avant installation

- [ ] Vérifier la mémoire, les CPU et le stockage réellement disponibles.
- [ ] Vérifier puis affecter les trois VMID, noms et IP.
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
