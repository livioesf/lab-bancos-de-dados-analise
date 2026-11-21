-- Missao 01: carga dos CSVs da Olist (pasta /dados dentro do container)
BEGIN;
COPY customers FROM '/dados/olist_customers_dataset.csv' WITH (FORMAT csv, HEADER true, ENCODING 'UTF8');
COPY sellers FROM '/dados/olist_sellers_dataset.csv' WITH (FORMAT csv, HEADER true, ENCODING 'UTF8');
COPY geolocation FROM '/dados/olist_geolocation_dataset.csv' WITH (FORMAT csv, HEADER true, ENCODING 'UTF8');
COPY product_category_translation FROM '/dados/product_category_name_translation.csv' WITH (FORMAT csv, HEADER true, ENCODING 'UTF8');
COPY products FROM '/dados/olist_products_dataset.csv' WITH (FORMAT csv, HEADER true, ENCODING 'UTF8');
COPY orders FROM '/dados/olist_orders_dataset.csv' WITH (FORMAT csv, HEADER true, ENCODING 'UTF8');
COPY order_items FROM '/dados/olist_order_items_dataset.csv' WITH (FORMAT csv, HEADER true, ENCODING 'UTF8');
COPY order_payments FROM '/dados/olist_order_payments_dataset.csv' WITH (FORMAT csv, HEADER true, ENCODING 'UTF8');
COPY order_reviews FROM '/dados/olist_order_reviews_dataset.csv' WITH (FORMAT csv, HEADER true, ENCODING 'UTF8');
COMMIT;
