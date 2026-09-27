-- Q14. Find employees who earn more than their department's average salary

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

-- Approach: Window function AVG() OVER (PARTITION BY department)
SELECT *
FROM (
    SELECT emp_name,
           department,
           salary,
           AVG(salary) OVER (PARTITION BY department) AS dept_avg
    FROM dept_staff
) t
WHERE salary > dept_avg;

-- Result: Sales average is 60000 and IT average is 70000, so Anita Sharma
-- (70000 in Sales) and Vikram Singh (90000 in IT) qualify.
