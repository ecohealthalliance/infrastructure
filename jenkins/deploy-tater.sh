#!/bin/bash

deploy_instance () {
  INSTANCE_NAME="$1"
  echo
  echo
  echo "#########################"
  echo "Deploying $INSTANCE_NAME:"
  echo

  scp -i /keys/infrastructure.pem docker/containers/tater/$INSTANCE_NAME ubuntu@po.tater.io:/tmp
  export remote_ssh="ssh -i /keys/infrastructure.pem ubuntu@po.tater.io"

  $remote_ssh "sudo --login docker-compose -f /tmp/$INSTANCE_NAME pull"
  export id="$($remote_ssh sudo docker ps | grep $INSTANCE_NAME | sed 's/ .*//')"
  $remote_ssh "sudo docker-compose -f /tmp/$INSTANCE_NAME stop $id"
  $remote_ssh "sudo docker-compose -f  /tmp/$INSTANCE_NAME rm $id"
  $remote_ssh "sudo docker-compose -f /tmp/$INSTANCE_NAME up -d"
  return 0
}

FILES=docker/containers/tater/*
for file in $FILES
do
  deploy_instance ${file##*/}
done
