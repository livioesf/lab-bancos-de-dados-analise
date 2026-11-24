-- Missao 02: consultas analiticas (PostgreSQL 16, base Olist)
-- Receita = soma de payment_value (inclui frete). Somente pedidos com status delivered.

\echo '=== Q1. Pedidos por status ==='
SELECT order_status, COUNT(*) AS pedidos
FROM orders
GROUP BY order_status
ORDER BY pedidos DESC;

\echo '=== Q2. Receita total e numero de pedidos entregues ==='
SELECT COUNT(DISTINCT o.order_id) AS pedidos, ROUND(SUM(p.payment_value), 2) AS receita_total
FROM orders o
JOIN order_payments p ON p.order_id = o.order_id
WHERE o.order_status = 'delivered';

\echo '=== Q3. Ticket medio por pedido entregue ==='
SELECT ROUND(AVG(total), 2) AS ticket_medio
FROM (
  SELECT o.order_id, SUM(p.payment_value) AS total
  FROM orders o
  JOIN order_payments p ON p.order_id = o.order_id
  WHERE o.order_status = 'delivered'
  GROUP BY o.order_id
) t;

\echo '=== Q4. Pedidos e receita por mes ==='
SELECT TO_CHAR(DATE_TRUNC('month', o.order_purchase_timestamp), 'YYYY-MM') AS mes,
       COUNT(DISTINCT o.order_id) AS pedidos,
       ROUND(SUM(p.payment_value), 2) AS receita
FROM orders o
JOIN order_payments p ON p.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY 1
ORDER BY 1;

\echo '=== Q5. Top 10 categorias por receita de itens ==='
SELECT COALESCE(t.product_category_name_english, pr.product_category_name, 'sem_categoria') AS categoria,
       COUNT(*) AS itens,
       ROUND(SUM(i.price), 2) AS receita_itens
FROM order_items i
JOIN orders o ON o.order_id = i.order_id
JOIN products pr ON pr.product_id = i.product_id
LEFT JOIN product_category_translation t ON t.product_category_name = pr.product_category_name
WHERE o.order_status = 'delivered'
GROUP BY 1
ORDER BY receita_itens DESC
LIMIT 10;

\echo '=== Q6. Entregas atrasadas em relacao a data estimada ==='
SELECT COUNT(*) AS entregues,
       COUNT(*) FILTER (WHERE order_delivered_customer_date > order_estimated_delivery_date) AS atrasados,
       ROUND(100.0 * COUNT(*) FILTER (WHERE order_delivered_customer_date > order_estimated_delivery_date) / COUNT(*), 2) AS pct_atrasados
FROM orders
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NOT NULL;

\echo '=== Q7. Top 10 estados por receita, com participacao e ranking ==='
WITH r AS (
  SELECT c.customer_state AS estado, SUM(p.payment_value) AS receita
  FROM customers c
  JOIN orders o ON o.customer_id = c.customer_id
  JOIN order_payments p ON p.order_id = o.order_id
  WHERE o.order_status = 'delivered'
  GROUP BY c.customer_state
)
SELECT estado,
       ROUND(receita, 2) AS receita,
       ROUND(100 * receita / SUM(receita) OVER (), 2) AS pct_total,
       RANK() OVER (ORDER BY receita DESC) AS ranking
FROM r
ORDER BY ranking
LIMIT 10;
