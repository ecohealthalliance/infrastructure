#!/bin/bash
cd $GRITS_HOME/grits-api &&\
$GRITS_HOME/grits_env/bin/celery worker -A tasks_preprocess -Q process -P threads --concurrency 10 --loglevel=INFO

