#!/usr/bin/env python
# Name: health_check.py
# Purpose: Script to run as an automated healt check for our websites
# Author: Freddie Rosario <rosario@ecohealthalliance.org>

import requests
from sys import exit
failure = False

urls = [
    'https://mantle.ecohealthalliance.org/grrs',
    'http://www.ecohealthalliance.org/',
    'https://eidr.ecohealthalliance.org/',
    'https://grits.ecohealthalliance.org/',
    'https://grits-dev.ecohealthalliance.org/',
    'https://eha.tater.io'
  ]

for u in urls:
  try:
    r = requests.get(u,verify=False)
    if r.status_code != 200:
      print "Problem with: " + u
      failure = True

  except requests.exceptions.SSLError:
    print "SSL verification failed for: " + u
    failure = True
  
  except requests.exceptions.ConnectionError:
    print "Could not connect to: " + u
    failure = True

if failure:
  exit(1)
else:
  print "All monitored websites up!"

