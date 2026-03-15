#!/usr/bin/env bash
# Usage: ./update_realm_docker.sh
# Si ton conteneur ne s'appelle pas "mysql", change la variable CONTAINER.

# --- Connexion MySQL ---
USER="root"
PASS="password"
DB="acore_auth"
CONTAINER="ac-database"   # nom du conteneur (docker ps -> colonne NAMES)

# --- Variables de ton royaume ---
REALMID=1
NAME="name_server"
IP_pub="public_ip"
IP_priv="private_ip"
MASK="255.255.255.0"
PORT=40001
ICON=1
FLAG=0
TIMEZONE=1
ALLOWED=0
BUILD=12340

# --- Exécution SQL dans le conteneur ---
docker exec -i "$CONTAINER" mysql -u"$USER" -p"$PASS" "$DB" <<SQL
DELETE FROM realmlist WHERE id = $REALMID;

INSERT INTO realmlist
  (id, name, address, localAddress, localSubnetMask, port, icon, flag, timezone, allowedSecurityLevel, gamebuild)
  VALUES
    ($REALMID, '$NAME', '$IP_pub', '$IP_priv', '$MASK', $PORT, $ICON, $FLAG, $TIMEZONE, $ALLOWED, $BUILD);
    SQL

    echo "✅ Royaume mis à jour avec IP pub $IP_pub, IP priv $IP_priv et nom \"$NAME\" (realmID=$REALMID) dans le conteneur '$CONTAINER'."

