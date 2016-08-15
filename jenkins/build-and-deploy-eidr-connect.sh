#!/bin/bash

alias remote_command="ssh -ti /keys/infrastructure.pem ubuntu@eidr-connect.eha.io"

#Make sure repo is up to date
remote_command "cd /opt/eidr-connect && git pull"

#Build the new image
remote_command "sudo docker build -t eidr-connect /opt/eidr-connect"

#Instantiate the new image
remote_command "sudo docker-compose -f /opt/eidr-connect/eidr-connect.yml up -d"


