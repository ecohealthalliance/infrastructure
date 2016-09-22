#!/bin/bash

source /source-vars.sh &&\
cd $GRITS_HOME/grits-api &&\
$GRITS_HOME/grits_env/bin/python create_disease_label_collection.py

