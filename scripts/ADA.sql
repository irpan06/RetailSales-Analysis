/* Muhamad Irvandi
	Dataset: Retail Sales

	======================
	Advanced Data Analysis
	======================

	- Profitability Analysis
	- RFM Segmentation
	- Cohort Retention
	
*/

/* ===== Profitability Analysis ===== */
SELECT
	category,
	SUM(total_sale) AS total_revenue,
	SUM(cogs) AS total_cogs,
	SUM(total_sale - cogs) AS total_margin,
	ROUND((SUM(total_sale - cogs)/NULLIF(SUM(total_sale),0)) * 100,2) AS margin_prcnt,
	COUNT(transactions_id) AS total_transactions
FROM saless
GROUP BY category
ORDER BY total_margin DESC;
	
/* ===== RFM Segmentation ===== */
WITH rfm_base AS (
  SELECT customer_id,
         MAX(sale_date) AS last_purchase_date,
         COUNT(transactions_id) AS frequency,
         SUM(total_sale) AS monetary
  FROM saless
  GROUP BY customer_id
),
snapshot AS (
  SELECT MAX(sale_date) AS max_date FROM saless
),
rfm_calc AS (
  SELECT rb.customer_id,
         rb.frequency,
         rb.monetary,
         DATEDIFF(s.max_date, rb.last_purchase_date) AS recency
  FROM rfm_base rb CROSS JOIN snapshot s
),
rfm_ntiles AS (
  SELECT customer_id,
         recency,
         frequency,
         monetary,
         NTILE(5) OVER (ORDER BY recency ASC) AS r_ntile,
         NTILE(5) OVER (ORDER BY frequency ASC) AS f_score,
         NTILE(5) OVER (ORDER BY monetary ASC) AS m_score
  FROM rfm_calc
),
rfm_final AS (
  SELECT
    customer_id,
    recency,
    frequency,
    monetary,
    (6 - r_ntile) AS r_score,
    f_score,
    m_score,
    CONCAT((6 - r_ntile), f_score, m_score) AS rfm_code
  FROM rfm_ntiles
)
SELECT
  customer_id,
  recency,
  frequency,
  monetary,
  r_score,
  f_score,
  m_score,
  rfm_code,
  CASE
    WHEN r_score = 5 AND f_score >= 4 AND m_score >= 4 THEN 'Champion'
    WHEN r_score >= 4 AND f_score >= 3 AND m_score >= 3 THEN 'Loyal'
    WHEN r_score >= 3 AND f_score >= 3 THEN 'Potential'
    WHEN r_score <= 2 AND f_score >= 3 THEN 'At Risk'
    WHEN r_score <= 2 AND f_score <= 2 THEN 'Lost'
    ELSE 'Other'
  END AS rfm_segment_label
FROM rfm_final
ORDER BY r_score DESC, f_score DESC, m_score DESC;


/* ===== Cohort Retention ===== */
WITH cohort AS (
    SELECT
        customer_id, 
        MIN(DATE_FORMAT(sale_date, '%Y-%m')) AS cohort_month
    FROM saless
    GROUP BY customer_id
),
cohort_activity AS (
    SELECT
        c.cohort_month,
        DATE_FORMAT(s.sale_date, '%Y-%m') AS activity_month,
        COUNT(DISTINCT s.customer_id) AS active_customers
    FROM cohort c
    JOIN saless s
        ON c.customer_id = s.customer_id
    GROUP BY c.cohort_month, DATE_FORMAT(s.sale_date, '%Y-%m')
),
cohort_size AS (
    SELECT
        cohort_month,
        COUNT(DISTINCT customer_id) AS total_customers
    FROM cohort
    GROUP BY cohort_month
)
SELECT
    ca.cohort_month,
    ca.activity_month,
    ca.active_customers,
    cs.total_customers,
    ROUND(ca.active_customers * 100.0 / cs.total_customers, 2) AS retention_rate
FROM cohort_activity ca
JOIN cohort_size cs
    ON ca.cohort_month = cs.cohort_month
ORDER BY ca.cohort_month, ca.activity_month;