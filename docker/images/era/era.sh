#!/bin/bash

export METEOR_SETTINGS=$(cat /shared/settings-production.json)
meteor node /era-webapp/build/bundle/main.js 

