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

#Upload image to s3 bucket
docker save eidr-connect > /tmp/eidr-connect.tar &&\
gzip -1 /tmp/eidr-connect.tar &&\
aws s3 cp /tmp/eidr-connect.tar.gz s3://eha-docker-repo/eidr-connect.tar.gz &&\
rm /tmp/eidr-connect.tar* &&\

#Load image onto server
$remote_command "aws s3 cp s3://eha-docker-repo/eidr-connect.tar.gz /tmp/eidr-connect.tar.gz" &&\
$remote_command "gzip -d /tmp/eidr-connect.tar.gz" &&\
$remote_command "echo 'y' | sudo docker system prune" &&\
$remote_command "sudo docker load < /tmp/eidr-connect.tar && rm /tmp/eidr-connect.tar*" &&\

#Instantiate the new image
$remote_command "cd /opt/eidr-connect && git pull" &&\
$remote_command "sudo docker-compose -f /opt/eidr-connect/eidr-connect.yml up -d"


