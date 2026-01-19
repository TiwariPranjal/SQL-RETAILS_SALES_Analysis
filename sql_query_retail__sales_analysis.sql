Create TABLE IF NOT EXISTS retail_sales(
transactions_id	 INT PRIMARY KEY,
sale_date	DATE,
sale_time	TIME,
customer_id	VARCHAR(20),
gender	VARCHAR(20),
age	INT,
category VARCHAR(20),
quantiy	INT,
price_per_unit	Float,
cogs	Float,
total_sale	Float
);

ALTER TABLE retail_sales
RENAME COLUMN Quantiy TO Quantity;


SELECT * FROM retail_sales;

SELECT Count(*)AS TOTAL_DATA From retail_sales;

--------------------------------------------------

-- data Cleaning--

Select * from retail_sales
WHERE
	transactions_id is NULL OR
	sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL
	OR total_sale IS NULL;

Delete from retail_sales
	WHERE
	transactions_id is NULL OR
	sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL
	OR total_sale IS NULL;
---------------------------------------------------------------------------

-- after cleaning the data

SELECT * FROM retail_sales;

SELECT Count(*)AS TOTAL_DATA From retail_sales;


-- Data Exploration

-- How many sales we have?

SELECT COUNT(*) as total_sale FROM retail_sales

-- How many uniuque customers we have ?

SELECT COUNT(DISTINCT customer_id) as total_customer FROM retail_sales;

---- Data analysis and Findings-----------

-- 1. Write a SQL query to retrieve all columns for sales made on '2022-11-05':

Select * from retail_sales
Where sale_date ='2022-11-05'

-- 2. Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:

Select * from retail_sales
WHERE category='Clothing'
	  And quantity>=4 And sale_date between '01-11-2022' and '30-11-2022';

	  -- or

SELECT * FROM retail_sales
WHERE 
    category = 'Clothing' AND 
    TO_CHAR(sale_date, 'YYYY-MM') = '2022-11' AND
    quantity >= 4 
order by sale_date;

-- 3. Write a SQL query to calculate the total sales (total_sale) for each category.:

Select category,
	   Sum(total_sale) As Total_sales_by_category,
from retail_sales
Group by category;

         --or
SELECT 
    category,
    SUM(total_sale) as net_sale,
    COUNT(*) as total_orders
FROM retail_sales
GROUP BY 1

-- 4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:

Select Avg(age)from retail_sales
WHERE category='Beauty'
   -- or
SELECT
    ROUND(AVG(age), 2) as avg_age
FROM retail_sales
WHERE category = 'Beauty'

-- 5. Write a SQL query to find all transactions where the total_sale is greater than 1000.

Select * from retail_sales
Where total_sale>1000;

-- 6. Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

Select category, gender,
	   Sum(total_sale) As total_sales,
	   count(*) as total_trans
From retail_sales
Group by category, gender
Order by category
    
-- 7. Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:

Select 
	year,
	month
	avg_sale FROM
(
Select 
	Extract(year from sale_date)as YEAR,
	Extract(month from sale_date)As Month,
	Avg(total_sale) as AVG_sale,
	Rank() over(partition by Extract(year from sale_date) order by Avg(total_sale) Desc)
From retail_sales	
Group by 1,2
) as t1
where rank=1


-- 8. Write a SQL query to find the top 5 customers based on the highest total sales 

Select customer_id ,
       Sum(total_sale)As Customer_total_sales
from retail_sales
Group by customer_id
order by Customer_total_sales Desc
limit 5;

-- 9. Write a SQL query to find the number of unique customers who purchased items from each category.:

Select category,
	   count(distinct customer_id) As uniq_customer
from retail_sales
group by category;

-- 10. Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):
WITH hourly_sales AS (
    SELECT *,
           EXTRACT(HOUR FROM sale_time) AS sale_hour
    FROM retail_sales
)
SELECT
    CASE
        WHEN sale_hour < 12 THEN 'Morning'
        WHEN sale_hour BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS shift_name,
    COUNT(*) AS total_orders
FROM hourly_sales
GROUP BY shift_name;

--- or ---

SELECT
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS shift_name,
    COUNT(*) AS total_orders
FROM retail_sales
GROUP BY shift_name;

-- or ---

WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift;