#!/bin/bash
source /source-vars.sh  &&\
cd $GRITS_HOME/grits-api &&\
$GRITS_HOME/grits_env/bin/python server.py

