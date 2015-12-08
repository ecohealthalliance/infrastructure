#!/bin/bash
# Name: docker-clean-orphans.sh
# Purpose: Remove docker images labeled as "none"
# Author: Freddie Rosario <rosario@ecohealthalliance.org>

docker images|grep none|awk '{print $3}'|xargs docker rmi

