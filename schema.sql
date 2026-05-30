-- Credit Card Fraud Detection
-- Schema: 3 tables

CREATE DATABASE IF NOT EXISTS fraud_detection;
USE fraud_detection;

CREATE TABLE cardholders (
    cardholder_id INT PRIMARY KEY,
    name VARCHAR(100),
    age INT,
    city VARCHAR(50),
    card_type VARCHAR(20),      -- Visa, Mastercard, Rupay
    credit_limit DECIMAL(10,2)
);

CREATE TABLE cards (
    card_id INT PRIMARY KEY,
    cardholder_id INT,
    card_number VARCHAR(20),
    issue_date DATE,
    expiry_date DATE,
    status VARCHAR(20),         -- Active, Blocked, Expired
    FOREIGN KEY (cardholder_id) REFERENCES cardholders(cardholder_id)
);

CREATE TABLE transactions (
    txn_id INT PRIMARY KEY,
    card_id INT,
    txn_date DATETIME,
    amount DECIMAL(10,2),
    merchant_category VARCHAR(50), -- Shopping, Travel, Food, Electronics, ATM
    location VARCHAR(50),
    txn_type VARCHAR(20),          -- Online, POS, ATM
    is_fraud TINYINT(1),           -- 0 = Legitimate, 1 = Fraud
    fraud_reason VARCHAR(100),     -- NULL, High Amount, Unusual Location, Rapid Transactions
    FOREIGN KEY (card_id) REFERENCES cards(card_id)
);
