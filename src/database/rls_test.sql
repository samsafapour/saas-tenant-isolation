-- As Acme: should see only Acme's 3 appointments / 2 users
SELECT set_config('app.current_tenant_id', '11111111-1111-1111-1111-111111111111', false);
SELECT '--- Acme context: appointments ---' AS demo;
SELECT id, tenant_id, customer_name, service_title FROM appointments ORDER BY customer_name;
SELECT '--- Acme context: users ---' AS demo;
SELECT id, tenant_id, email, role FROM users ORDER BY email;

-- As Globex: should see only Globex's 2 appointments / 2 users
SELECT set_config('app.current_tenant_id', '22222222-2222-2222-2222-222222222222', false);
SELECT '--- Globex context: appointments ---' AS demo;
SELECT id, tenant_id, customer_name, service_title FROM appointments ORDER BY customer_name;

-- Unset context: RLS blocks everything (returns 0 rows)
SELECT set_config('app.current_tenant_id', '', false);
SELECT '--- No context (should be empty) ---' AS demo;
SELECT count(*) AS appointments_visible_without_tenant FROM appointments;

-- Reset for a clean interactive session
SELECT set_config('app.current_tenant_id', NULL, false);
