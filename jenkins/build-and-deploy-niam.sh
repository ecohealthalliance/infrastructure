#!/bin/bash

cd /opt/infrastructure/ansible/niam/ &&\
ansible-galaxy install -r requirements.yml &&\
ansible-playbook site.yml --become-user=ubuntu --vault-password-file /keys/grits_vault_password --private-key /keys/infrastructure.pem 
