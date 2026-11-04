# Loyalty Ledger

A distributed, multi-tenant points and rewards engine (loyalty ledger) that ingests high-volume events and guarantees that no points are wrongly credited or lost.

| Folder | Contents |
|---|---|
| [`loyalty-ledger/`](loyalty-ledger/) | Java (Spring Boot) application, with Liquibase migrations in `src/main/resources/db/changelog` |
| [`loyalty-ledger-infra/`](loyalty-ledger-infra/) | Local infrastructure (docker compose), kind cluster with Traefik and Argo CD via Terraform, Kubernetes manifests |
| [`loyalty-ledger-doc/`](loyalty-ledger-doc/) | Project plan, ADRs, and architecture |

## Quick start

```bash
make -C loyalty-ledger-infra up             # local infrastructure
cd loyalty-ledger && ./mvnw spring-boot:run # application + migrations
```
