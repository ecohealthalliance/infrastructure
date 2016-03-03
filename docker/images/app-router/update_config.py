#!/usr/bin/env python
# A word of caution: This updates the config file in place!
# The documentation for pyhaproxy is a little lacking.
# Had to browse the source to figure it out:  https://github.com/imjoey/pyhaproxy

import argparse
import sys
import pyhaproxy
from pyhaproxy.parse import Parser
from pyhaproxy.render import Render
from collections import defaultdict


# Argument handling and parsing
parser = argparse.ArgumentParser(description='Update haproxy.cfg')
parser.add_argument('-n', '--name', help='Name of the instance, e.g. eha, dtra, or beta')
parser.add_argument('-c', '--config', help='haproxy.cfg file to update')
parser.add_argument('-p', '--port', help='reserved tcp port e.g 8001')
parser.add_argument('-d', '--delete', help='Delete instance out of config file', action='store_true')
args = parser.parse_args()


# Check the args
if args.name is None:
  print 'Please specify an instance name'
  sys.exit(1)
elif args.config is None:
  print 'Please specify a haproxy.cfg file to use'
  sys.exit(1)
elif args.delete is not True and args.port is None:
    print 'Please specify a backend port to use'
    sys.exit(1)


#Parse config file
cfg_parser = Parser(args.config)
configuration = cfg_parser.build_configuration()


#Backend section
for backend in configuration.backends:
  if args.name == backend.name:
    if not args.delete:
      print 'Instance name already exists. Exiting without making changes'
      sys.exit(1)
    else:
      configuration.backends.remove(backend)
      print 'Removed %s from backends' % args.name
      break


#Update config with new instance info
frontend = configuration.frontends[0]


#acl line
if args.delete is not True:
  acl_name = 'host_%s' % args.name
  acl_value = 'hdr(host) -i %s.tater.io' % args.name
  acl = pyhaproxy.config.Acl(name=acl_name, value=acl_value)
  frontend.acls().append(acl)
else:
  for acl in frontend.acls():
    if acl.name == 'host_%s' % args.name:
      frontend.acls().remove(acl)
      print 'Removed %s from acl list' % args.name
      break


#use_backend line
if args.delete is not True:
  be_name = args.name
  be_condition = 'host_%s' % args.name
  operator = 'if'
  use_backend = pyhaproxy.config.UseBackend(be_name, operator, be_condition)
  frontend.config_block['usebackends'].append(use_backend)
else:
  for line in frontend.config_block['usebackends']:
    if line.backend_name == args.name:
      frontend.config_block['usebackends'].remove(line)
      print 'Removed %s from use_backend list' % args.name
      break


#backend config section
if args.delete is not True:
  host1 = '10.0.0.116'
  name1 = 'po.tater.io'
  host2 = '10.0.0.240'
  name2 = 'tots01.tater.io'
  port = args.port
  attributes = ['check']

  server1 = pyhaproxy.config.Server(name1, host1, port, attributes)
  server2 = pyhaproxy.config.Server(name2, host2, port, attributes)

  config_block = defaultdict(list)
  config_block['servers'] = [server1, server2]
  backend = pyhaproxy.config.Backend(args.name, config_block)
  configuration.backends.append(backend)


#Render and write out new config file
cfg_render = Render(configuration)
cfg_render.dumps_to(args.config)










