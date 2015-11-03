#!/bin/bash

if [ -f /var/lib/mongodb/NOT-MOUNTED ] || [ -f /var/log/NOT-MOUNTED ]
then
  echo "An external volume is not mounted to /var/lib/mongodb or /var/log."
  echo "Failing because we do not want to write files inside of a container."
  exit 1
else
  mkdir /var/lib/mongodb
  /usr/bin/mongod --config /etc/mongodb.conf
fi
