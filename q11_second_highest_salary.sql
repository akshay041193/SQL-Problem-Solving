-- Q11. Find the second highest salary

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

-- NOTE: table is created as `Employee`; approaches below use `employees` --
-- make sure the name/casing matches your actual table before running.

-- Approach 1: Subquery with MAX() and WHERE
SELECT MAX(salary) AS second_highest_salary
FROM employees
WHERE salary < (SELECT MAX(salary) FROM employees);

-- Approach 2: DISTINCT with ORDER BY, LIMIT/OFFSET
SELECT DISTINCT salary AS second_highest_salary
FROM employees
ORDER BY salary DESC
LIMIT 1 OFFSET 1;

-- Approach 3: DENSE_RANK() window function
SELECT second_higest_salary
FROM (
    SELECT DISTINCT salary AS second_higest_salary,
           DENSE_RANK() OVER (ORDER BY salary DESC) AS ranking
    FROM employees
) t
WHERE ranking = 2;
