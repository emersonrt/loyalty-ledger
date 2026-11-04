package com.loyaltyledger.campaigns.api;

import com.loyaltyledger.shared.tenancy.TenantId;

import java.util.UUID;

public record CampaignChanged(TenantId tenantId, UUID campaignId, int version) {
}
