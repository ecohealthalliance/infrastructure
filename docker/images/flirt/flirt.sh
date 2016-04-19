#!/bin/bash

export METEOR_SETTINGS=$(cat /shared/settings-production.json)
node /flirt-webapp/app/build/bundle/main.js 

