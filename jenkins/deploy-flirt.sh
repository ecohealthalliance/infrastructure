#!/bin/bash

#Dump the freshly built image into a tarball
/bin/rm /tmp/grits-net-meteor.tar.gz
/usr/bin/docker save grits-net-meteor > /tmp/grits-net-meteor.tar
/bin/echo "Docker image exported"
/bin/gzip -9 /tmp/grits-net-meteor.tar 
/bin/echo "Exported image now compressed"

#Import image on demo box
/usr/bin/scp -i /keys/infrastructure.pem /tmp/grits-net-meteor.tar.gz  ubuntu@52.23.65.236:/tmp/
/usr/bin/ssh -i /keys/infrastructure.pem  ubuntu@52.23.65.236 /bin/gzip -d /tmp/grits-net-meteor.tar.gz
/usr/bin/ssh -i /keys/infrastructure.pem  ubuntu@52.23.65.236 "/usr/bin/sudo /usr/bin/docker load < /tmp/grits-net-meteor.tar"
/bin/echo "Image now imported on demo box"

#Clean up old data
/bin/rm /tmp/grits-net-meteor.tar.gz
/usr/bin/ssh -i /keys/infrastructure.pem ubuntu@52.23.65.236 /bin/rm /tmp/grits-net-meteor.tar
