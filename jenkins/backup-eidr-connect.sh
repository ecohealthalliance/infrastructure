#!/bin/bash
#Note: This script is intended for jenkins.

export remote_command="ssh -ti /var/lib/jenkins/.ssh/id_rsa ubuntu@eidr-connect.eha.io"

export DATE=$(date +%Y-%m-%d)
$remote_command "mkdir /tmp/ec-dumps"
$remote_command "mongodump --port 27017 --out /tmp/ec-dumps/dump" &&\
$remote_command "sudo tar -czf /tmp/ec-dumps/mongodump-$DATE.tar.gz /tmp/ec-dumps/dump" &&\
$remote_command "aws s3 cp /tmp/ec-dumps/mongodump-$DATE.tar.gz s3://eidr-connect-backups"
