#!/bin/bash

while true; do aws s3 cp --recursive /var/log/supervisor/ s3://bsve-logs; sleep 60; done
