#!/bin/bash

export remote_command="/usr/bin/ssh -i /keys/infrastructure.pem  ubuntu@grits.eha.io "

#Make sure repo is up to date
$remote_command "cd /opt/infrastructure && git pull"

#Build the new image
$remote_command "sudo docker build --no-cache -t grits /opt/infrastructure/docker/images/grits"

#Instantiate the new image
$remote_command "sudo docker-compose -f /opt/infrastructure/docker/containers/grits.yml up -d"

#Make sure grits has classifiers and disease lables
$remote_command "sudo docker cp /home/ubuntu/source-vars.sh.backup grits:/source-vars.sh"
$remote_command "sudo docker exec grits bash -c 'source /source-vars.sh && /scripts/update-settings.sh && /scripts/classifiers.sh && /scripts/disease-label-autocomplete.sh'"

#Restart grits
$remote_command "sudo docker kill grits && sudo docker start grits"
sleep 10
$remote_command "sudo docker exec grits supervisorctl start all"
