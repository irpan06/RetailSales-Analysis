/* Muhamad Irvandi
	Dataset:	Retail Sales

	=========================
	Exploratory Data Analysis
	=========================

	Dimension Exploration:
	1.	Explore all category
	
	Date Exploration:
	1.	Find first and last order
	2.	Find youngest and oldest customer
	
	Measure Exploration:
	1.	Find total customer
	2.	Find total sales
	3.	Find total order
	4.	Find total number of products sold
	5.	Find total revenue generated for each customer
	6.	Find total revenue generated for each category
	7.	Find total sales and gender distribution for each category
	8.	Find the average age for gender in each category
	9.	Find customer who make repeat order (for all category)

*/

SELECT * FROM retail_sales;

/* ===== Dimension Exploration ===== */
-- Explore All Category
SELECT
	DISTINCT(category) AS category
FROM retail_sales;


/* ===== Date Exploration ===== */
-- Find the date of the first and last order, How many years of sales are available
SELECT
	MIN(sale_date) AS first_order,
	MAX(sale_date) AS last_order,
	CONCAT(TIMESTAMPDIFF(YEAR, MIN(sale_date), MAX(sale_date)), " Year ", TIMESTAMPDIFF(MONTH, MIN(sale_date), MAX(sale_date)), " Month") AS order_range
FROM retail_sales;

-- Find the youngest and the oldest customer for each gender 
SELECT
	MIN(age) AS youngest_customer,
	MAX(age) AS oldest_customer
FROM retail_sales;


/* ===== Measure Exploration ===== */
-- Find total customer
SELECT
	COUNT(DISTINCT(customer_id)) AS total_customer
FROM retail_sales;

-- Find total sales
SELECT
	SUM(total_sale) AS total_revenue
FROM retail_sales;

-- Find total order
SELECT 
	COUNT(transactions_id) AS total_order
FROM retail_sales;

-- Find total number of products sold
SELECT
	SUM(quantiy) AS product_sold
FROM retail_sales;

-- Find total revenue generated for each customer
SELECT 
	customer_id,
	SUM(total_sale) AS total_revenue
FROM retail_sales
GROUP BY customer_id
ORDER BY customer_id;

-- Find total revenue generated for each category
SELECT
	category,
	SUM(total_sale) AS total_revenue
FROM retail_sales
GROUP BY category
ORDER BY category;

-- Find total sales and gender distribution for each category
-- for All category
SELECT
	gender,
	COUNT(gender) AS total_customer_gender,
	SUM(total_sale) AS total_revenue
FROM retail_sales
GROUP BY gender;

-- for Beauty
SELECT
	gender,
	COUNT(gender) AS total_customer_gender,
	SUM(total_sale) AS total_revenue
FROM retail_sales
WHERE category = "Beauty"
GROUP BY gender;

-- for Clothing
SELECT
	gender,
	COUNT(gender) AS total_customer_gender,
	SUM(total_sale) AS total_revenue
FROM retail_sales
WHERE category = "Clothing"
GROUP BY gender;

-- for Electronics
SELECT
	gender,
	COUNT(gender) AS total_customer_gender,
	SUM(total_sale) AS total_revenue	
FROM retail_sales
WHERE category = "Electronics"
GROUP BY gender;

-- Find the average age for gender in each category
-- for All category
SELECT
	gender,
	ROUND(AVG(age)) AS age
FROM retail_sales
GROUP BY gender;

-- for Beauty
SELECT
	gender,
	ROUND(AVG(age)) AS age
FROM retail_sales
WHERE category = "Beauty"
GROUP BY gender;

-- for Clothing
SELECT
	gender,
	ROUND(AVG(age)) AS age
FROM retail_sales
WHERE category = "Clothing"
GROUP BY gender;

-- for Electronics
SELECT
	gender,
	ROUND(AVG(age)) AS age
FROM retail_sales
WHERE category = "Electronics"
GROUP BY gender;

-- Find customer who make repeat order (for all category)
-- in a Day (order > 2)
SELECT 
	customer_id, 
	sale_date AS day 
FROM retail_sales 
GROUP BY customer_id, day 
HAVING COUNT(*) > 2 
ORDER BY customer_id, day ;

-- in a Week (order > 3)
SELECT
	customer_id,
	CONCAT("Week-",WEEK(sale_date), " of ", YEAR(sale_date)) AS order_date
FROM retail_sales
GROUP BY customer_id, order_date
HAVING COUNT(*) > 3
ORDER BY customer_id;

-- in a Month (order > 7) 
SELECT
	customer_id,
	DATE_FORMAT(sale_date,"%Y-%m") AS order_date
FROM retail_sales
GROUP BY customer_id, order_date
HAVING COUNT(customer_id) > 7
ORDER BY customer_id, order_date;

-- in a Year (order > 70)
SELECT
	customer_id,
	DATE_FORMAT(sale_date, "%Y") AS order_date
FROM retail_sales
GROUP BY customer_id, order_date
HAVING COUNT(customer_id) > 70
ORDER BY customer_id, order_date;

/* ===== Generate Report that shows all key metrics of business ===== */
SELECT "Total Sales" AS measure_name, SUM(total_sale) AS measure_value FROM retail_sales
UNION ALL
SELECT "Total Customer" AS measure_name, COUNT(DISTINCT(customer_id)) AS measure_value FROM retail_sales
UNION ALL
SELECT "Total Category" AS measure_name, COUNT(DISTINCT(category)) AS measure_value FROM retail_sales
UNION ALL
SELECT "Total Nr. Product Sold" AS measure_name, SUM(quantiy) AS measure_value FROM retail_sales
UNION ALL
SELECT "Total Nr. Order" AS measure_name,	COUNT(transactions_id) AS measure_value FROM retail_sales;








