#!/bin/bash

export remote_command="/usr/bin/ssh -i /keys/infrastructure.pem  ubuntu@birt.eha.io "

#Make sure repo is up to date
$remote_command "cd /opt/infrastructure && git pull"

#Build the new image
$remote_command "sudo docker build --no-cache -t birt /opt/infrastructure/docker/images/birt"

#Instantiate the new image
$remote_command "sudo docker-compose -f /opt/infrastructure/docker/containers/birt.yml up -d"

