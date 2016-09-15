#!/bin/bash
cd $GRITS_HOME/grits-api &&\
$GRITS_HOME/grits_env/bin/celery flower -A tasks --port=5555 --basic_auth=$BASIC_AUTH
