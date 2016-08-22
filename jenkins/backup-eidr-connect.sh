#!/bin/bash
#Note: This script is intended for jenkins.

export remote_command="ssh -ti /keys/infrastructure.pem ubuntu@eidr-connect.eha.io"

export DATE=$(date +%Y-%m-%d)
$remote_command "sudo docker exec -t mongodb mongodump --out /var/log/dump"
$remote_command "sudo tar -czf /var/log/mongodump-$DATE.tar.gz /var/log/dump"
$remote_command "aws s3 cp /var/log/mongodump-$DATE.tar.gz s3://eidr-connect-backups"

