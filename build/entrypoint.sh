#!/bin/bash

echo "Starting cron"
crond -b -S -c $CRONDIR

while :
do
    echo "Starting nginx in foreground"
    nginx # No need for -g "daemon off;" anymore, it's now in nginx.conf
    echo "nginx exited. Restarting in 5 seconds."
    sleep 5
done