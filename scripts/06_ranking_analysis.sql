-- A) Product rank by total sales (overall)
SELECT
  p.product_key,
  p.product_name,
  SUM(f.sales_amount) AS sales,
  RANK() OVER (ORDER BY SUM(f.sales_amount) DESC) AS rnk
FROM fact_sales f
JOIN dim_products p USING (product_key)
GROUP BY p.product_key, p.product_name
ORDER BY rnk
LIMIT 20;

-- B) Top 3 products within each category by sales
SELECT *
FROM (
  SELECT
    p.category,
    p.product_name,
    SUM(f.sales_amount) AS sales,
    ROW_NUMBER() OVER (PARTITION BY p.category ORDER BY SUM(f.sales_amount) DESC) AS rn
  FROM fact_sales f
  JOIN dim_products p USING (product_key)
  GROUP BY p.category, p.product_name
) x
WHERE rn <= 3
ORDER BY category, rn;

-- C) Customer rank within each country by sales
SELECT *
FROM (
  SELECT
    c.country,
    c.customer_key,
    c.first_name,
    c.last_name,
    SUM(f.sales_amount) AS sales,
    ROW_NUMBER() OVER (PARTITION BY c.country ORDER BY SUM(f.sales_amount) DESC) AS rn
  FROM fact_sales f
  JOIN dim_customers c USING (customer_key)
  GROUP BY c.country, c.customer_key, c.first_name, c.last_name
) y
WHERE rn <= 10
ORDER BY country, rn;

-- D) Top 5 orders per month by order total
WITH order_totals AS (
  SELECT
    order_number,
    MIN(order_date) AS order_date,
    SUM(sales_amount) AS order_total
  FROM fact_sales
  GROUP BY order_number
)
SELECT *
FROM (
  SELECT
    DATE_FORMAT(order_date, '%Y-%m') AS ym,
    order_number,
    order_total,
    ROW_NUMBER() OVER (
      PARTITION BY YEAR(order_date), MONTH(order_date)
      ORDER BY order_total DESC
    ) AS rn
  FROM order_totals
) z
WHERE rn <= 5
ORDER BY ym, rn;

