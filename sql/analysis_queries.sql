-- =========================
-- Data Integrity Test
-- =========================
SELECT COUNT(*) FROM orders;
SELECT COUNT(*) FROM order_items;
SELECT COUNT(*) FROM customers;

-- =========================
-- KPIs
-- =========================

-- 1) Total Revenue
SELECT SUM(price + freight_value) AS total_revenue
FROM order_items;

-- 2) Total Orders
SELECT COUNT(*) FROM orders;

-- 3) Total Customers
SELECT COUNT(DISTINCT customer_unique_id)
FROM customers;

-- Avg  = sum of total records / count of unique records
-- 4) Average Order Value(average of all the orders placed)
SELECT SUM(price + freight_value) / COUNT(DISTINCT order_id) AS average_order_value
FROM order_items;

-- 5) Orders Per Customer (average value of order per customer)
SELECT COUNT(*) / COUNT(DISTINCT customer_id)
FROM orders;

-- 6) Monthly Revenue Trend
select TO_CHAR(o.order_purchase_timestamp, 'YYYY-MM') AS month,
sum(oi.price + oi.freight_value)
from 
order_items as oi
join orders as o
on oi.order_id = o.order_id
group by month
order by month asc;

-- 7) Month-over-Month Growth
SELECT
t.*,lag(t.revenue,1,0) over() as prev_revenue,
(t.revenue - lag(t.revenue,1,0) over()) as mom_revenue,
(t.revenue - lag(t.revenue,1,0) over()) * 100.0 / lag(t.revenue,1,1) over() as mom_perc
from
(SELECT TO_CHAR(o.order_purchase_timestamp,'YYYY-MM') AS month,
sum(oi.price + oi.freight_value) AS revenue
from
orders as o
join order_items as oi
on o.order_id=oi.order_id
group by month
order by month) t;

-- 8) Top 10 Products by Revenue
SELECT p.product_category_name,oi.product_id ,SUM(price + freight_value) AS total_revenue
FROM order_items as oi
join products as p
on oi.product_id=p.product_id
group by oi.product_id,p.product_category_name
order by total_revenue desc
limit 10;

-- 9)Category revenue
SELECT p.product_category_name,SUM(price + freight_value) AS total_revenue
FROM order_items as oi
join products as p
on oi.product_id=p.product_id
group by p.product_category_name
order by total_revenue desc;


--10)Repeted customer
select count(*) 
from (
SELECT customer_id,count(customer_id) as order_count
from orders 
group by customer_id
having count(customer_id) > 1
order by customer_id desc
);

-- 11) Repeat Rate -> Rate => %

select (count(*) * 100  / (SELECT COUNT(*) FROM customers)) as repeat_rate
from (
SELECT customer_id,count(customer_id) as order_count 
from orders 
group by customer_id
having count(customer_id) > 1
order by customer_id desc
);

-- 12) Customer Lifetime Value (CLV)
select customer_id ,sum(price+ freight_value)as CLV from 
orders as o
join order_items as oi
on o.order_id= oi.order_id
group by customer_id
order by CLV desc ;

-- 13) Revenue by State
select t.customer_state, sum(price+ freight_value) as revenue
from
(select * from 
customers as c
join orders as o 
on c.customer_id=o.customer_id
join order_items as oi
on o.order_id=oi.order_id) t
group by t.customer_state
order by revenue desc;

-- 14) Monthly orders

select count(*) as total_order, TO_CHAR(o.order_purchase_timestamp, 'YYYY-MM') AS month
from
orders as o
group by month
order by month desc;

-- 15) Quarterly Revenue
select Concat(Extract(Year from o.order_purchase_timestamp),'-Q',Extract(Quarter from o.order_purchase_timestamp)) as quarter,
sum(oi.price + oi.freight_value) as revenue
from 
orders as o
join order_items as oi 
on o.order_id = oi.order_id
group by quarter
order by quarter asc
;

-- 16) Average Basket Size
SELECT AVG(item_count)
FROM (
    SELECT order_id, COUNT(*) AS item_count
    FROM order_items
    GROUP BY order_id
) t;

-- 17) Basket Size Distribution **(Show how many orders are there with items in cart eg.)
-- item_in_cart | num_of_order
-- 		1			31231
-- 		2   		21233
-- 		3			12131
-- 		4			1212
-- 		.			  .
SELECT 
    item_count,
    COUNT(*) AS num_orders
FROM (
    SELECT order_id, COUNT(*) AS item_count
    FROM order_items
    GROUP BY order_id
) t
GROUP BY item_count
ORDER BY item_count;

-- 18) High Value Orders % -> (per of orders that are greater then 1000) 
select (count(*) * 100.0)/ (SELECT count(Distinct order_id) from order_items) as high_order_perc
from
(select order_id ,sum(price+freight_value)as price 
from 
order_items
group by order_id
having sum(price+freight_value) >1000)t;


-- 19) New Customers per Month
SELECT 
    TO_CHAR(first_order, 'YYYY-MM') AS month,
    COUNT(*) AS new_customers
FROM (
    SELECT customer_id, MIN(order_purchase_timestamp) AS first_order
    FROM orders
    GROUP BY customer_id
) t
GROUP BY month
ORDER BY month;

-- 20) Repeated customers per month
select to_char(order_purchase_timestamp,'YYYY-MM')
from 
(select count(*),customer_id
FROM orders
group by customer_id
having count(*) > 1)t
group by t.order_purchase_timestamp;


-- 21) Days Between Purchases
SELECT 
    customer_id,
    order_purchase_timestamp,
    LEAD(order_purchase_timestamp) OVER (
        PARTITION BY customer_id 
        ORDER BY order_purchase_timestamp
    ) AS next_order,
    EXTRACT(DAY FROM 
        LEAD(order_purchase_timestamp) OVER (
            PARTITION BY customer_id 
            ORDER BY order_purchase_timestamp
        ) - order_purchase_timestamp
    ) AS days_between
FROM orders;

-- 22) Avg Days Between Purchases
SELECT AVG(days_between)
FROM (
    SELECT 
        EXTRACT(DAY FROM 
            LEAD(order_purchase_timestamp) OVER (
                PARTITION BY customer_id 
                ORDER BY order_purchase_timestamp
            ) - order_purchase_timestamp
        ) AS days_between
    FROM orders
) t
WHERE days_between IS NOT NULL;

-- 23) % Revenue from Top Products
select t.product_id, t.revenue ,
t.revenue * 100.0/ (select sum(t.revenue) from
(SELECT product_id, sum(price+freight_value) as revenue
from order_items
group by product_id
order by revenue desc
limit 10) t)
from 
(SELECT product_id, sum(price+freight_value) as revenue
from order_items
group by product_id
order by revenue desc
limit 10) t;


-- using CTE(Common Table Expression)
with top_product as (SELECT product_id, sum(price+freight_value) as revenue
from order_items
group by product_id
order by revenue desc
limit 10)
select product_id,revenue, revenue * 100.0/(select sum(revenue) from top_product) from top_product;



-- 24)Revenue Distribution (Buckets)
select case
	when t.order_value < 100 then 'LOW'
	when t.order_value between 100 AND 500 then 'MEDIUM'
	when t.order_value > 500 then 'HIGH'
end as bucket,
count(*)
from
 (SELECT order_id, SUM(price + freight_value) AS order_value
    FROM order_items
    GROUP BY order_id)t
group by bucket;

-- 25) New vs Repeat Customer Ratio
SELECT 
    SUM(CASE WHEN order_count = 1 THEN 1 ELSE 0 END) AS new_customers,
    SUM(CASE WHEN order_count > 1 THEN 1 ELSE 0 END) AS repeat_customers
FROM (
    SELECT customer_id, COUNT(*) AS order_count
    FROM orders
    GROUP BY customer_id
) t;

-- 26) Top 10 Customers 
SELECT 
    o.customer_id,
    SUM(oi.price + oi.freight_value) AS total_spent
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.customer_id
ORDER BY total_spent DESC
LIMIT 10;

-- 27) 60-Day Return Rate
SELECT 
    COUNT(DISTINCT customer_id) * 100.0 / 
    (SELECT COUNT(DISTINCT customer_id) FROM orders) AS return_60d
FROM (
    SELECT customer_id,
	Extract(day from
	 LEAD(order_purchase_timestamp) OVER (PARTITION BY customer_id ORDER BY order_purchase_timestamp)
           - order_purchase_timestamp
		   )
           AS gap
    FROM orders
) t
WHERE gap <= 60;

-- 28) Avg First → Second Purchase Gap
select avg(gap) from
(SELECT customer_id,
           LEAD(order_purchase_timestamp) OVER (PARTITION BY customer_id ORDER BY order_purchase_timestamp)
           - order_purchase_timestamp AS gap,
		   row_number() OVER (PARTITION BY customer_id ORDER BY order_purchase_timestamp) as rn
    FROM orders)
where rn  = 1;

-- 29) Median Time Between Purchases
SELECT PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY gap)
FROM (
    SELECT 
        EXTRACT(DAY FROM 
            LEAD(order_purchase_timestamp) OVER (PARTITION BY customer_id ORDER BY order_purchase_timestamp)
            - order_purchase_timestamp
        ) AS gap
    FROM orders
) t
WHERE gap IS NOT NULL;

-- 30) Monthly Active Customers
SELECT 
    TO_CHAR(order_purchase_timestamp, 'YYYY-MM') AS month,
    COUNT(DISTINCT customer_id) AS active_customers
FROM orders
GROUP BY month
ORDER BY month;

-- 31)Churn proxy
SELECT 
    COUNT(DISTINCT customer_id)
FROM orders
WHERE customer_id NOT IN (
    SELECT customer_id
    FROM orders
    WHERE order_purchase_timestamp >= '2018-01-01'
);

-- 32)Repeat Rate by Region

SELECT 
    c.customer_state,
    COUNT(DISTINCT CASE WHEN order_count > 1 THEN o.customer_id END) * 100.0
    / COUNT(DISTINCT o.customer_id) AS repeat_rate
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN (
    SELECT customer_id, COUNT(*) AS order_count
    FROM orders
    GROUP BY customer_id
) t ON o.customer_id = t.customer_id
GROUP BY c.customer_state;

-- 33) Orders by Region (Trend)
SELECT 
    c.customer_state,
    COUNT(*) AS orders
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_state
ORDER BY orders DESC;

-- 34) Top vs Long-Tail Revenue
WITH ranked_products AS (
    SELECT 
        product_id,
        SUM(price + freight_value) AS revenue,
        NTILE(10) OVER (ORDER BY SUM(price + freight_value) DESC) AS bucket
    FROM order_items
    GROUP BY product_id
)
SELECT 
    CASE WHEN bucket = 1 THEN 'Top 10%' ELSE 'Long Tail' END AS segment,
    SUM(revenue) AS total_revenue
FROM ranked_products
GROUP BY segment;