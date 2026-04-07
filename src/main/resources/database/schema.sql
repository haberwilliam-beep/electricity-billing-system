-- ============================================================
-- Electricity Billing System - MySQL Database Schema
-- ============================================================

CREATE DATABASE IF NOT EXISTS electricity_billing
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE electricity_billing;

-- ============================================================
-- Users Table
-- ============================================================
CREATE TABLE IF NOT EXISTS users (
    id          BIGINT AUTO_INCREMENT PRIMARY KEY,
    username    VARCHAR(50)  NOT NULL UNIQUE,
    password    VARCHAR(255) NOT NULL,
    full_name   VARCHAR(100) NOT NULL,
    email       VARCHAR(100),
    role        VARCHAR(30)  NOT NULL DEFAULT 'USER',
    enabled     TINYINT(1)   NOT NULL DEFAULT 1,
    created_at  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_username (username)
) ENGINE=InnoDB;

-- ============================================================
-- Clients Table
-- ============================================================
CREATE TABLE IF NOT EXISTS clients (
    id               BIGINT AUTO_INCREMENT PRIMARY KEY,
    name             VARCHAR(100) NOT NULL,
    address          VARCHAR(255),
    phone            VARCHAR(30),
    email            VARCHAR(100),
    client_type      ENUM('METER_BASED','AMPER_BASED') NOT NULL,
    ampere_capacity  INT          NOT NULL DEFAULT 5 COMMENT '5 or 10 Amperes',
    account_number   VARCHAR(50)  NOT NULL UNIQUE,
    active           TINYINT(1)   NOT NULL DEFAULT 1,
    created_at       DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at       DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_client_type (client_type),
    INDEX idx_account_number (account_number),
    INDEX idx_active (active)
) ENGINE=InnoDB;

-- ============================================================
-- Meter Readings Table (for METER_BASED clients only)
-- ============================================================
CREATE TABLE IF NOT EXISTS meter_readings (
    id             BIGINT AUTO_INCREMENT PRIMARY KEY,
    client_id      BIGINT        NOT NULL,
    reading_date   DATE          NOT NULL,
    start_reading  DECIMAL(12,3) NOT NULL DEFAULT 0.000,
    end_reading    DECIMAL(12,3) NOT NULL DEFAULT 0.000,
    consumption    DECIMAL(12,3) GENERATED ALWAYS AS (end_reading - start_reading) STORED
                   COMMENT 'Auto-calculated: end_reading - start_reading in kWh',
    billing_month  TINYINT       NOT NULL COMMENT '1-12',
    billing_year   YEAR          NOT NULL,
    notes          TEXT,
    created_at     DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at     DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY fk_mr_client (client_id) REFERENCES clients(id) ON DELETE CASCADE,
    UNIQUE KEY uq_client_period (client_id, billing_month, billing_year),
    INDEX idx_billing_period (billing_month, billing_year)
) ENGINE=InnoDB;

-- ============================================================
-- Bills Table
-- ============================================================
CREATE TABLE IF NOT EXISTS bills (
    id                          BIGINT AUTO_INCREMENT PRIMARY KEY,
    client_id                   BIGINT        NOT NULL,
    meter_reading_id            BIGINT        NULL COMMENT 'NULL for amper-based clients',
    billing_month               TINYINT       NOT NULL,
    billing_year                YEAR          NOT NULL,
    consumption                 DECIMAL(12,3) NULL    COMMENT 'kWh for meter-based clients',
    price_per_kwh               DECIMAL(10,4) NULL    COMMENT 'USD at time of billing',
    price_per_ampere            DECIMAL(10,4) NULL    COMMENT 'USD at time of billing',
    subscription_fee_per_ampere DECIMAL(10,4) NOT NULL DEFAULT 0,
    ampere_capacity             INT           NOT NULL,
    consumption_charge_usd      DECIMAL(12,4) NOT NULL DEFAULT 0,
    subscription_fee_usd        DECIMAL(12,4) NOT NULL DEFAULT 0,
    total_amount_usd            DECIMAL(14,4) NOT NULL,
    total_amount_lbp            DECIMAL(20,2) NOT NULL,
    exchange_rate               DECIMAL(10,2) NOT NULL COMMENT 'USD to LBP rate',
    status                      ENUM('PENDING','INVOICED','PAID','CANCELLED') NOT NULL DEFAULT 'PENDING',
    created_at                  DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at                  DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY fk_bill_client (client_id) REFERENCES clients(id),
    FOREIGN KEY fk_bill_mr (meter_reading_id) REFERENCES meter_readings(id) ON DELETE SET NULL,
    INDEX idx_bill_period (billing_month, billing_year),
    INDEX idx_bill_status (status)
) ENGINE=InnoDB;

-- ============================================================
-- Invoices Table
-- ============================================================
CREATE TABLE IF NOT EXISTS invoices (
    id               BIGINT AUTO_INCREMENT PRIMARY KEY,
    invoice_number   VARCHAR(50)   NOT NULL UNIQUE,
    bill_id          BIGINT        NOT NULL,
    client_id        BIGINT        NOT NULL,
    billing_month    TINYINT       NOT NULL,
    billing_year     YEAR          NOT NULL,
    issue_date       DATE          NOT NULL,
    due_date         DATE          NOT NULL,
    total_amount_usd DECIMAL(14,4) NOT NULL,
    total_amount_lbp DECIMAL(20,2) NOT NULL,
    exchange_rate    DECIMAL(10,2) NOT NULL,
    status           ENUM('ISSUED','PAID','OVERDUE','CANCELLED') NOT NULL DEFAULT 'ISSUED',
    notes            TEXT,
    created_at       DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at       DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY fk_inv_bill (bill_id) REFERENCES bills(id),
    FOREIGN KEY fk_inv_client (client_id) REFERENCES clients(id),
    INDEX idx_inv_number (invoice_number),
    INDEX idx_inv_period (billing_month, billing_year),
    INDEX idx_inv_status (status)
) ENGINE=InnoDB;

-- ============================================================
-- Parameters Table
-- ============================================================
CREATE TABLE IF NOT EXISTS parameters (
    id          BIGINT AUTO_INCREMENT PRIMARY KEY,
    param_key   VARCHAR(100) NOT NULL UNIQUE,
    param_value VARCHAR(500) NOT NULL,
    description VARCHAR(255),
    created_at  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_param_key (param_key)
) ENGINE=InnoDB;
