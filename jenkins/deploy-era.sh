#!/bin/bash
#Note: This script is intended for jenkins.
#Please run this from the top level of the infrastructure repo

#Useful alias/function
export ssh_command="/usr/bin/ssh -i /var/lib/jenkins/.ssh/id_rsa  ubuntu@era.eha.io "
function scp_file { /usr/bin/scp -i /var/lib/jenkins/.ssh/id_rsa $1 ubuntu@era.eha.io:/tmp/; }

#Reprovision flirt container
scp_file /opt/infrastructure/docker/containers/era.yml &&\
$ssh_command "sudo docker-compose -f /tmp/era.yml up -d"

