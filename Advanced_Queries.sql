-- =============================================
-- ADVANCED QUERIES (CTEs & Window Functions)
-- =============================================

-- 1. Rank cardholders by fraud amount within each city
SELECT c.name, c.city,
       ROUND(SUM(t.amount), 2) AS total_fraud_amount,
       RANK() OVER (PARTITION BY c.city ORDER BY SUM(t.amount) DESC) AS city_rank
FROM cardholders c
JOIN cards ca ON c.cardholder_id = ca.cardholder_id
JOIN transactions t ON ca.card_id = t.card_id
WHERE t.is_fraud = 1
GROUP BY c.cardholder_id, c.name, c.city;

-- 2. Month over month fraud growth using LAG
WITH monthly_fraud AS (
    SELECT DATE_FORMAT(txn_date, '%Y-%m') AS month,
           SUM(is_fraud) AS fraud_count
    FROM transactions
    GROUP BY month
)
SELECT month,
       fraud_count,
       LAG(fraud_count) OVER (ORDER BY month) AS prev_month,
       ROUND(
           (fraud_count - LAG(fraud_count) OVER (ORDER BY month)) * 100.0 /
           NULLIF(LAG(fraud_count) OVER (ORDER BY month), 0), 2
       ) AS growth_pct
FROM monthly_fraud;

-- 3. Running total of fraud amount per card
SELECT txn_id, card_id, txn_date, amount,
       ROUND(SUM(amount) OVER (PARTITION BY card_id ORDER BY txn_date), 2) AS running_fraud_total
FROM transactions
WHERE is_fraud = 1
ORDER BY card_id, txn_date;

-- 4. Cards with rapid transactions (3 or more transactions within same day)
SELECT card_id,
       DATE(txn_date) AS txn_day,
       COUNT(*) AS txn_count,
       ROUND(SUM(amount), 2) AS total_amount
FROM transactions
GROUP BY card_id, DATE(txn_date)
HAVING txn_count >= 3
ORDER BY txn_count DESC;

-- 5. High risk cardholders: fraud in more than one city
SELECT c.name, c.city AS home_city,
       COUNT(DISTINCT t.location) AS fraud_locations,
       ROUND(SUM(t.amount), 2) AS total_fraud_amount
FROM cardholders c
JOIN cards ca ON c.cardholder_id = ca.cardholder_id
JOIN transactions t ON ca.card_id = t.card_id
WHERE t.is_fraud = 1
GROUP BY c.cardholder_id, c.name, c.city
HAVING fraud_locations > 1
ORDER BY fraud_locations DESC;

-- 6. Fraud risk score per cardholder using CTE
WITH fraud_stats AS (
    SELECT ca.cardholder_id,
           COUNT(*) AS fraud_txns,
           ROUND(SUM(t.amount), 2) AS fraud_amount,
           COUNT(DISTINCT t.location) AS fraud_cities
    FROM transactions t
    JOIN cards ca ON t.card_id = ca.card_id
    WHERE t.is_fraud = 1
    GROUP BY ca.cardholder_id
)
SELECT c.name, c.city, c.credit_limit,
       fs.fraud_txns, fs.fraud_amount, fs.fraud_cities,
       CASE
           WHEN fs.fraud_txns >= 3 AND fs.fraud_cities > 1 THEN 'High Risk'
           WHEN fs.fraud_txns >= 2 OR fs.fraud_amount > 100000 THEN 'Medium Risk'
           ELSE 'Low Risk'
       END AS risk_level
FROM cardholders c
JOIN fraud_stats fs ON c.cardholder_id = fs.cardholder_id
ORDER BY fs.fraud_amount DESC;
