#!/bin/bash

DATE=$(date +"%Y-%m-%d_%H-%M")
BACKUP_DIR="$HOME/azerothcore_backups"
DB_USER=root
DB_PASS=password   # change si ton mot de passe root est différent

# Cherche le conteneur MySQL par son nom
CONTAINER=$(docker ps --filter "name=ac-database" --format '{{.Names}}' | head -n1)

if [ -z "$CONTAINER" ]; then
  echo "❌ Erreur : conteneur 'ac-database' introuvable."
  exit 1
fi

mkdir -p "$BACKUP_DIR"

echo "🔄 Sauvegarde de la base AzerothCore ($DATE)..."
echo "   Conteneur utilisé : $CONTAINER"

# Liste des bases à sauvegarder
DBS="acore_auth acore_characters acore_world"

# Dump des bases
for DB in $DBS; do
  echo "💾 Dump de la base $DB..."
  docker exec -i "$CONTAINER" mysqldump \
    --single-transaction --quick --lock-tables=false \
    -u"$DB_USER" -p"$DB_PASS" "$DB" \
    > "$BACKUP_DIR/${DB}_${DATE}.sql"
done

echo "🧹 Nettoyage des anciennes sauvegardes (on garde seulement les 2 plus récentes par base)..."

for DB in $DBS; do
  # Liste les fichiers du plus récent au plus vieux, et supprime à partir du 3e
  ls -1t "$BACKUP_DIR/${DB}_"*.sql 2>/dev/null | tail -n +3 | xargs -r rm --
done

echo "✅ Sauvegarde terminée ! Fichiers enregistrés dans $BACKUP_DIR/"


