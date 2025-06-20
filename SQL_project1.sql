-- DROP TABLE IF EXISTS retail_sales;

create table retail_sales
(
				transactions_id INT PRIMARY KEY,
				sale_date DATE,
				sale_time TIME,
				customer_id	INT,
				gender VARCHAR(15),
				age INT,
				category VARCHAR(15),
				quantiy INT,
				price_per_unit FLOAT,
				cogs FLOAT,
				total_sale FLOAT
);

SELECT COUNT(*) FROM retail_sales;


SELECT * FROM retail_sales
limit 50;

-- Data Cleaning
SELECT *
FROM retail_sales
WHERE transactions_id is null;


SELECT *
FROM retail_sales
WHERE 
	transactions_id is null
	or
	sale_date is null
	or
	sale_time is null
	or
	customer_id is null
	or
	gender is null
	or
	age is null
	or
	category is null
	or
	quantiy is null
	or
	price_per_unit is null
	or
	cogs is null
	or
	total_sale is null;

DELETE FROM retail_sales
WHERE 
	transactions_id is null
	or
	sale_date is null
	or
	sale_time is null
	or
	customer_id is null
	or
	gender is null
	or
	age is null
	or
	category is null
	or
	quantiy is null
	or
	price_per_unit is null
	or
	cogs is null
	or
	total_sale is null;

-- Exploration

--How many sales we have?

SELECT COUNT(*) as total_sales
from retail_sales;

-- How Many Category we have?
select distinct category from retail_sales;

-- Data Analysis & Businnes key problmes & Answers
-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17


-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
select * from retail_sales
where sale_date = '2022-11-02';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
select * 
from retail_sales
WHERE 
	category = 'Clothing'
	and 
	to_char(sale_date,'yyyy-mm')= '2022-11'
	and 
	quantiy >= 4;

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
select
	category,
	sum(total_sale) as net_sale,
	count(*) as total_order
from retail_sales
group by 1;


-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
select 
	round(avg(age), 2 ) as AVG_age
from retail_sales
where category ='Beauty';


-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
select *
from retail_sales
where total_sale >= 1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
select
	category,
	gender,
	count(*)
from retail_sales
group by
	category,
	gender
order by category;



-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
select
	year,
	month,
	avg_sale
from
(
select 
	EXTRACT(YEAR FROM sale_date) as year,
	EXTRACT(MONTH FROM sale_date) as month, 
	avg(total_sale) as avg_sale,
	rank() over(PARTITION BY EXTRACT(YEAR FROM sale_date) order by avg (total_sale)DESC) as rank
from retail_sales
group by 1, 2
) as t1
WHERE rank =1

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 


select 
	customer_id,
	sum(total_sale) as tolal_sale
from retail_sales
group by 1
order by 2 desc
limit 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

select
	category,
	count(DISTINCT customer_id) as ctn_unique_cs
from retail_sales
group by 1;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17
WITH hourly_sale
AS
(
select *,
	CASE
		WHEN EXTRACT(HOUR FROM sale_time) <12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END AS shift
from retail_sales
)
select 
	shift,
	count(*) as total_orders
from hourly_sale
group by shift;

--

	