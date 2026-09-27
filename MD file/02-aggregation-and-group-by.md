# Aggregation & GROUP BY / HAVING

Queries centered on `GROUP BY`, `HAVING`, and aggregate functions (`SUM`, `COUNT`, `AVG`, `MIN`, `MAX`), including conditional/pivot-style aggregation.

---

### Q2. Find the average delivery time per restaurant

Table includes orders that are still in transit / undelivered (`delivery_time IS NULL`). These should be excluded automatically since `TIMESTAMPDIFF` against a `NULL` value returns `NULL`, and `AVG()` ignores `NULL`s.

```sql
CREATE TABLE orders1 (
    order_id INT PRIMARY KEY,
    restaurant_name VARCHAR(50),
    order_time DATETIME,
    delivery_time DATETIME  -- NULL means order is still in transit / undelivered
);

INSERT INTO orders1 VALUES
(1,'Spice Villa','2024-03-01 12:00:00','2024-03-01 12:45:00'),
(2,'Spice Villa','2024-03-01 13:00:00','2024-03-01 13:50:00'),
(3,'Pizza Hub','2024-03-01 12:10:00','2024-03-01 12:40:00'),
(4,'Pizza Hub','2024-03-01 13:15:00',NULL),
(5,'Pizza Hub','2024-03-01 14:00:00','2024-03-01 14:35:00'),
(6,'Curry House','2024-03-01 12:30:00','2024-03-01 13:20:00');
```

**Approach: AVG with TIMESTAMPDIFF**

```sql
SELECT restaurant_name,
       AVG(TIMESTAMPDIFF(MINUTE, order_time, delivery_time)) AS avg_delivery_time
FROM orders1
GROUP BY restaurant_name;
```

---

### Q4. Find monthly active users from watch history

Count the number of distinct users who watched content in each month.

```sql
CREATE TABLE watch_history (
    watch_id INT PRIMARY KEY,
    user_id INT,
    content_id INT,
    watch_date DATE
);

INSERT INTO watch_history VALUES
(1,1,101,'2024-01-05'),
(2,2,102,'2024-01-10'),
(3,1,103,'2024-01-20'),
(4,3,101,'2024-02-01'),
(5,1,104,'2024-02-15'),
(6,4,105,'2024-02-20'),
(7,2,101,'2024-03-01'),
(8,3,103,'2024-03-05');
```

**Approach: GROUP BY on formatted month**

```sql
SELECT DATE_FORMAT(watch_date, '%Y-%m') AS month,
       COUNT(DISTINCT user_id) AS active_users
FROM watch_history
GROUP BY DATE_FORMAT(watch_date, '%Y-%m');
```

---

### Q8. Find patients who have multiple appointments on the same day

```sql
CREATE TABLE appointments (
    appointment_id INT PRIMARY KEY,
    patient_id INT,
    doctor_id INT,
    appointment_date DATE
);

INSERT INTO appointments VALUES
(1,1,10,'2024-05-01'),
(2,1,11,'2024-05-01'),
(3,2,10,'2024-05-01'),
(4,3,12,'2024-05-02'),
(5,3,12,'2024-05-02'),
(6,4,13,'2024-05-03'),
(7,1,10,'2024-05-04');
```

**Approach: GROUP BY with HAVING**

```sql
SELECT patient_id, appointment_date, COUNT(*) AS appointment_count
FROM appointments
GROUP BY patient_id, appointment_date
HAVING COUNT(*) > 1;
```

---

### Q10. Get a breakdown of likes, comments, and shares per post

```sql
CREATE TABLE posts (
    post_id INT PRIMARY KEY,
    user_id INT,
    post_date DATE
);

CREATE TABLE engagements (
    engagement_id INT PRIMARY KEY,
    post_id INT,
    engagement_type VARCHAR(10)  -- LIKE, COMMENT, SHARE
);

INSERT INTO posts VALUES
(1,101,'2024-06-01'),
(2,102,'2024-06-02'),
(3,101,'2024-06-03');

INSERT INTO engagements VALUES
(1,1,'LIKE'),(2,1,'LIKE'),(3,1,'COMMENT'),(4,1,'SHARE'),
(5,2,'LIKE'),(6,2,'COMMENT'),(7,2,'COMMENT'),
(8,3,'LIKE');
```

**Approach: LEFT JOIN with conditional aggregation (pivot)**

```sql
SELECT p.post_id,
       SUM(CASE WHEN e.engagement_type = 'LIKE' THEN 1 ELSE 0 END) AS likes,
       SUM(CASE WHEN e.engagement_type = 'COMMENT' THEN 1 ELSE 0 END) AS comments,
       SUM(CASE WHEN e.engagement_type = 'SHARE' THEN 1 ELSE 0 END) AS shares
FROM posts p
LEFT JOIN engagements e
    ON p.post_id = e.post_id
GROUP BY p.post_id;
```

---

### Q12. Find duplicate emails in the users table

```sql
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
```

**Approach: GROUP BY with HAVING**

```sql
SELECT email, COUNT(*) AS occurences
FROM users
GROUP BY email
HAVING COUNT(*) > 1;
```

---

### Q18. Find each customer's first and last order date

```sql
CREATE TABLE orders5 (order_id INT, customer VARCHAR(5), order_date DATE);

INSERT INTO orders5 VALUES
(101,'C1','2024-01-05'),(102,'C1','2024-02-10'),(103,'C1','2024-03-01'),
(104,'C2','2024-01-20');
```

**Approach: GROUP BY with MIN() and MAX()**

```sql
SELECT customer,
       MIN(order_date) AS first_order_date,
       MAX(order_date) AS last_order_date
FROM orders5
GROUP BY customer;
```

---

<!-- Add new aggregation/group by questions below this line -->
