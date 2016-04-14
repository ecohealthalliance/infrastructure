#!/bin/bash
#This is a jenkins script

cd /opt/infrastructure
git submodule update --init
docker build -t era /opt/infrastructure/docker/images/era

