FROM ubuntu:16.04

# Install apt package dependencies
RUN apt-get clean all && apt-get update && \
    apt-get -y install wget curl python make g++ git && \
    apt-get clean all

# Install Meteor
RUN curl https://install.meteor.com/ | sh

#Create and use meteor user
RUN groupadd meteor && adduser --ingroup meteor --home /home/meteor meteor
RUN mkdir /app
RUN chown -R meteor:meteor /app
USER meteor

#Add in the repo
RUN git clone --depth 1 https://github.com/ecohealthalliance/ibis.git /app
WORKDIR /app

RUN meteor npm install
RUN meteor build /home/meteor/build --directory

USER root

WORKDIR /home/meteor/build/bundle/programs/server
RUN meteor npm install

WORKDIR /

ENV ROOT_URL http://ibis.eha.io
ENV PORT 80

# Start application
CMD meteor node /home/meteor/build/bundle/main.js
