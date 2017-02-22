#!/bin/bash
#Note: This script is intended for jenkins.
#Please run this from the top level of the infrastructure repo

#Dump the freshly built image into a tarball
/usr/bin/docker save flirt > /tmp/flirt.tar
/bin/echo "Docker image exported"
# /bin/gzip -1 /tmp/flirt.tar 
# /bin/echo "Exported image now compressed"


#Import image on demo box
/usr/bin/sudo /usr/bin/docker load < /tmp/flirt.tar
/bin/echo "Image now imported on demo box"

#Clean up old data
/bin/rm /tmp/flirt.tar

#Reprovision flirt container
# scp_file /opt/infrastructure/docker/containers/flirt.yml
/usr/bin/sudo docker-compose -f /opt/infrastructure/docker/containers/flirt.yml up -d