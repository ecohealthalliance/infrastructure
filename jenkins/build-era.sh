#!/bin/bash
#This is a jenkins script

cd /opt/infrastructure/docker/images/era/era
git pull origin master
cd /opt/infrastructure
docker build -t era /opt/infrastructure/docker/images/era

