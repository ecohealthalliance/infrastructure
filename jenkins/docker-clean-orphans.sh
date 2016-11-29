#!/bin/bash -e
# Purpose: Remove docker images labeled as "none"
# Author: Freddie Rosario <rosario@ecohealthalliance.org>

remove_orphans="sudo docker images|grep none|awk '{print $3}'|xargs sudo docker rmi"

cleanup(){
  ssh -ti /keys/infrastructure.pem ubuntu@$1 $remove_orphans;
}

docker_servers=(
  dev-survey.eha.io
  survey.eha.io
  eidr-connect.eha.io
  grits.eha.io
  grits-dev.eha.io
  birt.eha.io
  era.eha.io
  spa.eha.io
               )

#Remove stopped containers and local orphans on jenkins itself
echo "Cleaning Jenkins..."
docker ps -a|egrep "Exited|Created"|awk '{print $1}'|xargs docker rm -f
$remove_orphans

#SSH to each machine, and clean up
for server in $docker_servers;do
  echo "Cleaning $server..."
  cleanup $server;
done

#NIAM access is a little different
echo "Cleaing Niam..."
ssh -t ubuntu@niam.eha.io $remove_orphans

