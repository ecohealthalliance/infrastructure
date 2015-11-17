#!/usr/bin/env python
# Name: deploy.py
# Purpose: Push latest compose yaml file to server, and deploy new images
# Author: Freddie Rosario <rosario@ecohealthalliance.org>

import argparse
import subprocess
import sys
import os

# Argument handling and parsing
parser = argparse.ArgumentParser(description='Push latest compose yaml file to server, and deploy new docker images')
parser.add_argument('--ssh-key', help='SSH private key to use for authenticating with server')
parser.add_argument('--file', help='docker compose yml file to use')
parser.add_argument('--server', help='FQDN or ip address of the server to deploy to')
#parser.add_argument('--force', help='Remove all running containers to provision newer versions', action='store_true')
args = parser.parse_args()


# Check the args
if args.ssh_key is None:
  print "Please specify a SSH key"
  sys.exit(1)
elif args.file is None:
  print "Please specify a docker compose yaml file to use"
  sys.exit(1)
elif args.server is None:
  print "Please specify a server to deploy to"
  sys.exit(1)


# Copy yaml file to server
scp_command = "scp -i " + args.ssh_key + " " + args.file + " ubuntu@" + args.server + ":/home/ubuntu/" 
scp_return_code = subprocess.call(scp_command, shell=True)
if scp_return_code != 0:
  print "Failed to copy yaml file."
  sys.exit(1)
else:
  print "Copied " + args.file + " to " + args.server


# Reusable commands
ssh = "ssh -i " + args.ssh_key + " ubuntu@" + args.server + " "
compose_file = os.path.basename(args.file)
docker_compose = "sudo docker-compose -f " + compose_file + " "


# Pull latest base images
docker_pull_command = docker_compose + "pull"
ssh_pull = ssh + docker_pull_command
pull_return_code = subprocess.call(ssh_pull, shell=True)
if pull_return_code != 0:
    print "Failed to pull latest images"
    sys.exit(1)
else:
  print "Pulled latest images"


## Does user want to remove running containers
#if args.force:
#  stop_containers_command = docker_compose + "stop"
#  ssh_stop_containers = ssh + stop_containers_command
#  stop_containers_return_code = subprocess.call(ssh_stop_containers, shell=True)
#  if stop_containers_return_code != 0:
#    print "Failed to stop running containers"
#  else:
#    print "Stopping running containers"


# Converge using lastest changes captured in yaml file
up_command = docker_compose + "up -d"
ssh_compose = ssh + up_command
compose_return_code = subprocess.call(ssh_compose, shell=True)
if compose_return_code != 0:
    print "Failed to create latest containers"
    sys.exit(1)








