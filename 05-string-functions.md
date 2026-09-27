# String Functions

Queries centered on parsing or transforming text values (`SUBSTRING_INDEX`, `CONCAT`, `LEFT`, etc.) as the core technique, rather than joins, aggregation, or window logic.

> Date/time functions like `DATE_FORMAT` (Q4, Q15) and `TIMESTAMPDIFF` (Q2) do appear elsewhere in this repo, but only as a supporting step inside an aggregation or window-function query — see [`02-aggregation-and-group-by.md`](02-aggregation-and-group-by.md) and [`03-window-functions.md`](03-window-functions.md). No question here is *primarily* about date functions yet, so this file is scoped to string functions only. That may become its own "Date Functions" file once a question is added where date manipulation is the main technique.

---

### Q17. Extract first name, last name, initials, and email domain from raw text fields

```sql
CREATE TABLE users6 (id INT, full_name VARCHAR(40), email VARCHAR(50));

INSERT INTO users6 VALUES
(1,'Ravi Kumar','ravi.kumar@gmail.com'),
(2,'Anita S Sharma','anita@yahoo.co.in'),
(3,'Vikram Singh Rao','vikram_rao@company.org');
```

**Approach: SUBSTRING_INDEX() and CONCAT() string functions**

```sql
SELECT SUBSTRING_INDEX(full_name, ' ', 1) AS first_name,
       SUBSTRING_INDEX(full_name, ' ', -1) AS last_name,
       CONCAT(LEFT(SUBSTRING_INDEX(full_name, ' ', 1), 1), LEFT(SUBSTRING_INDEX(full_name, ' ', -1), 1)) AS initials,
       SUBSTRING_INDEX(email, '@', -1) AS email_host,
       SUBSTRING_INDEX(email, '.', -1) AS email_tld
FROM users6;
```

> Note: the original query aliased both the last two columns as `email_domain` — `SUBSTRING_INDEX(email,"@",-1)` (the full host, e.g. `gmail.com`) and `SUBSTRING_INDEX(email,".",-1)` (just the TLD, e.g. `com`). MySQL allows duplicate output aliases, so it runs, but it's ambiguous to read and risky if consumed programmatically. Renamed them to `email_host` and `email_tld` above to keep them distinct.

---

<!-- Add new string/date function questions below this line -->
