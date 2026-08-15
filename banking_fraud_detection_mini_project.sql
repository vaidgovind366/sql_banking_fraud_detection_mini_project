USE banking_fraud_detection;


SELECT 
    *
FROM
    accounts;

SELECT 
    *
FROM
    customers;

SELECT 
    *
FROM
    locations;

SELECT 
    *
FROM
    transactions;
 
 
 -- Duplicate Transactions
 
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



-- Unusual Transaction Amounts

SELECT
    account_id,
    transaction_id,
    amount
FROM transactions
WHERE amount > (
    SELECT AVG(amount) * 3
    FROM transactions
);


-- Multiple Transactions Within a Short Period

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
ORDER BY t1.account_id, t1.transaction_date;



-- High-Value Transactions

SELECT
    transaction_id,
    account_id,
    amount,
    transaction_date
FROM transactions
WHERE amount >= 100000
ORDER BY amount DESC;




-- Suspicious Accounts

SELECT
    account_id,

    COUNT(*) AS total_transactions,

    SUM(
        CASE
            WHEN amount >= 100000 THEN 1
            ELSE 0
        END
    ) AS high_value_transactions,

    SUM(
        CASE
            WHEN transaction_status = 'Failed' THEN 1
            ELSE 0
        END
    ) AS failed_transactions,

    SUM(
        CASE
            WHEN merchant_name = 'Unknown Merchant' THEN 1
            ELSE 0
        END
    ) AS unknown_merchant_transactions,

    SUM(amount) AS total_transaction_amount

FROM transactions
GROUP BY account_id;