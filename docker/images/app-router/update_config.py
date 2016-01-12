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
args = parser.parse_args()


# Check the args
if args.name is None:
  print 'Please specify an instance name'
  sys.exit(1)
elif args.port is None:
  print 'Please specify a backend to use'
  sys.exit(1)
elif args.config is None:
  print 'Please specify a haproxy.cfg file to use'
  sys.exit(1)


#Parse config file
cfg_parser = Parser(args.config)
configuration = cfg_parser.build_configuration()


#Validate name is not already in config
for backend in configuration.backends:
  if args.name == backend.name:
    print 'Instance name already exists. Exiting without making changes'
    sys.exit(1)


#Update config with new instance info
frontend = configuration.frontends[0]


#New acl line
acl_name = 'host_%s' % args.name
acl_value = 'hdr(host) -i %s.tater.io' % args.name
acl = pyhaproxy.config.Acl(name=acl_name, value=acl_value)
frontend.acls().append(acl)


#New use_backend line
be_name = args.name
be_condition = 'host_%s' % args.name
operator = 'if'
use_backend = pyhaproxy.config.UseBackend(be_name, operator, be_condition)
frontend.config_block['usebackends'].append(use_backend)


#New backend config section
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










