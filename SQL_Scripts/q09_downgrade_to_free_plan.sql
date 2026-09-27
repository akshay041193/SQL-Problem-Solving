-- Q9. Detect customers who downgraded to the FREE plan
-- Customers who moved from a paid plan (BASIC or PRO) to FREE, with the downgrade date.

CREATE TABLE subscriptions (
    subscription_id INT PRIMARY KEY,
    customer_id INT,
    plan_type VARCHAR(20),   -- FREE, BASIC, PRO
    start_date DATE,
    end_date DATE
);

INSERT INTO subscriptions VALUES
(1,1,'BASIC','2024-01-01','2024-02-01'),
(2,1,'FREE','2024-02-01',NULL),
(3,2,'PRO','2024-01-01','2024-03-01'),
(4,2,'PRO','2024-03-01',NULL),
(5,3,'FREE','2024-01-01','2024-02-01'),
(6,3,'BASIC','2024-02-01',NULL);

-- Approach: LEAD() to compare each plan with the next one
SELECT customer_id, from_plan, next_plan, downgrade_date
FROM (
    SELECT customer_id,
           plan_type AS from_plan,
           LEAD(plan_type) OVER (PARTITION BY customer_id ORDER BY start_date) AS next_plan,
           LEAD(start_date) OVER (PARTITION BY customer_id ORDER BY start_date) AS downgrade_date
    FROM subscriptions
) t
WHERE from_plan IN ('BASIC', 'PRO') AND next_plan = 'FREE';
