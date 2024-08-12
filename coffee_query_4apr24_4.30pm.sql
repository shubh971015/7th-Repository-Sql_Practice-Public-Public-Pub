
############ create a database ############

create database  coffee_chain;
use coffee_chain;

############ create tables ############
  
create table coffee
(
Area int,
Date date  ,
Product varchar(30),
Product_Line varchar(30) ,
Product_Type varchar(30),
State varchar(30),
Territory varchar (30),
Type varchar (30),
Budget_Profit int,
Budget_Sales int,
Marketing int,
Profit int,
Sales int,
Total_Expenses int);

############ LOAD DATA  ############
  
load data infile 
'E:\ccc.csv'
into table coffee
fields terminated by ','
ENCLOSED BY '"'
ignore 1 rows
;
describe coffee;

SELECT * FROM coffee_chain.coffee;

#1 What are the top 10 areas by total sales of Espresso products in dataset?
select area , sum(sales) as area_wise_sales ,product_type from coffee
where product_type ='Espresso'
group by area
order by area_wise_sales desc
limit 5;

#2. Which State in the East Market has the lowest Profit for Espresso? New Hampshire
SELECT * FROM coffee_chain.coffee;
SELECT 
    area, state, product_type, Territory, SUM(profit) as Total_profit
FROM
    coffee
WHERE
    product_type = 'Espresso'
        AND Territory = 'east'
GROUP BY area , Territory
ORDER BY Total_profitASC
LIMIT 1;
#4"What are the monthly sales of Decaf products exceeding $30,000 aggregated by month and year ?
select area, type,
		extract(month from date) as month_no,
		extract(year from date) as year_no,
		sum(sales) as month_sales
		from coffee
		where type ='decaf' -- (state = 'colorado' or state='florida')
		group by  month_no,year_no
		having month_sales > 30000
		order by month_no,year_no 
        ;
			
#7. In 2013, identify the State with the highest Profit in the West Market? calfornia
select 
extract(year from date) as year_no,
state,
sum(profit) sum_profit,
territory
from coffee
where territory = 'west' 
and extract(year from date) =2013
group by state
order by sum_profit desc;
;

#9. Identify the % (Expenses / Sales)of the State with the lowest Profit. 45.58%
SELECT * FROM coffee_chain.coffee;
select state ,sum(Total_Expenses),sum(sales),
		concat(round((sum(Total_Expenses)/sum(sales))*100,2),'%') as percent_sales
        from coffee
        group by state
        order by percent_sales asc
        limit 5;
#10. Create a Combined Field with Product and State. Identify the highest selling Product and State.
-- (Colombian, California), (Colombian, New York)
SELECT * FROM coffee_chain.coffee;
select 
concat(product_type,' ', state) as  product_state_combined,
sum(sales) from coffee
group by product_type, state
order by sum(sales) desc 
limit 3;

#11. What is the contribution of Tea to the overall Profit in 2012? 23.45%

SELECT 
    CONCAT(ROUND(SUM(CASE
                        WHEN product_type = 'tea' THEN profit
                        ELSE 0
                    END) / SUM(profit) * 100,2),'%')
                    AS tea_contribution_percentage
FROM
    coffee
WHERE
    EXTRACT(YEAR FROM date) = 2012;

#12. What is the average % Profit / Sales for all the Products starting with C? 
-- i dont understand question ,
select * from coffee;
SELECT 
    concat(ROUND(AVG(profit / sales) * 100, 2),'%') as avg_profit_sales 
FROM
    coffee
WHERE
    product_type LIKE 'c%';
#13. What is the distinct count of Area Codes for the State with the lowest Budget Margin in Small Market? 
select * from coffee;
select count(distinct area)
from coffee
group by state;
#14. Which Product Type does not have any of its Product within the Top 5 Products by Sales? 
#15 find the top 5 products according to sales for each state,

SELECT Product_Type
FROM (
        SELECT Product_Type,
            ROW_NUMBER() OVER (PARTITION BY Product_Type ORDER BY SUM(Sales) DESC) AS row_num
        FROM coffee
        GROUP BY Product_Type
     )  AS ranked_products
WHERE 
    row_num < 5;
#15 find the top 5 products according to sales for each state,
    WITH ranked_products AS (
    SELECT 
        Product,
        State,
        Sales,
        ROW_NUMBER() OVER (PARTITION BY State ORDER BY Sales DESC) AS row_num
    FROM coffee
)
SELECT 
    State,Product,Sales
	FROM ranked_products
WHERE 
    row_num <= 5;


select * from coffee;
-- 16 Top-selling products by total sales revenue:
select product_type ,sum(sales) from coffee
group by product_type
order by sum(sales) desc
limit 1 

;
select * from coffee;

--  17 Seasonal trends in sales volume or profit margins:
select 
extract(month from date) as month,
extract(year from date) as year,
avg(sales) as avg_sales
from coffee
group by month
order by  year,  avg_sales asc;

-- 18 Profitability across different states or territories:
select * from coffee;
select sum(profit),state, territory,
extract(year from date) as year
-- extract(month from date) as month
 from coffee
group by state, year
order by  sum(profit) desc
limit 5
;
-- Average profit margin for each product type:
SELECT product_type, 
       AVG(profit / sales) * 100 AS avg_profit_margin
FROM coffee
GROUP BY product_type;

-- 19 Example query to identify underperforming products
SELECT product_type, 
       AVG(sales) AS avg_sales, 
       AVG(profit) AS avg_profit
FROM coffee
GROUP BY product_type
HAVING avg_sales < (SELECT AVG(sales) FROM coffee) 
   AND avg_profit < (SELECT AVG(profit) FROM coffee);
