#!/bin/bash

#Dump the freshly built image into a tarball
docker save grits-net-meteor > /tmp/grits-net-meteor.tar
echo "Docker image exported"
gzip -9 /tmp/grits-net-meteor.tar 
"Exported image now compressed"

#Import image on demo box
scp -i /keys/infrastructure.pem /tmp/grits-net-meteor.tar.gz  ubuntu@52.23.65.236:/tmp/
ssh -i /keys/infrastructure.pem  ubuntu@52.23.65.236 gzip -d /tmp/grits-net-meteor.tar.gz
ssh -i /keys/infrastructure.pem  ubuntu@52.23.65.236 "sudo docker load < /tmp/grits-net-meteor.tar"
"Image now imported on demo box"

#Clean up old data
rm /tmp/grits-net-meteor.tar.gz
ssh -i /keys/infrastructure.pem  ubuntu@52.23.65.236 rm /tmp/grits-net-meteor.tar
