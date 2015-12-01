#!/bin/bash
# Name: run-meteor-tests.sh
# Purpose: As the name implies :)
# Author: Freddie Rosario <rosario@ecohealthalliance.org>

java -version
source ~/.profile && nvm use v0.12.7
VELOCITY_CI=1 CHIMP_OPTIONS="--browser=chrome --no-screenshotsOnError" meteor --test

