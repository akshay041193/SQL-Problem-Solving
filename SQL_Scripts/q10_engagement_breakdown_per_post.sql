-- Q10. Get a breakdown of likes, comments, and shares per post

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

-- Approach: LEFT JOIN with conditional aggregation (pivot)
SELECT p.post_id,
       SUM(CASE WHEN e.engagement_type = 'LIKE' THEN 1 ELSE 0 END) AS likes,
       SUM(CASE WHEN e.engagement_type = 'COMMENT' THEN 1 ELSE 0 END) AS comments,
       SUM(CASE WHEN e.engagement_type = 'SHARE' THEN 1 ELSE 0 END) AS shares
FROM posts p
LEFT JOIN engagements e
    ON p.post_id = e.post_id
GROUP BY p.post_id;
