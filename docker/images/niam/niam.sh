#!/bin/bash

export METEOR_SETTINGS=$(cat /shared/settings-production.json)
node /nia-monitor/build/bundle/main.js 
