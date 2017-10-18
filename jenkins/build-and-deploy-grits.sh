#!/bin/bash
cd /opt/infrastructure/ansible/main
ansible-galaxy install -r requirements.yml
ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook provision-instance-and-build.yml \
  --private-key ~/.keys/infrastructure.pem \
  --extra-vars "image_name=grits"

if [ "$NOTIFY_BSVE" = true ]; then
  /bin/echo "Notify BSVE to redeploy"
  aws sns publish --topic-arn arn:aws:sns:us-east-1:789867670404:EHA-Git-Lambda --message '{"app":"grits"}' --profile bsve-user
fi

ansible-playbook deploy-apps.yml \
  --private-key ~/.ssh/id_rsa \
  --tags deploy-grits

