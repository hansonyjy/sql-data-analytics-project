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
