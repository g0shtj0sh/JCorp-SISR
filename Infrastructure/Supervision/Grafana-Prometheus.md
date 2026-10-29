# Supervision — Grafana et Prometheus

**AP 1 — Planifiée, non installée.** La supervision sera ensuite étendue aux services de l'AP 2.

## Architecture prévue

- **Prometheus** collecte et conserve les métriques.
- **Node Exporter** expose les métriques du serveur Linux pilote.
- **Windows Exporter** expose les métriques du poste ou serveur Windows pilote.
- **Grafana** consulte Prometheus, affiche les tableaux de bord et évalue les alertes retenues.
- **AP 2 :** ajout de métriques des conteneurs (par exemple cAdvisor ou intégration Dokploy compatible) et d'un contrôle HTTP avec Blackbox Exporter pour le site.

Les collecteurs exacts, versions et flux autorisés seront consignés avant installation. La VM de supervision reste distincte de la VM Dokploy. Les notifications intégrées à Dokploy ne sont pas présentées comme inexistantes : Grafana apporte une vue transversale.

## Paramètres à renseigner

| Élément | Valeur |
| --- | --- |
| VM, IP et nom | Proposition dans la [feuille de route](../Feuille-de-route.md), à vérifier |
| Versions Linux/Grafana/Prometheus | À choisir et relever |
| Versions des collecteurs | À choisir et relever |
| URL et certificat | À définir |
| Cibles Linux et Windows | À confirmer |
| Rétention des métriques | À dimensionner selon le disque disponible |
| Canal de notification | À définir ; aucun envoi externe configuré à ce stade |

## Étapes prévues

- [ ] Préparer la VM et vérifier DNS, heure et accès réseau aux cibles.
- [ ] Installer Prometheus et Grafana.
- [ ] Installer les collecteurs sur une cible Linux et une cible Windows.
- [ ] Définir les cibles et constater leur état UP.
- [ ] Ajouter Prometheus comme source Grafana.
- [ ] Créer ou importer un tableau de bord adapté : CPU, RAM, disque et disponibilité.
- [ ] Définir une règle d'alerte, son seuil et sa durée ; les documenter.
- [ ] Simuler une indisponibilité sans arrêter un service AD/DNS/DHCP essentiel.
- [ ] Constater l'alerte puis sa résolution après rétablissement.
- [ ] Si un canal est configuré, vérifier la réception de la notification.
- [ ] En AP 2, ajouter Dokploy, les conteneurs et le contrôle HTTP du site.

## Recette et captures

| Contrôle | Résultat attendu | Capture |
| --- | --- | --- |
| Collecte | Cibles Linux et Windows UP | Page des cibles Prometheus |
| Visualisation | Métriques réelles et période visible | Tableau Grafana |
| Détection | Alerte en état déclenché après la durée définie | Règle et état |
| Rétablissement | Alerte résolue après retour à la normale | État résolu |
| Extension AP 2 | Hôte, conteneurs et site observables | Tableaux et contrôle HTTP |

Aucun test n'est encore exécuté. Voir le [guide des captures](images/README.md).

## Références

- [Grafana et Prometheus](https://grafana.com/docs/grafana/latest/datasources/prometheus/)
- [Prometheus](https://prometheus.io/docs/introduction/overview/)
- [Node Exporter](https://github.com/prometheus/node_exporter)
- [Windows Exporter](https://github.com/prometheus-community/windows_exporter)
- [Blackbox Exporter](https://github.com/prometheus/blackbox_exporter)
- [Logs et métriques Dokploy](https://docs.dokploy.com/docs/core/logs-and-metrics)

[Retour AP 1](../../AP%201/README.md) · [Infrastructure](../README.md)
