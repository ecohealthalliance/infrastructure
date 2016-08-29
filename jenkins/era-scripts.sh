#!/bin/bash

(cd ERA || git clone https://github.com/ecohealthalliance/ERA.git)
cd ERA

git pull origin master

(docker run --name mongo-client -d mongodb sleep infinity || true)
docker cp .scripts mongo-client:/scripts

docker exec -t mongo-client mongo mongodb://flirt-reporting.eha.io/flirt /scripts/flight_counts.js

docker exec -t mongo-client mongo mongodb://flirt-reporting.eha.io/flirt /scripts/day_counts.js

docker exec -t mongo-client mongo mongodb://flirt-reporting.eha.io/flirt /scripts/airport_counts.js

