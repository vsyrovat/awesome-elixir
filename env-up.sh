#!/usr/bin/env bash

mkdir -p var/pgdata
export UID=$UID
export GID=`id -g`
docker-compose up -d
