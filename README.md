# SQL Practice Questions

A growing collection of SQL practice questions, organized by concept, with schema, sample data, and multiple solution approaches for each problem.

All queries are written and tested in **MySQL Workbench 8.0**.

## Structure

Questions are grouped by the core SQL concept they practice. Each file below is self-contained (schema + data + query) and grows as new questions are added.

| File | Concept | Questions |
|---|---|---|
| [`concepts/01-joins-and-subqueries.md`](concepts/01-joins-and-subqueries.md) | Joins & Subqueries | Q1, Q6, Q13 |
| [`concepts/02-aggregation-and-group-by.md`](concepts/02-aggregation-and-group-by.md) | Aggregation & GROUP BY / HAVING | Q2, Q4, Q8, Q10, Q12, Q18 |
| [`concepts/03-window-functions.md`](concepts/03-window-functions.md) | Window Functions | Q3, Q7, Q9, Q11, Q14, Q15, Q16 |
| [`concepts/04-ctes.md`](concepts/04-ctes.md) | CTEs | Q5 |
| [`concepts/05-string-functions.md`](concepts/05-string-functions.md) | String Functions | Q17 |

> Note: `DATE_FORMAT` and `TIMESTAMPDIFF` show up in Q2, Q4, and Q15, but only as a supporting step inside an aggregation/window query — not as the main technique — so those stay filed under Aggregation and Window Functions rather than under String Functions.

## Index of all questions

1. Find customers who have never placed any orders — *Joins & Subqueries*
2. Find the average delivery time per restaurant — *Aggregation*
3. Calculate running wallet balance per customer — *Window Functions*
4. Find monthly active users from watch history — *Aggregation*
5. Find the trip cancellation rate per city — *CTEs*
6. Detect overlapping (double-booked) room bookings — *Joins & Subqueries*
7. Find the top-selling product in each category — *Window Functions*
8. Find patients who have multiple appointments on the same day — *Aggregation*
9. Detect customers who downgraded to the FREE plan — *Window Functions*
10. Get a breakdown of likes, comments, and shares per post — *Aggregation*
11. Find the second highest salary — *Window Functions*
12. Find duplicate emails in the users table — *Aggregation*
13. Find employees who earn more than their manager — *Joins & Subqueries*
14. Find employees who earn more than their department's average salary — *Window Functions*
15. Calculate month-over-month sales growth percentage — *Window Functions*
16. Calculate the median salary — *Window Functions*
17. Extract first name, last name, initials, and email domain from raw text fields — *String Functions*
18. Find each customer's first and last order date — *Aggregation*
