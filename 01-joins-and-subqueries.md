# Joins & Subqueries

Queries that rely on `JOIN` (including self-joins) or subqueries (`NOT EXISTS`, correlated subqueries) as the core technique.

---

### Q1. Find customers who have never placed any orders

```sql
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(50),
    city VARCHAR(50),
    signup_date DATE
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    order_status VARCHAR(20)
);

INSERT INTO customers VALUES
(1,'Ravi Kumar','Mumbai','2024-01-05'),
(2,'Anita Sharma','Delhi','2024-01-10'),
(3,'Vikram Singh','Pune','2024-01-15'),
(4,'Neha Joshi','Bangalore','2024-02-01'),
(5,'Suresh Rao','Chennai','2024-02-10'),
(6,'Priya Nair','Hyderabad','2024-02-15'),
(7,'Amit Verma','Mumbai','2024-03-01'),
(8,'Kavita Desai','Delhi','2024-03-05');

INSERT INTO orders VALUES
(101,1,'2024-01-20','DELIVERED'),
(102,2,'2024-01-25','DELIVERED'),
(103,1,'2024-02-05','CANCELLED'),
(104,4,'2024-02-10','DELIVERED'),
(105,5,'2024-02-20','DELIVERED');
```

**Approach 1: LEFT JOIN**

```sql
SELECT c.customer_id, c.customer_name, o.order_id
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;
```

**Approach 2: NOT EXISTS**

```sql
SELECT c.customer_id, c.customer_name
FROM customers c
WHERE NOT EXISTS (
    SELECT 1
    FROM orders o
    WHERE o.customer_id = c.customer_id
);
```

---

### Q6. Detect overlapping (double-booked) room bookings

For each room, find pairs of bookings whose date ranges overlap — i.e. the room was booked to two different guests for overlapping nights.

```sql
CREATE TABLE bookings (
    booking_id INT PRIMARY KEY,
    room_id INT,
    guest_name VARCHAR(50),
    check_in DATE,
    check_out DATE
);

INSERT INTO bookings VALUES
(1,101,'Ravi Kumar','2024-04-01','2024-04-05'),
(2,101,'Anita Sharma','2024-04-04','2024-04-08'),
(3,102,'Vikram Singh','2024-04-01','2024-04-03'),
(4,102,'Neha Joshi','2024-04-03','2024-04-06'),
(5,103,'Suresh Rao','2024-04-01','2024-04-02'),
(6,101,'Priya Nair','2024-04-10','2024-04-12');
```

**Approach: Self-join on room with overlap condition**

The classic overlap test for two date ranges is `start1 < end2 AND end1 > start2`. `b.booking_id < b1.booking_id` avoids matching a booking with itself and avoids duplicate reversed pairs.

```sql
SELECT b.room_id,
       b.booking_id AS booking_id_1,
       b.guest_name AS guest_1,
       b1.booking_id AS booking_id_2,
       b1.guest_name AS guest_2
FROM bookings b
JOIN bookings b1
    ON b.room_id = b1.room_id
    AND b.booking_id < b1.booking_id
    AND b.check_in < b1.check_out
    AND b.check_out > b1.check_in;
```

---

### Q13. Find employees who earn more than their manager

```sql
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
```

**Approach: Self-join on manager_id = emp_id**

```sql
SELECT e.emp_name AS employee_name,
       e.salary AS employee_salary,
       m.emp_name AS manager_name,
       m.salary AS manager_salary
FROM companyEmployee e
JOIN companyEmployee m
    ON e.manager_id = m.emp_id
WHERE e.salary > m.salary;
```

Result: **Anita Sharma** (80,000) earns more than her manager Ravi Kumar (60,000), and **Suresh Rao** (90,000) earns more than his manager Anita Sharma (80,000).

---

<!-- Add new joins/subqueries questions below this line -->
