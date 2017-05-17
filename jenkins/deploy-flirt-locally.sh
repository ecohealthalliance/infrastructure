#!/bin/bash
#Note: This script is intended for jenkins.
#Please run this from the top level of the infrastructure repo

/usr/bin/sudo docker-compose -f /opt/infrastructure/docker/containers/flirt.yml up -d
