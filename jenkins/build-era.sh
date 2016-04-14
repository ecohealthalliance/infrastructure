#!/bin/bash
#This is a jenkins script

git checkout master
git submodule update --init
docker build -t era /opt/infrastructure/docker/images/era

