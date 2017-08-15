#!/bin/bash
#This is a jenkins script

cd /opt/infrastructure/docker/images/era/era && /usr/bin/sudo git pull origin master &&\
/usr/bin/sudo docker build -t era /opt/infrastructure/docker/images/era &&\
/usr/bin/sudo docker save era /tmp/era.tar &&\
aws s3 cp /tmp/era.tar s3://eha-docker-repo/era.tar &&\
rm /tmp/era.tar

