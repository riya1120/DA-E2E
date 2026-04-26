-- =========================
-- CUSTOMERS (independent)
-- =========================

CREATE TABLE customers(
    customer_id VARCHAR(40) PRIMARY KEY,
    customer_unique_id VARCHAR(40),
    customer_zip_code_prefix INT,
    customer_city VARCHAR(60),
    customer_state CHAR(2)
);

-- =========================
-- SELLERS (independent)
-- =========================

CREATE TABLE sellers (
    seller_id VARCHAR(40) PRIMARY KEY,
    seller_zip_code_prefix INT,
    seller_city VARCHAR(60),
    seller_state CHAR(2)
);

-- =========================
-- PRODUCTS (independent)
-- =========================

CREATE TABLE products (
    product_id VARCHAR(40) PRIMARY KEY,
    product_category_name VARCHAR(100),

    product_name_length INT NULL,
    product_description_length INT NULL,
    product_photos_qty INT NULL,

    product_weight_g DECIMAL(10,2) NULL,
    product_length_cm DECIMAL(10,2) NULL,
    product_height_cm DECIMAL(10,2) NULL,
    product_width_cm DECIMAL(10,2) NULL
);

-- =========================
-- GEOLOCATION (lookup table)
-- no PK because zip repeats
-- =========================

CREATE TABLE geolocation(
    geolocation_zip_code_prefix INT,
    geolocation_lat DECIMAL(10,6),
    geolocation_lng DECIMAL(10,6),
    geolocation_city VARCHAR(60),
    geolocation_state CHAR(2)
);

-- =========================
-- ORDERS (depends on customers)
-- =========================

CREATE TABLE orders(
    order_id VARCHAR(40) PRIMARY KEY,
    customer_id VARCHAR(40),

    order_status VARCHAR(30),

    order_purchase_timestamp TIMESTAMP,
    order_approved_at TIMESTAMP,
    order_delivered_carrier_date TIMESTAMP,
    order_delivered_customer_date TIMESTAMP,
    order_estimated_delivery_date TIMESTAMP,

    delivery_day INT,

    FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
);

-- =========================
-- ORDER ITEMS (line items)
-- composite PK
-- =========================

CREATE TABLE order_items(
    order_id VARCHAR(40),
    order_item_id INT,

    product_id VARCHAR(40),
    seller_id VARCHAR(40),

    shipping_limit_date TIMESTAMP,
    price DECIMAL(10,2),
    freight_value DECIMAL(10,2),

    PRIMARY KEY (order_id, order_item_id),

    FOREIGN KEY (order_id)
        REFERENCES orders(order_id),

    FOREIGN KEY (product_id)
        REFERENCES products(product_id),

    FOREIGN KEY (seller_id)
        REFERENCES sellers(seller_id)
);

-- =========================
-- PAYMENTS (multi-payment possible)
-- composite PK
-- =========================

CREATE TABLE payments(
    order_id VARCHAR(40),
    payment_sequential INT,

    payment_type VARCHAR(30),
    payment_installments INT,
    payment_value DECIMAL(10,2),

    PRIMARY KEY (order_id, payment_sequential),

    FOREIGN KEY (order_id)
        REFERENCES orders(order_id)
);

-- =========================
-- REVIEWS
-- =========================

CREATE TABLE reviews(
    review_id VARCHAR(40) PRIMARY KEY,
    order_id VARCHAR(40),

    review_score INT,
    review_comment_title VARCHAR(200),
    review_comment_message TEXT,

    review_creation_date TIMESTAMP,
    review_answer_timestamp TIMESTAMP,

    FOREIGN KEY (order_id)
        REFERENCES orders(order_id)
);

ALTER TABLE orders
ALTER COLUMN delivery_day TYPE DECIMAL(5,2);