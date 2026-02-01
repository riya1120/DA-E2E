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
