/* ============================================================
   CLINIC MANAGEMENT SYSTEM – SQL ANSWERS (MySQL)
   ============================================================ */


/* ============================================================
   Q1. Revenue from each sales channel for a given year (2021)
   ============================================================ */
SELECT 
    sales_channel,
    SUM(amount) AS revenue
FROM clinic_sales
WHERE YEAR(sale_date) = 2021
GROUP BY sales_channel
ORDER BY revenue DESC;



/* ============================================================
   Q2. Top 10 most valuable customers for 2021
   ============================================================ */
SELECT 
    cs.patient_id,
    p.patient_name,
    SUM(cs.amount) AS total_spend
FROM clinic_sales cs
JOIN patients p ON cs.patient_id = p.patient_id
WHERE YEAR(cs.sale_date) = 2021
GROUP BY cs.patient_id, p.patient_name
ORDER BY total_spend DESC
LIMIT 10;



/* ============================================================
   Q3. Month-wise revenue, expense, profit & status (2021)
   ============================================================ */
WITH revenue AS (
    SELECT 
        DATE_FORMAT(sale_date, '%Y-%m') AS month,
        SUM(amount) AS revenue
    FROM clinic_sales
    WHERE YEAR(sale_date) = 2021
    GROUP BY month
),
expense AS (
    SELECT 
        DATE_FORMAT(expense_date, '%Y-%m') AS month,
        SUM(amount) AS expense
    FROM expenses
    WHERE YEAR(expense_date) = 2021
    GROUP BY month
)
SELECT 
    m.month,
    COALESCE(r.revenue, 0) AS revenue,
    COALESCE(e.expense, 0) AS expense,
    (COALESCE(r.revenue, 0) - COALESCE(e.expense, 0)) AS profit,
    CASE 
        WHEN COALESCE(r.revenue,0) - COALESCE(e.expense,0) > 0 THEN 'PROFITABLE'
        ELSE 'NOT PROFITABLE'
    END AS status
FROM (
    SELECT DISTINCT month FROM (
        SELECT DATE_FORMAT(sale_date, '%Y-%m') AS month FROM clinic_sales
        UNION
        SELECT DATE_FORMAT(expense_date, '%Y-%m') AS month FROM expenses
    ) all_months
) m
LEFT JOIN revenue r ON r.month = m.month
LEFT JOIN expense e ON e.month = m.month
ORDER BY m.month;



/* ============================================================
   Q4. Most profitable clinic in each city (for March 2021)
   ============================================================ */
WITH clinic_fin AS (
    SELECT 
        c.clinic_id,
        c.clinic_name,
        c.city,
        SUM(cs.amount) AS revenue,
        (
            SELECT COALESCE(SUM(amount),0)
            FROM expenses e
            WHERE e.clinic_id = c.clinic_id
              AND DATE_FORMAT(e.expense_date, '%Y-%m') = '2021-03'
        ) AS expense
    FROM clinics c
    LEFT JOIN clinic_sales cs 
        ON c.clinic_id = cs.clinic_id 
       AND DATE_FORMAT(cs.sale_date, '%Y-%m') = '2021-03'
    GROUP BY c.clinic_id, c.clinic_name, c.city
)
SELECT *
FROM (
    SELECT *,
        ROW_NUMBER() OVER (PARTITION BY city ORDER BY (revenue - expense) DESC) AS rn
    FROM clinic_fin
) x
WHERE rn = 1;



/* ============================================================
   Q5. Second least profitable clinic in each state (for March 2021)
   ============================================================ */
WITH clinic_fin AS (
    SELECT 
        c.clinic_id,
        c.clinic_name,
        c.state,
        SUM(cs.amount) AS revenue,
        (
            SELECT COALESCE(SUM(amount),0)
            FROM expenses e
            WHERE e.clinic_id = c.clinic_id
              AND DATE_FORMAT(e.expense_date, '%Y-%m') = '2021-03'
        ) AS expense
    FROM clinics c
    LEFT JOIN clinic_sales cs 
        ON c.clinic_id = cs.clinic_id 
       AND DATE_FORMAT(cs.sale_date, '%Y-%m') = '2021-03'
    GROUP BY c.clinic_id, c.clinic_name, c.state
)
SELECT *
FROM (
    SELECT *,
        DENSE_RANK() OVER (PARTITION BY state ORDER BY (revenue - expense) ASC) AS rn
    FROM clinic_fin
) x
WHERE rn = 2;

