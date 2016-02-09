#!/bin/bash

cd /flirt-simulation-service
virtualenv /flirt-simulation-service-env &&\
source /flirt-simulation-service-env/bin/activate &&\
pip install -r requirements.txt &&\
celery worker -A tasks --loglevel=INFO --concurrency=2

