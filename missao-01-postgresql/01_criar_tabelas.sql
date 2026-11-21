-- Missao 01: esquema do banco Olist (PostgreSQL 16)
-- CEP como VARCHAR(5) para preservar zeros a esquerda.
BEGIN;

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
  geolocation_lat DOUBLE PRECISION,
  geolocation_lng DOUBLE PRECISION,
  geolocation_city TEXT,
  geolocation_state CHAR(2)
);

CREATE TABLE product_category_translation (
  product_category_name TEXT PRIMARY KEY,
  product_category_name_english TEXT NOT NULL
);

CREATE TABLE products (
  product_id VARCHAR(32) PRIMARY KEY,
  product_category_name TEXT,
  product_name_length INTEGER,
  product_description_length INTEGER,
  product_photos_qty INTEGER,
  product_weight_g INTEGER,
  product_length_cm INTEGER,
  product_height_cm INTEGER,
  product_width_cm INTEGER
);

CREATE TABLE orders (
  order_id VARCHAR(32) PRIMARY KEY,
  customer_id VARCHAR(32) NOT NULL,
  order_status VARCHAR(20) NOT NULL,
  order_purchase_timestamp TIMESTAMP,
  order_approved_at TIMESTAMP,
  order_delivered_carrier_date TIMESTAMP,
  order_delivered_customer_date TIMESTAMP,
  order_estimated_delivery_date TIMESTAMP
);

CREATE TABLE order_items (
  order_id VARCHAR(32) NOT NULL,
  order_item_id INTEGER NOT NULL,
  product_id VARCHAR(32) NOT NULL,
  seller_id VARCHAR(32) NOT NULL,
  shipping_limit_date TIMESTAMP,
  price NUMERIC(10,2),
  freight_value NUMERIC(10,2),
  PRIMARY KEY (order_id, order_item_id)
);

CREATE TABLE order_payments (
  order_id VARCHAR(32) NOT NULL,
  payment_sequential INTEGER NOT NULL,
  payment_type VARCHAR(20),
  payment_installments INTEGER,
  payment_value NUMERIC(10,2),
  PRIMARY KEY (order_id, payment_sequential)
);

CREATE TABLE order_reviews (
  review_id VARCHAR(32) NOT NULL,
  order_id VARCHAR(32) NOT NULL,
  review_score SMALLINT,
  review_comment_title TEXT,
  review_comment_message TEXT,
  review_creation_date TIMESTAMP,
  review_answer_timestamp TIMESTAMP
);

COMMIT;
