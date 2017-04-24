#!/bin/bash
#Note: This script is intended for jenkins.
#Please run this from the top level of the infrastructure repo

#Useful alias/function
export ssh_command="/usr/bin/ssh -i /var/lib/jenkins/.ssh/id_rsa  freddie@kirby.ecohealthalliance.org "

#Pull latest version of master
$ssh_command "cd /home/freddie/infrastructure/ && git pull"

#Build latest grits image
$ssh_command "sudo docker build --no-cache -t grits /home/freddie/infrastructure/docker/images/grits/"

#Spin up latest celery worker
$ssh_command "sudo docker-compose -f /home/freddie/infrastructure/docker/containers/grits-worker.yml up -d"

#Clean up to save on disk space
$ssh_command "echo 'y'|sudo docker system prune"
