#!/bin/bash
export METEOR_SETTINGS=$(cat /shared/settings-production.json)
source /shared/sensitive-environment-vars.env
# Start application
meteor node /home/meteor/build/bundle/main.js
