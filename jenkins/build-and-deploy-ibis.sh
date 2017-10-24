#!/bin/bash
set -e
cd /opt/infrastructure/ansible/main
ansible-galaxy install -r requirements.yml
ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook provision-instance-and-build.yml \
  --private-key ~/.keys/temp-instances.pem \
  --extra-vars "image_name=ibis"

ansible-playbook deploy-apps.yml \
  --private-key ~/.ssh/id_rsa \
  --tags deploy-ibis
