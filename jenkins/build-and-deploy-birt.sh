#!/bin/bash

export remote_command="/usr/bin/ssh -i /var/lib/jenkins/.ssh/id_rsa ubuntu@birt.eha.io "

#Make sure repo is up to date
$remote_command "cd /opt/infrastructure && git pull" &&\

#Build the new image
$remote_command "sudo docker build --no-cache -t birt /opt/infrastructure/docker/images/birt" &&\

#Instantiate the new image
$remote_command "sudo docker-compose -f /opt/infrastructure/docker/containers/birt.yml up -d birt" &&\

#Upload new docker image to S3
$remote_command "
  sudo rm /tmp/birt.tar.gz
  sudo docker save birt > /tmp/birt.tar &&\
  sudo gzip -1 /tmp/birt.tar &&\
  sudo aws s3 cp /tmp/birt.tar.gz s3://bsve-integration/birt.tar.gz
  sudo rm /tmp/birt.tar.gz
"

#Notify BSVE of new birt image
aws sns publish --topic-arn arn:aws:sns:us-east-1:789867670404:EHA-Git-Lambda --message '{"app":"birt"}' --profile bsve-user
