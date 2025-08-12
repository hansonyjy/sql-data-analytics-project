-- Overall sales metrics
SELECT
  SUM(sales_amount) AS total_sales,
  SUM(quantity)     AS total_qty,
  AVG(price)        AS avg_price
FROM fact_sales;

-- Min / Max sale amounts
SELECT
  MIN(sales_amount) AS min_sale,
  MAX(sales_amount) AS max_sale
FROM fact_sales;

-- Average order value (AOV)
SELECT
  SUM(sales_amount) / COUNT(DISTINCT order_number) AS avg_order_value
FROM fact_sales;

-- Sales by product
SELECT
  p.product_key,
  p.product_name,
  SUM(f.sales_amount) AS sales,
  SUM(f.quantity)     AS qty
FROM fact_sales f
JOIN dim_products p USING (product_key)
GROUP BY p.product_key, p.product_name
ORDER BY sales DESC
LIMIT 10;

-- Top customers by sales
SELECT
  c.customer_key,
  c.first_name,
  c.last_name,
  SUM(f.sales_amount) AS sales
FROM fact_sales f
JOIN dim_customers c USING (customer_key)
GROUP BY c.customer_key, c.first_name, c.last_name
ORDER BY sales DESC
LIMIT 10;
