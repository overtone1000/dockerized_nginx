#!/bin/bash

set -e

# keep track of the last executed command
trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
# echo an error message before exiting
trap 'echo "\"${last_command}\" command filed with exit code $?."' EXIT

echo "Allowing processes to start"
sleep 5

#echo "0 * * * * root wget --quiet --tries=1 --spider -o /dev/null $HEALTHCHECK_URL" > /etc/cron.d/health
#echo "0 0,12 * * * root /opt/certbot/bin/python -c 'import random; import time; time.sleep(random.random() * 3600)' && sudo certbot renew -q" | sudo tee -a /etc/cron.d/certbot > /dev/null

echo "Starting cron"
service cron start

echo "Starting php$PHP_VERSION-fpm in background"
service php$PHP_VERSION-fpm start
service --status-all

echo "nginx test"
nginx -t

echo "Starting nginx in foreground"
nginx -g "daemon off;"

function success()
{
echo "Configuration successful."
}
trap success EXIT
