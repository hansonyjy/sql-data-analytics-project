-- Preview all rows from a dimension table 
SELECT *
FROM dim_customers
LIMIT 10;

-- Count total rows in a dimension table
SELECT COUNT(*) AS total_customers
FROM dim_customers;

-- Distinct values for a specific column
SELECT DISTINCT country
FROM dim_customers
ORDER BY country;

-- Count customers by country
SELECT country, COUNT(*) AS customer_count
FROM dim_customers
GROUP BY country
ORDER BY customer_count DESC;
