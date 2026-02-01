# E-Commerce Sales & Customer Analytics — Python + SQL Project

## Project Objective

The objective of this project is to analyze e-commerce transaction data using SQL and Python to understand sales performance, customer behavior, product trends, and regional patterns. The goal is to derive actionable business insights and build a reproducible analytics pipeline similar to real-world data analyst workflows.

This project demonstrates end-to-end analytics skills including data cleaning, SQL data modeling, KPI computation, customer behavior analysis, retention analysis, and visualization.

---

## Business Scenario

Assume we are working as a Data Analyst for an e-commerce company. The business team wants deeper visibility into revenue drivers, customer purchase behavior, product performance, and geographic trends.

Management is interested in identifying:

- revenue growth patterns  
- high value customers and products  
- repeat purchase behavior  
- customer retention signals  
- regional performance differences  

The analysis will support data-driven decisions around marketing, retention, and product strategy.

---

## 📂 Dataset Overview

This project uses the **Olist Brazilian E-Commerce dataset**, a real-world public dataset that contains transactional data from a large online marketplace in Brazil.

The dataset includes detailed information about customers, orders, products, sellers, payments, reviews, and geolocation. It is structured across multiple relational tables, which makes it suitable for practicing real-world SQL joins, KPI calculation, and business analysis.

**Source:** Kaggle — Olist Brazilian E-Commerce Dataset  
**Time Period Covered:** 2016 – 2018  
**Total Orders:** ~100,000  
**Total Tables:** 9 relational tables  
**Granularity:** Order-level and item-level transactions
  I selected this dataset because it allows deep SQL-based business analysis across multiple connected tables and supports advanced analytical queries, cohort analysis, KPI tracking, and customer behavior insights.

---

# 📊 Dataset Schema — Brazilian E-Commerce (Olist)

This project uses the Olist Brazilian E-Commerce dataset, which contains real transactional data from an online marketplace.  
The dataset is structured in multiple relational tables, similar to a real production database.

---

## 🧾 Orders Table — `olist_orders_dataset.csv`
Contains the main order lifecycle and timestamps.

| Column | Description |
|---------|-------------|
order_id | Unique order identifier |
customer_id | Customer who placed the order |
order_status | Order status (delivered, shipped, canceled, etc.) |
order_purchase_timestamp | Order purchase time |
order_approved_at | Payment approval time |
order_delivered_carrier_date | Handed to logistics partner |
order_delivered_customer_date | Delivered to customer |
order_estimated_delivery_date | Estimated delivery date |

---

## 👤 Customers Table — `olist_customers_dataset.csv`
Customer identity and location information.

| Column | Description |
|---------|-------------|
customer_id | Order-level customer ID |
customer_unique_id | Unique customer across all orders |
customer_zip_code_prefix | ZIP prefix |
customer_city | City |
customer_state | State |

---

## 🛒 Order Items Table — `olist_order_items_dataset.csv`
Products included in each order.

| Column | Description |
|---------|-------------|
order_id | Order identifier |
order_item_id | Item sequence within order |
product_id | Product identifier |
seller_id | Seller identifier |
shipping_limit_date | Shipping deadline |
price | Item price |
freight_value | Shipping cost |

---

## 💳 Payments Table — `olist_order_payments_dataset.csv`
Payment transaction details.

| Column | Description |
|---------|-------------|
order_id | Order identifier |
payment_sequential | Payment sequence number |
payment_type | Payment method |
payment_installments | Installments count |
payment_value | Amount paid |

---

## ⭐ Reviews Table — `olist_order_reviews_dataset.csv`
Customer review and rating data.

| Column | Description |
|---------|-------------|
review_id | Review identifier |
order_id | Order identifier |
review_score | Rating (1–5) |
review_comment_title | Review title |
review_comment_message | Review text |
review_creation_date | Review date |
review_answer_timestamp | Seller response time |

---

## 📦 Products Table — `olist_products_dataset.csv`
Product characteristics.

| Column | Description |
|---------|-------------|
product_id | Product identifier |
product_category_name | Category (Portuguese) |
product_name_lenght | Name length |
product_description_lenght | Description length |
product_photos_qty | Photo count |
product_weight_g | Weight |
product_length_cm | Length |
product_height_cm | Height |
product_width_cm | Width |

---

## 🧑‍💼 Sellers Table — `olist_sellers_dataset.csv`
Seller location details.

| Column | Description |
|---------|-------------|
seller_id | Seller identifier |
seller_zip_code_prefix | ZIP prefix |
seller_city | City |
seller_state | State |

---

## 🌍 Geolocation Table — `olist_geolocation_dataset.csv`
ZIP prefix to latitude/longitude mapping.

| Column | Description |
|---------|-------------|
geolocation_zip_code_prefix | ZIP prefix |
geolocation_lat | Latitude |
geolocation_lng | Longitude |
geolocation_city | City |
geolocation_state | State |

---

## 🌐 Category Translation — `product_category_name_translation.csv`
Portuguese → English category mapping.

| Column | Description |
|---------|-------------|
product_category_name | Original category |
product_category_name_english | English name |

---

## Business Questions (Scope of Analysis)

### Revenue & Sales Performance
1. What is the total revenue?
2. What is the monthly revenue trend?
3. What is the month-over-month growth rate?
4. What is the quarterly revenue trend?
5. How does revenue vary by product category?
6. What are the top 10 products by revenue?
7. What % of revenue comes from top products?
8. What is the average order value?
9. How is revenue distributed across order value buckets?

### Orders & Basket Behavior
10. What is the total number of orders?
11. How many orders occur each month?
12. What is the average basket size (items per order)?
13. What is the basket size distribution?
14. What % of orders are high value?
15. How many orders per customer on average?

### Customer Analysis
16. How many unique customers are there?
17. How many new customers per month?
18. How many repeat customers per month?
19. What is the ratio of new vs repeat customers?
20. What is the repeat purchase rate?
21. Who are the top 10 customers by revenue?
22. What is the estimated customer lifetime value (basic CLV)?

### Retention & Sequential Behavior
23. What % of customers return within 30 days?
24. What % return within 60 days?
25. What is the average time between first and second purchase?
26. What is the average time between purchases overall?
27. What is the median time between purchases?
28. How many monthly active customers are there?
29. What is the churn proxy rate (no purchase after defined period)?

### Geographic Analysis
30. How does revenue vary by region/state/city?
31. How do order volumes trend by region?
32. What is the average order value by region?
33. How does repeat rate vary by region?

### Product & Category Insights
34. Which categories perform best by revenue?
35. What is the revenue share of top products vs long-tail products?

---

## KPI List

The following key performance indicators (KPIs) are computed and reused across analyses:

### Revenue KPIs
- Total Revenue
- Monthly Revenue
- Revenue Growth %
- Average Order Value (AOV)
- Category Revenue Share
- Top Product Revenue %

### Order KPIs
- Total Orders
- Orders per Month
- Basket Size
- Orders per Customer
- High Value Order %

### Customer KPIs
- Total Customers
- New Customers
- Repeat Customers
- Repeat Rate
- Customer Lifetime Value (CLV)

### Retention KPIs
- 30-Day Return Rate
- 60-Day Return Rate
- Avg Days Between Purchases
- Median Days Between Purchases
- Monthly Active Customers
- Churn Proxy Rate

### Geographic KPIs
- Revenue by Region
- Orders by Region
- AOV by Region
- Repeat Rate by Region

---

## Analysis Dimensions

The dataset is analyzed across multiple business dimensions:

- **Time** — monthly, quarterly, cohort periods  
- **Customer** — new vs repeat, frequency, lifetime value  
- **Product** — product and category performance  
- **Geography** — regional revenue and behavior differences  

---

## Notes on Approach

The project follows a structured analytics workflow:

1. Data ingestion and validation  
2. Cleaning and feature engineering in Python  
3. SQL schema design and data modeling  
4. KPI computation using SQL queries  
5. Behavioral and retention analysis using window functions  
6. Visualization and insight generation 
