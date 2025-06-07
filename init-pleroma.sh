#!/bin/sh

PUID=${PUID:-1000}
PGID=${PGID:-1000}

groupmod -o -g "$PGID" pleroma
usermod -o -u "$PUID" pleroma

set -e

echo "
-------------------------------------
Pleroma Docker by ELESTIO
-------------------------------------
-------------------------------------
User:        $(whoami)    
User uid:    $(id -u pleroma)
User gid:    $(id -g pleroma)
-------------------------------------
"

if [ "$(stat -c %U:%G /app)" != "pleroma:pleroma" ]; then
    chown -R pleroma:pleroma /app
fi

if [ "$(stat -c %U:%G /data)" != "pleroma:pleroma" ]; then
    chown -R pleroma:pleroma /data
fi

if [ -z "$DB_PORT" ]; then
  echo "ERROR: DB_PORT is not set! Exiting."
  exit 1
fi

while ! pg_isready -U "${DB_USER:-pleroma}" -d "postgres://${DB_HOST:-pleroma-db}:${DB_PORT}/${DB_NAME:-pleroma}" -t 1; do
    sleep 1s
done

echo "-- Injecting prod.secret.exs config..."
mkdir -p /app/config
cp /prod.secret.exs /app/config/prod.secret.exs
chown pleroma:pleroma /app/config
chown pleroma:pleroma /app/config/prod.secret.exs

echo "-- Running migrations..."
su-exec pleroma mix ecto.migrate

echo "-- Starting server..."
su-exec pleroma mix phx.server