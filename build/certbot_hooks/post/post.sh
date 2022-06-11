#!/bin/bash

echo "Executing webhook $CERTBOT_WEBHOOK_POST"
wget --quiet --tries=1 --spider -o /dev/null "$CERTBOT_WEBHOOK_POST" || exit 1
exit 0