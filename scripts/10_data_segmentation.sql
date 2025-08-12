-- A) Sales by customer country
SELECT
  c.country,
  SUM(f.sales_amount) AS sales,
  COUNT(DISTINCT f.customer_key) AS customers
FROM fact_sales f
JOIN dim_customers c USING (customer_key)
GROUP BY c.country
ORDER BY sales DESC;

-- B) Sales by product category & subcategory
SELECT
  p.category,
  p.subcategory,
  SUM(f.sales_amount) AS sales,
  SUM(f.quantity)     AS qty
FROM fact_sales f
JOIN dim_products p USING (product_key)
GROUP BY p.category, p.subcategory
ORDER BY sales DESC
LIMIT 20;

-- C) Sales by gender and marital status
SELECT
  c.gender,
  c.marital_status,
  SUM(f.sales_amount) AS sales,
  COUNT(DISTINCT f.customer_key) AS customers
FROM fact_sales f
JOIN dim_customers c USING (customer_key)
GROUP BY c.gender, c.marital_status
ORDER BY sales DESC;

-- D) Age bands (customers + sales)
WITH cust_age AS (
  SELECT
    c.customer_key,
    TIMESTAMPDIFF(YEAR, c.birth_date, CURDATE()) AS age
  FROM dim_customers c
  WHERE c.birth_date IS NOT NULL
)
SELECT
  CASE
    WHEN age < 25 THEN '<25'
    WHEN age < 35 THEN '25–34'
    WHEN age < 45 THEN '35–44'
    WHEN age < 55 THEN '45–54'
    WHEN age < 65 THEN '55–64'
    ELSE '65+'
  END AS age_band,
  COUNT(DISTINCT ca.customer_key) AS customers,
  SUM(f.sales_amount) AS sales
FROM cust_age ca
LEFT JOIN fact_sales f ON f.customer_key = ca.customer_key
GROUP BY age_band
ORDER BY
  CASE age_band
    WHEN '<25' THEN 1
    WHEN '25–34' THEN 2
    WHEN '35–44' THEN 3
    WHEN '45–54' THEN 4
    WHEN '55–64' THEN 5
    ELSE 6
  END;

-- E) Price tier segmentation
SELECT
  CASE
    WHEN price < 100  THEN '<100'
    WHEN price < 500  THEN '100–499'
    WHEN price < 1000 THEN '500–999'
    ELSE '1000+'
  END AS price_tier,
  COUNT(*)           AS lines,
  SUM(quantity)      AS units,
  SUM(sales_amount)  AS sales
FROM fact_sales
GROUP BY price_tier
ORDER BY
  CASE price_tier
    WHEN '<100' THEN 1
    WHEN '100–499' THEN 2
    WHEN '500–999' THEN 3
    ELSE 4
  END;
