-- sql retail sales analysis
drop table if exists retail_sales;
create table retail_sales(
	transaction_id int primary key,
	sales_date date,
	sales_time time,
	customer_id int,
	gender varchar(20),
	age int,
	category varchar(50),
	quantity int,
	price_per_unit float,
	cogs float,
	total_sale float
);
--counting rows
select count(*) from retail_sales;
-- data cleaning
select * from retail_sales
where 
	transaction_id is null
	or
	sales_date is null
	or
	sales_time is null
	or
	customer_id is null
	or
	gender is null
	or
	age is null
	or
	category is null
	or
	quantity is null
	or
	price_per_unit is null
	or
	cogs is null
	or
	total_sale is null;

--deleting null values
delete from retail_sales
where
	transaction_id is null
	or
	sales_date is null
	or
	sales_time is null
	or
	customer_id is null
	or
	gender is null
	or
	age is null
	or
	category is null
	or
	quantity is null
	or
	price_per_unit is null
	or
	cogs is null
	or
	total_sale is null;
--total sales
select count(*) total_sale
from retail_sales;
--total customers
select count( distinct customer_id) as total_sale
from retail_sales;
--total categories
select count(distinct category) as total_sale
from retail_sales;
select distinct category from retail_sales;

--data analysis
select * from retail_sales;
--q1. retrieve all sale from '2022-11-05'
select *
from retail_sales
where sales_date = '2022-11-05';
--q2.all transaction where category as 'clothing' and quantity >3 in nov-2022.
select *
from retail_sales
where 
	category='clothing' 
	and to_char(sales_date, 'YYYY-MM')='2022-11'
	and quantity >=3;
--q3.total sale of each category
select
	category,
	sum(total_sale) as net_sale,
	count(*) as total_orders
from retail_sales
group by 1;

--q4.average age of customer from beauty category
select
	round(avg(age),2) as avg_age
	from retail_sales
	where category = 'Beauty';
--q5.all transaction where total sale>1000
select *
from retail_sales
where total_sale > 1000 

--q6.total transaction made bt each gender in each category
select category,gender,
count(*) as total_trans
from retail_sales
group by category,gender
order by 1

--q7.calculate avg sale from each month and best selling month each year
select * from
	(
	select
		extract(year from sales_date) as year,
		extract(month from sales_date) as month,
		avg(total_sale) as avg_sale,
		rank() over(partition by extract(year from sales_date) order by avg(total_sale) desc) as rank
	from retail_sales
	group by 1,2
) as t1
where rank = 1
-- order by 1,3 desc
--q8. top 5 customer based on highest total sale
select 
customer_id,
sum(total_sale) as total_sale
from retail_sales
group by 1
order by 2 desc
limit 5
--q9.number of unique customer who purchase item from each cattegory
select
count(distinct customer_id),
category
from retail_sales
group by category

--q10.query to create each shift and number of order
with hourly_sales
as
(
select *,
	case
		when extract(hour from sales_time) < 12 then 'morning'
		when extract(hour from sales_time) between 12 and 17 then 'afternoon'
		else 'evening'
	end as shift
from retail_sales
)
select shift,
count(*) as total_orders
from hourly_sales
group by shift

--project end






