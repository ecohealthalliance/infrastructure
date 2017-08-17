#!/bin/bash
#Note: This script is intended for jenkins.

export remote_command="ssh -ti /var/lib/jenkins/.ssh/id_rsa ubuntu@eidr-connect.eha.io"

#Make sure repo is up to date
cd /opt/eidr-connect &&\
git checkout release &&\
git pull &&\
git rev-parse HEAD > revision.txt &&\

#Build the new image
docker build --no-cache -t eidr-connect /opt/eidr-connect &&\

#Instantiate the new image
$remote_command "cd /opt/eidr-connect && git pull" &&\
$remote_command "sudo docker-compose -f /opt/eidr-connect/eidr-connect.yml up -d"


