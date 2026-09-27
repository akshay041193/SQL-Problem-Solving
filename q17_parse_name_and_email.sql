-- Q17. Extract first name, last name, initials, and email domain from raw text fields

CREATE TABLE users6 (id INT, full_name VARCHAR(40), email VARCHAR(50));

INSERT INTO users6 VALUES
(1,'Ravi Kumar','ravi.kumar@gmail.com'),
(2,'Anita S Sharma','anita@yahoo.co.in'),
(3,'Vikram Singh Rao','vikram_rao@company.org');

-- Approach: SUBSTRING_INDEX() and CONCAT() string functions
-- Note: email_host is the full domain (e.g. gmail.com); email_tld is just
-- the top-level domain (e.g. com). The original draft aliased both as
-- "email_domain", which MySQL allows but is ambiguous -- renamed here.
SELECT SUBSTRING_INDEX(full_name, ' ', 1) AS first_name,
       SUBSTRING_INDEX(full_name, ' ', -1) AS last_name,
       CONCAT(LEFT(SUBSTRING_INDEX(full_name, ' ', 1), 1), LEFT(SUBSTRING_INDEX(full_name, ' ', -1), 1)) AS initials,
       SUBSTRING_INDEX(email, '@', -1) AS email_host,
       SUBSTRING_INDEX(email, '.', -1) AS email_tld
FROM users6;
