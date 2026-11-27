# Captures — AP 2

Ce dossier accompagne la [procédure de déploiement de Checkpoint](../Deploiement-Checkpoint.md). Les captures de la plateforme elle-même sont dans le [dossier Dokploy](../../Infrastructure/Dokploy/images/README.md).

| Fichier | Contenu | État |
| --- | --- | --- |
| `01-depot-github-checkpoint.png` | Dépôt g0shtj0sh/checkpoint créé, public, branche main | **Produite** |
| `02-clone-depot.png` | Clonage du dépôt sur le poste | **Produite** |
| `03-incident-politique-execution.png` | Incident : npx bloqué par la politique d'exécution PowerShell | **Produite** |
| `04-create-next-app.png` | Création du projet Next.js, choix recommandés | **Produite** |
| `05-create-next-app-succes.png` | Projet créé, aucune vulnérabilité | **Produite** |
| `06-npm-run-dev.png` | Serveur de développement Next.js 16.4.6 | **Produite** |
| `07-page-next-localhost.png` | Page par défaut sur localhost:3000 | **Produite** |
| `08-git-status.png` | État du dépôt avant le premier commit | **Produite** |
| `09-premier-commit-push.png` | Commit ad862ff envoyé (identité du poste masquée) | **Produite** |
| `10-dokploy-application-creee.png` | Application checkpoint-site créée dans Dokploy | **Produite** |
| `11-dokploy-provider-github.png` | Source GitHub, branche main, déclenchement On Push | **Produite** |
| `12-build-node18-avertissements.png` | Incident : build lancé avec Node 18 (EBADENGINE) | **Produite** |
| `13-build-echec-node18.png` | Incident : échec du build Nixpacks | **Produite** |
| `14-correctif-node22-push.png` | engines.node = 22.x vérifié, commit 4882a99 envoyé | **Produite** |
| `15-services-checkpoint-verts.png` | Site et base en service dans le projet | **Produite** |
| `16-dns-enregistrement-checkpoint.png` | Enregistrement A checkpoint.ad.jcorp créé sur le DC | **Produite** |
| `17-dns-resolution-checkpoint.png` | Résolution de checkpoint.ad.jcorp en 10.2.101.154 | **Produite** |
| `18-dokploy-domaine-formulaire.png` | Domaine checkpoint.ad.jcorp, port 3000, HTTPS désactivé | **Produite** |
| `19-dokploy-domaine-actif.png` | Domaine actif dans Dokploy | **Produite** |
| `20-site-vm701-checkpoint-ad-jcorp.png` | Site ouvert depuis la VM 701 par son nom DNS | **Produite** |
| `21-nrpt-poste-administration.png` | Règle NRPT `.ad.jcorp` vers le DNS de l'AD, nom résolu | **Produite** |
| `22-site-depuis-poste-administration.png` | Site ouvert depuis le poste d'administration | **Produite** |
| `23-variable-database-url-masquee.png` | Variable `DATABASE_URL` saisie et masquée dans Dokploy | **Produite** |
| `24-git-status-v020.png` | État du dépôt avant l'envoi du catalogue | **Produite** |
| `25-aucun-secret-dans-le-code.png` | `git grep "postgresql://"` ne trouve rien dans le code | **Produite** |
| `26-commit-push-v020.png` | Commit `42b16c1` : catalogue, fiches et formulaire envoyés | **Produite** |
| — | Site HTTPS, commande de test, données après redéploiement, retour de version, supervision | Non produites |

## Règles retenues

Format PNG, nom en minuscules avec des tirets, résultat visible sur la capture, légende décrivant ce qu'elle prouve. Mots de passe, jetons et données personnelles inutiles masqués avant publication. Une liste de captures prévues ne vaut pas validation.

[Retour à la procédure](../Deploiement-Checkpoint.md) · [Retour AP 2](../README.md)
