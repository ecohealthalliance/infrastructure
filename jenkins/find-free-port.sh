#!/bin/bash

# Find an unused port (http://unix.stackexchange.com/questions/55913/whats-the-easiest-way-to-find-an-unused-local-port)
instance_port=$RANDOM
quit=0

while [ "$quit" -ne 1 ]; do
  netstat -a | grep $instance_port >> /dev/null
  if [ $? -gt 0 ]; then
    quit=1
  else
    port=`expr $instance_port + 1`
  fi
done

echo $instance_port
