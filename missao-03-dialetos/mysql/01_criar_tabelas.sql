-- Missao 03 (MySQL 8.4): esquema do banco Olist
-- Diferencas em relacao ao PostgreSQL: TIMESTAMP vira DATETIME; chave primaria em texto precisa de tamanho (VARCHAR);
-- DDL no MySQL nao e transacional (cada CREATE TABLE confirma sozinho).

CREATE TABLE customers (
  customer_id VARCHAR(32) PRIMARY KEY,
  customer_unique_id VARCHAR(32) NOT NULL,
  customer_zip_code_prefix VARCHAR(5),
  customer_city TEXT,
  customer_state CHAR(2)
);

CREATE TABLE sellers (
  seller_id VARCHAR(32) PRIMARY KEY,
  seller_zip_code_prefix VARCHAR(5),
  seller_city TEXT,
  seller_state CHAR(2)
);

CREATE TABLE geolocation (
  geolocation_zip_code_prefix VARCHAR(5),
  geolocation_lat DOUBLE,
  geolocation_lng DOUBLE,
  geolocation_city TEXT,
  geolocation_state CHAR(2)
);

CREATE TABLE product_category_translation (
  product_category_name VARCHAR(100) PRIMARY KEY,
  product_category_name_english VARCHAR(100) NOT NULL
);

CREATE TABLE products (
  product_id VARCHAR(32) PRIMARY KEY,
  product_category_name VARCHAR(100),
  product_name_length INT,
  product_description_length INT,
  product_photos_qty INT,
  product_weight_g INT,
  product_length_cm INT,
  product_height_cm INT,
  product_width_cm INT
);

CREATE TABLE orders (
  order_id VARCHAR(32) PRIMARY KEY,
  customer_id VARCHAR(32) NOT NULL,
  order_status VARCHAR(20) NOT NULL,
  order_purchase_timestamp DATETIME,
  order_approved_at DATETIME,
  order_delivered_carrier_date DATETIME,
  order_delivered_customer_date DATETIME,
  order_estimated_delivery_date DATETIME
);

CREATE TABLE order_items (
  order_id VARCHAR(32) NOT NULL,
  order_item_id INT NOT NULL,
  product_id VARCHAR(32) NOT NULL,
  seller_id VARCHAR(32) NOT NULL,
  shipping_limit_date DATETIME,
  price DECIMAL(10,2),
  freight_value DECIMAL(10,2),
  PRIMARY KEY (order_id, order_item_id)
);

CREATE TABLE order_payments (
  order_id VARCHAR(32) NOT NULL,
  payment_sequential INT NOT NULL,
  payment_type VARCHAR(20),
  payment_installments INT,
  payment_value DECIMAL(10,2),
  PRIMARY KEY (order_id, payment_sequential)
);

CREATE TABLE order_reviews (
  review_id VARCHAR(32) NOT NULL,
  order_id VARCHAR(32) NOT NULL,
  review_score TINYINT,
  review_comment_title TEXT,
  review_comment_message TEXT,
  review_creation_date DATETIME,
  review_answer_timestamp DATETIME
);
