#!/bin/bash
#Note: This script is intended for jenkins.

export remote_command="ssh -ti /var/lib/jenkins/.ssh/id_rsa ubuntu@eidr-connect-bsve.eha.io"

$remote_command "cd /opt/eidr-connect; git checkout master; git pull" &&\
$remote_command "sudo docker build --no-cache -t eidr-connect /opt/eidr-connect" &&\
$remote_command "rm /tmp/eidr-connect.tar*" &&\
$remote_command "sudo docker save eidr-connect > /tmp/eidr-connect.tar" &&\
$remote_command "cd /tmp; sudo gzip -1 /tmp/eidr-connect.tar" &&\

/bin/echo "Save image to S3"
$remote_command "sudo aws s3 cp /tmp/eidr-connect.tar.gz s3://bsve-integration/eidr-connect.tar.gz" &&\

if [ "$NOTIFY_BSVE" = true ]; then
  # Notify BSVE to redeploy
  aws sns publish --topic-arn arn:aws:sns:us-east-1:789867670404:EHA-Git-Lambda --message '{"app":"eidr-connect"}' --profile bsve-user
fi

#Reprovision containers
#Forcefully remove previous running container
$remote_command "sudo docker rm -f eidr-connect-bsve.eha.io || true" &&\

#Instantiate the new image
$remote_command "sudo docker-compose -f /opt/eidr-connect/eidr-connect-bsve.yml up -d eidr-connect-bsve.eha.io"
