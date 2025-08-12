-- A) Top 10 orders by sales amount
SELECT
  order_number,
  order_date,
  sales_amount,
  quantity,
  price
FROM fact_sales
ORDER BY sales_amount DESC
LIMIT 10;

-- B) Sales by product (with share of total)
SELECT
  p.product_key,
  p.product_name,
  SUM(f.sales_amount) AS sales,
  ROUND(100 * SUM(f.sales_amount) / SUM(SUM(f.sales_amount)) OVER (), 2) AS pct_of_total
FROM fact_sales f
JOIN dim_products p USING (product_key)
GROUP BY p.product_key, p.product_name
ORDER BY sales DESC
LIMIT 20;

-- C) Sales by category & subcategory (top 15)
SELECT
  p.category,
  p.subcategory,
  SUM(f.sales_amount) AS sales
FROM fact_sales f
JOIN dim_products p USING (product_key)
GROUP BY p.category, p.subcategory
ORDER BY sales DESC
LIMIT 15;

-- D) High-value customers (with share)
SELECT
  c.customer_key,
  c.first_name,
  c.last_name,
  SUM(f.sales_amount) AS sales,
  ROUND(100 * SUM(f.sales_amount) / SUM(SUM(f.sales_amount)) OVER (), 2) AS pct_of_total
FROM fact_sales f
JOIN dim_customers c USING (customer_key)
GROUP BY c.customer_key, c.first_name, c.last_name
ORDER BY sales DESC
LIMIT 20;

-- E) Order value buckets
SELECT
  CASE
    WHEN sales_amount < 100   THEN '< 100'
    WHEN sales_amount < 500   THEN '100–499'
    WHEN sales_amount < 1000  THEN '500–999'
    ELSE '1000+'
  END AS order_bucket,
  COUNT(*) AS orders,
  SUM(sales_amount) AS sales
FROM fact_sales
GROUP BY order_bucket
ORDER BY
  CASE order_bucket
    WHEN '< 100' THEN 1
    WHEN '100–499' THEN 2
    WHEN '500–999' THEN 3
    ELSE 4
  END;

