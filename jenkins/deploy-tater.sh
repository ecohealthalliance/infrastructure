#!/bin/bash

#Argument parsing
key="$1"

case $key in
  --instance-name)
    INSTANCE_NAME="$2"
    ;;

  *)
    echo "Please specify instance name, e.g.: --instance-name eha"
    echo
    echo
    exit 1
    ;;
esac

scp -i /keys/infrastructure.pem docker/containers/eha ubuntu@po.tater.io:/tmp
export remote_ssh="ssh -i /keys/infrastructure.pem ubuntu@po.tater.io"

$remote_ssh "sudo docker-compose -f /tmp/$INSTANCE_NAME pull"
export id="$($remote_ssh sudo docker ps | grep $INSTANCE_NAME | sed 's/ .*//')"
$remote_ssh "sudo docker stop $id"
$remote_ssh "sudo docker rm $id"
$remote_ssh "sudo docker-compose -f /tmp/$INSTANCE_NAME up -d"
