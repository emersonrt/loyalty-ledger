--liquibase formatted sql

--changeset loyalty:002-accounts
-- Customer accounts (CUSTOMER) and per-tenant system accounts (ISSUANCE, REDEMPTION, EXPIRED).
CREATE TABLE accounts (
    tenant_id    uuid        NOT NULL REFERENCES tenants (id),
    id           uuid        NOT NULL,
    kind         text        NOT NULL CHECK (kind IN ('CUSTOMER', 'ISSUANCE', 'REDEMPTION', 'EXPIRED')),
    external_id  text,
    created_at   timestamptz NOT NULL DEFAULT now(),
    PRIMARY KEY (tenant_id, id),
    UNIQUE (tenant_id, kind, external_id)
);
--rollback DROP TABLE accounts;

--changeset loyalty:002-ledger-transactions
CREATE TABLE ledger_transactions (
    tenant_id                uuid        NOT NULL,
    id                       uuid        NOT NULL,
    kind                     text        NOT NULL CHECK (kind IN ('EARN', 'REDEEM', 'REVERSAL', 'EXPIRATION')),
    reverses_transaction_id  uuid,
    source_event_id          text,
    created_at               timestamptz NOT NULL DEFAULT now(),
    PRIMARY KEY (tenant_id, id)
);
--rollback DROP TABLE ledger_transactions;

--changeset loyalty:002-ledger-entries
-- Append-only. The amounts of a transaction always sum to zero.
CREATE TABLE ledger_entries (
    tenant_id       uuid        NOT NULL,
    id              bigint      GENERATED ALWAYS AS IDENTITY,
    transaction_id  uuid        NOT NULL,
    account_id      uuid        NOT NULL,
    amount          bigint      NOT NULL CHECK (amount <> 0),
    created_at      timestamptz NOT NULL DEFAULT now(),
    PRIMARY KEY (tenant_id, id),
    FOREIGN KEY (tenant_id, transaction_id) REFERENCES ledger_transactions (tenant_id, id),
    FOREIGN KEY (tenant_id, account_id)     REFERENCES accounts (tenant_id, id)
);
CREATE INDEX ledger_entries_account_idx ON ledger_entries (tenant_id, account_id, id);
--rollback DROP TABLE ledger_entries;

--changeset loyalty:002-point-lots
-- Point lots for FIFO expiration. remaining is the only mutable column in the ledger.
CREATE TABLE point_lots (
    tenant_id       uuid        NOT NULL,
    id              uuid        NOT NULL,
    account_id      uuid        NOT NULL,
    transaction_id  uuid        NOT NULL,
    original        bigint      NOT NULL CHECK (original > 0),
    remaining       bigint      NOT NULL CHECK (remaining >= 0),
    expires_at      timestamptz NOT NULL,
    PRIMARY KEY (tenant_id, id),
    FOREIGN KEY (tenant_id, account_id)     REFERENCES accounts (tenant_id, id),
    FOREIGN KEY (tenant_id, transaction_id) REFERENCES ledger_transactions (tenant_id, id)
);
CREATE INDEX point_lots_expiring_idx ON point_lots (expires_at) WHERE remaining > 0;
--rollback DROP TABLE point_lots;

--changeset loyalty:002-idempotency-keys
CREATE TABLE idempotency_keys (
    tenant_id       uuid        NOT NULL,
    key             text        NOT NULL,
    transaction_id  uuid        NOT NULL,
    created_at      timestamptz NOT NULL DEFAULT now(),
    PRIMARY KEY (tenant_id, key)
);
--rollback DROP TABLE idempotency_keys;
