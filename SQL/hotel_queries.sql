-- Q1: For every user, get last booked room
SELECT user_id, room_no
FROM (
    SELECT 
        user_id,
        room_no,
        booking_date,
        ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY booking_date DESC) AS rn
    FROM bookings
) t
WHERE rn = 1;


-- Q2: Booking_id and total billing amount for bookings in November 2021
SELECT 
    b.booking_id,
    SUM(bi.quantity * bi.rate) AS total_amount
FROM bookings b
JOIN booking_items bi ON b.booking_id = bi.booking_id
WHERE b.booking_date BETWEEN '2021-11-01' AND '2021-11-30'
GROUP BY b.booking_id;


-- Q3: Bills in October 2021 with amount > 1000
SELECT 
    bl.bill_id,
    SUM(bi.quantity * bi.rate) AS bill_amount
FROM bills bl
JOIN bookings b ON bl.booking_id = b.booking_id
JOIN booking_items bi ON b.booking_id = bi.booking_id
WHERE bl.bill_date BETWEEN '2021-10-01' AND '2021-10-31'
GROUP BY bl.bill_id
HAVING bill_amount > 1000;


-- Q4: Most and least ordered item per month for 2021
WITH monthly_data AS (
    SELECT 
        DATE_FORMAT(b.booking_date, '%Y-%m-01') AS month_start,
        i.item_id,
        i.item_name,
        SUM(bi.quantity) AS qty
    FROM bookings b
    JOIN booking_items bi ON b.booking_id = bi.booking_id
    JOIN items i ON bi.item_id = i.item_id
    WHERE YEAR(b.booking_date) = 2021
    GROUP BY month_start, i.item_id, i.item_name
),
ranked AS (
    SELECT *,
        ROW_NUMBER() OVER (PARTITION BY month_start ORDER BY qty DESC) AS most_rn,
        ROW_NUMBER() OVER (PARTITION BY month_start ORDER BY qty ASC) AS least_rn
    FROM monthly_data
)
SELECT month_start, item_id, item_name, qty, 'MOST_ORDERED' AS type
FROM ranked
WHERE most_rn = 1
UNION ALL
SELECT month_start, item_id, item_name, qty, 'LEAST_ORDERED' AS type
FROM ranked
WHERE least_rn = 1
ORDER BY month_start, type;


-- Q5: Second highest bill per month for 2021
WITH bill_amounts AS (
    SELECT 
        bl.bill_id,
        b.user_id,
        DATE_FORMAT(bl.bill_date, '%Y-%m-01') AS month_start,
        SUM(bi.quantity * bi.rate) AS bill_amount
    FROM bills bl
    JOIN bookings b ON bl.booking_id = b.booking_id
    JOIN booking_items bi ON b.booking_id = bi.booking_id
    WHERE YEAR(bl.bill_date) = 2021
    GROUP BY bl.bill_id, b.user_id, month_start
),
ranked AS (
    SELECT *,
        DENSE_RANK() OVER (PARTITION BY month_start ORDER BY bill_amount DESC) AS rnk
    FROM bill_amounts
)
SELECT month_start, user_id, bill_id, bill_amount
FROM ranked
WHERE rnk = 2
ORDER BY month_start;

