#!/bin/bash
# NOTE: Some of these commands must stay here and not in Dockerfile
# This is because we have to perform actions on mounted external volumes


if [ -f /var/lib/mongodb/NOT-MOUNTED ] || [ -f /var/log/NOT-MOUNTED ]
then
  echo "An external volume is not mounted to /var/lib/mongodb or /var/log."
  echo "Failing because we do not want to write files inside of a container."
  exit 1
else
  (mkdir /var/lib/mongodb || true)
  chown mongodb:mongodb /var/lib/mongodb/

  (mkdir /var/log/mongodb || true)
  touch /var/log/mongodb/mongodb.log
  chown -R mongodb:mongodb /var/log/mongodb/
  /usr/bin/mongod --config /etc/mongodb.conf
fi
