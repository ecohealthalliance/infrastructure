#!/bin/bash
#Note: This script is intended for jenkins.
#Please run this from the top level of the infrastructure repo

#Dump the freshly built image into a tarball
/usr/bin/docker save flirt > /tmp/flirt.tar
/bin/echo "Docker image exported"
/bin/gzip -1 /tmp/flirt.tar 
/bin/echo "Exported image now compressed"

#Useful alias/function
export ssh_command="/usr/bin/ssh -i /keys/infrastructure.pem  ubuntu@52.23.65.236 "
function scp_file { /usr/bin/scp -i /keys/infrastructure.pem $1 ubuntu@52.23.65.236:/tmp/; }

#Import image on demo box
scp_file /tmp/flirt.tar.gz
$ssh_command /bin/gzip -d /tmp/flirt.tar.gz
$ssh_command "/usr/bin/sudo /usr/bin/docker load < /tmp/flirt.tar"
/bin/echo "Image now imported on demo box"

#Clean up old data
/bin/rm /tmp/flirt.tar.gz
$ssh_command /bin/rm /tmp/flirt.tar

#Reprovision flirt container
scp_file /opt/infrastructure/docker/containers/flirt.yml
$ssh_command "sudo docker-compose -f /tmp/flirt.yml up -d"

#Upload new docker image to S3
$ssh_command "
  sudo rm /tmp/flirt.tar.gz
  sudo docker save flirt > /tmp/flirt.tar &&\
  sudo gzip -1 /tmp/flirt.tar &&\
  sudo aws s3 cp /tmp/flirt.tar.gz s3://bsve-integration/flirt.tar.gz
  sudo rm /tmp/flirt.tar.gz
"
