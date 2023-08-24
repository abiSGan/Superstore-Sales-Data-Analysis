use mydb
select top 5 * from dbo.superstore_data;
select top 5 sales from dbo.superstore_data;

/*Beginning Analysis */
/* 1. What are the total sales and total profits of each year? */
select year(order_date) as year, sum(sales) as total_sales, sum(profit) as total_profits from dbo.superstore_data group by year(order_date) order by year(order_date);

/* 2. What are the total profits and total sales per quarter? */
select year(order_date) as year, datepart(quarter, order_date) as quarter, sum(sales) as total_sales, sum(profit) as total_profits from dbo.superstore_data group by year(order_date), datepart(quarter, order_date) order by year(order_date), datepart(quarter, order_date);
select datepart(quarter, order_date) as quarter, sum(sales) as total_sales, sum(profit) as total_profits from dbo.superstore_data group by datepart(quarter, order_date) order by datepart(quarter, order_date);

/* 3. What region generates the highest sales and profits? */
select region, sum(sales) as total_sales, sum(profit) as total_profit from dbo.superstore_data group by Region order by total_profit desc;

/* 4. Analysing profit margin of each region (profit margin = net profit/ total revenue)*100? */
select region, round(sum(profit)/ sum(sales)*100,2) as profit_margin from dbo.superstore_data group by region order by profit_margin;

/* 5. What state and city brings in the highest sales and profits? */
select state, max(sales) as total_sales from dbo.superstore_data group by state order by total_sales desc;
select city, max(sales) as total_sales from dbo.superstore_data group by City order by total_sales desc;

select state, max(profit) as total_profit from dbo.superstore_data group by state order by total_profit desc;
select city, max(sales) as total_profit from dbo.superstore_data group by City order by total_profit desc;

/* 6. The relationship between discount and sales and the total discount per category */

--relationship between discount and sales- to find correlation coeff
select round(discount, 2) as discount, avg(sales) as avg_sales from dbo.superstore_data group by discount order by round(discount, 2);

--finding correlation coefficient- XXX there is no way to find cor coeff directly in sql server. You have to use a statistical tool to achieve this
SELECT 
    CORREL(round(discount, 2), avg(sales)) AS CorrelationCoefficient
FROM 
    dbo.superstore_data;

-- Total discount per category
select category, sum(discount) as total_discount from dbo.superstore_data group by category order by total_discount desc;

SELECT category, sub_category, SUM(discount) AS total_discount
FROM dbo.superstore_data
GROUP BY category, sub_category
ORDER BY total_discount DESC;

/* 7. What category generates the highest sales and profit in each region and state */

select region, category, sum(sales) as total_sales, sum(profit) as total_profit from dbo.superstore_data group by region, category order by total_profit desc;
select state, category, sum(sales) as total_sales, sum(profit) as total_profit from dbo.superstore_data group by state, category order by total_profit desc;

/* 8. What subcategory generates the highest sales and profits in each region and state? */

select region, sub_category, sum(sales) as total_sales, sum(profit) as total_profit from dbo.superstore_data group by region, sub_category order by total_profit desc;
select state, sub_category, sum(sales) as total_sales, sum(profit) as total_profit from dbo.superstore_data group by state, sub_category order by total_profit desc;

/* 9. What are the names of the products that are the most and least profitable to us? */

select product_name, sum(profit) as total_profit from dbo.superstore_data group by product_name order by total_profit;

/* 10. What segments make the most of our profits and sales? */

select Segment, sum(sales) as total_sales, sum(profit) as total_profit from dbo.superstore_data group by segment order by total_profit desc;

/* 11. How many customers do we have in total and how much per region and state? */

select count(customer_id) from dbo.superstore_data;
select region, count(customer_id) from dbo.superstore_data group by region;
select state, count(customer_id) from dbo.superstore_data group by state;

/* customer rewards program */

SELECT top 15 customer_id, 
SUM(sales) AS total_sales,
SUM(profit) AS total_profit
FROM dbo.superstore_data
GROUP BY customer_id
ORDER BY total_sales DESC;


/* Average shipping time per class and in total? */

SELECT round(avg(DATEDIFF(DAY, Order_Date, ship_Date)), 1) AS DaysBetween
FROM dbo.superstore_data;

SELECT ship_mode, round(avg(DATEDIFF(DAY, Order_Date, ship_Date)), 1) AS DaysBetween
FROM dbo.superstore_data group by Ship_Mode order by DaysBetween;
