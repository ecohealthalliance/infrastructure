#!/usr/bin/env python
# Name: monitor-mongod-processes.py
# Purpose: SSH into boxes with mongodb running, fail if process is down
# Author: Freddie Rosario <rosario@ecohealthalliance.org>

import os,sys

# "Useful name": ["ssh_key", "ip address or fqdn"]
servers = {
  "grits.eha.io": ["infrastructure.pem", "grits.eha.io"],
  "mongodb01.tater.io": ["infrastructure.pem", "mongodb01.tater.io"]
}

key_dir = "/keys/"

for name in servers.keys():
  print "Checking " + name + "..."
  SSH = "/usr/bin/ssh -i /var/lib/jenkins/.ssh/id_rsa ubuntu@" + servers[name][1] + " 'pgrep mongod'"
  return_code = os.system(SSH)
  if return_code != 0:
    print "Problem checking for running mongodb on " + name
    sys.exit(1)


