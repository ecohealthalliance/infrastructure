#!/bin/bash
#Note: This script is intended for jenkins.
#Please run this from the top level of the infrastructure repo

#Useful alias/function
export ssh_command="/usr/bin/ssh -i /var/lib/jenkins/.ssh/id_rsa  ubuntu@era.eha.io "
function scp_file { /usr/bin/scp -i /var/lib/jenkins/.ssh/id_rsa $1 ubuntu@era.eha.io:/tmp/; }

#Copy image to server
$ssh_command "aws s3 cp s3://eha-docker-repo/era.tar.gz /tmp/era.tar.gz" &&\
$ssh_command "gzip -d /tmp/era.tar.gz" &&\
$ssh_command "sudo docker load < /tmp/era.tar" &&\
$ssh_command "rm /tmp/era.tar*" &&\

#Reprovision flirt container
scp_file /opt/infrastructure/docker/containers/era.yml &&\
$ssh_command "sudo docker-compose -f /tmp/era.yml up -d"

