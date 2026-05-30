# Credit Card Fraud Detection — SQL Project

## Objective
Detect fraudulent credit card transactions using pattern analysis, risk scoring,
and anomaly detection techniques implemented entirely in MySQL.

---

## Tools Used
- Database: MySQL 8.0
- IDE: MySQL Workbench
- Language: SQL (DDL, DML, Analytical Queries)
- Dataset: Mock data representing Indian credit card transactions

---

## Database Schema

Three tables:

- cardholders — 200 records — name, age, city, card type, credit limit
- cards — 200 records — card status, issue date, expiry date
- transactions — 500 records — amount, merchant category, location, fraud flag, fraud reason

Relationships:
- cardholders to cards — one to one via cardholder_id
- cards to transactions — one to many via card_id

---

## Business Questions Answered

1. What is the overall fraud rate by transaction count and amount?
2. Which cities have the highest fraud rate?
3. Which merchant categories are most targeted for fraud?
4. What is the month on month fraud growth trend?
5. Which cardholders have fraud activity across multiple cities?
6. Which cards show rapid transaction patterns in a single day?
7. What is the fraud risk level of each cardholder?

---

## Key Insights from the Data

- Approximately 12% of all transactions are flagged as fraudulent
- High Amount is the most common fraud reason, contributing the largest fraud value
- Online transactions show a higher fraud rate compared to POS and ATM
- Certain cardholders show fraud activity in 2 or more cities — flagged as High Risk
- Electronics and Travel merchant categories show the highest fraud concentration
- Peak fraud activity observed in mid-year months based on monthly trend analysis

---

## SQL Concepts Used

- Multi-table JOINs across 3 tables
- GROUP BY with HAVING for conditional aggregation
- CASE statements for fraud classification and risk scoring
- CTEs using WITH clause for fraud stats and MoM growth
- Window Functions: RANK(), LAG(), SUM() OVER() with PARTITION BY
- Date functions: DATE_FORMAT, DATE() for daily and monthly grouping
- Aggregate functions: SUM, COUNT, AVG, ROUND, NULLIF

---

## Project Structure

- schema.sql — table creation scripts
- mock_data.sql — 500 rows of credit card transaction data
- queries/basic_queries.sql — fraud counts, transaction breakdown, card status
- queries/intermediate_queries.sql — fraud by city, merchant, cardholder analysis
- queries/advanced_queries.sql — CTEs, window functions, risk scoring

---

## How to Run

1. Open MySQL Workbench and connect to local server
2. Run schema.sql to create the database and tables
3. Run mock_data.sql to load all records
4. Open any file in the queries folder and execute

---

## Author

Arunkumar Shivanand Hallad 
MBA — Finance and Business Analytics
Acharya Bangalore B-School, Bengaluru
SEBI Investor Certified
