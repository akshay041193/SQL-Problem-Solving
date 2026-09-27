# CTEs (Common Table Expressions)

Queries where a `WITH` clause is the key technique for breaking a problem into readable steps (as opposed to window-function-heavy CTEs already covered in `03-window-functions.md`).

---

### Q5. Find the trip cancellation rate per city

For each city, calculate the percentage of trips that were cancelled (either by rider or by driver).

```sql
CREATE TABLE trips (
    trip_id INT PRIMARY KEY,
    city VARCHAR(30),
    rider_id INT,
    driver_id INT,
    trip_status VARCHAR(20)  -- COMPLETED, CANCELLED_BY_RIDER, CANCELLED_BY_DRIVER
);

INSERT INTO trips VALUES
(1,'Mumbai',1,10,'COMPLETED'),
(2,'Mumbai',2,11,'CANCELLED_BY_RIDER'),
(3,'Mumbai',3,10,'COMPLETED'),
(4,'Mumbai',4,12,'CANCELLED_BY_DRIVER'),
(5,'Delhi',5,13,'COMPLETED'),
(6,'Delhi',6,14,'COMPLETED'),
(7,'Delhi',7,13,'CANCELLED_BY_RIDER'),
(8,'Pune',8,15,'COMPLETED');
```

**Approach: CTE with conditional aggregation**

```sql
WITH CTE AS (
    SELECT city, COUNT(*) AS total_trips,
           SUM(
               CASE
                   WHEN trip_status LIKE 'CANCELLED%' THEN 1
                   ELSE 0
               END
           ) AS cancelled_trips
    FROM trips
    GROUP BY city
)

SELECT *, ROUND(cancelled_trips / total_trips * 100, 2) AS cancellation_rate_pct
FROM CTE;
```

---

<!-- Add new CTE questions below this line -->
