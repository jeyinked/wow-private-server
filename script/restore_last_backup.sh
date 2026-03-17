#!/bin/bash
set -euo pipefail

BACKUP_DIR="$HOME/azerothcore_backups"
COMPOSE_DIR="$HOME/docker/azerothcore-wotlk"
DB_USER="root"
DB_PASS="password"
DB_SERVICE_NAME="ac-database"

echo "🔁 Script de recovery AzerothCore"
echo "   Dossier des backups : $BACKUP_DIR"
echo

# Vérifie la présence des backups
for DB in acore_auth acore_characters acore_world; do
  if ! ls "$BACKUP_DIR/${DB}_"*.sql >/dev/null 2>&1; then
    echo "❌ Aucun backup trouvé pour la base '$DB' dans $BACKUP_DIR/"
    exit 1
  fi
done

# Récupère les derniers fichiers (les plus récents) pour chaque base
AUTH_BACKUP=$(ls -1t "$BACKUP_DIR/acore_auth_"*.sql | head -n1)
CHAR_BACKUP=$(ls -1t "$BACKUP_DIR/acore_characters_"*.sql | head -n1)
WORLD_BACKUP=$(ls -1t "$BACKUP_DIR/acore_world_"*.sql | head -n1)

echo "📦 Derniers backups trouvés :"
echo "  - acore_auth       => $AUTH_BACKUP"
echo "  - acore_characters => $CHAR_BACKUP"
echo "  - acore_world      => $WORLD_BACKUP"
echo
echo "⚠️ ATTENTION :"
echo "  - La base Docker va être RÉINITIALISÉE (docker compose down -v)"
echo "  - Toutes les données actuelles seront remplacées par ces backups."
echo

read -rp "➡️ Continuer ? (y/N) : " ANSWER
ANSWER=${ANSWER:-N}

if [[ "$ANSWER" != "y" && "$ANSWER" != "Y" ]]; then
  echo "❎ Annulé."
  exit 0
fi
                 
