#!/bin/bash
cd $GRITS_HOME/grits-api &&\
$GRITS_HOME/grits_env/bin/celery worker -A tasks -Q diagnose,priority --loglevel=INFO --concurrency=2
