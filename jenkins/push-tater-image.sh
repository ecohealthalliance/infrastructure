#!/bin/bash

#Export the tater docker image
rm /tmp/tater.tar || true
rm /tmp/tater.tar.gz || true
docker save tater > /tmp/tater.tar
gzip -1 /tmp/tater.tar

#Useful alias/function
function ssh_command () { /usr/bin/ssh -i /keys/infrastructure.pem  ubuntu@$1 $2; }
function scp_file () { /usr/bin/scp -i /keys/infrastructure.pem $1 ubuntu@$2:/tmp/; }

SERVERS=(po.tater.io tots01.tater.io)

for server in ${SERVERS[@]}; do
  scp_file /tmp/tater.tar.gz $server
  ssh_command $server "gzip -d /tmp/tater.tar.gz"

  echo "Loading image on $server"
  ssh_command $server "/usr/bin/sudo /usr/bin/docker load < /tmp/tater.tar"
  echo "Tater image now imported on $server"

  ssh_command $server "rm /tmp/tater.tar"
done
