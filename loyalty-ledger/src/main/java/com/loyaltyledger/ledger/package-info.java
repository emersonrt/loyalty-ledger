/**
 * Double-entry ledger. The only module that writes to {@code ledger_*}, {@code point_lots},
 * {@code idempotency_keys}, and {@code outbox}. Entries are immutable; balance is derived.
 * <p>
 * Consumes {@link com.loyaltyledger.ledger.api.LedgerTopics#COMMANDS}. Publishes events only by
 * writing to the outbox, which Debezium delivers to {@link com.loyaltyledger.ledger.api.LedgerTopics#TRANSACTION_POSTED}.
 * Depends only on {@code shared}.
 */
package com.loyaltyledger.ledger;
