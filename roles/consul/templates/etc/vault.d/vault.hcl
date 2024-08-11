# {{ ansible_managed }}

vault {
  address = "https://hashi-vault.tailnet-047c.ts.net:8200"
  retry {
    num_retries = 5
  }
}

auto_auth {
  method "cert" {
    mount_path = "auth/tailscale-cert"
    config {
      client_cert = "/opt/vault/tls/{{ inventory_hostname }}.crt"
      client_key = "/opt/vault/tls/{{ inventory_hostname }}.key"
      reload = true
    }
  }
}

api_proxy {
  use_auto_auth_token = "force"
}

listener "tcp" {
  address = "127.0.0.1:8100"
  tls_disable = true # no tls locally, probably not great but no easy way around it
}