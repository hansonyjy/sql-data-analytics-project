-- A) Category share of total sales
SELECT
  p.category,
  SUM(f.sales_amount) AS sales,
  ROUND(100 * SUM(f.sales_amount) / SUM(SUM(f.sales_amount)) OVER (), 2) AS pct_of_total
FROM fact_sales f
JOIN dim_products p USING (product_key)
GROUP BY p.category
ORDER BY sales DESC;

-- B) Subcategory share within each category
SELECT
  p.category,
  p.subcategory,
  SUM(f.sales_amount) AS sales,
  ROUND(100 * SUM(f.sales_amount)
        / SUM(SUM(f.sales_amount)) OVER (PARTITION BY p.category), 2) AS pct_of_category
FROM fact_sales f
JOIN dim_products p USING (product_key)
GROUP BY p.category, p.subcategory
ORDER BY p.category, sales DESC;
