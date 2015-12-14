#!/bin/bash

#eha.tater.io:
#  container_name: eha.tater.io
#  image: docker-repository.tater.io:5000/apps/tater
#  ports:
#    - "8002:3000"
#  restart: always
#  environment:
#    - MONGO_URL=mongodb://10.0.0.92:27017/eha
#    - ROOT_URL=https://eha.tater.io
#    - PORT=3000

name=$1

if [[ -n "$name" ]]; then
  echo "${name}.tater.io:
  container_name: ${name}.tater.io
  image: docker-repository.tater.io:5000/apps/tater
  ports:
    - \"8002:3000\"
  restart: always
  environment:
    - MONGO_URL=mongodb://10.0.0.92:27017/${name}
    - ROOT_URL=https://${name}.tater.io
    - PORT=3000
"
else
  echo "Please specify the instance name (e.g. $0 eha)"
fi
