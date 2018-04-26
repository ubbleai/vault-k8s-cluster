vault {
  ssl {
    verify = false
  }
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
