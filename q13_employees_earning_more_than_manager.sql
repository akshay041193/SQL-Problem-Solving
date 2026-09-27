-- Q13. Find employees who earn more than their manager

CREATE TABLE companyEmployee (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    salary INT,
    manager_id INT   -- references companyEmployee.emp_id; NULL for the CEO
);

INSERT INTO companyEmployee VALUES
(1,'Ravi Kumar',60000,NULL),
(2,'Anita Sharma',80000,1),
(3,'Vikram Singh',50000,1),
(4,'Neha Joshi',70000,2),
(5,'Suresh Rao',90000,2);

-- Approach: Self-join on manager_id = emp_id
SELECT e.emp_name AS employee_name,
       e.salary AS employee_salary,
       m.emp_name AS manager_name,
       m.salary AS manager_salary
FROM companyEmployee e
JOIN companyEmployee m
    ON e.manager_id = m.emp_id
WHERE e.salary > m.salary;

-- Result: Anita Sharma (80000) earns more than her manager Ravi Kumar (60000),
-- and Suresh Rao (90000) earns more than his manager Anita Sharma (80000).
