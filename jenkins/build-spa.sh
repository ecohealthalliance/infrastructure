#!/bin/bash
#This is a jenkins script

cd /opt/infrastructure && git pull &&\
docker build --no-cache -t spa docker/images/spa

