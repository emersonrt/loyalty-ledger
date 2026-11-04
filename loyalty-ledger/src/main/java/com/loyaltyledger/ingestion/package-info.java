/**
 * Ingestion module: receives tenant business events (HTTP), validates them, applies the
 * idempotency key, and publishes to {@link com.loyaltyledger.ingestion.api.IngestionTopics#INBOUND}.
 * <p>
 * Depends only on {@code shared}. Other modules may only use the {@code api} package.
 */
package com.loyaltyledger.ingestion;
