/**
 * Campaigns: versioned CRUD of rules (multiplier, validity, stock, segment) via the admin API.
 * Publishes {@link com.loyaltyledger.campaigns.api.CampaignChanged} so the rules engine can invalidate its cache.
 * Depends only on {@code shared}.
 */
package com.loyaltyledger.campaigns;
