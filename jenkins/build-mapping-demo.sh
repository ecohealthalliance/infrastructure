#!/bin/bash
#Name: build-mapping-demo.sh
#Purpose: Shell script that jenkins will use to build docker container to demo mapping engine build by DIT
#Warning: This is a convoluted process that I had to reverse engineer from an external contractor.
#         There is a better way to handle all of this, I just don't have a ton of time right now
#Author: Freddie Rosario <rosario@ecohealthalliance.org>

#Checkout necessary repos
mkdir -p example/packages
cd example/packages
rm -fr grits-net-meteor grits-net-mapper grits-net-consume
git clone git@github.com:ecohealthalliance/grits-net-meteor.git
git clone git@github.com:ecohealthalliance/grits-net-mapper.git
git clone git@github.com:ecohealthalliance/grits-net-consume.git


#Build the meteor app
cd ../
source /var/lib/jenkins/.profile 
nvm use v0.12.7
rm -fr ./gritsbuild
meteor build ./gritsbuild --directory || exit 1


#Create the supervisor config file for embedded mongo
touch ./gritsbuild/bundle/mongod-supervisor.conf
cat > ./gritsbuild/bundle/mongod-supervisor.conf<<-EOF
[program:mongod]
command=/usr/bin/mongod -f /etc/mongodb.conf 
environment=LC_ALL=C
user=mongodb
autostart=true
autorestart=unexpected
EOF


#Create the docker file
touch ./gritsbuild/bundle/Dockerfile
cat > ./gritsbuild/bundle/Dockerfile<<-EOF
FROM node:0.12
EXPOSE 80
ADD . .

#Install dependencies
RUN apt-get clean all && apt-get update
RUN apt-get -y install build-essential python python-dev python-setuptools python-pip mongodb-clients mongodb supervisor
RUN pip install virtualenv virtualenvwrapper awscli
RUN cd programs/server && npm install

#Move mongodb supervisor config file to correct location
RUN mv /mongod-supervisor.conf /etc/supervisor/conf.d/mongod.conf

#Setup AWS config
RUN mkdir /root/.aws

ENV AWS_ACCESS_KEY_ID=AKIAJLKTQX7LL2L2JV7Q
ENV AWS_SECRET_ACCESS_KEY=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

CMD bash run.sh
EOF


#Create run.sh
touch ./gritsbuild/bundle/run.sh
cat > ./gritsbuild/bundle/run.sh<<-EOF
#Take care of dependencies
virtualenv grits-net-consume-env &&\ 
source grits-net-consume-env/bin/activate &&\ 
pip install -r requirements.txt

#Update ftp credentials
sed -i 's/url-innovata.com/suwweb03.innovata-llc.com/' grits_ftp_config.py
sed -i 's/username/ECOHEALTH/' grits_ftp_config.py
sed -i 's/password/CC6832Hy/' grits_ftp_config.py

#Consume/import flight data
python grits_flight_pull.py
python grits_consume.py --type DiioAirport -m 10.0.0.175 -d grits-net-meteor /tests/data/MiExpressAllAirportCodes.tsv
python grits_consume.py --type FlightGlobal -m 10.0.0.175 -d grits-net-meteor /data/EcoHealth_*.csv  &&\ 
rm -fr /data

#Make sure indexes are good
python grits_ensure_index.py

#Import heat map data
aws s3 sync s3://flight-network-heat-map/ /
mongorestore -h 10.0.0.175 -d grits-net-meteor -c heatmap /dump/grits/heatmap.bson

#To enable the embedded instance of mongodb, uncomment the following line
#service supervisor start

#Start the app
node main.js
EOF

#Build the example app container
cp -R ./packages/grits-net-consume/* ./gritsbuild/bundle/
docker build -t grits-net-meteor ./gritsbuild/bundle/


