#!/bin/bash
#This is a jenkins script

git checkout master && git pull &&\
git submodule foreach git pull origin master &&\
docker build --no-cache -t promed-scraper docker/images/promed-scraper