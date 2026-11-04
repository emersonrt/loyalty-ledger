/**
 * Rules engine: consumes {@code loyalty.inbound}, evaluates active campaigns, and emits
 * {@link com.loyaltyledger.ledger.api.LedgerCommand}s.
 * <p>
 * Depends on {@code ingestion.api}, {@code campaigns.api}, and {@code ledger.api}. Exposes no API of its own.
 */
package com.loyaltyledger.rules;
