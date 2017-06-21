#!/bin/bash
set -x

#Download rana data
aws s3 sync s3://mantle-data/rana/rana /tmp/rana &&\

#Ensure we have a mongo image built
docker build -t mongodb /opt/infrastructure/docker/images/mongodb/ &&\

#Start the mongo container for testing
docker run --name rana-test -v /tmp:/mnt/tmp -d mongodb sleep infinity &&\
docker exec rana-test rm /var/lib/mongodb/NOT-MOUNTED /var/log/NOT-MOUNTED &&\
docker exec rana-test bash -c 'nohup bash ./run.sh &> /output.log & sleep 1' &&\

#Import the mongodump
docker exec rana-test mongorestore --drop -d rana --dir /mnt/tmp/rana &&\

#Cleanup when done
rm -fr /tmp/rana &&\
docker rm -f rana-test &&\
echo "Mongorestore of rana dump successful!"

