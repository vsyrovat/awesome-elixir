#!/usr/bin/env bash

#
# This file created automatically by deploy script
# and will be overwriten on next deploy.
# All manual changes will be lost.
# 

set -euo pipefail

set -o allexport
. .env
set +o allexport

# Timeout after 30 sec if we still haven't gotten a response
timeout 30s bash <<EOT
# Wait until an HTTP request succeeds against staging:PORT
function ping_server(){
    while true; do
        if curl -sSf "http://127.0.0.1:${PORT}" >/dev/null; then
            echo "Internal health-check OK"
            exit 0
        fi
        sleep 1
    done
}

ping_server
EOT
