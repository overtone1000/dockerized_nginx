#!/bin/bash

set -e

echo "Starting cron"
crond -b -S -c $CRONDIR

echo "Starting nginx in foreground"
nginx -g "daemon off;"