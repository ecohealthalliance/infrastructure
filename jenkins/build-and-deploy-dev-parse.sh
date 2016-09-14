#!/bin/bash
#Note: This script is intended for jenkins.

export remote_command="ssh -ti /keys/infrastructure.pem ubuntu@dev-survey.eha.io"

#Make sure repo is up to date
$remote_command "cd /opt/infrastructure && git pull"

#Build the new image
$remote_command "sudo docker build --no-cache -t parse-server /opt/infrastructure/docker/images/parse-server"

#Instantiate the new image
$remote_command "sudo docker-compose -f /opt/infrastructure/docker/containers/parse-server.yml up -d"


