![SQL](https://img.shields.io/badge/SQL-Analysis-blue?logo=postgresql)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-Data--Cleaning-blue?logo=postgresql)
![Status](https://img.shields.io/badge/Status-Completed-brightgreen)

# 🛒 Retail Sales Analysis (SQL)

## 🧭 Overview
This SQL-based project explores key trends in the retail market—such as category performance, customer demographics, and sales timing. Unlike simple data entry, this project focuses on deep-dive analysis using raw transaction data, data cleaning, and advanced SQL queries to answer real-world business questions.

▶️ [**Retail_Analysis.sql**](reatil_sales_query.sql) — includes all the table definitions, data cleaning scripts, and business queries used in the analysis.

## 📚 Research Questions
This project dives into four main areas through 10 specific questions:
1. Sales Performance: Which categories and dates drive the highest revenue?
2. Customer Demographics: What is the age and gender distribution of our customers?
3. Operational Trends: Which time shifts (Morning/Afternoon/Evening) are most active?
4. Customer Insights: Who are our most loyal and high-spending customers?

## 📄 Dataset Description
The dataset used in this project is retail_sales, which contains transaction records. It includes:
- 💼 Transaction IDs (Unique identifiers)
- 💰 Financial Info (Price per unit, COGS, Total sale)
- 🌍 Customer Demographics (Gender, Age, ID)
- 🛠️ Product Category (Clothing, Beauty, etc.)
- 📅 Time Data (Sale date and Sale time)

## 🛠️ SQL Skills Used
This analysis applies a full set of modern SQL techniques to uncover trends:
- 🔍 Data Cleaning: Using IS NULL and DELETE for data integrity.
- 💪 Aggregations: Using SUM, AVG, and COUNT for key metrics.
- 📊 Window Functions: Using RANK() and PARTITION BY for ranking sales.
- 🧮 Common Table Expressions (CTE): For structured and readable multi-step queries.
- ⚡ Conditional Logic: Using CASE for time segmentation.
---
## 1️⃣ How does the data need to be prepared?
### 🧮 Method: DDL & DML (Data Cleaning)
I started by creating the table structure and immediately performed a cleanup to remove any records with missing values to ensure the analysis is accurate.
```sql
-- Create Table & Data Cleaning
CREATE TABLE retail_sales (
    transactions_id INT PRIMARY KEY,
    sale_date DATE,
    sale_time TIME,
    customer_id INT,
    gender VARCHAR(15),
    age INT,
    category VARCHAR(15),    
    quantiy INT,
    price_per_unit FLOAT,   
    cogs FLOAT,
    total_sale FLOAT
);

DELETE FROM retail_sales
WHERE 
    transactions_id IS NULL OR sale_date IS NULL OR sale_time IS NULL OR 
    customer_id IS NULL OR gender IS NULL OR age IS NULL OR 
    category IS NULL OR quantiy IS NULL OR price_per_unit IS NULL OR 
    cogs IS NULL OR total_sale IS NULL;
```
## 2️⃣ What are the key sales performance metrics?
### 🧮 Method: Aggregations & Filtering
I applied various filtering and aggregation techniques to extract core performance data:
- **Q1: Daily Transaction Retrieval:** I retrieved all transaction details for a specific high-traffic date ('2022-11-05') to analyze daily operations.
``` sql
SELECT * FROM retail_sales
WHERE sale_date = '2022-11-05'
```
- **Q2: High-Volume Category Analysis:** I filtered for 'Clothing' sales where the quantity sold was 4 or more within November 2022 to identify bulk purchase trends.
``` sql
SELECT * FROM retail_sales
WHERE 
	category = 'Clothing'
	AND 
	quantiy >=4
	AND
	TO_CHAR(sale_date, 'YYYY-MM') = '2022-11';
```
- **Q3: Revenue per Category** I calculated the total sales amount for each product category to determine which sectors are the primary revenue drivers.
``` sql
SELECT 
	category,
	SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY category;
```
- **Q5: High-Value Transaction Identification** I isolated all transactions where the total sale amount exceeded 1000 to identify premium customer spending.
``` sql
SELECT * FROM  retail_sales
WHERE total_sale > 1000;
```
#### **📊 Key Findings**
- **📈 Specific Growth:** The 'Clothing' category showed high-volume potential during seasonal peaks (Nov-2022).
- **💼 Premium Market:** Identified a consistent segment of high-value transactions (over 1000), suggesting a strong market for premium items.
- **💰 Category Leadership:** The total sales calculation clearly highlights which categories contribute the most to the bottom line.

## 3️⃣ What do we know about our customers?
### 🧮 Method: Descriptive Statistics
I analyzed customer demographics and behavior through these specific queries:
- **Q4: Target Audience Age:** Found the average age of customers purchasing from the 'Beauty' category to understand its demographic.
``` sql
SELECT ROUND(AVG (age)) AS avg_age_cust 
FROM retail_sales
WHERE category = 'Beauty';
```
- **Q6: Gender-Based Category Preference:** Counted transactions by gender in each category to see which groups prefer which products.
``` sql
SELECT
	gender,
	category,
	COUNT(transactions_id)
FROM retail_sales
GROUP BY category, gender
ORDER BY category;
```
- **Q8: Top Spenders Identification:** Identified the top 5 customers based on their total spending.
``` sql
SELECT 
	customer_id,
	SUM (total_sale) AS total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;
```
- **Q9: Customer Reach:** Counted unique customers per category to measure market penetration.
``` sql
SELECT
	category,
	COUNT(DISTINCT customer_id) AS count_unique_cust
FROM retail_sales
GROUP BY category;
```
#### 📊 Key Findings
- **🎯 Loyalty Potential:** We can identify exactly who our top 5 customers are for potential VIP rewards.
- **🌍 Demographic Targeting:** Understanding the average age and gender preferences helps in tailoring marketing campaigns.

## 4️⃣ When are the most productive sales periods?
### 🧮 Method: Window Functions & CTE
I identified peak periods to help optimize staffing and inventory management:
- **Q7: Seasonal Performance Ranking:** Used RANK() to find the best-selling month for each year based on average sales.
``` sql
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
```
- **Q10: Shift-Based Order Volume:** Created a CTE with CASE logic to segment sales into 'Morning', 'Afternoon', and 'Evening' shifts.
``` sql
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
```
#### 📊 Key Findings
- **🌐 Operational Efficiency:** Analysis of shifts reveals when the store is busiest, assisting in better staff allocation.
- **☁️ Trend Consistency:** Seasonal rankings highlight consistent growth months across 2022 and 2023.

## ✅ Conclusion
As someone passionate about data, this project gave me a hands-on way to explore the retail market. Using real transaction records, I analyzed trends in revenue, customer behavior, and timing—all in SQL. With the help of tools like CTEs, Window Functions, and Case Statements, I uncovered key links between product categories and consumer habits.

🔍 I hope this project offers helpful insights—whether you're into retail, data analysis, or exploring what SQL can do.

### 📩 Contact & Connect
If you have any questions or would like to collaborate, feel free to reach out!
- LinkedIn: [Hanifah Arrasyidah](https://www.linkedin.com/in/hanifaharrasyidah/)
- GitHub: [Hanifah Arrasyidah](https://github.com/hanifahar29)
- Email: hanifaharrasyidah@email.com
