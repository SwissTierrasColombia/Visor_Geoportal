#!/bin/bash

# rationale: wait for database and execute population scripts for database
exec_scripts_db(){

# wait for postgres to come up
printf "Waiting for postgres (localhost-only)."
until `nc -z 127.0.0.1 5432`; do
    printf "."
    sleep 1
done
printf "\npostgres ready\n"

# Set a default database name
if [ -z "$POSTGRES_DBNAME" ]; then
  POSTGRES_DBNAME=gis
fi

# rationale: Wait for database become available
printf "Wait a moment while creating the database $POSTGRES_DBNAME."
while ! su - postgres -c "psql -d $POSTGRES_DBNAME -l &> /dev/null"
do
  printf "."
  sleep 2
done
printf "\ndone creation\n"

#su - postgres -c "psql -f /sql/creation_scripts.sql -d $POSTGRES_DBNAME"
#su - postgres -c "psql -f /sql/newScript.sql -d $POSTGRES_DBNAME"

}

# rationale: jobs, fb and bg cannot be used in no full interactive shell
# link: https://askubuntu.com/questions/192798/reading-the-output-from-any-process-using-its-pid
echo "Execute script."
exec_scripts_db &
#PID=$!
#reptyr -T $PID

# rationale: execute original CMD entry
# link: https://github.com/kartoza/docker-postgis/blob/develop/start-postgis.sh
/start-postgis.sh
