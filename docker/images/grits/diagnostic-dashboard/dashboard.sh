#!/bin/bash
source /source-vars.sh  &&\
cd $GRITS_HOME/diagnostic-dashboard &&\
meteor node $GRITS_HOME/diagnostic-dashboard/bundle/main.js

