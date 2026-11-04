--liquibase formatted sql

--changeset loyalty:004-outbox
-- Read by Debezium (Outbox Event Router). Columns follow the router's default names.
CREATE TABLE outbox (
    id             uuid        PRIMARY KEY,
    tenant_id      uuid        NOT NULL,
    topic          text        NOT NULL,
    aggregatetype  text        NOT NULL,
    aggregateid    text        NOT NULL,
    type           text        NOT NULL,
    payload        jsonb       NOT NULL,
    created_at     timestamptz NOT NULL DEFAULT now()
);
--rollback DROP TABLE outbox;

--changeset loyalty:004-outbox-publication
-- Publication limited to the outbox: Debezium cannot see the other tables.
CREATE PUBLICATION dbz_outbox FOR TABLE outbox;
--rollback DROP PUBLICATION dbz_outbox;
