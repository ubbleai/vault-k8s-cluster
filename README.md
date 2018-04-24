# Vault k8s cluster

Current supported versions:

* `consul`: `1.0.7`
* `vault`: `0.10.0`

## Requirements

* A kubectl context is already set to the target k8s cluster.
* `consul`, `vault` and `cfssl` on the client.
* a public host fronting the vault api, like `vault.example.com` and a public certificates.

For example for certificates from [Let's Encrypt](https://letsencrypt.org/) and `vault.example.com`
you should put the certificates at `vault.example.com/privkey.pem` and `vault.example.com/fullchain.pem`.

## Usage

```
VAULT_HOST=vault.example.com ./bin/setup_vault
```

## What happen

* A ca root certificates is created, and certificates are generated for consul and vault for internal
communication.
* A 3 replicas [Consul](https://www.consul.io/) statefulset is created and configured.
* A 2 replicas [Vault](https://www.vaultproject.io/) statefulset is created and configured.
* A 2 replicas [Nginx](https://www.nginx.com/) deployment for exposing the vault cluster and ssl termination.

## Caveat

* For disaster recovery, and backup should be done regularly of the consul cluster, for example using
`consul snapshot save` command.
* At this time, in order to use the consul dns from any node, which allows nginx to query the active vault
replica using `active.vault.service.consul`, we configure `kube-dns` using the ips of the 3 consul replicas.
If these instances crash, new ips are issued for the pods, and the vault cluster might become inaccessible from outside
(nginx not being able to use `active.vault.service.consul`).
Using a loadbalancer doesn't seem to work.
