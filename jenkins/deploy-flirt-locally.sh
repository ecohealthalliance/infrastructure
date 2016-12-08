#!/bin/bash
#Note: This script is intended for jenkins.
#Please run this from the top level of the infrastructure repo

#Dump the freshly built image into a tarball
/usr/bin/docker save flirt > /tmp/flirt.tar
/bin/echo "Docker image exported"
/bin/gzip -1 /tmp/flirt.tar 
/bin/echo "Exported image now compressed"


#Import image on demo box
/bin/gzip -d /tmp/flirt.tar.gz
/usr/bin/sudo /usr/bin/docker load < /tmp/flirt.tar
/bin/echo "Image now imported on demo box"

#Clean up old data
/bin/rm /tmp/flirt.tar.gz
/bin/rm /tmp/flirt.tar

#Reprovision flirt container
# scp_file /opt/infrastructure/docker/containers/flirt.yml
sudo docker-compose -f /tmp/flirt.yml up -d