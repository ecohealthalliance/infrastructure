#!/bin/bash

scp -i /keys/infrastructure.pem docker/containers/eha ubuntu@po.tater.io:/tmp
export remote_ssh="ssh -i /keys/infrastructure.pem ubuntu@po.tater.io"

$remote_ssh "sudo docker-compose -f /tmp/eha pull"
id=$($remote_ssh '$(sudo docker ps|grep eha| sed "s/ .*//")')
$remote_ssh "sudo docker stop $id"
$remote_ssh "sudo docker rm $id"
$remote_ssh "sudo docker-compose -f /tmp/eha up -d"
