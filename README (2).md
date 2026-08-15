# 🏦 Banking Fraud Detection --- SQL Data Analytics Project

## 📌 Project Overview

This project analyzes banking transactions using **MySQL and SQL** to
identify potentially fraudulent transaction patterns and suspicious bank
accounts.

The analysis focuses on five major fraud-detection scenarios:

1.  Duplicate transactions
2.  Unusual transaction amounts
3.  Multiple transactions within a short period
4.  High-value transactions
5.  Suspicious accounts

The project is designed as a **Data Analyst portfolio project**
demonstrating practical SQL, data analysis, and fraud-detection logic.

------------------------------------------------------------------------

## 🎯 Business Problem

Banks process a large number of transactions every day. Some
transactions may indicate unusual or potentially fraudulent behavior.

The objective of this project is to use SQL to answer:

-   Are there duplicate transactions?
-   Which transactions have unusual amounts?
-   Are multiple transactions happening within a short time?
-   Which transactions are high-value?
-   Which accounts show multiple suspicious indicators?

------------------------------------------------------------------------

## 🗂️ Database Information

  Table              Records
  ---------------- ---------
  `customers`          1,000
  `accounts`           1,000
  `transactions`       1,000
  `locations`             50

This project uses a synthetic banking dataset created for educational
and portfolio purposes.

------------------------------------------------------------------------

## 🏗️ Database Schema

``` text
customers
    │
    │ customer_id
    ↓
accounts
    │
    │ account_id
    ↓
transactions
    │
    │ location_id
    ↓
locations
```

### Main Relationships

-   A customer can have one or more accounts.
-   An account can have multiple transactions.
-   Each transaction is associated with a location.
-   Transaction behavior is analyzed at both transaction and account
    level.

------------------------------------------------------------------------

## 📋 Tables

### 1. Customers

Contains customer-level information such as:

-   Customer ID
-   Customer name
-   Age
-   Gender
-   City
-   Occupation
-   Risk level

### 2. Accounts

Contains bank account information such as:

-   Account ID
-   Customer ID
-   Account type
-   Balance
-   Account status
-   Account opening date

### 3. Transactions

Contains transaction-level information such as:

-   Transaction ID
-   Account ID
-   Transaction date
-   Transaction type
-   Amount
-   Location ID
-   Merchant name
-   Payment method
-   Transaction status

### 4. Locations

Contains geographical information such as:

-   Location ID
-   City
-   State
-   Country

------------------------------------------------------------------------

# 🔍 Fraud Detection Analysis

## 1️⃣ Duplicate Transactions

### Business Question

> Find transactions that appear more than once with the same account,
> date/time, amount, and merchant.

### SQL

``` sql
SELECT
    account_id,
    transaction_date,
    amount,
    merchant_name,
    COUNT(*) AS transaction_count
FROM transactions
GROUP BY
    account_id,
    transaction_date,
    amount,
    merchant_name
HAVING COUNT(*) > 1;
```

### SQL Concepts

-   GROUP BY
-   COUNT()
-   HAVING

------------------------------------------------------------------------

## 2️⃣ Unusual Transaction Amounts

### Business Question

> Find transactions whose amount is significantly higher than the normal
> transaction amount for that account.

An account-level average is calculated and transactions above **3× the
account average** are flagged.

### SQL

``` sql
SELECT
    t.transaction_id,
    t.account_id,
    t.transaction_date,
    t.amount,
    a.average_amount
FROM transactions t
JOIN (
    SELECT
        account_id,
        AVG(amount) AS average_amount
    FROM transactions
    GROUP BY account_id
) a
ON t.account_id = a.account_id
WHERE t.amount > a.average_amount * 3
ORDER BY t.amount DESC;
```

### SQL Concepts

-   Subquery
-   AVG()
-   JOIN
-   WHERE
-   GROUP BY

------------------------------------------------------------------------

## 3️⃣ Multiple Transactions Within 10 Minutes

### Business Question

> Find accounts that perform 3 or more transactions within a 10-minute
> period.

A **Self JOIN** is used to compare transactions from the same account.

### SQL

``` sql
SELECT
    t1.transaction_id,
    t1.account_id,
    t1.transaction_date,
    t1.amount,
    COUNT(t2.transaction_id) AS txn_count
FROM transactions t1
JOIN transactions t2
    ON t1.account_id = t2.account_id
    AND t2.transaction_date BETWEEN
        t1.transaction_date - INTERVAL 10 MINUTE
        AND t1.transaction_date
GROUP BY
    t1.transaction_id,
    t1.account_id,
    t1.transaction_date,
    t1.amount
HAVING COUNT(t2.transaction_id) >= 3
ORDER BY
    t1.account_id,
    t1.transaction_date;
```

### SQL Concepts

-   Self JOIN
-   Date/time functions
-   INTERVAL
-   COUNT()
-   GROUP BY
-   HAVING

------------------------------------------------------------------------

## 4️⃣ High-Value Transactions

### Business Question

> Find transactions with an amount of ₹1,00,000 or more.

### SQL

``` sql
SELECT
    transaction_id,
    account_id,
    transaction_date,
    amount,
    transaction_type,
    merchant_name
FROM transactions
WHERE amount >= 100000
ORDER BY amount DESC;
```

### Risk Classification

``` sql
SELECT
    transaction_id,
    account_id,
    amount,
    CASE
        WHEN amount >= 500000 THEN 'Critical'
        WHEN amount >= 200000 THEN 'High'
        WHEN amount >= 100000 THEN 'Medium'
        ELSE 'Normal'
    END AS transaction_risk
FROM transactions
ORDER BY amount DESC;
```

### SQL Concepts

-   WHERE
-   CASE WHEN
-   ORDER BY

------------------------------------------------------------------------

# 🚨 5️⃣ Suspicious Accounts

Instead of considering a single transaction as fraud, multiple
indicators are combined to identify suspicious accounts.

## Fraud Scoring Rules

  Indicator                                Score
  -------------------------------------- -------
  High-value transaction                      +2
  Failed transaction                          +1
  Unknown merchant                            +2
  More than 100 transactions                  +2
  Total transaction amount \> ₹10 lakh        +3

## Risk Classification

    Fraud Score Risk Level
  ------------- ------------
           0--2 Low
           3--5 Medium
           6--9 High
            10+ Critical

### Example Logic

``` text
High-value transactions
        +
Failed transactions
        +
Unknown merchant activity
        +
High transaction volume
        +
High total transaction amount
        ↓
   Fraud Score
        ↓
   Risk Level
```

> The scoring thresholds are analytical rules created for this portfolio
> project and are not intended to represent a real bank's production
> fraud model.

------------------------------------------------------------------------

# 🧠 SQL Skills Demonstrated

This project demonstrates practical SQL skills including:

-   SELECT
-   WHERE
-   GROUP BY
-   HAVING
-   ORDER BY
-   COUNT()
-   SUM()
-   AVG()
-   CASE WHEN
-   Conditional aggregation
-   Subqueries
-   CTEs
-   INNER JOIN
-   Self JOIN
-   Date and time analysis
-   Window functions
-   Ranking functions
-   Fraud scoring
-   Risk classification

------------------------------------------------------------------------

# 📊 Suggested KPIs

The project can be extended into a Power BI dashboard using:

-   Total Customers
-   Total Accounts
-   Total Transactions
-   Total Transaction Amount
-   High-Value Transactions
-   Duplicate Transactions
-   Failed Transactions
-   Suspicious Accounts
-   High-Risk Accounts
-   Critical-Risk Accounts
-   Average Transaction Amount
-   Transaction Volume by Month
-   Transaction Volume by Type
-   Transaction Amount by Location

------------------------------------------------------------------------

# 📁 Recommended GitHub Structure

``` text
banking-fraud-detection/
│
├── data/
│   ├── customers.csv
│   ├── accounts.csv
│   ├── transactions.csv
│   └── locations.csv
│
├── sql/
│   ├── 01_database_setup.sql
│   ├── 02_data_validation.sql
│   ├── 03_duplicate_transactions.sql
│   ├── 04_unusual_amounts.sql
│   ├── 05_rapid_transactions.sql
│   ├── 06_high_value_transactions.sql
│   └── 07_suspicious_accounts.sql
│
├── dashboard/
│   └── banking_fraud_dashboard.pbix
│
└── README.md
```

------------------------------------------------------------------------

# ⚙️ How to Run the Project

### Step 1 --- Create Database

``` sql
CREATE DATABASE banking_fraud_detection;

USE banking_fraud_detection;
```

### Step 2 --- Create Tables

Create the following tables:

``` text
customers
accounts
transactions
locations
```

### Step 3 --- Import CSV Data

Import the four CSV files into MySQL Workbench.

### Step 4 --- Validate Records

``` sql
SELECT COUNT(*) FROM customers;
SELECT COUNT(*) FROM accounts;
SELECT COUNT(*) FROM transactions;
SELECT COUNT(*) FROM locations;
```

Expected:

``` text
Customers     → 1,000
Accounts      → 1,000
Transactions  → 1,000
Locations     → 50
```

### Step 5 --- Run Analysis

Execute the fraud detection SQL queries from the `sql/` folder.

------------------------------------------------------------------------

# 🚀 Future Improvements

The project can be upgraded with:

-   Power BI fraud detection dashboard
-   Location-based anomaly detection
-   Multiple-location transaction analysis
-   Transaction velocity scoring
-   Customer risk profiling
-   Advanced CTE-based fraud scoring
-   Statistical anomaly detection
-   Machine Learning fraud prediction
-   Automated fraud alert reporting

------------------------------------------------------------------------

# 💼 Resume Description

**Banking Fraud Detection --- SQL Data Analytics Project**

> Developed a SQL-based banking fraud detection project using 1,000
> banking transactions to identify duplicate transactions, unusual
> transaction amounts, rapid transaction activity, high-value
> transactions, and suspicious accounts. Applied SQL aggregations,
> subqueries, CASE expressions, self joins, date-time analysis, and
> account-level fraud scoring to classify potentially suspicious
> activity into different risk levels.

------------------------------------------------------------------------

# 🧰 Tech Stack

-   **Database:** MySQL
-   **Query Tool:** MySQL Workbench
-   **Analysis:** SQL
-   **Visualization:** Power BI
-   **Version Control:** Git & GitHub

------------------------------------------------------------------------

# ⚠️ Disclaimer

This project uses synthetic data for educational and portfolio purposes.

The fraud detection rules and risk scores are analytical examples and
should not be used for real-world banking decisions.

------------------------------------------------------------------------

# 👨‍💻 Author

**Govind Vaid**

Data Analyst Aspirant\
SQL \| Python \| Excel \| Power BI

------------------------------------------------------------------------

⭐ **If you found this project useful, feel free to star the repository
and explore the SQL analysis.**
