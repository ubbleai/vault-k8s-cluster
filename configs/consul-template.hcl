vault {
  ssl {
    verify = false
  }

  # certificates renewal should happend about 30 days before ttl
  # consul-template should reload them after that, here it's 15 days.
  grace = "21600m"
}

exec {
  command = "nginx -g \"daemon off;\""
}

template {
  destination = "/etc/vault-tls/fullchain.pem"

  contents = "{{ with secret \"secret/certs/VAULT_HOST\" }}{{ index .Data \"fullchain.pem\" }}{{ end }}"
}

template {
  destination = "/etc/vault-tls/privkey.pem"

  contents = "{{ with secret \"secret/certs/VAULT_HOST\" }}{{ index .Data \"privkey.pem\" }}{{ end }}"
}
