-- Missao 02: views com os indicadores prontos

CREATE OR REPLACE VIEW vw_receita_mensal AS
SELECT TO_CHAR(DATE_TRUNC('month', o.order_purchase_timestamp), 'YYYY-MM') AS mes,
       COUNT(DISTINCT o.order_id) AS pedidos,
       ROUND(SUM(p.payment_value), 2) AS receita
FROM orders o
JOIN order_payments p ON p.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY 1;

CREATE OR REPLACE VIEW vw_receita_por_estado AS
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
FROM r;

CREATE OR REPLACE VIEW vw_top_categorias AS
SELECT COALESCE(t.product_category_name_english, pr.product_category_name, 'sem_categoria') AS categoria,
       COUNT(*) AS itens,
       ROUND(SUM(i.price), 2) AS receita_itens
FROM order_items i
JOIN orders o ON o.order_id = i.order_id
JOIN products pr ON pr.product_id = i.product_id
LEFT JOIN product_category_translation t ON t.product_category_name = pr.product_category_name
WHERE o.order_status = 'delivered'
GROUP BY 1;

\echo '=== vw_receita_por_estado (5 maiores) ==='
SELECT * FROM vw_receita_por_estado ORDER BY ranking LIMIT 5;

\echo '=== vw_top_categorias (5 maiores) ==='
SELECT * FROM vw_top_categorias ORDER BY receita_itens DESC LIMIT 5;

\echo '=== vw_receita_mensal (3 ultimos meses) ==='
SELECT * FROM vw_receita_mensal ORDER BY mes DESC LIMIT 3;
