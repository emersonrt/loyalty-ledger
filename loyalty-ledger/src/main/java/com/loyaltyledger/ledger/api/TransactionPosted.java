package com.loyaltyledger.ledger.api;

import java.time.Instant;
import java.util.UUID;

/**
 * Outbound event published to {@link LedgerTopics#TRANSACTION_POSTED}.
 * Consumers must deduplicate by {@code transactionId} (at-least-once delivery).
 */
public record TransactionPosted(
        UUID transactionId,
        String tenantId,
        UUID accountId,
        String kind,
        long points,
        Instant postedAt) {
}
