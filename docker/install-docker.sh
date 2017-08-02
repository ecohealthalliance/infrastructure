#!/bin/bash
# Install docker on ubuntu

#Install necessary packages
sudo apt-get update
sudo apt-get -y install linux-image-extra-$(uname -r) linux-image-extra-virtual apt-transport-https ca-certificates curl software-properties-common

#Install docker repo key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

#Add official docker repo
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update

#Install docker engine community edition
sudo apt-get -y install docker-ce


