#!/bin/bash

#Dump the freshly built image into a tarball
/bin/rm /tmp/flirt.tar.gz
/usr/bin/docker save flirt > /tmp/flirt.tar
/bin/echo "Docker image exported"
/bin/gzip -1 /tmp/flirt.tar 
/bin/echo "Exported image now compressed"

#Import image on demo box
/usr/bin/scp -i /keys/infrastructure.pem /tmp/flirt.tar.gz  ubuntu@52.23.65.236:/tmp/
/usr/bin/ssh -i /keys/infrastructure.pem  ubuntu@52.23.65.236 /bin/gzip -d /tmp/flirt.tar.gz
/usr/bin/ssh -i /keys/infrastructure.pem  ubuntu@52.23.65.236 "/usr/bin/sudo /usr/bin/docker load < /tmp/flirt.tar"
/bin/echo "Image now imported on demo box"

#Clean up old data
/bin/rm /tmp/flirt.tar.gz
/usr/bin/ssh -i /keys/infrastructure.pem ubuntu@52.23.65.236 /bin/rm /tmp/flirt.tar
