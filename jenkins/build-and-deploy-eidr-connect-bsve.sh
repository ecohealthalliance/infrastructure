#!/bin/bash
#Note: This script is intended for jenkins.

export remote_command="ssh -ti /var/lib/jenkins/.ssh/id_rsa ubuntu@eidr-connect-bsve.eha.io"

cd /opt/eidr-connect; git checkout master; git pull &&\
docker build --no-cache -t eidr-connect /opt/eidr-connect &&\
rm /tmp/eidr-connect.tar*
docker save eidr-connect > /tmp/eidr-connect.tar &&\
gzip -1 /tmp/eidr-connect.tar &&\

#Upload to S3
aws s3 cp /tmp/eidr-connect.tar.gz s3://bsve-integration/eidr-connect.tar.gz &&\
/tmp/eidr-connect.tar*

if [ "$NOTIFY_BSVE" = true ]; then
  # Notify BSVE to redeploy
  aws sns publish --topic-arn arn:aws:sns:us-east-1:789867670404:EHA-Git-Lambda --message '{"app":"eidr-connect"}' --profile bsve-user
fi

#Load image onto server
$remote_command "aws s3 cp s3://bsve-integration/eidr-connect.tar.gz /tmp/eidr-connect.tar.gz" &&\
$remote_command "gzip -d /tmp/eidr-connect.tar.gz" &&\
$remote_command "sudo docker load < /tmp/eidr-connect.tar" &&\
$remote_command "rm /tmp/eidr-connect.tar" &&\

#Instantiate the new image
$remote_command "cd /opt/eidr-connect && git pull" &&\
$remote_command "sudo docker-compose -f /opt/eidr-connect/eidr-connect-bsve.yml up -d eidr-connect-bsve.eha.io"
