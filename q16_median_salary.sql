-- Q16. Calculate the median salary
-- Computes the median across all employees (no PARTITION BY dept).
-- Add PARTITION BY dept to both window functions to get the median per department.

CREATE TABLE emp2 (name VARCHAR(10), dept VARCHAR(10), salary INT);

INSERT INTO emp2 VALUES
('A','Eng',60000),('B','Eng',70000),('C','Eng',80000),('D','Eng',90000),
('E','Sales',50000),('F','Sales',60000),('G','Sales',70000);

-- Approach: ROW_NUMBER() + COUNT() OVER(), averaging the middle rank(s)
-- FLOOR((total+1)/2) and FLOOR((total+2)/2) pick the single middle value
-- for an odd count, and the two middle values (then averaged) for an even count.
SELECT AVG(salary) AS median_salary
FROM (
  SELECT salary,
    ROW_NUMBER() OVER (ORDER BY salary) AS ranking,
    COUNT(*)     OVER ()                AS total
  FROM emp2
) t
WHERE ranking IN (FLOOR((total + 1) / 2),
                  FLOOR((total + 2) / 2));

-- Result: sorted salaries are 50000, 60000, 60000, 70000, 70000, 80000, 90000
-- with 7 values, the median is the 4th value: 70000.
