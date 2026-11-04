--liquibase formatted sql

--changeset loyalty:003-campaigns
CREATE TABLE campaigns (
    tenant_id   uuid        NOT NULL REFERENCES tenants (id),
    id          uuid        NOT NULL,
    version     int         NOT NULL DEFAULT 1,
    name        text        NOT NULL,
    rule        jsonb       NOT NULL,
    stock       bigint      CHECK (stock IS NULL OR stock >= 0),
    starts_at   timestamptz NOT NULL,
    ends_at     timestamptz,
    created_at  timestamptz NOT NULL DEFAULT now(),
    PRIMARY KEY (tenant_id, id)
);
--rollback DROP TABLE campaigns;
