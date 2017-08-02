#!/bin/bash
#Install kubectl on ubuntu

#Download latest version
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl

#Make binary executable
chmod +x ./kubectl

#Move binary to PATH
sudo mv ./kubectl /usr/local/bin/kubectl

#Enable bash autocompletion
echo "source <(kubectl completion bash)" >> ~/.bashrc

