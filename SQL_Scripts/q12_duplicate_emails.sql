-- Q12. Find duplicate emails in the users table

CREATE TABLE users (
    user_id INT PRIMARY KEY,
    user_name VARCHAR(50),
    email VARCHAR(100)
);

INSERT INTO users VALUES
(1,'Ravi Kumar','ravi@example.com'),
(2,'Anita Sharma','anita@example.com'),
(3,'Ravi K','ravi@example.com'),
(4,'Neha Joshi','neha@example.com'),
(5,'Anita S','anita@example.com');

-- Approach: GROUP BY with HAVING
SELECT email, COUNT(*) AS occurences
FROM users
GROUP BY email
HAVING COUNT(*) > 1;
