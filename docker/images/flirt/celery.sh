#!/bin/bash

cd /flirt-simulation-service/simulator/
/flirt-pypy-env/bin/celery worker -A tasks --loglevel=INFO --concurrency=2
