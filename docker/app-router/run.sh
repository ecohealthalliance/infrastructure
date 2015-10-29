#!/bin/bash
/usr/sbin/service rsyslog start &&\
/usr/sbin/haproxy -f /etc/haproxy/haproxy.cfg

