#!/bin/bash

#Import heat map data
aws s3 sync s3://promed-database/ ./
mongorestore -h 172.30.2.160 -d promed -c blindspots ./dump/promed/blindspots.bson

#Start the app
service supervisor start