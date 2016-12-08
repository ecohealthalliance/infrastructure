#!/bin/bash
#This is a jenkins script

git checkout master && git pull &&\
git submodule foreach git pull origin master &&\
git clone -b master git@github.com:ecohealthalliance/promed_mail_scraper.git docker/images/promed-scraper/promed_mail_scraper 
docker build --no-cache -t promed-scraper docker/images/promed-scraper