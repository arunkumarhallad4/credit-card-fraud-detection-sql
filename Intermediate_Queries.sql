-- =============================================
-- INTERMEDIATE QUERIES
-- =============================================

-- 1. Fraud rate by city
SELECT t.location AS city,
       COUNT(*) AS total_txns,
       SUM(t.is_fraud) AS fraud_count,
       ROUND(SUM(t.is_fraud) * 100.0 / COUNT(*), 2) AS fraud_rate_pct
FROM transactions t
GROUP BY t.location
ORDER BY fraud_rate_pct DESC;

-- 2. Top 10 cardholders with highest fraud amount
SELECT c.name, c.city, c.card_type,
       COUNT(t.txn_id) AS fraud_txns,
       ROUND(SUM(t.amount), 2) AS total_fraud_amount
FROM cardholders c
JOIN cards ca ON c.cardholder_id = ca.cardholder_id
JOIN transactions t ON ca.card_id = t.card_id
WHERE t.is_fraud = 1
GROUP BY c.cardholder_id, c.name, c.city, c.card_type
ORDER BY total_fraud_amount DESC
LIMIT 10;

-- 3. Monthly fraud trend
SELECT DATE_FORMAT(txn_date, '%Y-%m') AS month,
       COUNT(*) AS total_txns,
       SUM(is_fraud) AS fraud_count,
       ROUND(SUM(is_fraud) * 100.0 / COUNT(*), 2) AS fraud_rate_pct
FROM transactions
GROUP BY month
ORDER BY month;

-- 4. Fraud by transaction type
SELECT txn_type,
       COUNT(*) AS total_txns,
       SUM(is_fraud) AS fraud_count,
       ROUND(AVG(amount), 2) AS avg_fraud_amount
FROM transactions
WHERE is_fraud = 1
GROUP BY txn_type
ORDER BY fraud_count DESC;

-- 5. Cardholders exceeding 50% of credit limit in fraud transactions
SELECT c.name, c.city, c.credit_limit,
       ROUND(SUM(t.amount), 2) AS total_fraud_amount,
       ROUND(SUM(t.amount) * 100 / c.credit_limit, 2) AS pct_of_limit
FROM cardholders c
JOIN cards ca ON c.cardholder_id = ca.cardholder_id
JOIN transactions t ON ca.card_id = t.card_id
WHERE t.is_fraud = 1
GROUP BY c.cardholder_id, c.name, c.city, c.credit_limit
HAVING pct_of_limit > 50
ORDER BY pct_of_limit DESC;

-- 6. Most targeted merchant categories for fraud
SELECT merchant_category,
       SUM(is_fraud) AS fraud_count,
       ROUND(SUM(CASE WHEN is_fraud = 1 THEN amount ELSE 0 END), 2) AS fraud_amount,
       ROUND(SUM(is_fraud) * 100.0 / COUNT(*), 2) AS fraud_rate_pct
FROM transactions
GROUP BY merchant_category
ORDER BY fraud_count DESC;
