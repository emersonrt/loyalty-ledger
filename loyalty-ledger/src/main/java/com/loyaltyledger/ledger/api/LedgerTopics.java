package com.loyaltyledger.ledger.api;

public final class LedgerTopics {

    /** Commands that change the balance. Partition key: {@code accountId}. */
    public static final String COMMANDS = "loyalty.ledger-commands";

    /** Published by Debezium from the outbox table. Key: {@code accountId}. */
    public static final String TRANSACTION_POSTED = "ledger.transaction-posted";

    private LedgerTopics() {
    }
}
