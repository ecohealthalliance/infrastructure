#!/bin/bash

cd /opt/infrastructure/ansible/niam/ &&\
ansible-galaxy install -r requirements.yml &&\
ansible-playbook site.yml --become-user=ubuntu --vault-password-file /keys/grits_vault_password --private-key /var/lib/jenkins/.ssh/id_rsa --tags niam

#Upload new docker image to S3
docker save niam > /tmp/niam.tar &&\
gzip -1 /tmp/niam.tar &&\
aws s3 cp /tmp/niam.tar.gz s3://bsve-integration/niam.tar.gz
rm /tmp/niam.tar.gz

# Notify BSVE to redeploy
aws sns publish --topic-arn arn:aws:sns:us-east-1:789867670404:EHA-Git-Lambda --message '{"app":"niam"}' --profile bsve-user
