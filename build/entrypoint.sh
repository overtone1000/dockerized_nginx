#!/bin/bash

set -e

echo "Allowing processes to start"
sleep 5

#echo "0 * * * * root wget --quiet --tries=1 --spider -o /dev/null $HEALTHCHECK_URL" > /etc/cron.d/health
#echo "0 0,12 * * * root /opt/certbot/bin/python -c 'import random; import time; time.sleep(random.random() * 3600)' && sudo certbot renew -q" | sudo tee -a /etc/cron.d/certbot > /dev/null

echo "Starting cron"
crond -b -S -c $CRONDIR

#echo "Starting php$PHP_VERSION-fpm in background"
#rc-service php$PHP_VERSION-fpm start
#rc-status

echo "nginx test"
nginx -t

echo "Starting nginx in foreground"
nginx -g "daemon off;"

function success()
{
echo "Configuration successful."
}
trap success EXIT
