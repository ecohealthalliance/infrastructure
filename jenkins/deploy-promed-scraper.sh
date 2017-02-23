#!/bin/bash
#Note: This script is intended for jenkins.
#Please run this from the top level of the infrastructure repo

#Remove any old version of image
rm /tmp/promed-scraper.tar*

#Dump the freshly built images into a tarball
/usr/bin/docker save promed-scraper > /tmp/promed-scraper.tar &&\
/bin/echo "Docker images exported" &&\
/bin/gzip -1 /tmp/promed-scraper.tar &&\
/bin/echo "Exported images now compressed"

#Store the image in an s3 bucket for the BSVE deployment scripts
aws s3 cp /tmp/promed-scraper.tar.gz s3://bsve-integration/promed-scraper.tar.gz &&\
/bin/echo "Images uploaded"

if [ "$NOTIFY_BSVE" = true ]; then
  /bin/echo "Notify the BSVE to redeploy"
  aws sns publish --topic-arn arn:aws:sns:us-east-1:789867670404:EHA-Git-Lambda --message '{"app":"promed-scraper"}' --profile bsve-user
fi

#Useful alias/function
export ssh_command="/usr/bin/ssh -i /var/lib/jenkins/.ssh/id_rsa  ubuntu@spa.eha.io "
function scp_file { /usr/bin/scp -i /var/lib/jenkins/.ssh/id_rsa $1 ubuntu@spa.eha.io:/tmp/; }

#Import images on demo box
scp_file /tmp/promed-scraper.tar.gz &&\
$ssh_command /bin/gzip -d /tmp/promed-scraper.tar.gz &&\
$ssh_command "/usr/bin/sudo /usr/bin/docker load < /tmp/promed-scraper.tar" &&\
/bin/echo "Images now imported on remote"

#Clean up old data
/bin/rm /tmp/promed-scraper.tar.gz &&\
$ssh_command /bin/rm /tmp/promed-scraper.tar

#Setup AWS credentials in shared directory
scp_file /var/lib/jenkins/.aws/credentials &&\
$ssh_command "sudo /bin/mkdir -p /shared/.aws" &&\
$ssh_command "sudo /bin/mv /tmp/credentials /shared/.aws"

# Reprovision containers
scp_file docker/containers/promed-scraper.yml &&\
$ssh_command "sudo docker-compose -f /tmp/promed-scraper.yml up -d"
