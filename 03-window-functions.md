# Window Functions

Queries built around `OVER()`, `PARTITION BY`, and ranking/offset functions (`ROW_NUMBER`, `DENSE_RANK`, `LEAD`, `LAG`, running `SUM`/`AVG`).

---

### Q3. Calculate running wallet balance per customer

For each transaction, show a running balance per customer over time, where `CREDIT` adds to the balance and `DEBIT` subtracts from it.

```sql
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
```

**Approach: Window function with SUM() OVER**

```sql
SELECT customer_id, txn_date, txn_type, amount,
       SUM(
           CASE
               WHEN txn_type = 'CREDIT' THEN amount
               WHEN txn_type = 'DEBIT' THEN -amount
               ELSE 0
           END
       ) OVER (PARTITION BY customer_id ORDER BY txn_date) AS running_balance
FROM wallet_transactions;
```

---

### Q7. Find the top-selling product in each category

For each category, find the product with the highest total quantity sold.

```sql
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(50),
    category VARCHAR(30)
);

CREATE TABLE sales (
    sale_id INT PRIMARY KEY,
    product_id INT,
    quantity_sold INT,
    sale_date DATE
);

INSERT INTO products VALUES
(1,'Colgate Toothpaste','Personal Care'),
(2,'Dove Soap','Personal Care'),
(3,'Tata Salt','Grocery'),
(4,'Aashirvaad Atta','Grocery'),
(5,'Lays Chips','Snacks'),
(6,'Kurkure','Snacks');

INSERT INTO sales VALUES
(1,1,50,'2024-01-01'),
(2,2,80,'2024-01-02'),
(3,3,120,'2024-01-03'),
(4,4,150,'2024-01-04'),
(5,5,200,'2024-01-05'),
(6,6,90,'2024-01-06'),
(7,1,30,'2024-01-07'),
(8,4,60,'2024-01-08');
```

**Approach: Two CTEs — aggregate, then rank with ROW_NUMBER()**

```sql
WITH total_quan_sold AS (
    SELECT p.category AS category,
           p.product_name AS product_name,
           SUM(s.quantity_sold) AS total_quantity
    FROM products p
    LEFT JOIN sales s
        ON p.product_id = s.product_id
    GROUP BY p.category, p.product_name
),
ranked_products AS (
    SELECT
        category,
        product_name,
        total_quantity,
        ROW_NUMBER() OVER (
            PARTITION BY category
            ORDER BY total_quantity DESC
        ) AS ranks
    FROM total_quan_sold
)

SELECT *
FROM ranked_products
WHERE ranks = 1
ORDER BY total_quantity;
```

---

### Q9. Detect customers who downgraded to the FREE plan

Find customers who moved from a paid plan (`BASIC` or `PRO`) to the `FREE` plan, along with the date of the downgrade.

```sql
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
```

**Approach: LEAD() to compare each plan with the next one**

```sql
SELECT customer_id, from_plan, next_plan, downgrade_date
FROM (
    SELECT customer_id,
           plan_type AS from_plan,
           LEAD(plan_type) OVER (PARTITION BY customer_id ORDER BY start_date) AS next_plan,
           LEAD(start_date) OVER (PARTITION BY customer_id ORDER BY start_date) AS downgrade_date
    FROM subscriptions
) t
WHERE from_plan IN ('BASIC', 'PRO') AND next_plan = 'FREE';
```

---

### Q11. Find the second highest salary

```sql
CREATE TABLE Employee (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    salary INT
);

INSERT INTO Employee VALUES
(1,'Ravi Kumar',90000),
(2,'Anita Sharma',85000),
(3,'Vikram Singh',85000),
(4,'Neha Joshi',70000),
(5,'Suresh Rao',60000);
```

**Approach 1: Subquery with MAX() and WHERE**

```sql
SELECT MAX(salary) AS second_highest_salary
FROM employees
WHERE salary < (SELECT MAX(salary) FROM employees);
```

**Approach 2: DISTINCT with ORDER BY, LIMIT/OFFSET**

```sql
SELECT DISTINCT salary AS second_highest_salary
FROM employees
ORDER BY salary DESC
LIMIT 1 OFFSET 1;
```

**Approach 3: DENSE_RANK() window function**

```sql
SELECT second_higest_salary
FROM (
    SELECT DISTINCT salary AS second_higest_salary,
           DENSE_RANK() OVER (ORDER BY salary DESC) AS ranking
    FROM employees
) t
WHERE ranking = 2;
```

> Note: Approaches use the table name `employees` (lowercase) — make sure it matches the actual table name/casing in your database, since the table above is created as `Employee`.

---

### Q14. Find employees who earn more than their department's average salary

```sql
CREATE TABLE dept_staff (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    department VARCHAR(30),
    salary INT
);

INSERT INTO dept_staff VALUES
(1,'Ravi Kumar','Sales',50000),
(2,'Anita Sharma','Sales',70000),
(3,'Vikram Singh','IT',90000),
(4,'Neha Joshi','IT',60000),
(5,'Suresh Rao','IT',60000);
```

**Approach: Window function AVG() OVER (PARTITION BY department)**

```sql
SELECT *
FROM (
    SELECT emp_name,
           department,
           salary,
           AVG(salary) OVER (PARTITION BY department) AS dept_avg
    FROM dept_staff
) t
WHERE salary > dept_avg;
```

Result: Sales average is 60,000 and IT average is 70,000, so **Anita Sharma** (70,000 in Sales) and **Vikram Singh** (90,000 in IT) qualify.

---

### Q15. Calculate month-over-month sales growth percentage

```sql
CREATE TABLE monthly_sales (
    sale_id INT PRIMARY KEY,
    sale_date DATE,
    amount INT
);

INSERT INTO monthly_sales VALUES
(1,'2024-01-05',6000),
(2,'2024-01-20',4000),
(3,'2024-02-10',15000),
(4,'2024-03-15',12000),
(5,'2024-04-08',10000),
(6,'2024-04-22',8000),
(7,'2024-05-15',9000),
(8,'2024-06-10',9000);
```

**Approach: CTE to roll up monthly totals, then LAG() for growth %**

```sql
WITH monthly AS (
    SELECT
        DATE_FORMAT(sale_date, '%Y-%m') AS sales_month,
        SUM(amount) AS total_sales
    FROM monthly_sales
    GROUP BY DATE_FORMAT(sale_date, '%Y-%m')
)
SELECT
    sales_month,
    total_sales,
    LAG(total_sales) OVER (ORDER BY sales_month) AS prev_month_sales,
    ROUND(
        (total_sales - LAG(total_sales) OVER (ORDER BY sales_month))
        / LAG(total_sales) OVER (ORDER BY sales_month) * 100
    , 2) AS growth_pct
FROM monthly
ORDER BY sales_month;
```

> Note: the first month in the series will have `NULL` for `prev_month_sales` and `growth_pct` since there's no prior month to compare against.

---

### Q16. Calculate the median salary

```sql
CREATE TABLE emp2 (name VARCHAR(10), dept VARCHAR(10), salary INT);

INSERT INTO emp2 VALUES
('A','Eng',60000),('B','Eng',70000),('C','Eng',80000),('D','Eng',90000),
('E','Sales',50000),('F','Sales',60000),('G','Sales',70000);
```

**Approach: ROW_NUMBER() + COUNT() OVER(), averaging the middle rank(s)**

Using `FLOOR((total+1)/2)` and `FLOOR((total+2)/2)` picks the single middle value for an odd count, and the two middle values (whose average is then taken) for an even count.

```sql
SELECT AVG(salary) AS median_salary
FROM (
  SELECT salary,
    ROW_NUMBER() OVER (ORDER BY salary) AS ranking,
    COUNT(*)     OVER ()                AS total
  FROM emp2
) t
WHERE ranking IN (FLOOR((total + 1) / 2),
                  FLOOR((total + 2) / 2));
```

> Note: this computes the median across **all** employees (no `PARTITION BY dept`). Sorted salaries are 50000, 60000, 60000, 70000, 70000, 80000, 90000 — with 7 values, the median is the 4th value, **70000**. To get the median per department instead, add `PARTITION BY dept` to both window functions.

---

<!-- Add new window function questions below this line -->
