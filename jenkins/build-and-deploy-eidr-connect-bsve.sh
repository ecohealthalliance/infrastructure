#!/bin/bash
#Note: This script is intended for jenkins.

export remote_command="ssh -ti /keys/infrastructure.pem ubuntu@eidr-connect-bsve.eha.io"

#Make sure repo is up to date
$remote_command "cd /opt/eidr-connect && git checkout master && git pull"

#Build the new image
$remote_command "sudo docker build --no-cache -t eidr-connect /opt/eidr-connect"

#Forcefully remove previous running container
$remote_command "sudo docker rm -f eidr-connect.eha.io"

#Instantiate the new image
$remote_command "sudo docker-compose -f /opt/eidr-connect/eidr-connect.yml up -d eidr-connect.eha.io"


