-- ============================================================
-- Electricity Generator Billing System - MySQL Schema
-- ============================================================

CREATE DATABASE IF NOT EXISTS electricity_billing
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE electricity_billing;

-- ============================================================
-- Roles
-- ============================================================
CREATE TABLE IF NOT EXISTS roles (
    id          BIGINT AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(50) NOT NULL UNIQUE,
    description VARCHAR(200),
    created_at  DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

INSERT INTO roles (name, description) VALUES
    ('ROLE_ADMIN',    'Administrator - Full access'),
    ('ROLE_OPERATOR', 'Operator - Manage customers, billing and issuance'),
    ('ROLE_VIEWER',   'Viewer - Read-only access')
ON DUPLICATE KEY UPDATE description = VALUES(description);

-- ============================================================
-- Users
-- ============================================================
CREATE TABLE IF NOT EXISTS users (
    id            BIGINT AUTO_INCREMENT PRIMARY KEY,
    username      VARCHAR(50)  NOT NULL UNIQUE,
    password      VARCHAR(255) NOT NULL,
    full_name     VARCHAR(100),
    email         VARCHAR(100),
    role_id       BIGINT NOT NULL,
    enabled       TINYINT(1) DEFAULT 1,
    created_at    DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at    DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_users_role FOREIGN KEY (role_id) REFERENCES roles(id)
) ENGINE=InnoDB;

-- Default admin user: password = 'admin123' (BCrypt encoded)
INSERT INTO users (username, password, full_name, email, role_id)
VALUES ('admin',
        '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy',
        'System Administrator', 'admin@electricity.com', 1)
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name);

-- ============================================================
-- Zones
-- ============================================================
CREATE TABLE IF NOT EXISTS zones (
    id          BIGINT AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(100) NOT NULL,
    description VARCHAR(300),
    active      TINYINT(1) DEFAULT 1,
    created_at  DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at  DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ============================================================
-- Boxes
-- ============================================================
CREATE TABLE IF NOT EXISTS boxes (
    id          BIGINT AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(100) NOT NULL,
    zone_id     BIGINT NOT NULL,
    description VARCHAR(300),
    active      TINYINT(1) DEFAULT 1,
    created_at  DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at  DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_boxes_zone FOREIGN KEY (zone_id) REFERENCES zones(id)
) ENGINE=InnoDB;

-- ============================================================
-- Customers
-- ============================================================
CREATE TABLE IF NOT EXISTS customers (
    id           BIGINT AUTO_INCREMENT PRIMARY KEY,
    name         VARCHAR(150) NOT NULL,
    phone        VARCHAR(30),
    address      VARCHAR(300),
    box_id       BIGINT NOT NULL,
    billing_type ENUM('METER','AMPER') NOT NULL DEFAULT 'METER',
    amper_capacity DECIMAL(10,2),
    meter_number VARCHAR(50),
    active       TINYINT(1) DEFAULT 1,
    created_at   DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at   DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_customers_box FOREIGN KEY (box_id) REFERENCES boxes(id)
) ENGINE=InnoDB;

-- ============================================================
-- Parameters (system configuration)
-- ============================================================
CREATE TABLE IF NOT EXISTS parameters (
    id              BIGINT AUTO_INCREMENT PRIMARY KEY,
    param_key       VARCHAR(100) NOT NULL UNIQUE,
    param_value     VARCHAR(500) NOT NULL,
    description     VARCHAR(300),
    updated_by      BIGINT,
    updated_at      DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_params_user FOREIGN KEY (updated_by) REFERENCES users(id)
) ENGINE=InnoDB;

INSERT INTO parameters (param_key, param_value, description) VALUES
    ('PRICE_PER_KWH',        '0.09',  'Electricity price per kWh in USD'),
    ('PRICE_PER_AMPER',      '5.00',  'Monthly price per Amper in USD'),
    ('SUBSCRIPTION_FEE_PER_AMPER', '2.00', 'Monthly subscription fee per Amper in USD'),
    ('EXCHANGE_RATE',        '90000', 'USD to LBP exchange rate')
ON DUPLICATE KEY UPDATE param_value = VALUES(param_value);

-- ============================================================
-- Issuances (monthly billing run header)
-- ============================================================
CREATE TABLE IF NOT EXISTS issuances (
    id              BIGINT AUTO_INCREMENT PRIMARY KEY,
    issuance_date   DATE NOT NULL,
    billing_month   DATE NOT NULL COMMENT 'First day of the billing month',
    exchange_rate   DECIMAL(15,2) NOT NULL,
    status          ENUM('DRAFT','FINAL') DEFAULT 'DRAFT',
    notes           VARCHAR(500),
    created_by      BIGINT,
    created_at      DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uk_issuance_month (billing_month),
    CONSTRAINT fk_issuance_user FOREIGN KEY (created_by) REFERENCES users(id)
) ENGINE=InnoDB;

-- ============================================================
-- Bills
-- ============================================================
CREATE TABLE IF NOT EXISTS bills (
    id              BIGINT AUTO_INCREMENT PRIMARY KEY,
    issuance_id     BIGINT NOT NULL,
    customer_id     BIGINT NOT NULL,
    billing_type    ENUM('METER','AMPER') NOT NULL,
    -- Meter-based fields
    prev_reading    DECIMAL(12,2),
    curr_reading    DECIMAL(12,2),
    consumption     DECIMAL(12,2),
    price_per_kwh   DECIMAL(10,4),
    -- Amper-based fields
    amper_capacity  DECIMAL(10,2),
    price_per_amper DECIMAL(10,4),
    -- Common
    sub_fee         DECIMAL(12,2) NOT NULL DEFAULT 0,
    total_usd       DECIMAL(12,2) NOT NULL DEFAULT 0,
    total_lbp       DECIMAL(15,2) NOT NULL DEFAULT 0,
    exchange_rate   DECIMAL(15,2) NOT NULL,
    is_trial        TINYINT(1) DEFAULT 0,
    created_at      DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_bills_issuance  FOREIGN KEY (issuance_id)  REFERENCES issuances(id),
    CONSTRAINT fk_bills_customer  FOREIGN KEY (customer_id)  REFERENCES customers(id)
) ENGINE=InnoDB;

-- ============================================================
-- Translations (i18n key-value store)
-- ============================================================
CREATE TABLE IF NOT EXISTS translations (
    id          BIGINT AUTO_INCREMENT PRIMARY KEY,
    msg_key     VARCHAR(200) NOT NULL,
    en_value    VARCHAR(500) NOT NULL,
    ar_value    VARCHAR(500),
    updated_by  BIGINT,
    updated_at  DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uk_translation_key (msg_key),
    CONSTRAINT fk_trans_user FOREIGN KEY (updated_by) REFERENCES users(id)
) ENGINE=InnoDB;

-- Seed core translations
INSERT INTO translations (msg_key, en_value, ar_value) VALUES
    ('app.title',         'Electricity Billing System', 'نظام فواتير الكهرباء'),
    ('menu.dashboard',    'Dashboard',   'لوحة التحكم'),
    ('menu.customers',    'Customers',   'الزبائن'),
    ('menu.zones',        'Zones',       'المناطق'),
    ('menu.boxes',        'Boxes',       'الصناديق'),
    ('menu.parameters',   'Parameters',  'الإعدادات'),
    ('menu.issuances',    'Issuances',   'الإصدارات'),
    ('menu.billing',      'Billing',     'الفواتير'),
    ('menu.translations', 'Translations','الترجمات'),
    ('menu.audit',        'Audit Log',   'سجل التدقيق'),
    ('menu.users',        'Users',       'المستخدمون'),
    ('btn.save',          'Save',        'حفظ'),
    ('btn.cancel',        'Cancel',      'إلغاء'),
    ('btn.delete',        'Delete',      'حذف'),
    ('btn.edit',          'Edit',        'تعديل'),
    ('btn.add',           'Add New',     'إضافة'),
    ('btn.trial',         'Trial Run',   'تشغيل تجريبي'),
    ('btn.final',         'Final Bill',  'فاتورة نهائية'),
    ('btn.pdf',           'Print PDF',   'طباعة PDF'),
    ('label.yes',         'Yes',         'نعم'),
    ('label.no',          'No',          'لا'),
    ('label.active',      'Active',      'نشط'),
    ('label.inactive',    'Inactive',    'غير نشط')
ON DUPLICATE KEY UPDATE en_value = VALUES(en_value), ar_value = VALUES(ar_value);

-- ============================================================
-- Audit Logs
-- ============================================================
CREATE TABLE IF NOT EXISTS audit_logs (
    id          BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id     BIGINT,
    username    VARCHAR(50),
    action      VARCHAR(100) NOT NULL,
    entity_type VARCHAR(100),
    entity_id   BIGINT,
    description VARCHAR(1000),
    ip_address  VARCHAR(50),
    created_at  DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_audit_user    (user_id),
    INDEX idx_audit_action  (action),
    INDEX idx_audit_created (created_at)
) ENGINE=InnoDB;

-- ============================================================
-- Indexes for performance
-- ============================================================
CREATE INDEX IF NOT EXISTS idx_customers_box    ON customers(box_id);
CREATE INDEX IF NOT EXISTS idx_boxes_zone       ON boxes(zone_id);
CREATE INDEX IF NOT EXISTS idx_bills_issuance   ON bills(issuance_id);
CREATE INDEX IF NOT EXISTS idx_bills_customer   ON bills(customer_id);
