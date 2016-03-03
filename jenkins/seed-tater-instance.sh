#!/bin/sh

#Wait for DNS
ping=`host $instance_name.tater.io 8.8.8.8 | grep -o "not found"`
while [ "$ping" ]
do
  echo $ping
  sleep 60
  ping=`host $instance_name.tater.io 8.8.8.8 | grep -o "not found"`
done

#Seed database
phantomjs --ssl-protocol=any \
          --web-security=false \
          --ignore-ssl-errors=true \
          jenkins/seedDatabase.js \
          "http://$instance_name.tater.io/seed?fullName=$full_name&emailAddress=$email_address&orgName=$organization_name&tenantName=$instance_name&stripeCustomerId=$stripe_customer_id"
