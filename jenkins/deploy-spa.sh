#!/bin/bash
#Note: This script is intended for jenkins.
#Please run this from the top level of the infrastructure repo

rm -fr /tmp/spa.tar*

#Dump the freshly built images into a tarball
/usr/bin/docker save spa > /tmp/spa.tar &&\
/bin/echo "Docker images exported" &&\
/bin/gzip -1 /tmp/spa.tar &&\
/bin/echo "Exported images now compressed"

#Store the image in a s3 buckets for the deployment scripts
aws s3 cp /tmp/spa.tar.gz s3://bsve-integration/spa.tar.gz &&\
aws s3 cp /tmp/spa.tar.gz s3://eha-docker-repo/spa.tar.gz &&\
/bin/echo "Images uploaded"

/bin/echo "Notify BSVE to redeploy"
aws sns publish --topic-arn arn:aws:sns:us-east-1:789867670404:EHA-Git-Lambda --message '{"app":"spa"}' --profile bsve-user

#Useful alias/function
export ssh_command="/usr/bin/ssh -i /var/lib/jenkins/.ssh/id_rsa  ubuntu@spa.eha.io "
function scp_file { /usr/bin/scp -i /var/lib/jenkins/.ssh/id_rsa $1 ubuntu@spa.eha.io:/tmp/; }

#Import images on demo box
$ssh_command rm -fr /tmp/spa.tar* &&\
scp_file /tmp/spa.tar.gz &&\
$ssh_command /bin/gzip -d /tmp/spa.tar.gz &&\
$ssh_command "/usr/bin/sudo /usr/bin/docker load < /tmp/spa.tar" &&\
/bin/echo "Images now imported on remote"

#Clean up old data
/bin/rm /tmp/spa.tar.gz &&\
$ssh_command /bin/rm /tmp/spa.tar &&\

#Setup AWS credentials in shared directory
scp_file /var/lib/jenkins/.aws/credentials &&\
$ssh_command "sudo /bin/mkdir -p /shared/.aws" &&\
$ssh_command "sudo /bin/mv /tmp/credentials /shared/.aws"

#Reprovision containers
scp_file /opt/infrastructure/docker/containers/spa.yml &&\
$ssh_command "sudo docker-compose -f /tmp/spa.yml up -d"
