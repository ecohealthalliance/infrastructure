#!/bin/bash
source /source-vars.sh  &&\
cd $GRITS_HOME/grits-api &&\
exec $GRITS_HOME/grits_env/bin/celery worker -A tasks_preprocess -Q process -P threads --concurrency=$PROCESS_WORKERS --loglevel=INFO

