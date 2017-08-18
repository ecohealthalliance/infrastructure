#!/bin/bash -x
# Purpose: Remove docker images labeled as "none"
# Author: Freddie Rosario <rosario@ecohealthalliance.org>

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
echo "y" | docker system prune

#SSH to each machine, and clean up
for server in "${docker_servers[@]}"; do
  echo "Cleaning $server..."
  echo "y" | sudo docker system prune
done

