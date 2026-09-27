-- Q7. Find the top-selling product in each category

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(50),
    category VARCHAR(30)
);

CREATE TABLE sales (
    sale_id INT PRIMARY KEY,
    product_id INT,
    quantity_sold INT,
    sale_date DATE
);

INSERT INTO products VALUES
(1,'Colgate Toothpaste','Personal Care'),
(2,'Dove Soap','Personal Care'),
(3,'Tata Salt','Grocery'),
(4,'Aashirvaad Atta','Grocery'),
(5,'Lays Chips','Snacks'),
(6,'Kurkure','Snacks');

INSERT INTO sales VALUES
(1,1,50,'2024-01-01'),
(2,2,80,'2024-01-02'),
(3,3,120,'2024-01-03'),
(4,4,150,'2024-01-04'),
(5,5,200,'2024-01-05'),
(6,6,90,'2024-01-06'),
(7,1,30,'2024-01-07'),
(8,4,60,'2024-01-08');

-- Approach: Two CTEs -- aggregate, then rank with ROW_NUMBER()
WITH total_quan_sold AS (
    SELECT p.category AS category,
           p.product_name AS product_name,
           SUM(s.quantity_sold) AS total_quantity
    FROM products p
    LEFT JOIN sales s
        ON p.product_id = s.product_id
    GROUP BY p.category, p.product_name
),
ranked_products AS (
    SELECT
        category,
        product_name,
        total_quantity,
        ROW_NUMBER() OVER (
            PARTITION BY category
            ORDER BY total_quantity DESC
        ) AS ranks
    FROM total_quan_sold
)

SELECT *
FROM ranked_products
WHERE ranks = 1
ORDER BY total_quantity;
