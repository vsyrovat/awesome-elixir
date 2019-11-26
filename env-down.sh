#!/usr/bin/env bash

export UID=${UID}
export GID=`id -g`
docker-compose down --remove-orphans
