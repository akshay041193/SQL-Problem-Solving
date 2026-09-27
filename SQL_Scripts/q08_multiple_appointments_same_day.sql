-- Q8. Find patients who have multiple appointments on the same day

CREATE TABLE appointments (
    appointment_id INT PRIMARY KEY,
    patient_id INT,
    doctor_id INT,
    appointment_date DATE
);

INSERT INTO appointments VALUES
(1,1,10,'2024-05-01'),
(2,1,11,'2024-05-01'),
(3,2,10,'2024-05-01'),
(4,3,12,'2024-05-02'),
(5,3,12,'2024-05-02'),
(6,4,13,'2024-05-03'),
(7,1,10,'2024-05-04');

-- Approach: GROUP BY with HAVING
SELECT patient_id, appointment_date, COUNT(*) AS appointment_count
FROM appointments
GROUP BY patient_id, appointment_date
HAVING COUNT(*) > 1;
