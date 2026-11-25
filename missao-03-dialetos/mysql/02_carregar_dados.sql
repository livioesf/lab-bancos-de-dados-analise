-- Missao 03 (MySQL 8.4): carga dos CSVs com LOAD DATA LOCAL INFILE (o cliente le o arquivo dentro do container)
-- Campos vazios viram NULL com NULLIF; TRIM remove o retorno de carro caso o arquivo use quebra de linha do Windows.

LOAD DATA LOCAL INFILE '/dados/olist_customers_dataset.csv' INTO TABLE customers CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' ESCAPED BY '' LINES TERMINATED BY '\n' IGNORE 1 LINES
(customer_id, customer_unique_id, customer_zip_code_prefix, customer_city, @st)
SET customer_state = TRIM(TRAILING '\r' FROM @st);

LOAD DATA LOCAL INFILE '/dados/olist_sellers_dataset.csv' INTO TABLE sellers CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' ESCAPED BY '' LINES TERMINATED BY '\n' IGNORE 1 LINES
(seller_id, seller_zip_code_prefix, seller_city, @st)
SET seller_state = TRIM(TRAILING '\r' FROM @st);

LOAD DATA LOCAL INFILE '/dados/olist_geolocation_dataset.csv' INTO TABLE geolocation CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' ESCAPED BY '' LINES TERMINATED BY '\n' IGNORE 1 LINES
(geolocation_zip_code_prefix, geolocation_lat, geolocation_lng, geolocation_city, @st)
SET geolocation_state = TRIM(TRAILING '\r' FROM @st);

LOAD DATA LOCAL INFILE '/dados/product_category_name_translation.csv' INTO TABLE product_category_translation CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' ESCAPED BY '' LINES TERMINATED BY '\n' IGNORE 1 LINES
(product_category_name, @en)
SET product_category_name_english = TRIM(TRAILING '\r' FROM @en);

LOAD DATA LOCAL INFILE '/dados/olist_products_dataset.csv' INTO TABLE products CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' ESCAPED BY '' LINES TERMINATED BY '\n' IGNORE 1 LINES
(product_id, @cat, @nl, @dl, @pq, @w, @l, @h, @wd)
SET product_category_name = NULLIF(@cat, ''),
    product_name_length = NULLIF(@nl, ''),
    product_description_length = NULLIF(@dl, ''),
    product_photos_qty = NULLIF(@pq, ''),
    product_weight_g = NULLIF(@w, ''),
    product_length_cm = NULLIF(@l, ''),
    product_height_cm = NULLIF(@h, ''),
    product_width_cm = NULLIF(TRIM(TRAILING '\r' FROM @wd), '');

LOAD DATA LOCAL INFILE '/dados/olist_orders_dataset.csv' INTO TABLE orders CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' ESCAPED BY '' LINES TERMINATED BY '\n' IGNORE 1 LINES
(order_id, customer_id, order_status, @pt, @ap, @dc, @dcu, @ed)
SET order_purchase_timestamp = NULLIF(@pt, ''),
    order_approved_at = NULLIF(@ap, ''),
    order_delivered_carrier_date = NULLIF(@dc, ''),
    order_delivered_customer_date = NULLIF(@dcu, ''),
    order_estimated_delivery_date = NULLIF(TRIM(TRAILING '\r' FROM @ed), '');

LOAD DATA LOCAL INFILE '/dados/olist_order_items_dataset.csv' INTO TABLE order_items CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' ESCAPED BY '' LINES TERMINATED BY '\n' IGNORE 1 LINES
(order_id, order_item_id, product_id, seller_id, shipping_limit_date, price, @fv)
SET freight_value = TRIM(TRAILING '\r' FROM @fv);

LOAD DATA LOCAL INFILE '/dados/olist_order_payments_dataset.csv' INTO TABLE order_payments CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' ESCAPED BY '' LINES TERMINATED BY '\n' IGNORE 1 LINES
(order_id, payment_sequential, payment_type, payment_installments, @pv)
SET payment_value = TRIM(TRAILING '\r' FROM @pv);

LOAD DATA LOCAL INFILE '/dados/olist_order_reviews_dataset.csv' INTO TABLE order_reviews CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' ESCAPED BY '' LINES TERMINATED BY '\n' IGNORE 1 LINES
(review_id, order_id, review_score, @t, @m, review_creation_date, @ra)
SET review_comment_title = NULLIF(@t, ''),
    review_comment_message = NULLIF(@m, ''),
    review_answer_timestamp = NULLIF(TRIM(TRAILING '\r' FROM @ra), '');
