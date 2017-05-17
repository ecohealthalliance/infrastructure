#!/bin/bash
#This is a jenkins script


cd /opt/infrastructure/docker/images/mobile-survey/mobile-survey-webapp &&\
git pull origin master &&\
docker build -t mobile-survey /opt/infrastructure/docker/images/mobile-survey/


