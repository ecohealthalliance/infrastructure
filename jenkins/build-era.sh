#!/bin/bash
#This is a jenkins script
export remote_command="/usr/bin/ssh -i /var/lib/jenkins/.ssh/id_rsa ubuntu@era.eha.io "

$remote_command "cd /opt/infrastructure/docker/images/era/era && git pull origin master"
$remote_command "docker build -t era /opt/infrastructure/docker/images/era"

