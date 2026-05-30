-- =============================================
-- BASIC QUERIES
-- =============================================

-- 1. Total number of transactions
SELECT COUNT(*) AS total_transactions FROM transactions;

-- 2. Total fraud vs legitimate transactions
SELECT 
    CASE WHEN is_fraud = 1 THEN 'Fraud' ELSE 'Legitimate' END AS txn_status,
    COUNT(*) AS count,
    ROUND(SUM(amount), 2) AS total_amount
FROM transactions
GROUP BY is_fraud;

-- 3. Fraud transactions by reason
SELECT fraud_reason, COUNT(*) AS count, ROUND(SUM(amount), 2) AS total_amount
FROM transactions
WHERE is_fraud = 1
GROUP BY fraud_reason
ORDER BY count DESC;

-- 4. Transactions by merchant category
SELECT merchant_category, COUNT(*) AS total_txns,
       ROUND(SUM(amount), 2) AS total_amount
FROM transactions
GROUP BY merchant_category
ORDER BY total_txns DESC;

-- 5. Transactions by type (Online, POS, ATM)
SELECT txn_type, COUNT(*) AS count,
       ROUND(SUM(amount), 2) AS total_amount
FROM transactions
GROUP BY txn_type
ORDER BY count DESC;

-- 6. Cards by status
SELECT status, COUNT(*) AS count
FROM cards
GROUP BY status;

-- 7. Cardholders by card type
SELECT card_type, COUNT(*) AS count
FROM cardholders
GROUP BY card_type;

-- 8. High value fraud transactions above 1 lakh
SELECT txn_id, card_id, txn_date, amount, location, fraud_reason
FROM transactions
WHERE is_fraud = 1 AND amount > 100000
ORDER BY amount DESC;
