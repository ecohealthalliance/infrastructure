#!/bin/bash
#Name: build-mapping-demo.sh
#Purpose: Shell script that jenkins will use to build docker container to demo mapping engine build by DIT
#Author: Freddie Rosario <rosario@ecohealthalliance.org>

#Checkout necessary repos
mkdir -p example/packages
cd example/packages
git clone git@github.com:ecohealthalliance/grits-net-meteor.git
git clone git@github.com:ecohealthalliance/grits-net-mapper.git


#Build the meteor app
cd ../
source /var/lib/jenkins/.profile 
nvm use v0.12.7
rm -fr ./gritsbuild
meteor build ./gritsbuild --directory || exit 1


#Create the docker file
touch ./gritsbuild/bundle/Dockerfile
cat > ./gritsbuild/bundle/Dockerfile<<-EOF
FROM node:0.12
EXPOSE 80
ADD . .
RUN cd programs/server && npm install
CMD node main.js
EOF

#Build the example app container
docker build -t grits-net-meteor ./gritsbuild/bundle/
