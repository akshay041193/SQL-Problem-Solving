-- Q6. Detect overlapping (double-booked) room bookings
-- For each room, find pairs of bookings whose date ranges overlap.

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

-- Approach: Self-join on room with overlap condition
-- Overlap test: start1 < end2 AND end1 > start2
-- booking_id < booking_id avoids self-matches and duplicate reversed pairs.
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
