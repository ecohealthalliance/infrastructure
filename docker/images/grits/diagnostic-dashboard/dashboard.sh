#!/bin/bash
source /source-vars.sh  &&\
cd $GRITS_HOME/diagnostic-dashboard &&\
node $GRITS_HOME/diagnostic-dashboard/bundle/main.js

