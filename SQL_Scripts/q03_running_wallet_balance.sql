-- Q3. Calculate running wallet balance per customer
-- CREDIT adds to the balance, DEBIT subtracts from it.

CREATE TABLE wallet_transactions (
    txn_id INT PRIMARY KEY,
    customer_id INT,
    txn_date DATE,
    txn_type VARCHAR(10),   -- CREDIT or DEBIT
    amount DECIMAL(10,2)
);

INSERT INTO wallet_transactions VALUES
(1,1,'2024-01-01','CREDIT',1000.00),
(2,1,'2024-01-03','DEBIT',200.00),
(3,1,'2024-01-05','CREDIT',500.00),
(4,1,'2024-01-07','DEBIT',300.00),
(5,2,'2024-01-01','CREDIT',2000.00),
(6,2,'2024-01-04','DEBIT',700.00);

-- Approach: Window function with SUM() OVER
SELECT customer_id, txn_date, txn_type, amount,
       SUM(
           CASE
               WHEN txn_type = 'CREDIT' THEN amount
               WHEN txn_type = 'DEBIT' THEN -amount
               ELSE 0
           END
       ) OVER (PARTITION BY customer_id ORDER BY txn_date) AS running_balance
FROM wallet_transactions;
