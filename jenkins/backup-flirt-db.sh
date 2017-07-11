#!/bin/bash
#Note: This script is intended for jenkins.

export remote_command="ssh ubuntu@flirt-reporting.eha.io"

export DATE=$(date +%Y%m%d)
$remote_command "sudo docker exec -t mongodb mongodump --db flirt --out /var/log/dump" &&\
$remote_command "sudo tar -czf /var/log/flirt_$DATE.tar.gz /var/log/dump" &&\
$remote_command "aws s3 cp /var/log/flirt_$DATE.tar.gz s3://eha-flirt/backups"

