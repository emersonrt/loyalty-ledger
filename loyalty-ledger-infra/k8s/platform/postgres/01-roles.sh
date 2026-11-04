#!/bin/sh
# Postgres bootstrap (runs only on the volume's first initialization).
# Creates the roles; schema and grants belong to the application's Liquibase.
#   ledger_owner: schema owner, used only by Liquibase (DDL). Not a superuser.
#   ledger_app:   application runtime, DML only; RLS applies to it.
#   debezium:     logical replication of the outbox.
set -eu

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" \
  -v owner_pw="$LEDGER_OWNER_PASSWORD" \
  -v app_pw="$LEDGER_APP_PASSWORD" \
  -v dbz_pw="$DEBEZIUM_PASSWORD" <<'SQL'
CREATE ROLE ledger_owner LOGIN PASSWORD :'owner_pw';
CREATE ROLE ledger_app LOGIN PASSWORD :'app_pw';
CREATE ROLE debezium LOGIN REPLICATION PASSWORD :'dbz_pw';

ALTER SCHEMA public OWNER TO ledger_owner;
-- CREATE on the database is required for the outbox CREATE PUBLICATION.
GRANT CREATE ON DATABASE loyalty TO ledger_owner;
SQL
