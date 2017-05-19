#!/bin/bash
#Note: This script is intended for jenkins.

export remote_command="ssh -ti /var/lib/jenkins/.ssh/id_rsa ubuntu@eidr-connect.eha.io"

#Make sure repo is up to date
$remote_command "cd /opt/eidr-connect && git checkout release; git pull; git rev-parse HEAD > revision.txt" &&\

#Free up resources before the build
$remote_command "docker kill eidr-connect.eha.io" &&\
$remote_command "docker rm eidr-connect.eha.io" &&\

#Build the new image
$remote_command "sudo docker build --no-cache -t eidr-connect /opt/eidr-connect" &&\

#Forcefully remove previous running container
$remote_command "sudo docker rm -f eidr-connect.eha.io || true" &&\

#Instantiate the new image
$remote_command "sudo docker-compose -f /opt/eidr-connect/eidr-connect.yml up -d"


