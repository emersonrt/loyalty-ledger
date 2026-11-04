--liquibase formatted sql

--changeset loyalty:005-rls splitStatements:false
-- Per-tenant isolation. The application runs "SET LOCAL app.tenant_id = ..." in each transaction.
-- Without the variable, current_setting returns NULL and no rows are visible.
DO $$
DECLARE
    t text;
BEGIN
    FOREACH t IN ARRAY ARRAY['accounts', 'ledger_transactions', 'ledger_entries', 'point_lots',
                             'idempotency_keys', 'campaigns', 'outbox']
    LOOP
        EXECUTE format('ALTER TABLE %I ENABLE ROW LEVEL SECURITY', t);
        EXECUTE format('ALTER TABLE %I FORCE ROW LEVEL SECURITY', t);
        EXECUTE format(
            'CREATE POLICY tenant_isolation ON %I USING (tenant_id = current_setting(''app.tenant_id'', true)::uuid)', t);
    END LOOP;
END
$$;
