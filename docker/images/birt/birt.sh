#!/bin/bash

export METEOR_SETTINGS=$(cat /shared/settings-production.json)
node /birt-meteor/app/birtbuild/bundle/main.js 

