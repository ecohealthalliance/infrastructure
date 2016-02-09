#!/bin/bash

cd /flirt-simulation-service/simulator/
source /flirt-simulation-service-env/bin/activate && \
celery worker -A tasks --loglevel=INFO --concurrency=2

