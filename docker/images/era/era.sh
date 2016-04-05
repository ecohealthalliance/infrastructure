#!/bin/bash

export METEOR_SETTINGS=$(cat /shared/settings-production.json)
node /era-webapp/build/bundle/main.js 

