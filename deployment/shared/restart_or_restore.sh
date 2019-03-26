#!/usr/bin/env bash

if [ "$KEEP_OR_WIPE" == "wipe" ]; then
    echo "Restoring database from the latest snapshot"
    cp ../../credentials/${CREDENTIALS_SUB_DIRECTORY}/.env-restore ../shared/restore/.env-restore

    docker images

    docker stop $(docker ps -a -q)
    docker rm $(docker ps -a -q)
    docker rmi $(docker images -q)

    /usr/local/bin/docker-compose down -v
    /usr/local/bin/docker-compose -f ../shared/restore/docker-compose.yml run rds-restore
    /usr/local/bin/docker-compose up --build --force-recreate -d

    rm -f ../shared/restore/.env-restore
else
    ../shared/restart.sh $1
fi
