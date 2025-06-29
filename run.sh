#!/bin/bash

export APP_NAME="7days"

set -e
cd "$(dirname "$0")"

mkdir -p data/saves data/mods data/logs

./stop.sh

docker build -t $APP_NAME -f docker/Dockerfile .

if [ "${APP_SERVICE:-}" = "true" ]; then
    DETACHED="-d"
else
    DETACHED=""
fi

docker run --rm -it $DETACHED \
    --name $APP_NAME \
    --log-driver local \
    --log-opt max-size=200k \
    --log-opt max-file=3 \
    -v "$(pwd)/data/saves:/data/saves" \
    -v "$(pwd)/data/mods:/app/Mods" \
    -v "$(pwd)/data/logs:/data/logs" \
    -v "$(pwd)/data/serverconfig.xml:/app/serverconfig.xml" \
    -p 8080:8080/tcp \
    -p 26900:26900/udp \
    -p 26901:26901/udp \
    -p 26902:26902/udp \
    $APP_NAME \
    $@
