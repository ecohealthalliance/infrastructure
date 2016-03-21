#!/bin/bash

export METEOR_SETTINGS=$(cat /shared/settings-production.json)
node /birt-meteor/spabuild/bundle/main.js 

