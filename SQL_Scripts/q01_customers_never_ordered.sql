-- Q1. Find customers who have never placed any orders

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

-- Approach 1: LEFT JOIN
SELECT c.customer_id, c.customer_name, o.order_id
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

-- Approach 2: NOT EXISTS
SELECT c.customer_id, c.customer_name
FROM customers c
WHERE NOT EXISTS (
    SELECT 1
    FROM orders o
    WHERE o.customer_id = c.customer_id
);

/
