TRUNCATE TABLE appointments, users, tenants RESTART IDENTITY CASCADE;

INSERT INTO tenants (id, business_name, subdomain, plan) VALUES
    ('11111111-1111-1111-1111-111111111111', 'Acme Salon',     'acme',     'enterprise'),
    ('22222222-2222-2222-2222-222222222222', 'Globex Spa',     'globex',   'pro'),
    ('33333333-3333-3333-3333-333333333333', 'Initech Studios','initech',  'starter');

INSERT INTO users (tenant_id, email, role) VALUES
    ('11111111-1111-1111-1111-111111111111', 'admin@acme.test',     'admin'),
    ('11111111-1111-1111-1111-111111111111', 'staff@acme.test',     'staff'),
    ('22222222-2222-2222-2222-222222222222', 'admin@globex.test',   'admin'),
    ('22222222-2222-2222-2222-222222222222', 'manager@globex.test', 'manager'),
    ('33333333-3333-3333-3333-333333333333', 'admin@initech.test',  'admin');

INSERT INTO appointments
    (tenant_id, customer_name, customer_phone, service_title, price_cents, scheduled_at, status)
VALUES
    -- Acme (tenant 1)
    ('11111111-1111-1111-1111-111111111111', 'Jane Doe',    '+1-555-0101', 'Haircut',        4500,  NOW() + INTERVAL '1 day',  'confirmed'),
    ('11111111-1111-1111-1111-111111111111', 'Carlos Ruiz', '+1-555-0102', 'Beard Trim',     2500,  NOW() + INTERVAL '2 days', 'confirmed'),
    ('11111111-1111-1111-1111-111111111111', 'Mia Wong',    '+1-555-0103', 'Color & Style',  12000, NOW() + INTERVAL '3 days', 'pending'),
    -- Globex (tenant 2)
    ('22222222-2222-2222-2222-222222222222', 'Tom Bell',    '+1-555-0201', 'Massage',        8000,  NOW() + INTERVAL '1 day',  'confirmed'),
    ('22222222-2222-2222-2222-222222222222', 'Sara Lin',    '+1-555-0202', 'Facial',         6500,  NOW() + INTERVAL '2 days', 'confirmed'),
    -- Initech (tenant 3)
    ('33333333-3333-3333-3333-333333333333', 'Omar Said',   '+1-555-0301', 'Photo Session',  20000, NOW() + INTERVAL '1 day',  'confirmed'),
    ('33333333-3333-3333-3333-333333333333', 'Lara Croft',  '+1-555-0302', 'Headshots',      15000, NOW() + INTERVAL '4 days', 'pending');


