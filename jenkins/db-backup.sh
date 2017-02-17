#!/bin/bash
#Purpose: Script to be used by Jenkins to perform regular backups of mongodb01.tater.io

export remote_ssh="ssh -i /var/lib/jenkins/.ssh/id_rsa ubuntu@mongodb01.tater.io"

#Mongodump
$remote_ssh "cd /tmp && mongodump"

#Create tarball mongodump with a descriptive timestamp
timestamp=$(date +%Y%m%d-%H:%M)
$remote_ssh "tar -czf /tmp/mongo-tater-$timestamp.tar.gz /tmp/dump"

#Grab tarball and Upload to S3
scp -i /var/lib/jenkins/.ssh/id_rsa ubuntu@mongodb01.tater.io:/tmp/mongo-tater-* /tmp
aws s3 cp /tmp/mongo-tater-* s3://tater-cloud-mongodumps

#Clean up dump dir and tarball
rm /tmp/mongo-tater-*
$remote_ssh "rm -fr /tmp/dump/ /tmp/mongo-tater-*"
