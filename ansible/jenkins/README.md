To initialize a jenkins server,
create a my_secure.yml file with aws_access_key and aws_secret_key variables,
set the targets ip address in inventory.ini to the server's ip address,
then run these commands:

```
ansible-galaxy install -r requirements.yml
sudo ansible-playbook site.yml --private-key ~/.keys/jenkins.pem
```
