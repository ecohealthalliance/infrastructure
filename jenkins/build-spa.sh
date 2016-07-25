#!/bin/bash
#This is a jenkins script

git checkout master
git submodule foreach git pull origin master
rm -rf docker/images/promed-scraper/promed_mail_scraperr
git clone https://github.com/ecohealthalliance/promed_mail_scraper.git docker/images/promed-scraper/promed_mail_scraper
docker build -t spa docker/images/spa
docker build -t promed-scraper docker/images/promed-scraper
