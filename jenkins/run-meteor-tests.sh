#!/bin/bash
# Name: run-meteor-tests.sh
# Purpose: As the name implies :)
# Author: Freddie Rosario <rosario@ecohealthalliance.org>

java -version
source ~/.profile && nvm use v0.12.7
export DISPLAY=:99.0
Xvfb :99 -screen 0 1600x1200x16 &
sleep 10
VELOCITY_CI=1 CHIMP_OPTIONS="--browser=chrome --no-screenshotsOnError" meteor --test

