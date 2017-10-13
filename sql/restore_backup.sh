#!/bin/bash

# rationale: wait for database and execute population scripts for database
exec_scripts_db(){

# wait for postgres to come up
echo "Waiting for postgres (localhost-only)."
until `nc -z 127.0.0.1 5432`; do
    sleep 1
done
echo "postgres ready"

# Set a default database name
if [ -z "$POSTGRES_DBNAME" ]; then
  POSTGRES_DBNAME=gis
fi

# rationale: Wait for database become available
printf "Wait a moment while creating the database $POSTGRES_DBNAME."
until su - postgres -c "psql -d $POSTGRES_DBNAME -l &> /dev/null" &> /dev/null
do
  sleep 2
done
echo "done creation"

# Set a default database name
if [ -z "$POSTGRES_SCRIPTS" ]; then
  POSTGRES_SCRIPTS=""
fi

for POSTGRES_SCRIPT in $POSTGRES_SCRIPTS; do
	echo "Execute $script"
	su - postgres -c "psql -f $POSTGRES_SCRIPT -d $POSTGRES_DBNAME"
	echo "done $script"
done
echo "done exec_scripts_db..."

}

# rationale: jobs, fb and bg cannot be used in no full interactive shell
# link: https://askubuntu.com/questions/192798/reading-the-output-from-any-process-using-its-pid
echo "Execute script."
exec_scripts_db &
#PID=$!
#reptyr -T $PID

# rationale: execute original CMD entry
# link: https://github.com/kartoza/docker-postgis/blob/develop/start-postgis.sh
echo "Starting postgres!"
/start-postgis.sh
