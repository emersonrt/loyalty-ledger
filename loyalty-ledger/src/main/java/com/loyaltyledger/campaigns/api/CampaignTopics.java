package com.loyaltyledger.campaigns.api;

public final class CampaignTopics {

    /** Campaign changes. Partition key: {@code tenantId}. */
    public static final String CHANGED = "loyalty.campaigns";

    private CampaignTopics() {
    }
}
