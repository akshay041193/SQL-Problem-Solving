-- Q2. Find the average delivery time per restaurant
-- Note: delivery_time IS NULL for undelivered orders; TIMESTAMPDIFF against NULL
-- returns NULL, and AVG() ignores NULLs, so in-transit orders are excluded automatically.

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

-- Approach: AVG with TIMESTAMPDIFF
SELECT restaurant_name,
       AVG(TIMESTAMPDIFF(MINUTE, order_time, delivery_time)) AS avg_delivery_time
FROM orders1
GROUP BY restaurant_name;
