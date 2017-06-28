#!/bin/bash

export METEOR_SETTINGS=$(cat /shared/settings-production.json)
cp /shared/config.py /flirt-simulation-service/simulator/config.py
node /flirt-webapp/app/build/bundle/main.js 

