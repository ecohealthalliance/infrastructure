#!/bin/bash

export METEOR_SETTINGS=$(cat /shared/settings-production.json)
node /mobile-survey-webapp/app/build/bundle/main.js 

