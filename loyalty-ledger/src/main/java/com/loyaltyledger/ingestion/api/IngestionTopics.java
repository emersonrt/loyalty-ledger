package com.loyaltyledger.ingestion.api;

public final class IngestionTopics {

    /** Accepted business events. Partition key: {@code tenantId:customerId}. */
    public static final String INBOUND = "loyalty.inbound";

    private IngestionTopics() {
    }
}
