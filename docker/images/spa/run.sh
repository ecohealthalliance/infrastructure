# Default run.sh..

#Import heat map data
aws s3 sync s3://promed-database/ ./
mongorestore -h 10.0.0.175 -d promed -c blindspots ./dump/promed/blindspots.bson

#Start the app
service supervisor start