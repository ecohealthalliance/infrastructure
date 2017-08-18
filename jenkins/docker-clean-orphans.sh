#!/bin/bash -x
# Purpose: Remove docker images labeled as "none"
# Author: Freddie Rosario <rosario@ecohealthalliance.org>

remove_stopped_containers="docker ps -a|egrep \"Exited|Created\"|awk '{print $1}'|xargs docker rm -f"
remove_orphans="docker images|grep none|awk '{print $3}'|xargs docker rmi"
sudo_remove_orphans="(sudo docker images|grep none|awk '{print $3}'|xargs sudo docker rmi) || true"

cleanup(){
  ssh -i /var/lib/jenkins/.ssh/id_rsa ubuntu@$1 $sudo_remove_orphans
}


docker_servers=(
  eidr-connect.eha.io
  eidr-connect-bsve.eha.io
  grits.eha.io
  era.eha.io
  spa.eha.io
  niam.eha.io
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
for server in "${docker_servers[@]}"; do
  echo "Cleaning $server..."
  cleanup $server;
done

#NIAM access is a little different
echo "Cleaing Niam..."
ssh ubuntu@niam.eha.io $sudo_remove_orphans


