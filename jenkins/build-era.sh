#!/bin/bash
#This is a jenkins script

cd /opt/infrastructure/docker/images/era/era &&\
docker build -t era /opt/infrastructure/docker/images/era &&\
docker save era /tmp/era.tar &&\
zip -1 /tmp/era.tar &&\
aws s3 cp /tmp/era.tar.gz s3://eha-docker-repo/era.tar.gz &&\
rm /tmp/era.tar*

