-- Earliest and latest sales date
SELECT
  MIN(order_date) AS first_sale_date,
  MAX(order_date) AS last_sale_date
FROM fact_sales;

-- Count sales by year
SELECT
  YEAR(order_date) AS sale_year,
  COUNT(*) AS total_sales
FROM fact_sales
GROUP BY YEAR(order_date)
ORDER BY sale_year;

-- Count sales by month
SELECT
  YEAR(order_date) AS sale_year,
  MONTH(order_date) AS sale_month,
  COUNT(*) AS total_sales
FROM fact_sales
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY sale_year, sale_month;

