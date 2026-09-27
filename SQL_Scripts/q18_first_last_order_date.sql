-- Q18. Find each customer's first and last order date

CREATE TABLE orders5 (order_id INT, customer VARCHAR(5), order_date DATE);

INSERT INTO orders5 VALUES
(101,'C1','2024-01-05'),(102,'C1','2024-02-10'),(103,'C1','2024-03-01'),
(104,'C2','2024-01-20');

-- Approach: GROUP BY with MIN() and MAX()
SELECT customer,
       MIN(order_date) AS first_order_date,
       MAX(order_date) AS last_order_date
FROM orders5
GROUP BY customer;
