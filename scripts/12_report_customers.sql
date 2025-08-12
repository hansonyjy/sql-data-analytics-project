-- A) Customer summary (pre-agg to avoid massive join)
WITH fs AS (
  SELECT
    customer_key,
    COUNT(DISTINCT order_number) AS orders,
    SUM(quantity)               AS units,
    SUM(sales_amount)           AS sales,
    MIN(order_date)             AS first_order_date,
    MAX(order_date)             AS last_order_date
  FROM fact_sales
  -- optional: limit time to reduce volume
  -- WHERE order_date >= DATE_SUB(CURDATE(), INTERVAL 2 YEAR)
  GROUP BY customer_key
)
SELECT
  c.customer_key,
  c.customer_id,
  c.customer_number,
  c.first_name,
  c.last_name,
  c.country,
  c.gender,
  c.marital_status,
  fs.orders,
  fs.units,
  fs.sales,
  ROUND(fs.sales / NULLIF(fs.orders, 0), 2) AS aov,
  fs.first_order_date,
  fs.last_order_date
FROM fs
JOIN dim_customers c USING (customer_key)
ORDER BY fs.sales DESC
LIMIT 100;

-- B) Customers and sales by country
WITH fs AS (
  SELECT customer_key, SUM(sales_amount) AS sales, COUNT(DISTINCT order_number) AS orders
  FROM fact_sales
  -- WHERE order_date >= DATE_SUB(CURDATE(), INTERVAL 2 YEAR)
  GROUP BY customer_key
)
SELECT
  c.country,
  COUNT(DISTINCT c.customer_key) AS customers,
  SUM(fs.orders)                 AS orders,
  SUM(fs.sales)                  AS sales
FROM dim_customers c
LEFT JOIN fs USING (customer_key)
GROUP BY c.country
ORDER BY sales DESC;

