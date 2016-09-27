#!/bin/bash
#This is a jenkins script

git checkout master &&\
git submodule foreach git pull origin master &&\
rm -rf docker/images/promed-scraper/promed_mail_scraper &&\
git clone -b master git@github.com:ecohealthalliance/promed_mail_scraper.git docker/images/promed-scraper/promed_mail_scraper &&\
docker build -t spa docker/images/spa

# Start netcat process to serve vault password to build script to docker build process. 
# This is done so that the password can be used in a single command
# without it being stored in the image's history/metadata.
nc -l 14242 < /vault-passwords/grits &
docker build -t promed-scraper docker/images/promed-scraper
# Ensure the netcat process terminates
nc localhost 14242
