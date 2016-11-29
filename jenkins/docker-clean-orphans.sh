#!/bin/bash
# Name: docker-clean-orphans.sh
# Purpose: Remove docker images labeled as "none"
# Author: Freddie Rosario <rosario@ecohealthalliance.org>

remove_orphans="docker images|grep none|awk '{print $3}'|xargs docker rmi"

cleanup(){
  ssh -ti /keys/infrastructure.pem ubuntu@$1 $remove_orphans;
}

docker_servers=(
  dev-parse.eha.io
  parse.eha.io
  eidr-connect.eha.io
  grits.eha.io
  grits-dev.eha.io
  birt.eha.io
  era.eha.io
  spa.eha.io
               )

#Remove local orphans on jenkins itself
$remove_orphans

#SSH to each machine, and clean up
for server in $docker_servers;do
  cleanup $server;
done

#NIAM access is a little different
ssh -ti ubuntu@niam.eha.io $remove_orphans

