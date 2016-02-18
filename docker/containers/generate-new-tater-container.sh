#!/bin/bash

# Help function
function usage() {
  echo "Usage: $0 --name <eha> [--port <8002>]" 1>&2
}

# Returns 1 if the provided port is free
function probePort() {
  local port=$1
  nc 127.0.0.1 $port < /dev/null
  echo $?
}

BAD_ARGS=""

#Argument parsing
while [ "$1" ]
do
  case "$1" in
   -n|--name)
    NAME="$2"
    shift 2
    ;;
   -p|--port)
    PORT="$2"
    shift 2
    ;;
   *)
    BAD_ARGS="$BAD_ARGS $1"
    shift
    ;;
  esac
done

if [[ "$BAD_ARGS" ]]
then
	usage
	echo "Bad arguments: $BAD_ARGS"
  exit 1
fi

if [[ "$PORT" ]]
then
  if [[ "$(probePort $PORT)" < 1 ]]
  then
    echo "Port $PORT is in use, please specify a different port"
    exit 1
  fi
else
  PORT_START=8002
  PORT_END=65535

  for i in $(seq $PORT_START $PORT_END);
  do
    if [[ "$(probePort $i)" > 0 ]]
    then
      PORT=$i
      break
    fi
  done
fi

# Lowercase the $NAME
NAME="$(tr [A-Z] [a-z] <<< $NAME)"

if [[ "$NAME" ]]
then
  # Create the sub-directory
  mkdir -p tater

  # Ouput the new container file
  echo "$NAME.tater.io:
  container_name: $NAME.tater.io
  image: docker-repository.tater.io:5000/apps/tater
  ports:
    - \"$PORT:3000\"
  restart: always
  environment:
    - MONGO_URL=mongodb://10.0.0.92:27017/$NAME
    - ROOT_URL=https://$NAME.tater.io
    - PORT=3000
  volumes_from:
      - shared-data:ro
" > "tater/$NAME"
fi
