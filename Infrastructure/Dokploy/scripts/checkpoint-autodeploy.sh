#!/bin/sh
# checkpoint-autodeploy.sh - Déploie Checkpoint quand un nouveau commit arrive sur GitHub.
# GitHub ne peut pas joindre Dokploy (adresse privée) : c'est la VM qui interroge GitHub.
# Exécuté chaque minute par checkpoint-autodeploy.timer sur JCORP-APP01.
set -eu

. /etc/checkpoint-autodeploy.env          # DOKPLOY_TOKEN, DEPOT, BRANCHE (fichier root, 600)
ETAT=/var/lib/checkpoint-autodeploy/dernier-commit
mkdir -p "$(dirname "$ETAT")"

DISTANT=$(git ls-remote "$DEPOT" "refs/heads/$BRANCHE" | cut -f1)
[ -n "$DISTANT" ] || { echo "GitHub injoignable ou branche absente"; exit 1; }
DERNIER=$(cat "$ETAT" 2>/dev/null || true)
[ "$DISTANT" = "$DERNIER" ] && exit 0

echo "Nouveau commit $DISTANT (précédent : ${DERNIER:-aucun}), déploiement demandé"
CODE=$(curl -s -o /tmp/checkpoint-autodeploy.out -w '%{http_code}' -X POST \
  -H 'Content-Type: application/json' -H 'X-GitHub-Event: push' \
  -d "{\"ref\":\"refs/heads/$BRANCHE\",\"commits\":[],\"head_commit\":{\"id\":\"$DISTANT\",\"message\":\"Déploiement automatique $DISTANT\"}}" \
  "http://127.0.0.1:3000/api/deploy/$DOKPLOY_TOKEN")
echo "Réponse de Dokploy : HTTP $CODE $(cat /tmp/checkpoint-autodeploy.out)"
[ "$CODE" = 200 ] && echo "$DISTANT" > "$ETAT"
