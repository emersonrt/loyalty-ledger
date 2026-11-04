# Loyalty Ledger: project

A distributed, multi-tenant points and rewards engine (loyalty ledger) that ingests high-volume events and guarantees that no points are wrongly credited or lost.

> Status: planning. This README will be updated as the phases progress.

## Why this project

A staff-level portfolio project. The focus is depth of decisions (consistency, idempotency, failures, observability), not number of features. Generic domain (e-commerce / delivery / fintech).

## Hard problems the project solves

- **Immutable double-entry ledger.** Balance is derived, never `UPDATE balance`. Auditable and reconcilable.
- **Idempotency with at-least-once delivery.** Duplicate, out-of-order, or reprocessed events never credit twice (idempotency keys, outbox pattern, deduplication).
- **Concurrency on the same balance.** Hot accounts; optimistic locking vs Kafka key partitioning; documented trade-offs.
- **Configurable rules engine.** Campaigns with expiration, multipliers, limited stock, and segmentation, with no new deployment.
- **Point expiration and reversal.**
- **Shadow mode.** Tooling to run the new version alongside the old one and compare results.
- **Observability and SLOs.** Metrics, tracing (OpenTelemetry), dashboards, and alerts.

## Planned stack

Java 21, Spring Boot, Kafka, PostgreSQL, Redis, Kubernetes (local kind/k3d), Terraform, OpenTelemetry, Prometheus + Grafana, k6/Gatling, jqwik (property-based testing).

## What makes the project "staff"

1. ADRs for every relevant decision, with rejected alternatives (`adr/`).
2. Real benchmarks (k6/Gatling): measured throughput and p99, with charts.
3. Chaos and failure tests: broker down, duplicate messages, consumer killed mid-processing, with proof that the balance stays correct.
4. An article/README explaining the problem, the pitfalls, and what would be done differently.
5. Infrastructure as code: a complete environment with one command.

## Phased plan

| Phase | Weeks | Deliverable |
|---|---|---|
| 1 | 1-2 | Ledger + API + idempotency + tests |
| 2 | 3-4 | Event pipeline (Kafka, outbox, partitioning) |
| 3 | 5-6 | Rules engine + expiration/reversal |
| 4 | 7-8 | Observability, benchmarks, chaos tests |
| 5 | 9-10 | Docs, ADRs, diagrams, article, and short demo video |

Rule: publish from phase 1 onward and keep commits steady.

## Alternatives considered (rejected for now)

- Durable workflow engine (mini Temporal): harder, less connected to professional background.
- Distributed rate limiter / gateway: smaller scope.
- Feature flag and experimentation platform: platform focus.

## Next steps

- [ ] Detail the ledger architecture and data model (`architecture.html`)
- [ ] ADR-0001: ledger model (double entry, derived balance)
- [ ] Project skeleton (Spring Boot + Postgres + Testcontainers)
- [ ] Idempotent credit/debit endpoint
