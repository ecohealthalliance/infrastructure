#!/bin/bash
#Note: This script is intended for jenkins.
#Please run this from the top level of the infrastructure repo

#Dump the freshly built image into a tarball
/usr/bin/docker save birt > /tmp/birt.tar
/bin/echo "Docker image exported"
/bin/gzip -1 /tmp/birt.tar 
/bin/echo "Exported image now compressed"

#Useful alias/function
export ssh_command="/usr/bin/ssh -i /keys/infrastructure.pem  ubuntu@birt.eha.io "
function scp_file { /usr/bin/scp -i /keys/infrastructure.pem $1 ubuntu@birt.eha.io:/tmp/; }

#Import image on demo box
scp_file /tmp/birt.tar.gz
$ssh_command /bin/gzip -d /tmp/birt.tar.gz
$ssh_command "/usr/bin/sudo /usr/bin/docker load < /tmp/birt.tar"
/bin/echo "Image now imported on demo box"

#Clean up old data
/bin/rm /tmp/birt.tar.gz
$ssh_command /bin/rm /tmp/birt.tar

#Reprovision birt container
scp_file docker/containers/birt.yml
$ssh_command "sudo docker-compose -f /tmp/birt.yml up -d"

