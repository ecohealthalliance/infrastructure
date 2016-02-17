#!/bin/bash

export METEOR_SETTINGS=$(cat /shared/settings-production.json)
node /example/gritsbuild/bundle/main.js 

