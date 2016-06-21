#!/bin/bash
#Note: This script is intended for jenkins.
#Please run this from the top level of the infrastructure repo

#Dump the freshly built image into a tarball
/usr/bin/docker save spa > /tmp/spa.tar
/bin/echo "Docker image exported"
/bin/gzip -1 /tmp/spa.tar 
/bin/echo "Exported image now compressed"

#Useful alias/function
export ssh_command="/usr/bin/ssh -i /keys/infrastructure.pem  ubuntu@spa.eha.io "
function scp_file { /usr/bin/scp -i /keys/infrastructure.pem $1 ubuntu@spa.eha.io:/tmp/; }

#Import image on demo box
scp_file /tmp/spa.tar.gz
$ssh_command /bin/gzip -d /tmp/spa.tar.gz
$ssh_command "/usr/bin/sudo /usr/bin/docker load < /tmp/spa.tar"
/bin/echo "Image now imported on demo box"

#Clean up old data
/bin/rm /tmp/spa.tar.gz
$ssh_command /bin/rm /tmp/spa.tar

#Reprovision flirt container
scp_file docker/containers/spa.yml
$ssh_command "sudo docker-compose -f /tmp/spa.yml up -d"

