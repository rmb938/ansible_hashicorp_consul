# ansible_hashicorp-consul
Ansible to Install [Hashicorp Consul](https://www.consul.io/) on Ubuntu

## Requirements

* Tailscale installed and configured for ssh
    ```bash
    sudo tailscale up --ssh --advertise-tags "tag:servers,tag:hashiconsulserver,tag:hvpolicy-default,tag:hvpolicy-hashiconsulserver"
    ```

## Run

```bash
ansible-playbook -i hosts site.yaml -v --diff
```