#!/bin/bash

export remote_command="/usr/bin/ssh -i /keys/infrastructure.pem  ubuntu@grits.eha.io "

#Make sure repo is up to date
$remote_command "cd /opt/infrastructure && git pull"

#Build the new image
$remote_command "sudo docker build --no-cache -t grits /opt/infrastructure/docker/images/grits"

#Instantiate the new image
$remote_command "sudo docker-compose -f /opt/infrastructure/docker/containers/grits.yml up -d"
