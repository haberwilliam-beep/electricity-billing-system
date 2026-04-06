# ⚡ Electricity Billing Management System

A complete Spring Boot application for managing electricity billing with support for meter-based and amper-based clients, dual-currency invoicing (USD & LBP), and a web-based management interface.

---

## 🚀 Features

### Client Management
- **Meter-Based Clients** – Billed on actual kWh consumption (end reading − start reading)
- **Amper-Based Clients** – Billed on subscribed Ampere capacity (5A or 10A)
- Full CRUD with editable jqGrid

### Billing Engine
- Automatic calculation of consumption charges, ampere charges, and subscription fees
- Dual-currency invoices: **USD** and **Lebanese Lira (LBP)**
- Formula:
  - *Meter-based:* `(kWh × price/kWh) + (subscriptionFee/A × capacity)`
  - *Amper-based:* `(price/A × capacity) + (subscriptionFee/A × capacity)`

### Invoice Management
- Invoice generation from bills
- Read-only invoice grid with export to CSV
- Mark invoices as Paid / Overdue / Cancelled

### Parameter Configuration
- Admin screen for:
  - Price per kWh
  - Price per Ampere
  - Monthly Subscription Fee per Ampere
  - USD → LBP Exchange Rate

### Security
- Spring Security login/logout with BCrypt password hashing
- Role-based access control (ADMIN / USER)
- CSRF protection

---

## 🛠️ Tech Stack

| Layer        | Technology                              |
|-------------|------------------------------------------|
| Backend     | Spring Boot 2.7.x, Spring MVC            |
| ORM         | MyBatis 2.3.x                            |
| Database    | MySQL 8.0                                |
| Frontend    | JSP, JSTL, Bootstrap 4                   |
| Grids       | jqGrid (free-jqgrid 4.15)                |
| JS/CSS      | jQuery 3.6, Bootstrap 4.6                |
| Security    | Spring Security 5.x                      |
| Build       | Maven (WAR packaging)                    |

---

## 📁 Project Structure

```
src/main/java/com/electricity/
├── config/
│   ├── SecurityConfig.java       # Spring Security configuration
│   └── WebConfig.java            # MVC resource handlers
├── controller/
│   ├── AuthController.java
│   ├── DashboardController.java
│   ├── ClientController.java
│   ├── MeterReadingController.java
│   ├── BillingController.java
│   ├── InvoiceController.java
│   └── ParameterController.java
├── dao/                          # MyBatis mapper interfaces
├── model/                        # Domain models
│   ├── User, Client, MeterReading, Bill, Invoice, Parameter
├── service/                      # Business logic
└── util/
    ├── BillingCalculator.java    # Billing formula calculations
    └── CurrencyConverter.java    # USD ↔ LBP conversion

src/main/resources/
├── application.properties
├── database/
│   ├── schema.sql                # MySQL DDL
│   └── sample-data.sql           # Initial data & demo clients
└── mapper/                       # MyBatis XML mappers

src/main/webapp/WEB-INF/jsp/      # JSP pages with jqGrid
src/main/webapp/css/              # Bootstrap + custom styles
src/main/webapp/js/               # jQuery utilities
```

---

## ⚙️ Setup & Installation

### Prerequisites
- Java 11+
- Maven 3.6+
- MySQL 8.0

### 1. Create the Database
```sql
-- Run schema
mysql -u root -p < src/main/resources/database/schema.sql

-- Load sample data (optional)
mysql -u root -p electricity_billing < src/main/resources/database/sample-data.sql
```

### 2. Configure Database Connection
Edit `src/main/resources/application.properties`:
```properties
spring.datasource.url=jdbc:mysql://localhost:3306/electricity_billing?useSSL=false&serverTimezone=UTC
spring.datasource.username=your_db_user
spring.datasource.password=your_db_password
```

### 3. Build & Run
```bash
# Build WAR
mvn clean package -DskipTests

# Run with embedded Tomcat
mvn spring-boot:run
```

The application starts at: **http://localhost:8080**

### 4. Default Login Credentials
| Username | Password  | Role  |
|----------|-----------|-------|
| admin    | admin123  | ADMIN |
| user1    | admin123  | USER  |

---

## 📊 Application Modules

| URL                | Description                              |
|--------------------|------------------------------------------|
| `/login`           | Login page                               |
| `/dashboard`       | Dashboard with key metrics               |
| `/clients`         | Client management (CRUD with jqGrid)     |
| `/meter-readings`  | Meter readings (editable jqGrid)         |
| `/billing`         | Bill generation for all client types     |
| `/invoices`        | Invoice management (read-only jqGrid)    |
| `/parameters`      | System parameter configuration           |

---

## 🧮 Billing Logic

```
// Meter-Based Client
consumptionCharge = (endReading - startReading) × pricePerKwh
subscriptionFee   = subscriptionFeePerAmpere × ampereCapacity
totalUSD          = consumptionCharge + subscriptionFee
totalLBP          = totalUSD × exchangeRate

// Amper-Based Client
ampereCharge    = pricePerAmpere × ampereCapacity
subscriptionFee = subscriptionFeePerAmpere × ampereCapacity
totalUSD        = ampereCharge + subscriptionFee
totalLBP        = totalUSD × exchangeRate
```

---

## 🧪 Tests

```bash
mvn test
```

Unit tests cover:
- `BillingCalculator` – all billing formula methods
- `CurrencyConverter` – USD ↔ LBP conversion
- Null input handling

---

## 📝 License

Apache License 2.0
