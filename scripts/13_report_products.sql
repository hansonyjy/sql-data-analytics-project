-- A) Product summary with KPIs
WITH fs AS (
  SELECT
    product_key,
    COUNT(DISTINCT order_number) AS orders,
    SUM(quantity)                AS units,
    SUM(sales_amount)            AS sales,
    ROUND(SUM(sales_amount) / NULLIF(SUM(quantity), 0), 2) AS avg_unit_price,
    MIN(order_date)              AS first_order_date,
    MAX(order_date)              AS last_order_date
  FROM fact_sales
  GROUP BY product_key
)
SELECT
  p.product_key,
  p.product_name,
  p.category,
  p.subcategory,
  fs.orders,
  fs.units,
  fs.sales,
  fs.avg_unit_price,
  fs.first_order_date,
  fs.last_order_date
FROM fs
JOIN dim_products p USING (product_key)
ORDER BY fs.sales DESC
LIMIT 100;

-- B) Category rollup
WITH fs AS (
  SELECT
    product_key,
    COUNT(DISTINCT order_number) AS orders,
    SUM(quantity)                AS units,
    SUM(sales_amount)            AS sales
  FROM fact_sales
  GROUP BY product_key
)
SELECT
  p.category,
  p.subcategory,
  SUM(fs.orders) AS orders,
  SUM(fs.units)  AS units,
  SUM(fs.sales)  AS sales
FROM fs
JOIN dim_products p USING (product_key)
GROUP BY p.category, p.subcategory
ORDER BY sales DESC
LIMIT 50;

