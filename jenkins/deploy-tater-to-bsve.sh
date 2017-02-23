#!/bin/bash

rm -fr /tmp/tater.tar*

docker save tater > /tmp/tater.tar
gzip -1 /tmp/tater.tar

aws s3 cp /tmp/tater.tar.gz s3://bsve-integration/tater.tar.gz

aws sns publish --topic-arn arn:aws:sns:us-east-1:789867670404:EHA-Git-Lambda --message '{"app":"tater"}' --profile bsve-user


