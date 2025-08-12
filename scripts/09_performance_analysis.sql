-- Yearly product sales vs average & prior year (MySQL)
WITH prod_year AS (
  SELECT
    YEAR(f.order_date) AS yr,
    p.product_name,
    SUM(f.sales_amount) AS sales
  FROM fact_sales f
  JOIN dim_products p USING (product_key)
  WHERE f.order_date IS NOT NULL
  GROUP BY YEAR(f.order_date), p.product_name
)
SELECT
  yr AS order_year,
  product_name,
  sales AS current_sales,
  AVG(sales) OVER (PARTITION BY product_name) AS avg_sales,
  sales - AVG(sales) OVER (PARTITION BY product_name) AS diff_avg,
  CASE
    WHEN sales > AVG(sales) OVER (PARTITION BY product_name) THEN 'Above Avg'
    WHEN sales < AVG(sales) OVER (PARTITION BY product_name) THEN 'Below Avg'
    ELSE 'Avg'
  END AS avg_change,
  LAG(sales) OVER (PARTITION BY product_name ORDER BY yr) AS py_sales,
  sales - LAG(sales) OVER (PARTITION BY product_name ORDER BY yr) AS diff_py,
  CASE
    WHEN sales > LAG(sales) OVER (PARTITION BY product_name ORDER BY yr) THEN 'Increase'
    WHEN sales < LAG(sales) OVER (PARTITION BY product_name ORDER BY yr) THEN 'Decrease'
    ELSE 'No Change'
  END AS py_change
FROM prod_year
ORDER BY product_name, order_year;
