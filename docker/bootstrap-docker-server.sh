#!/bin/bash
# Name: bootstrap-docker-server.sh
# Purpose: As the name implies :)
# Author: Freddie Rosario <rosario@ecohealthalliance.org>

#Argument parsing
if [[ $# > 1 ]]
then
  key="$1"
fi

case $key in
  --hostname)
    NAME="$2"
    ;;

  *)
    echo "Please specify hostname like so: --hostname <FQDN>"
    echo "\n\n\n"
    exit 1
    ;;
esac


apt-get update && apt-get -y dist-upgrade


#Ensure secure apt transport is installed
if [ ! -e /usr/lib/apt/methods/https ]; then
apt-get update
  apt-get install -y apt-transport-https
fi


# Add docker apt repo and import GPG key
echo deb https://get.docker.com/ubuntu docker main > /etc/apt/sources.list.d/docker.list
apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9


#Install docker
apt-get update
apt-get install -y lxc-docker


asdfset hostname


#Install docker compose
curl -L https://github.com/docker/compose/releases/download/1.4.2/docker-compose-Linux-x86_64 > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose


reboot
