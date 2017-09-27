#!/bin/bash

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

/usr/bin/ssh -i /var/lib/jenkins/.ssh/id_rsa  ubuntu@grits.eha.io <<EOF
#Load image onto grits server
sudo docker system prune -f &&\
aws s3 cp s3://eha-docker-repo/grits.tar.gz /tmp/grits.tar.gz &&\
gzip -d /tmp/grits.tar.gz && echo 'Image decompressed' &&\
sudo docker load < /tmp/grits.tar && echo 'Image loaded' &&\
rm /tmp/grits.tar* &&\

#Load geonames api image and data
aws s3 cp s3://bsve-integration/elasticsearch-data.tar.gz /tmp/elasticsearch-data.tar.gz &&\
aws s3 cp s3://bsve-integration/geonames-api.tar.gz /tmp/geonames-api.tar.gz &&\
#Remove old elasticsearch data and ignore errors if it doesn't exist.
sudo docker stop elasticsearch ; true &&\
sudo rm -rf /mnt/elasticsearch ; true &&\
sudo tar -xvzf /tmp/elasticsearch-data.tar.gz -C / &&\
gzip -d /tmp/geonames-api.tar.gz &&\
sudo docker load < /tmp/geonames-api.tar &&\
rm /tmp/*.tar* ; true &&\

#Instantiate the new image
cd /opt/infrastructure && git pull &&\
EOF &&\

#Send super user commands to the server
/usr/bin/ssh -i /var/lib/jenkins/.ssh/id_rsa ubuntu@grits.eha.io <<EOF
sudo su
(
elasticsearch_data_path=/mnt/elasticsearch/data  \
ip_address=\$(ip -4 route get 8.8.8.8 | awk '{print \$7}')  \
docker-compose -f /opt/infrastructure/docker/containers/grits.yml up -d
) &&\

#Make sure grits has classifiers and disease lables
docker cp /home/ubuntu/source-vars.sh.backup grits:/source-vars.sh &&\
docker exec grits bash -c 'source /source-vars.sh && /scripts/update-settings.sh && /scripts/disease-label-autocomplete.sh' &&\

#Restart grits
docker kill grits && docker start grits &&\
sleep 10 &&\
docker exec grits supervisorctl start all
EOF &&\

if [ "$NOTIFY_BSVE" = true ]; then
  /bin/echo "Notify BSVE to redeploy grits"
  aws sns publish --topic-arn arn:aws:sns:us-east-1:789867670404:EHA-Git-Lambda --message '{"app":"grits"}' --profile bsve-user
fi
