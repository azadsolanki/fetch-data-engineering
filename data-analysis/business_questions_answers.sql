-- 1. Top 5 brands by receipts scanned for most recent month
WITH recent_month AS (
  SELECT FORMAT_DATE('%Y-%m', MAX(purchase_date)) AS latest_month
  FROM fact_receipts
)
SELECT
  b.brand_name,
  COUNT(*) AS receipts_scanned
FROM
  fact_receipts r
JOIN
  dim_brand b ON r.brand_id = b.brand_id
JOIN
  recent_month m ON FORMAT_DATE('%Y-%m', r.purchase_date) = m.latest_month
GROUP BY
  b.brand_name
ORDER BY
  receipts_scanned DESC
LIMIT 5;

-- 2. Compare top 5 brands: most recent month vs previous month
WITH ranked_receipts AS (
  SELECT
    b.brand_name,
    FORMAT_DATE('%Y-%m', r.purchase_date) AS year_month,
    COUNT(*) AS scan_count
  FROM
    fact_receipts r
  JOIN
    dim_brand b ON r.brand_id = b.brand_id
  GROUP BY
    b.brand_name, year_month
),
months AS (
  SELECT DISTINCT year_month
  FROM ranked_receipts
  ORDER BY year_month DESC
  LIMIT 2
)
SELECT
  r1.brand_name,
  r1.scan_count AS scans_this_month,
  r2.scan_count AS scans_last_month
FROM
  ranked_receipts r1
JOIN
  ranked_receipts r2 ON r1.brand_name = r2.brand_name
JOIN
  (SELECT MAX(year_month) AS this_month FROM months) m1
JOIN
  (SELECT MIN(year_month) AS last_month FROM months) m2
WHERE
  r1.year_month = m1.this_month
  AND r2.year_month = m2.last_month
ORDER BY
  scans_this_month DESC
LIMIT 5;

-- 3. Average spend: ‘Accepted’ vs ‘Rejected’
SELECT
  rewards_status,
  AVG(total_spent) AS avg_spend
FROM
  fact_receipts
WHERE
  rewards_status IN ('Accepted', 'Rejected')
GROUP BY
  rewards_status;

-- 4. Total items purchased: ‘Accepted’ vs ‘Rejected’
SELECT
  rewards_status,
  SUM(items_count) AS total_items
FROM
  fact_receipts
WHERE
  rewards_status IN ('Accepted', 'Rejected')
GROUP BY
  rewards_status;

-- 5. Brand with the most spend among users created in the last 6 months
WITH recent_users AS (
  SELECT user_id
  FROM dim_user
  WHERE created_date >= DATE_SUB(CURRENT_DATE(), INTERVAL 6 MONTH)
)
SELECT
  b.brand_name,
  SUM(r.total_spent) AS total_spent
FROM
  fact_receipts r
JOIN
  dim_brand b ON r.brand_id = b.brand_id
JOIN
  recent_users u ON r.user_id = u.user_id
GROUP BY
  b.brand_name
ORDER BY
  total_spent DESC
LIMIT 1;

-- 6. Brand with the most transactions among users created in the last 6 months
WITH recent_users AS (
  SELECT user_id
  FROM dim_user
  WHERE created_date >= DATE_SUB(CURRENT_DATE(), INTERVAL 6 MONTH)
)
SELECT
  b.brand_name,
  COUNT(*) AS transaction_count
FROM
  fact_receipts r
JOIN
  dim_brand b ON r.brand_id = b.brand_id
JOIN
  recent_users u ON r.user_id = u.user_id
GROUP BY
  b.brand_name
ORDER BY
  transaction_count DESC
LIMIT 1;
