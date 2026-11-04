package com.loyaltyledger.shared.tenancy;

import java.util.Objects;
import java.util.UUID;

/**
 * Tenant identifier. Always derived from the authenticated credential, never from the payload.
 */
public record TenantId(UUID value) {

    public TenantId {
        Objects.requireNonNull(value, "tenant id is required");
    }

    public static TenantId of(String value) {
        return new TenantId(UUID.fromString(value));
    }

    @Override
    public String toString() {
        return value.toString();
    }
}
