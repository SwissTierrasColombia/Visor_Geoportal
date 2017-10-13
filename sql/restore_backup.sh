#!/bin/bash
# link: https://github.com/kartoza/docker-postgis/blob/develop/start-postgis.sh
/bin/bash /start-postgis.sh &

PID=$!

# wait for postgres to come up
until `nc -z 127.0.0.1 5432`; do
    echo "$(date) - waiting for postgres (localhost-only)..."
    sleep 1
done
echo "postgres ready"

echo "$POSTGRES_DBNAME"
# Set a default database name
if [ -z "$POSTGRES_DBNAME" ]; then
  POSTGRES_DBNAME=gis
fi

# rationale: Wait for database become available
while ! su - postgres -c "psql -d $POSTGRES_DBNAME -l" &> /dev/null
do
  echo "Wait a moment while loading the database."
  sleep 2
done
echo "done creation"

su - postgres -c "psql -f /sql/creation_scripts.sql -d $POSTGRES_DBNAME"
su - postgres -c "psql -f /sql/newScript.sql -d $POSTGRES_DBNAME"
