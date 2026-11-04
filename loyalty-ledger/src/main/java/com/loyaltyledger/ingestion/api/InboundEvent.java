package com.loyaltyledger.ingestion.api;

import tools.jackson.databind.JsonNode;
import com.loyaltyledger.shared.tenancy.TenantId;

import java.time.Instant;

/**
 * Contract published to {@link IngestionTopics#INBOUND}.
 *
 * @param eventId    tenant-generated id; together with the tenant it forms the idempotency key
 * @param type       business type, e.g. {@code OrderCompleted}, {@code OrderRefunded}
 * @param payload    original event body, interpreted by the rules engine
 */
public record InboundEvent(
        TenantId tenantId,
        String eventId,
        String type,
        String customerId,
        Instant occurredAt,
        JsonNode payload) {

    public String partitionKey() {
        return tenantId + ":" + customerId;
    }
}
