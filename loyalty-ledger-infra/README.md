# loyalty-ledger-infra

## Local (docker compose)

```bash
make up     # Postgres, Kafka (KRaft), Debezium Connect, Redis + outbox connector registration
make down   # stop (keeps volumes)
make nuke   # stop and delete volumes
```

Ports are bound to `127.0.0.1` only. The outbox connector is registered right away, but it only reaches `RUNNING` after the application starts and applies the migrations; until then `register-connector` keeps retrying.

## Cluster (kind + Traefik + Argo CD)

Prerequisite: Terraform >= 1.9 (kind is embedded in the provider).

```bash
cp terraform/terraform.tfvars.example terraform/terraform.tfvars   # set the repository URL
make cluster
```

- Argo CD: http://argocd.localhost:8080 (password: `terraform -chdir=terraform output -raw argocd_admin_password_command`)
- Application: http://ledger.localhost:8080
- Argo CD reads the manifests from Git (`k8s/platform`, `k8s/app`): changes only reach the cluster after a push.

| Where | What |
|---|---|
| `terraform/` | kind cluster, Traefik, Argo CD, namespaces, and Secrets (generated passwords, kept out of Git) |
| `k8s/platform/` | Postgres, Kafka, Kafka Connect (Debezium), Redis, NetworkPolicies |
| `k8s/app/` | Application Deployment, Ingress, connector registration (PostSync), NetworkPolicies |

## Network security

- **IP allowlist on the Traefik entrypoint:** applies to every request, before routing, including Argo CD. Configured through `allowed_source_cidrs`; anything outside the list gets a `403`.
- **Real source IP:** `externalTrafficPolicy: Local` avoids SNAT, and any `X-Forwarded-For` sent by the client is ignored.
- **On kind**, the IP seen by Traefik is the docker network gateway (e.g. `172.18.0.1`). Check it in the Traefik access log and narrow it to `/32` if you want.
- **NetworkPolicies:** the application only accepts traffic from Traefik; the `platform` namespace only accepts traffic from itself and from the `loyalty` namespace.
