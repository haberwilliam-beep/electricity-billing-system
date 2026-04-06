-- H2 compatible test schema for unit tests
CREATE TABLE IF NOT EXISTS roles (
    id          BIGINT AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(50) NOT NULL,
    description VARCHAR(200),
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS users (
    id            BIGINT AUTO_INCREMENT PRIMARY KEY,
    username      VARCHAR(50)  NOT NULL,
    password      VARCHAR(255) NOT NULL,
    full_name     VARCHAR(100),
    email         VARCHAR(100),
    role_id       BIGINT NOT NULL,
    enabled       BOOLEAN DEFAULT TRUE,
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_users_role FOREIGN KEY (role_id) REFERENCES roles(id)
);

CREATE TABLE IF NOT EXISTS zones (
    id          BIGINT AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(100) NOT NULL,
    description VARCHAR(300),
    active      BOOLEAN DEFAULT TRUE,
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS boxes (
    id          BIGINT AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(100) NOT NULL,
    zone_id     BIGINT NOT NULL,
    description VARCHAR(300),
    active      BOOLEAN DEFAULT TRUE,
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_boxes_zone FOREIGN KEY (zone_id) REFERENCES zones(id)
);

CREATE TABLE IF NOT EXISTS customers (
    id             BIGINT AUTO_INCREMENT PRIMARY KEY,
    name           VARCHAR(150) NOT NULL,
    phone          VARCHAR(30),
    address        VARCHAR(300),
    box_id         BIGINT NOT NULL,
    billing_type   VARCHAR(10) NOT NULL DEFAULT 'METER',
    amper_capacity DECIMAL(10,2),
    meter_number   VARCHAR(50),
    active         BOOLEAN DEFAULT TRUE,
    created_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_customers_box FOREIGN KEY (box_id) REFERENCES boxes(id)
);

CREATE TABLE IF NOT EXISTS parameters (
    id          BIGINT AUTO_INCREMENT PRIMARY KEY,
    param_key   VARCHAR(100) NOT NULL,
    param_value VARCHAR(500) NOT NULL,
    description VARCHAR(300),
    updated_by  BIGINT,
    updated_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS issuances (
    id              BIGINT AUTO_INCREMENT PRIMARY KEY,
    issuance_date   DATE NOT NULL,
    billing_month   DATE NOT NULL,
    exchange_rate   DECIMAL(15,2) NOT NULL,
    status          VARCHAR(10) DEFAULT 'DRAFT',
    notes           VARCHAR(500),
    created_by      BIGINT,
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS bills (
    id              BIGINT AUTO_INCREMENT PRIMARY KEY,
    issuance_id     BIGINT NOT NULL,
    customer_id     BIGINT NOT NULL,
    billing_type    VARCHAR(10) NOT NULL,
    prev_reading    DECIMAL(12,2),
    curr_reading    DECIMAL(12,2),
    consumption     DECIMAL(12,2),
    price_per_kwh   DECIMAL(10,4),
    amper_capacity  DECIMAL(10,2),
    price_per_amper DECIMAL(10,4),
    sub_fee         DECIMAL(12,2) NOT NULL DEFAULT 0,
    total_usd       DECIMAL(12,2) NOT NULL DEFAULT 0,
    total_lbp       DECIMAL(15,2) NOT NULL DEFAULT 0,
    exchange_rate   DECIMAL(15,2) NOT NULL,
    is_trial        BOOLEAN DEFAULT FALSE,
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS translations (
    id          BIGINT AUTO_INCREMENT PRIMARY KEY,
    msg_key     VARCHAR(200) NOT NULL,
    en_value    VARCHAR(500) NOT NULL,
    ar_value    VARCHAR(500),
    updated_by  BIGINT,
    updated_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS audit_logs (
    id          BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id     BIGINT,
    username    VARCHAR(50),
    action      VARCHAR(100) NOT NULL,
    entity_type VARCHAR(100),
    entity_id   BIGINT,
    description VARCHAR(1000),
    ip_address  VARCHAR(50),
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Seed test data
INSERT INTO roles (name, description) VALUES
    ('ROLE_ADMIN', 'Administrator'),
    ('ROLE_OPERATOR', 'Operator'),
    ('ROLE_VIEWER', 'Viewer');

INSERT INTO users (username, password, full_name, email, role_id, enabled) VALUES
    ('admin', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'Admin', 'admin@test.com', 1, TRUE);

INSERT INTO parameters (param_key, param_value, description) VALUES
    ('PRICE_PER_KWH', '0.09', 'Price per kWh'),
    ('PRICE_PER_AMPER', '5.00', 'Price per Amper'),
    ('SUBSCRIPTION_FEE_PER_AMPER', '2.00', 'Subscription fee per Amper'),
    ('EXCHANGE_RATE', '90000', 'Exchange rate');
