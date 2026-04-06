# Electricity Generator Billing System

A comprehensive web-based billing management system for electricity generator services. Built with **Spring Boot**, **JSP/JSTL**, **jqGrid**, **MyBatis**, and **MySQL**.

## Features

- ✅ **Authentication & Authorization** — Login/logout with role-based access (Admin, Operator, Viewer)
- ✅ **Customer Management** — Create/edit customers with meter or amper billing types
- ✅ **Zone & Box Management** — Hierarchical zone → box → customer structure
- ✅ **Parameter Configuration** — Configurable price per kWh, per amper, subscription fees, exchange rates
- ✅ **Issuance Management** — Monthly billing issuances with exchange rate tracking
- ✅ **Trial & Final Billing** — Preview billing before committing to final records
- ✅ **PDF Invoice Generation** — Separate layouts for meter-based and amper-based clients
- ✅ **Multi-Language Support** — English and Arabic with dynamic translation management
- ✅ **Audit Logging** — Track all user actions and billing operations
- ✅ **jqGrid Tables** — Readonly and inline-editable grids for all entities

## Technology Stack

| Layer | Technology |
|-------|-----------|
| Backend | Spring Boot 2.7.x, Spring MVC, Spring Security |
| Frontend | JSP + JSTL, Bootstrap 4, Font Awesome |
| Grid Component | jqGrid (free-jqgrid 4.15.5) |
| JavaScript | jQuery 3.6, Bootstrap JS |
| Data Access | MyBatis 3 with XML mappers |
| Database | MySQL 8.0 |
| PDF Generation | iText PDF 5.5.x |
| Build Tool | Maven 3.x |

## Prerequisites

- **Java 11** or later
- **Maven 3.6+**
- **MySQL 8.0+**

## Setup Instructions

### 1. Database Setup

Create the database and run the schema:

```bash
mysql -u root -p < src/main/resources/schema.sql
```

This creates:
- The `electricity_billing` database
- All required tables (users, roles, zones, boxes, customers, parameters, issuances, bills, translations, audit_logs)
- Default data (admin user, roles, parameters, translations)

**Default admin credentials:**
- Username: `admin`
- Password: `admin123`

### 2. Configure Application

Edit `src/main/resources/application.properties`:

```properties
spring.datasource.url=jdbc:mysql://localhost:3306/electricity_billing?useSSL=false&serverTimezone=UTC
spring.datasource.username=your_db_username
spring.datasource.password=your_db_password
```

### 3. Build and Run

```bash
# Build the project
mvn clean package -DskipTests

# Run with embedded Tomcat
mvn spring-boot:run
```

The application will be available at: `http://localhost:8080/ebilling`

### 4. Deploy to External Tomcat (Optional)

```bash
mvn clean package -DskipTests
# Copy target/electricity-billing-system-1.0.0.war to Tomcat's webapps directory
```

## Project Structure

```
src/
├── main/
│   ├── java/com/electricity/
│   │   ├── ElectricityBillingApplication.java
│   │   ├── config/           # Security, Web MVC, UserDetailsService
│   │   ├── controller/       # REST + MVC controllers for all features
│   │   ├── model/            # Domain entities (User, Customer, Zone, Box, etc.)
│   │   ├── mapper/           # MyBatis mapper interfaces
│   │   ├── service/          # Service interfaces and implementations
│   │   ├── dto/              # GridResponse, ApiResponse, BillingResult
│   │   └── util/             # PdfGenerator, MeterReadingPair
│   ├── resources/
│   │   ├── application.properties
│   │   ├── schema.sql
│   │   └── mapper/           # MyBatis XML mapper files
│   └── webapp/
│       ├── WEB-INF/jsp/      # JSP pages for all screens
│       └── static/           # CSS and JavaScript files
```

## Default User Roles

| Role | Access |
|------|--------|
| ROLE_ADMIN | Full access including user management |
| ROLE_OPERATOR | Customers, billing, issuances, parameters |
| ROLE_VIEWER | Read-only access to all views |

## Billing Workflow

1. **Create Parameters** — Set price per kWh, per amper, subscription fee, exchange rate
2. **Create Zones & Boxes** — Define geographic/organizational structure
3. **Add Customers** — Assign to boxes, choose billing type (Meter or Amper)
4. **Create Issuance** — Select billing month and exchange rate
5. **Trial Billing** — Preview calculations without saving
6. **Final Billing** — Commit billing to database
7. **Generate PDF** — Print invoices for customers

## License

Apache License 2.0 — see [LICENSE](LICENSE) for details.
