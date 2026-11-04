--liquibase formatted sql

--changeset loyalty:006-grants runOnChange:true
-- Roles are created during Postgres bootstrap (loyalty-ledger-infra/k8s/platform/postgres/01-roles.sh).
-- This changelog runs as ledger_owner (schema owner), never as a superuser.
-- ledger_entries and ledger_transactions: INSERT and SELECT only. The ledger is also immutable by permission.
GRANT USAGE ON SCHEMA public TO ledger_app;
GRANT SELECT ON tenants, api_keys TO ledger_app;
GRANT UPDATE (last_used_at) ON api_keys TO ledger_app;
GRANT SELECT, INSERT ON accounts, ledger_transactions, ledger_entries, idempotency_keys, outbox TO ledger_app;
GRANT SELECT, INSERT, UPDATE ON point_lots, campaigns TO ledger_app;
GRANT DELETE ON outbox TO ledger_app;

GRANT USAGE ON SCHEMA public TO debezium;
GRANT SELECT ON outbox TO debezium;
