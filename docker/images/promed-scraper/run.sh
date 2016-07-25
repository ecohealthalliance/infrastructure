#!/bin/bash
env > /docker.env
# link to aws config
ln -s ~/shared/.aws /root
/usr/sbin/cron -f
