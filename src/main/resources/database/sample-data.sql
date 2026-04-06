-- ============================================================
-- Electricity Billing System - Sample Data
-- ============================================================

USE electricity_billing;

-- ============================================================
-- Default Admin User
-- Password: admin123  (BCrypt encoded)
-- ============================================================
INSERT IGNORE INTO users (username, password, full_name, email, role, enabled)
VALUES
    ('admin', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'System Administrator', 'admin@electricity.com', 'ADMIN', 1),
    ('user1', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'Regular User', 'user1@electricity.com', 'USER', 1);

-- ============================================================
-- Default Parameters
-- ============================================================
INSERT IGNORE INTO parameters (param_key, param_value, description)
VALUES
    ('PRICE_PER_KWH',              '0.15',  'Price per kilowatt-hour in USD'),
    ('PRICE_PER_AMPERE',           '20.00', 'Price per Ampere per month in USD'),
    ('SUBSCRIPTION_FEE_PER_AMPERE','5.00',  'Monthly subscription fee per Ampere in USD'),
    ('EXCHANGE_RATE_USD_TO_LBP',   '89500', 'Current USD to Lebanese Lira exchange rate');

-- ============================================================
-- Sample Clients
-- ============================================================
INSERT IGNORE INTO clients (name, address, phone, email, client_type, ampere_capacity, account_number, active)
VALUES
    -- Meter-based clients (5A)
    ('Ahmad Al-Hassan',   'Beirut, Hamra Street 45',     '+961 70 123456', 'ahmad@example.com',   'METER_BASED', 5,  'ACC-M5-001', 1),
    ('Sara Khalil',       'Tripoli, Al-Mina District',   '+961 76 234567', 'sara@example.com',    'METER_BASED', 5,  'ACC-M5-002', 1),
    ('Joseph Gemayel',    'Jounieh, Kaslik Road',        '+961 71 345678', 'joseph@example.com',  'METER_BASED', 5,  'ACC-M5-003', 1),

    -- Meter-based clients (10A)
    ('Hana Moussawi',     'Sidon, Old City',             '+961 78 456789', 'hana@example.com',    'METER_BASED', 10, 'ACC-M10-004', 1),
    ('Rami Saad',         'Tyre, Al-Bass Area',          '+961 79 567890', 'rami@example.com',    'METER_BASED', 10, 'ACC-M10-005', 1),

    -- Amper-based clients (5A)
    ('Lina Khoury',       'Jdeideh, Main Street',        '+961 70 678901', 'lina@example.com',    'AMPER_BASED', 5,  'ACC-A5-006', 1),
    ('Omar Nassar',       'Zalka, Industrial Zone',      '+961 76 789012', 'omar@example.com',    'AMPER_BASED', 5,  'ACC-A5-007', 1),

    -- Amper-based clients (10A)
    ('Fadi Abi-Nader',    'Metn, Antelias',              '+961 71 890123', 'fadi@example.com',    'AMPER_BASED', 10, 'ACC-A10-008', 1),
    ('Maya Bassil',       'Bekaa Valley, Zahleh',        '+961 78 901234', 'maya@example.com',    'AMPER_BASED', 10, 'ACC-A10-009', 1),
    ('Tony Rizk',         'Baabda, Hazmieh',             '+961 79 012345', 'tony@example.com',    'AMPER_BASED', 5,  'ACC-A5-010', 1);

-- ============================================================
-- Sample Meter Readings (for meter-based clients)
-- Month: January 2024
-- ============================================================
INSERT IGNORE INTO meter_readings (client_id, reading_date, start_reading, end_reading, billing_month, billing_year)
VALUES
    ((SELECT id FROM clients WHERE account_number = 'ACC-M5-001'),  '2024-01-31', 1500.000, 1685.000, 1, 2024),
    ((SELECT id FROM clients WHERE account_number = 'ACC-M5-002'),  '2024-01-31',  800.000,  950.000, 1, 2024),
    ((SELECT id FROM clients WHERE account_number = 'ACC-M5-003'),  '2024-01-31', 2200.000, 2410.000, 1, 2024),
    ((SELECT id FROM clients WHERE account_number = 'ACC-M10-004'), '2024-01-31', 3100.000, 3450.000, 1, 2024),
    ((SELECT id FROM clients WHERE account_number = 'ACC-M10-005'), '2024-01-31', 1750.000, 2080.000, 1, 2024);

-- Month: February 2024
INSERT IGNORE INTO meter_readings (client_id, reading_date, start_reading, end_reading, billing_month, billing_year)
VALUES
    ((SELECT id FROM clients WHERE account_number = 'ACC-M5-001'),  '2024-02-29', 1685.000, 1860.000, 2, 2024),
    ((SELECT id FROM clients WHERE account_number = 'ACC-M5-002'),  '2024-02-29',  950.000, 1095.000, 2, 2024),
    ((SELECT id FROM clients WHERE account_number = 'ACC-M5-003'),  '2024-02-29', 2410.000, 2600.000, 2, 2024),
    ((SELECT id FROM clients WHERE account_number = 'ACC-M10-004'), '2024-02-29', 3450.000, 3800.000, 2, 2024),
    ((SELECT id FROM clients WHERE account_number = 'ACC-M10-005'), '2024-02-29', 2080.000, 2420.000, 2, 2024);
