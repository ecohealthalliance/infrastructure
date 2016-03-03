#!/usr/bin/env python
#API call to update tater.io DNS records

import argparse
import sys
import boto.route53


# Argument handling and parsing
parser = argparse.ArgumentParser(description='Update tater.io DNS records')
parser.add_argument('-n', '--name', help='Name of the instance, e.g. eha, dtra, or beta')
parser.add_argument('-d', '--delete', help='Delete instance out of config file', action='store_true')
args = parser.parse_args()


# Check the args
if args.name is None:
  print 'Please specify an instance name'
  sys.exit(1)


# Update DNS with CNAME change
conn = boto.route53.connect_to_region('us-east-1')
zone = conn.get_zone("tater.io.")
cname = "%s.tater.io" % args.name

if args.delete is not True:
  status = zone.add_cname(cname, "router.tater.io", ttl=60)
else:
  status = zone.delete_cname(cname)

print status
