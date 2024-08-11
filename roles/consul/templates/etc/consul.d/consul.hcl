# {{ ansible_managed }}

datacenter = "us-homelab1"
primary_datacenter = "us-homelab1"

data_dir = "/opt/consul/data"
encrypt = "{{ consule_encrypt_key.secret.key }}"

server = true

retry_join = ["{% raw %}{{ GetDefaultInterfaces | attr \"address\" }}{% endraw %}"]
bootstrap_expect = 1

ui_config {
  enabled = true
}

bind_addr = "{% raw %}{{ GetDefaultInterfaces | attr \"address\" }}{% endraw %}"

serf_lan = "{% raw %}{{ GetDefaultInterfaces | attr \"address\" }}{% endraw %}"
serf_lan_allowed_cidrs = ["{{ (ansible_default_ipv4.address + '/' + ansible_default_ipv4.netmask) | ansible.utils.ipaddr('network/prefix') }}"]

advertise_addr = "{% raw %}{{ GetDefaultInterfaces | attr \"address\" }}{% endraw %}"

addresses {
  https = "{% raw %}{{ GetInterfaceIP \"tailscale0\" }}{% endraw %}"
  grpc_tls = "{% raw %}{{ GetDefaultInterfaces | attr \"address\" }}{% endraw %}"
}

ports {
  http = -1
  https = 8501
  serf_wan = -1
}

peering {
  enabled = true
}

connect {
  enabled = true
  ca_provider = "vault"
  ca_config {
    address = "http://127.0.0.1:8100"
    token = "dummy" # vault agent overrides this with the agent token

    root_pki_path = "pki_consul_connect_root"
    intermediate_pki_path = "pki_consul_connect_intermediate"
    leaf_cert_ttl = "72h"
    rotation_period = "2160h"
    intermediate_cert_ttl = "8760h"
    private_key_type = "ec"
    private_key_bits = 256
  }
}

auto_encrypt {
  allow_tls = true
  // tls = true # client only
}

tls {
  https {
    // verify_outgoing = true

    cert_file = "/opt/consul/tls/{{ inventory_hostname }}.crt"
    key_file = "/opt/consul/tls/{{ inventory_hostname }}.key"
  }

  grpc {
    verify_incoming = true

    # grpc certs will come from connect CA
    use_auto_cert = true

    ca_file = "/opt/consul/tls/grpc_ca.crt"
    cert_file = "/opt/consul/tls/grpc.crt"
    key_file = "/opt/consul/tls/grpc.key"
  }

  internal_rpc {
    verify_incoming = true
    verify_outgoing = true
    verify_server_hostname = true

    ca_file = "/opt/consul/tls/internal_rpc_ca.crt"
    cert_file = "/opt/consul/tls/internal_rpc.crt"
    key_file = "/opt/consul/tls/internal_rpc.key"
  }
}