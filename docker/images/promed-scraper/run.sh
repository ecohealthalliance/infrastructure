#!/bin/bash
# Create cronjob to run ProMED mail ingest.
# A CRON_SPECIFIER environment variable can be provided.
# Otherwise the script will run at a randomly chosen hour each day.
RANDOM_HOUR=$(($RANDOM % 24))
DEFAULT_CRON_SPECIFIER="0 $RANDOM_HOUR * * *"
CRON_SPECIFIER="${CRON_SPECIFIER:-$DEFAULT_CRON_SPECIFIER}"
echo "$CRON_SPECIFIER bash /cronjob.sh >> /cron.log 2>&1" > /etc/cron.d/crontab
crontab /etc/cron.d/crontab
env > /docker.env
# link to aws config
ln -s /shared/.aws /root
/usr/sbin/cron -f
