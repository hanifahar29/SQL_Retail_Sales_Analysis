-- Create TABLE
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
(
	transactions_id	INT PRIMARY KEY,
	sale_date DATE,
	sale_time TIME,
	customer_id INT,
	gender VARCHAR(15),
	age	INT,
	category VARCHAR(15),	
	quantiy	INT,
	price_per_unit FLOAT,	
	cogs FLOAT,
	total_sale FLOAT
);

SELECT * FROM retail_sales;

-- check missing value
SELECT * FROM retail_sales
WHERE 
	transactions_id	IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR
	age IS NULL
	OR
	category IS NULL
	OR
	quantiy IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;

-- Delete missing value 
DELETE FROM retail_sales
WHERE 
	transactions_id	IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR
	age IS NULL
	OR
	category IS NULL
	OR
	quantiy IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;

--  Data Exploration

-- How many sales we have?
SELECT COUNT (*) AS total_sales FROM retail_sales;

-- How many unique customers we have?
SELECT COUNT(DISTINCT customer_id) AS total_customer FROM retail_sales;

-- Data Anaysis & Business Key Problems & Answers

-- My Analysis & Findings
-- Q1 Write a SQL query to retrieve all columns for sale made on '2022-11-05'
-- Q2 retrieve all transaction where the category is 'clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q3 calculate the total sales for each category
-- Q4 find the average age of customers who purchased items from the 'Beauty' category
-- Q5 find all transaction where the total sales is greater than 1000
-- Q6 find the total number of transactions made by each gender in each category
-- Q7 calculate the average sale for each month. Find out best selling month in each year
-- Q8 find the top 5 customers based on the highest total sales
-- Q9 find the number of unique customers who purchased items from each category
-- Q10 create each shift and number of orders (Ex: Morning <=12, Afternoon Between 12 & 17, Evening >17)

-- Q1 Write a SQL query to retrieve all columns for sale made on '2022-11-05'
SELECT * FROM retail_sales
WHERE sale_date = '2022-11-05'

-- Q2 retrieve all transaction where the category is 'clothing' and the quantity sold is more than 10 in the month of Nov-2022
SELECT * FROM retail_sales
WHERE 
	category = 'Clothing'
	AND 
	quantiy >=4
	AND
	TO_CHAR(sale_date, 'YYYY-MM') = '2022-11';

-- Q3 calculate the total sales for each category
SELECT 
	category,
	SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY category;

-- Q4 find the average age of customers who purchased items from the 'Beauty' category
SELECT ROUND(AVG (age)) AS avg_age_cust 
FROM retail_sales
WHERE category = 'Beauty';

-- Q5 find all transaction where the total sales is greater than 1000
SELECT * FROM  retail_sales
WHERE total_sale > 1000;

-- Q6 find the total number of transactions made by each gender in each category
SELECT
	gender,
	category,
	COUNT(transactions_id)
FROM retail_sales
GROUP BY category, gender
ORDER BY category;

-- Q7 calculate the average sale for each month. Find out best selling month in each year
SELECT 
	year,
	month,
	avg_sale
FROM (
	SELECT 
		EXTRACT (YEAR FROM sale_date) AS year,
		EXTRACT (MONTH FROM sale_date) AS month,
		AVG(total_sale) AS avg_sale,
		RANK () OVER (
			PARTITION BY EXTRACT (YEAR FROM sale_date) 
			ORDER BY AVG(total_sale) DESC
			) AS rank
	FROM retail_sales
	GROUP BY 1, 2
	) AS t1
WHERE rank = 1

-- Q8 find the top 5 customers based on the highest total sales
SELECT 
	customer_id,
	SUM (total_sale) AS total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;

-- Q9 find the number of unique customers who purchased items from each category
SELECT
	category,
	COUNT(DISTINCT customer_id) AS count_unique_cust
FROM retail_sales
GROUP BY category;

-- Q10 create each shift and number of orders (Ex: Morning <=12, Afternoon Between 12 & 17, Evening >17)
WITH hourly_sale
AS (
	SELECT *,
	CASE
		WHEN EXTRACT (HOUR FROM sale_time) < 12 THEN 'Morning'
		WHEN EXTRACT (HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END AS shift
	FROM retail_sales
	)
SELECT 
	shift,
	COUNT(*) AS total_orders
FROM hourly_sale
GROUP BY shift;

-- End of project