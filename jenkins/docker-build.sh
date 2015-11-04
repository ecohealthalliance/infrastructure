#!/bin/bash
# Name: docker-build.sh
# Purpose: Script to run on jenkins to build and publish docker images
# Author: Freddie Rosario <rosario@ecohealthalliance.org>

#Argument parsing
if [[ $# > 1 ]]
then
  key="$1"
fi

case $key in
  --image-name)
    IMAGE_NAME="$2"
    ;;

  *)
    echo "Please specify hostname like so: --image-name docker-repository.tater.io/<repo name>/<image name>"
    echo
    echo
    exit 1
    ;;
esac


# Embed git revision into container
git rev-parse HEAD > revision.txt

DATE=$(date +%F) &&\
docker build -t $IMAGE_NAME:$DATE . &&\
docker tag -f $IMAGE_NAME:$DATE $IMAGE_NAME:latest &&\
docker push $IMAGE_NAME

