#!/bin/bash -e
# Purpose: Remove docker images labeled as "none"
# Author: Freddie Rosario <rosario@ecohealthalliance.org>


cleanup(){
  ssh -ti /keys/infrastructure.pem ubuntu@$1 "sudo docker images|grep none|awk '{print $3}'|xargs sudo docker rmi";
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

#Cleanup jenkins itself
echo "Cleaning Jenkins..."
docker ps -a |egrep "Exited|Created"

#Check for and remove stopped containers
if [[ $? -eq 0 ]];then
  docker ps -a|egrep "Exited|Created"|awk '{print $1}'|xargs docker rm -f
fi

#Check for none images
docker images|grep none
if [[ $? -eq 0 ]];then
  docker images|grep none|awk '{print $3}'|xargs docker rmi
fi

#SSH to each machine, and clean up
for server in $docker_servers;do
  echo "Cleaning $server..."
  cleanup $server;
done

#NIAM access is a little different
echo "Cleaing Niam..."
ssh -t ubuntu@niam.eha.io $remove_orphans

