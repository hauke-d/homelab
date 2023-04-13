# Ansible 

# Playbook execution

The first run afer OS install may require running as root, because the SSH public key is not trusted yet:

```
$ ansible-playbook [-l <host_ip>] playbooks/setup.yaml --ask-pass -u root
```

It will remove the possibility to log in as root via SSH, so from then on playbooks need to be run as the `ansible` user with public key authentication:

```
$ ansible-playbook [-l <host_ip>] playbooks/setup.yaml
```