-- Q15. Calculate month-over-month sales growth percentage

CREATE TABLE monthly_sales (
    sale_id INT PRIMARY KEY,
    sale_date DATE,
    amount INT
);

INSERT INTO monthly_sales VALUES
(1,'2024-01-05',6000),
(2,'2024-01-20',4000),
(3,'2024-02-10',15000),
(4,'2024-03-15',12000),
(5,'2024-04-08',10000),
(6,'2024-04-22',8000),
(7,'2024-05-15',9000),
(8,'2024-06-10',9000);

-- Approach: CTE to roll up monthly totals, then LAG() for growth %
-- Note: the first month in the series will have NULL for prev_month_sales
-- and growth_pct since there's no prior month to compare against.
WITH monthly AS (
    SELECT
        DATE_FORMAT(sale_date, '%Y-%m') AS sales_month,
        SUM(amount) AS total_sales
    FROM monthly_sales
    GROUP BY DATE_FORMAT(sale_date, '%Y-%m')
)
SELECT
    sales_month,
    total_sales,
    LAG(total_sales) OVER (ORDER BY sales_month) AS prev_month_sales,
    ROUND(
        (total_sales - LAG(total_sales) OVER (ORDER BY sales_month))
        / LAG(total_sales) OVER (ORDER BY sales_month) * 100
    , 2) AS growth_pct
FROM monthly
ORDER BY sales_month;
