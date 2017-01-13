#!/bin/bash
#Note: This script is intended for jenkins.

export remote_command="ssh -ti /keys/infrastructure.pem ubuntu@eidr-connect-bsve.eha.io"
function scp_file { /usr/bin/scp -i /keys/infrastructure.pem $1 ubuntu@eidr-connect-bsve.eha.io:/tmp/; }

git clone https://github.com/ecohealthalliance/eidr-connect.git
cd eidr-connect

git checkout master && git pull
sudo docker build --no-cache -t eidr-connect /opt/eidr-connect

sudo docker save eidr-connect > /tmp/eidr-connect.tar
sudo gzip -1 /tmp/eidr-connect.tar

/bin/echo "Save image to S3"
sudo aws s3 cp /tmp/eidr-connect.tar.gz s3://bsve-integration/eidr-connect.tar.gz

# Notify BSVE to redeploy
aws sns publish --topic-arn arn:aws:sns:us-east-1:789867670404:EHA-Git-Lambda --message '{"app":"eidr-connect"}' --profile bsve-user

scp_file /tmp/eidr-connect.tar.gz &&\
$ssh_command /bin/gzip -d /tmp/eidr-connect.tar.gz &&\
$ssh_command "/usr/bin/sudo /usr/bin/docker load < /tmp/eidr-connect.tar" &&\
/bin/echo "Images now imported on remote"

#Reprovision containers
scp_file /opt/eidr-connect/eidr-connect-bsve.yml
#Forcefully remove previous running container
$remote_command "sudo docker rm -f eidr-connect-bsve.eha.io || true"
#Instantiate the new image
$remote_command "sudo docker-compose -f eidr-connect-bsve.yml up -d eidr-connect-bsve.eha.io"

sudo rm /tmp/eidr-connect.tar.gz