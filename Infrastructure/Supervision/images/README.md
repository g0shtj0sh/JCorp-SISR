# Captures — Grafana et Prometheus

Ce dossier accompagne la [procédure de supervision](../Grafana-Prometheus.md).

| Fichier | Contenu attendu | État |
| --- | --- | --- |
| `01-prometheus-installation-paquets.png` | Installation de `prometheus` et `prometheus-node-exporter` depuis les dépôts Debian | **Produite** |
| `02-prometheus-versions-sante.png` | Versions 2.53.3 et 1.9.0, `Prometheus Server is Healthy.`, métriques du Node Exporter | **Produite** |
| `03-prometheus-retention.png` | Options de rétention `15d` / `5GB` dans `/etc/default/prometheus` | **Produite** |
| `04-prometheus-jobs-redemarrage.png` | Redémarrage `active` et tâches `prometheus` et `node` déclarées | **Produite** |
| `05-prometheus-interface-absente.png` | Avertissement Debian : interface web moderne non incluse | **Produite** |
| `06-prometheus-retention-appliquee.png` | Rétention `15d` et `5GiB` lue dans l'API | **Produite** |
| `07-cibles-prometheus.png` | Page *Targets* classique, `node` et `prometheus` en état UP | **Produite** |
| `08-grafana-installation-gnupg.png` | Installation de `gnupg` | **Produite** |
| `09-grafana-depot-installation.png` | Clé et dépôt Grafana ajoutés, index signé récupéré | **Produite** |
| `10-grafana-service-actif.png` | Service `grafana-server` activé et actif, mémoire disponible | **Produite** |
| `11-grafana-accueil.png` | Page d'accueil après connexion, depuis le poste d'administration | **Produite** |
| `12-grafana-version-paquet.png` | Version 13.3.1 lue par `dpkg` | **Produite** |
| `13-grafana-source-prometheus.png` | Source Prometheus enregistrée, par défaut | **Produite** |
| `14-grafana-import-1860.png` | Import du tableau Node Exporter Full (ID 1860) depuis grafana.com | **Produite** |
| `15-tableau-grafana.png` | Tableau CPU, RAM, disque et disponibilité de `JCORP-SRV01`, période visible | **Produite** |
| `16-windows-exporter-installation.png` | Téléchargement et installation du MSI sur `JCORP-DC01` | **Produite** |
| `17-windows-exporter-arrete.png` | Service arrêté, port 9182 injoignable (incident) | **Produite** |
| `18-windows-exporter-echec-demarrage.png` | Échec de `Start-Service` (incident) | **Produite** |
| `19-windows-exporter-journal-cs.png` | Journal : `unknown collector cs`, cause de l'incident | **Produite** |
| `20-windows-exporter-actif.png` | Service `Running`, `/metrics` répond 200 | **Produite** |
| `21-dc01-pare-feu-9182.png` | Règle de pare-feu 9182 limitée à `JCORP-SRV01` | **Produite** |
| `22-srv01-acces-9182.png` | Code 200 depuis `JCORP-SRV01` vers le DC01 | **Produite** |
| `23-prometheus-job-windows.png` | Tâche `windows` dans `prometheus.yml` | **Produite** |
| `24-promtool-redemarrage.png` | Configuration validée par `promtool`, Prometheus actif | **Produite** |
| `25-cible-windows-up.png` | Cible `JCORP-DC01` UP dans Prometheus | **Produite** |
| `26-alerte-requete-condition.png` | Requête `up{job="windows"}` et condition *Is below 1* | **Produite** |
| `27-alerte-dossier-evaluation.png` | Dossier `JCorp`, groupe `supervision` (30 s), attente 1 min | **Produite** |
| `28-alerte-normale.png` | Règle enregistrée, état Normal | **Produite** |
| `29-dc01-exporteur-arrete.png` | Panne simulée : `windows_exporter` arrêté sur le DC01 | **Produite** |
| `30-alerte-declenchee.png` | Règle `JCORP-DC01 injoignable` en état Firing | **Produite** |
| `31-dc01-exporteur-redemarre.png` | Service `windows_exporter` relancé (`Running`) | **Produite** |
| `32-alerte-resolue.png` | Règle revenue à l'état Normal après rétablissement | **Produite** |
| `33-dc01-collecteurs-ad-dns-dhcp.png` | Collecteurs AD, DNS, DHCP actifs, 202 séries | **Produite** |
| `34-script-ad-metriques.png` | Sortie du script `ad-metrics.ps1` | **Produite** |
| `35-tache-planifiee-ad.png` | Tâche planifiée « JCorp - Metriques AD » prête | **Produite** |
| `36-prometheus-metriques-ad.png` | `jcorp_ad_users` lu dans Prometheus | **Produite** |
| `37-vm702-cle-ssh.png` | Clé copiée sur la VM 702, connexion sans mot de passe | **Produite** |
| `38-vm702-etat-clamav.png` | Services ClamAV, timer d'analyse, journaux, freshclam | **Produite** |
| `39-vm702-node-exporter.png` | Installation de Node Exporter sur la VM 702 | **Produite** |
| `40-vm702-rapport-analyse.png` | Service d'analyse et rapport avec détection EICAR | **Produite** |
| `41-scp-scripts-clamav.png` | Envoi des scripts ClamAV par `scp` | **Produite** |
| `42-clamav-metriques-generees.png` | Métriques ClamAV générées par le script | **Produite** |
| `43-quatre-cibles-up.png` | Quatre cibles UP dans l'API Prometheus | **Produite** |
| `44-noms-metriques-ad-dns-dhcp.png` | Noms des métriques AD, DNS et DHCP | **Produite** |
| `45-import-tableau-jcorp.png` | Import du tableau JCorp dans le dossier `JCorp` | **Produite** |
| `46-tableau-vue-ensemble.png` | Tableau JCorp : vue d'ensemble | **Produite** |
| `47-tableau-active-directory.png` | Tableau JCorp : Active Directory | **Produite** |
| `48-tableau-dns-dhcp.png` | Tableau JCorp : DNS et DHCP | **Produite** |
| `49-tableau-clamav.png` | Tableau JCorp : ClamAV | **Produite** |
| `50-tableau-machines.png` | Tableau JCorp : ressources des machines | **Produite** |
| `51-clamav-version-depots.png` | Version ClamAV 1.4.3 et dépôts Debian configurés | **Produite** |
| `52-prometheus-script-install-ui.png` | Lecture du script `install-ui.sh` avant décision | **Produite** |
| `53-clamav-aucune-mise-a-jour-debian.png` | Après `apt-get update`, candidat toujours 1.4.3 | **Produite** |
| `54-prometheus-ui-verifiee-installee.png` | Empreinte SHA-256 OK, interface installée, Prometheus actif | **Produite** |
| `55-prometheus-interface-moderne.png` | Interface moderne, page *Targets* (cible `debian` DOWN : VM 702 éteinte) | **Produite** |
| `56-grafana-smtp-parametres.png` | Paramètres SMTP Gmail ajoutés (abandonnés ensuite) | **Produite** |
| `57-grafana-smtp-secret-masque.png` | Saisie masquée du mot de passe d'application | **Produite** |
| `58-grafana-smtp-droits-redemarrage.png` | Fichier restreint à root:grafana, Grafana actif | **Produite** |
| `59-grafana-smtp-controle.png` | Contrôle de la configuration, mot de passe masqué | **Produite** |
| `60-smtp-echec-identifiants.png` | Incident : Gmail refuse l'authentification (535) | **Produite** |
| `61-discord-test-reussi.png` | Test du point de contact Discord réussi | **Produite** |
| `62-discord-message-test.png` | Message de test reçu dans Discord | **Produite** |
| `63-discord-point-contact.png` | Point de contact `Discord JCorp` enregistré | **Produite** |
| `64-regle-choix-discord.png` | Règle rattachée au point de contact Discord | **Produite** |
| `65-regle-livree-discord.png` | Règle : notifications livrées à Discord JCorp | **Produite** |
| `66-grafana-root-url.png` | Adresse publique de Grafana configurée | **Produite** |
| `67-dc01-arret-exporteur-discord.png` | Panne simulée : exporteur arrêté | **Produite** |
| `68-discord-alerte-firing.png` | Alerte FIRING reçue dans Discord | **Produite** |
| `69-dc01-redemarrage-exporteur-discord.png` | Exporteur relancé | **Produite** |
| `70-discord-alerte-resolue.png` | Résolution reçue dans Discord | **Produite** |
| `71-alerte-toutes-cibles.png` | Règle étendue à toutes les cibles, `User2-JCorp` en Firing (VM éteinte) | **Produite** |
| `72-alertes-liste-provisionnees-1.png` | Règles JCorp « Provisioned », état Normal (début de liste) | **Produite** |
| `72-alertes-liste-provisionnees-2.png` | Fin de liste : 17 règles, dont la règle de disponibilité modifiable | **Produite** |
| `73-alerte-service-ad-detail.png` | Règle Service AD arrêté : six services, Discord, origine Provisioning | **Produite** |

Les captures `02` et `04` prouvent que les services fonctionnent et que les cibles sont déclarées, **pas** que Prometheus les collecte : c'est la capture `07` qui l'établira. La capture `05` documente une absence, pas une panne.

## Règles retenues

Format PNG, nom en minuscules avec des tirets, la commande ou l'écran **et** son résultat visibles sur la même capture, une légende décrivant ce qu'elle prouve. Aucun mot de passe, jeton ou donnée personnelle inutile visible. Une liste de captures prévues ne vaut pas validation.

[Retour à la procédure](../Grafana-Prometheus.md) · [Infrastructure](../../README.md)
