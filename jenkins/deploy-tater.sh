#!/bin/bash

deploy_instance () {
  INSTANCE_NAME="$1"
  echo
  echo
  echo "#########################"
  echo "Deploying $INSTANCE_NAME:"
  echo

  scp -i /keys/infrastructure.pem docker/containers/tater/$INSTANCE_NAME ubuntu@po.tater.io:/tmp

  remote_ssh="ssh -i /keys/infrastructure.pem ubuntu@po.tater.io"
  remote_ssh="$remote_ssh export DOCKER_HOST='tcp://10.0.0.116:3376';"
  remote_ssh="$remote_ssh export DOCKER_MACHINE_NAME='po.tater.io';"
  remote_ssh="$remote_ssh export DOCKER_TLS_VERIFY='1';"
  remote_ssh="$remote_ssh export DOCKER_CERT_PATH='/root/.docker/machine/machines/po.tater.io';"
  export remote_ssh
  export docker_compose="sudo -E docker-compose -f /tmp/$INSTANCE_NAME"


  $remote_ssh $docker_compose "pull"
  $remote_ssh $docker_compose "stop"
  $remote_ssh $docker_compose "rm -f"
  $remote_ssh $docker_compose "up -d"
  return 0
}

INSTANCE_NAME="$1"
if [ $INSTANCE_NAME ]; then
  deploy_instance $INSTANCE_NAME
else
  FILES=docker/containers/tater/*
  for file in $FILES
  do
    deploy_instance ${file##*/}
  done
fi
