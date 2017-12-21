#!/bin/bash

cd /flirt-simulation-service/simulator/
/flirt-simulation-service-env/bin/celery worker -A tasks --loglevel=INFO --concurrency=2
