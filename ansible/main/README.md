This contains ansible scripts for:

1. setting up a multiple domain server with automatic ssl renewal
2. temporarily provisioning instances to build our apps
3. deploying our apps to the multiple domain server


To initialize a multipule domain server,
create a my_secure.yml file with aws_access_key and aws_secret_key variables,
set the targets ip address in inventory.ini to its ip address,
then run these commands:

```
ansible-galaxy install -r requirements.yml
sudo ansible-playbook multi-domain-server.yml --private-key ~/.ssh/id_rsa
```

To provision a temporary build instances that will stop in 1 hour and build
the docker image for an app on it use this command:

```
sudo ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook provision-instance-and-build.yml  --private-key ~/.key/infrastructure.pem --extra-vars "image_name=grits"
```

To deploy an app to the multiple domain server use this command:

```
sudo ansible-playbook deploy-apps.yml --private-key ~/.ssh/id_rsa
```
