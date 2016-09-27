#!/bin/bash

cd $GRITS_HOME/annie &&\
curl -O http://download.geonames.org/export/dump/allCountries.zip &&\
unzip allCountries.zip &&\
$GRITS_HOME/grits_env/bin/python mongo_import_geonames.py --mongo_url $MONGO_URL


