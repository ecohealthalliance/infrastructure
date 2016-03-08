#!/bin/bash

export METEOR_SETTINGS=$(cat /shared/settings-production.json)
node /spa-meteor/spabuild/bundle/main.js 

