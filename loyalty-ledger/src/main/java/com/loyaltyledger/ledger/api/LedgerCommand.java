package com.loyaltyledger.ledger.api;

import com.loyaltyledger.shared.tenancy.TenantId;

import java.time.Instant;
import java.util.UUID;

/**
 * Commands accepted by the ledger. Every command carries an idempotency key;
 * resending the same command never creates a second entry.
 */
public sealed interface LedgerCommand {

    TenantId tenantId();

    UUID accountId();

    String idempotencyKey();

    record Earn(TenantId tenantId, UUID accountId, String idempotencyKey,
                long points, Instant expiresAt, UUID campaignId, String sourceEventId) implements LedgerCommand {
    }

    record Redeem(TenantId tenantId, UUID accountId, String idempotencyKey,
                  long points, String rewardId) implements LedgerCommand {
    }

    record Reverse(TenantId tenantId, UUID accountId, String idempotencyKey,
                   UUID originalTransactionId, String reason) implements LedgerCommand {
    }

    record Expire(TenantId tenantId, UUID accountId, String idempotencyKey,
                  UUID pointLotId) implements LedgerCommand {
    }
}
