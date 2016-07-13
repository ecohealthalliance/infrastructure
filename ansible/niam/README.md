# How to deploy NAIM Infrastructure

Install ansible and ansible galaxy.

Install 3rd party ansible roles:

```
ansible-galaxy install -r requirements.yml
```

### to deploy on the EHA niam instance

```
ansible-playbook site.yml --vault-password-file ~/.keys/.grits_vault_password --private-key infrastructure.pem
```

### to deploy locally

Uncomment the localhost entry in inventory.ini and remove the remote host.

```
sudo ansible-playbook site.yml --become-user=[your user] --vault-password-file ~/.keys/.grits_vault_password
```
