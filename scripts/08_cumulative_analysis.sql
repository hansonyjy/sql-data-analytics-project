-- A) Daily running total of sales
WITH d AS (
  SELECT order_date, SUM(sales_amount) AS sales
  FROM fact_sales
  GROUP BY order_date
)
SELECT
  order_date,
  sales,
  SUM(sales) OVER (ORDER BY order_date ROWS UNBOUNDED PRECEDING) AS sales_cum
FROM d
ORDER BY order_date;

-- B) Monthly sales with YTD cumulative (resets each year)
WITH m AS (
  SELECT
    YEAR(order_date) AS y,
    MONTH(order_date) AS mth,
    DATE_FORMAT(order_date, '%Y-%m') AS ym,
    SUM(sales_amount) AS sales
  FROM fact_sales
  GROUP BY y, mth
)
SELECT
  y, mth, ym, sales,
  SUM(sales) OVER (PARTITION BY y ORDER BY mth ROWS UNBOUNDED PRECEDING) AS ytd_sales
FROM m
ORDER BY y, mth;

