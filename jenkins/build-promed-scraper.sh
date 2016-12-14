#!/bin/bash
#This is a jenkins script

git checkout master && git pull &&\
git submodule foreach git pull origin master &&\
rm -rf docker/images/promed-scraper/promed_mail_scraper &&\
git clone -b master git@github.com:ecohealthalliance/promed_mail_scraper.git /opt/infrastructure/docker/images/promed-scraper/promed_mail_scraper 
# Start netcat process to serve vault password to build script to docker build process. 
# This is done so that the password can be used in a single command
# without it being stored in the image's history/metadata.
nc -l 14242 < /vault-passwords/grits &
docker build --no-cache -t promed-scraper docker/images/promed-scraper
# Ensure the netcat process terminates
nc -v localhost 14242
