#!/bin/bash

source /source-vars.sh

#Download classifiers
mkdir $GRITS_HOME/classifiers/
aws s3 sync s3://classifier-data/classifiers/ $GRITS_HOME/classifiers/ || exit 1

#Find the newest then link it
export CLASSIFIER_PATH=$(ls -t $GRITS_HOME/classifiers/*/*.p | head -1 | xargs dirname)
ln -s $CLASSIFIER_PATH $GRITS_HOME/grits-api/current_classifier

#Import keywords into mongo for annotation
cd $GRITS_HOME/grits-api/
$GRITS_HOME/grits_env/bin/python $GRITS_HOME/annie/mongo_import_keywords.py --mongo_url $MONGO_URL

