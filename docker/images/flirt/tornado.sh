#!/bin/bash

cd /flirt-simulation-service
source /flirt-simulation-service-env/bin/activate && \
--port=45000 --mongo_host=127.0.0.1 --mongo_port=27017 --mongo_database=grits
python server.py --port=45000 --mongo_host=10.0.0.175 --mongo_port=27017 --mongo_database=grits-net-meteor
