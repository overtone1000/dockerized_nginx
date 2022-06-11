#!/bin/bash

echo "Executing webhook $CERTBOT_WEBHOOK_PRE"
wget --quiet --tries=1 --spider -o /dev/null "$CERTBOT_WEBHOOK_PRE" || exit 1
exit 0