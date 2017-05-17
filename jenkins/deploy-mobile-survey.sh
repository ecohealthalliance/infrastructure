#!/bin/bash
#Note: This script is intended for jenkins.
#Please run this from the top level of the infrastructure repo

#Dump the freshly built image into a tarball
/usr/bin/docker save mobile-survey > /tmp/mobile-survey.tar &&\
/bin/echo "Docker image exported" &&\
/bin/gzip -1 /tmp/mobile-survey.tar &&\
/bin/echo "Exported image now compressed"

#Useful alias/function
export ssh_command="/usr/bin/ssh -i /var/lib/jenkins/.ssh/id_rsa  ubuntu@survey.eha.io "
function scp_file { /usr/bin/scp -i /var/lib/jenkins/.ssh/id_rsa $1 ubuntu@survey.eha.io:/tmp/; }

#Import image on demo box
scp_file /tmp/mobile-survey.tar.gz &&\
$ssh_command /bin/gzip -d /tmp/mobile-survey.tar.gz &&\
$ssh_command "/usr/bin/sudo /usr/bin/docker load < /tmp/mobile-survey.tar" &&\
/bin/echo "Image now imported on demo box"

#Clean up old data
/bin/rm /tmp/mobile-survey.tar.gz &&\
$ssh_command /bin/rm /tmp/mobile-survey.tar &&\

#Reprovision flirt container
scp_file /opt/infrastructure/docker/containers/mobile-survey.yml &&\
$ssh_command "sudo docker-compose -f /tmp/mobile-survey.yml up -d"

