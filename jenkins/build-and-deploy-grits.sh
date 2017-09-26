#!/bin/bash

export remote_command="/usr/bin/ssh -i /var/lib/jenkins/.ssh/id_rsa  ubuntu@grits.eha.io "

#Make sure repo is up to date
cd /opt/infrastructure && git pull &&\

#Build the new image
docker build --no-cache -t grits /opt/infrastructure/docker/images/grits &&\

#Upload new docker image to S3
rm /tmp/grits.tar*
docker save grits > /tmp/grits.tar &&\
gzip -1 /tmp/grits.tar &&\
aws s3 cp /tmp/grits.tar.gz s3://bsve-integration/grits.tar.gz &&\
aws s3 cp /tmp/grits.tar.gz s3://eha-docker-repo/grits.tar.gz &&\
echo "Images uploaded to s3 buckets" &&\
rm /tmp/grits.tar.gz


#Load image onto grits server
$remote_command "echo 'y'|sudo docker system prune" &&\
$remote_command "aws s3 cp s3://eha-docker-repo/grits.tar.gz /tmp/grits.tar.gz" &&\
$remote_command "gzip -d /tmp/grits.tar.gz && echo 'Image decompressed'" &&\
$remote_command "sudo docker load < /tmp/grits.tar && echo 'Image loaded'" &&\
$remote_command "rm /tmp/grits.tar*" &&\

#Load geonames api image and data
$remote_command "aws s3 cp s3://bsve-integration/elasticsearch-data.tar.gz /tmp/elasticsearch-data.tar.gz" &&\
$remote_command "aws s3 cp s3://bsve-integration/geonames-api.tar.gz /tmp/geonames-api.tar.gz" &&\
$remote_command "tar -xvzf /tmp/elasticsearch-data.tar.gz -C /" &&\
$remote_command "gzip -d /tmp/geonames-api.tar.gz" &&\
$remote_command "docker load < /tmp/geonames-api.tar" &&\
$remote_command "rm *.tar* /tmp/*.tar*" &&\

#Instantiate the new image
$remote_command "cd /opt/infrastructure && git pull" &&\
$remote_command "(
  elasticsearch_data_path=/mnt/elasticsearch/data \
  ip_address=$(ip -4 route get 8.8.8.8 | awk '{print $7}') \
  sudo docker-compose -f /opt/infrastructure/docker/containers/grits.yml up -d grits
)" &&\

#Make sure grits has classifiers and disease lables
$remote_command "sudo docker cp /home/ubuntu/source-vars.sh.backup grits:/source-vars.sh" &&\
$remote_command "sudo docker exec grits bash -c 'source /source-vars.sh && /scripts/update-settings.sh && /scripts/disease-label-autocomplete.sh'" &&\

#Restart grits
$remote_command "sudo docker kill grits && sudo docker start grits" &&\
sleep 10 &&\
$remote_command "sudo docker exec grits supervisorctl start all" &&\


if [ "$NOTIFY_BSVE" = true ]; then
  /bin/echo "Notify BSVE to redeploy grits"
  aws sns publish --topic-arn arn:aws:sns:us-east-1:789867670404:EHA-Git-Lambda --message '{"app":"grits"}' --profile bsve-user
fi
