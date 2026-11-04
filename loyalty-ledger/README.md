# loyalty-ledger

Java 21 / Spring Boot 4 application. Liquibase migrations live in the project itself, in
`src/main/resources/db/changelog` (one folder per version: `v001/`, ...), and the application applies them on startup.

## Run

With the local infrastructure up (`make -C ../loyalty-ledger-infra up`):

```bash
./mvnw spring-boot:run
```

Image: `docker build -t loyalty-ledger:dev .`

## Database

Migrations run as `ledger_owner` (schema owner, not a superuser). The application uses `ledger_app`, which only has DML and is subject to per-tenant Row-Level Security. Ledger entries only accept `INSERT` and `SELECT`, so immutability is also enforced by permissions.

| Variable | Used by | Local default |
|---|---|---|
| `LEDGER_APP_PASSWORD` | runtime (`ledger_app`) | `ledger_app` |
| `LEDGER_OWNER_PASSWORD` | Liquibase (`ledger_owner`) | `ledger_owner` |
| `REDIS_PASSWORD` | Redis | `redis` |

## Code modules

```
com.loyaltyledger
  shared/       shared kernel (TenantId); depends on nothing
  ingestion/    HTTP -> loyalty.inbound
  rules/        loyalty.inbound -> loyalty.ledger-commands
  ledger/       sole owner of the ledger tables; publishes via outbox + Debezium
  campaigns/    campaign admin API -> loyalty.campaigns
  expiration/   expiration job -> Expire commands
```

Each module exposes only its `api` package; other modules do not use the `internal` package. Modules communicate through Kafka topics, so any of them can become a separate service without changing the contracts.
