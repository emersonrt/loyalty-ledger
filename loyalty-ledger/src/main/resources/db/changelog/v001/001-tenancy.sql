--liquibase formatted sql

--changeset loyalty:001-tenants
CREATE TABLE tenants (
    id          uuid        PRIMARY KEY,
    name        text        NOT NULL,
    status      text        NOT NULL DEFAULT 'ACTIVE' CHECK (status IN ('ACTIVE', 'SUSPENDED')),
    created_at  timestamptz NOT NULL DEFAULT now()
);
--rollback DROP TABLE tenants;

--changeset loyalty:001-api-keys
-- Only the key's sha256 hash is stored. The prefix allows lookup without exposing the key.
-- No RLS: authentication must find the key before it knows the tenant.
CREATE TABLE api_keys (
    id            uuid        PRIMARY KEY,
    tenant_id     uuid        NOT NULL REFERENCES tenants (id),
    prefix        text        NOT NULL UNIQUE,
    key_hash      bytea       NOT NULL,
    scopes        text[]      NOT NULL,
    created_at    timestamptz NOT NULL DEFAULT now(),
    expires_at    timestamptz,
    last_used_at  timestamptz,
    revoked_at    timestamptz
);
CREATE INDEX api_keys_tenant_idx ON api_keys (tenant_id);
--rollback DROP TABLE api_keys;
