#!/bin/bash
#Note: This script is intended for jenkins.
#Please run this from the top level of the infrastructure repo

#Dump the freshly built image into a tarball
/usr/bin/docker save era > /tmp/era.tar
/bin/echo "Docker image exported"
/bin/gzip -1 /tmp/era.tar 
/bin/echo "Exported image now compressed"

#Useful alias/function
export ssh_command="/usr/bin/ssh -i /var/lib/jenkins/.ssh/id_rsa  ubuntu@era.eha.io "
function scp_file { /usr/bin/scp -i /var/lib/jenkins/.ssh/id_rsa $1 ubuntu@era.eha.io:/tmp/; }

#Import image on demo box
scp_file /tmp/era.tar.gz
$ssh_command /bin/gzip -d /tmp/era.tar.gz
$ssh_command "/usr/bin/sudo /usr/bin/docker load < /tmp/era.tar"
/bin/echo "Image now imported on demo box"

#Clean up old data
/bin/rm /tmp/era.tar.gz
$ssh_command /bin/rm /tmp/era.tar

#Reprovision flirt container
scp_file /opt/infrastructure/docker/containers/era.yml
$ssh_command "sudo docker-compose -f /tmp/era.yml up -d"

