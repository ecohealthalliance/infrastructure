#!/bin/bash
set -e

cd /opt/infrastructure/ansible/main
ansible-galaxy install -r requirements.yml
ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook provision-instance-and-build.yml \
  --private-key ~/.keys/temp-instances.pem \
  --extra-vars "image_name=eidr-connect"

if [ "$NOTIFY_BSVE" = true ]; then
  echo "Notify BSVE to redeploy"
  aws sns publish --topic-arn arn:aws:sns:us-east-1:789867670404:EHA-Git-Lambda --message '{"app":"eidr-connect"}' --profile bsve-user
fi

ansible-playbook deploy-apps.yml \
  --private-key ~/.ssh/id_rsa \
  --tags deploy-eidr-connect
