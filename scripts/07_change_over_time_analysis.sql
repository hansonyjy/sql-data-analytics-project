-- A) Daily sales trend
SELECT
  order_date,
  SUM(sales_amount) AS sales
FROM fact_sales
GROUP BY order_date
ORDER BY order_date;

-- B) Monthly sales with MoM change and %
WITH m AS (
  SELECT
    YEAR(order_date)  AS y,
    MONTH(order_date) AS mth,
    DATE_FORMAT(order_date, '%Y-%m') AS ym,
    SUM(sales_amount) AS sales
  FROM fact_sales
  GROUP BY y, mth
)
SELECT
  y, mth, ym, sales,
  LAG(sales) OVER (ORDER BY y, mth) AS prev_month_sales,
  sales - LAG(sales) OVER (ORDER BY y, mth) AS mom_change,
  ROUND(100 * (sales - LAG(sales) OVER (ORDER BY y, mth)) /
        NULLIF(LAG(sales) OVER (ORDER BY y, mth), 0), 2) AS mom_pct
FROM m
ORDER BY y, mth;

-- C) Year-over-year by month (align same month across years)
WITH m AS (
  SELECT
    YEAR(order_date)  AS y,
    MONTH(order_date) AS mth,
    SUM(sales_amount) AS sales
  FROM fact_sales
  GROUP BY y, mth
)
SELECT
  y, mth, sales,
  LAG(sales) OVER (PARTITION BY mth ORDER BY y) AS last_year_sales,
  sales - LAG(sales) OVER (PARTITION BY mth ORDER BY y) AS yoy_change,
  ROUND(100 * (sales - LAG(sales) OVER (PARTITION BY mth ORDER BY y)) /
        NULLIF(LAG(sales) OVER (PARTITION BY mth ORDER BY y), 0), 2) AS yoy_pct
FROM m
ORDER BY mth, y;

-- D) 7-day rolling average of daily sales
WITH d AS (
  SELECT order_date, SUM(sales_amount) AS sales
  FROM fact_sales
  GROUP BY order_date
)
SELECT
  order_date,
  sales,
  ROUND(AVG(sales) OVER (ORDER BY order_date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW), 2) AS sales_7d_avg
FROM d
ORDER BY order_date;

