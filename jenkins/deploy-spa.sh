#!/bin/bash
#Note: This script is intended for jenkins.
#Please run this from the top level of the infrastructure repo

#Dump the freshly built images into a tarball
/usr/bin/docker save spa > /tmp/spa.tar &&\
/usr/bin/docker save promed-scraper > /tmp/promed-scraper.tar &&\
/bin/echo "Docker images exported" &&\
/bin/gzip -1 /tmp/spa.tar &&\
/bin/gzip -1 /tmp/promed-scraper.tar &&\
/bin/echo "Exported images now compressed"

#Store the image in an s3 bucket for the BSVE deployment scripts
aws s3 cp /tmp/spa.tar.gz s3://bsve-integration/spa.tar.gz &&\
aws s3 cp /tmp/promed-scraper.tar.gz s3://bsve-integration/promed-scraper.tar.gz &&\
/bin/echo "Images uploaded"

#Useful alias/function
export ssh_command="/usr/bin/ssh -i /keys/infrastructure.pem  ubuntu@spa.eha.io "
function scp_file { /usr/bin/scp -i /keys/infrastructure.pem $1 ubuntu@spa.eha.io:/tmp/; }

#Import images on demo box
scp_file /tmp/spa.tar.gz &&\
scp_file /tmp/promed-scraper.tar.gz &&\
$ssh_command /bin/gzip -d /tmp/spa.tar.gz &&\
$ssh_command /bin/gzip -d /tmp/promed-scraper.tar.gz &&\
$ssh_command "/usr/bin/sudo /usr/bin/docker load < /tmp/spa.tar" &&\
$ssh_command "/usr/bin/sudo /usr/bin/docker load < /tmp/promed-scraper.tar" &&\
/bin/echo "Images now imported on remote"

#Clean up old data
/bin/rm /tmp/spa.tar.gz &&\
/bin/rm /tmp/promed-scraper.tar.gz &&\
$ssh_command /bin/rm /tmp/spa.tar &&\
$ssh_command /bin/rm /tmp/promed-scraper.tar

#Setup AWS credentials in shared directory
scp_file /var/lib/jenkins/.aws/credentials &&\
$ssh_command "sudo /bin/mkdir -p /shared/.aws" &&\
$ssh_command "sudo /bin/mv /tmp/credentials /shared/.aws"

#Reprovision containers
scp_file docker/containers/spa.yml &&\
$ssh_command "sudo docker-compose -f /tmp/spa.yml up -d"
