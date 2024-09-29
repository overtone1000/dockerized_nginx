#!/bin/bash

echo "Starting cron"
crond -b -S -c $CRONDIR

while :
do
    echo "Starting nginx in foreground"
    RESULT=$(nginx -g "daemon off;")
    echo "nginx exited with result $RESULT. Restarting in 5 seconds."
    sleep 5
done