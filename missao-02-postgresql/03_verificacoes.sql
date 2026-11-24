-- Missao 02: verificacoes de qualidade dos dados

\echo '=== V1. Pedidos entregues sem registro de pagamento ==='
SELECT COUNT(*) AS entregues_sem_pagamento
FROM orders o
WHERE o.order_status = 'delivered'
  AND NOT EXISTS (SELECT 1 FROM order_payments p WHERE p.order_id = o.order_id);

\echo '=== V2. Pedidos entregues sem data de entrega ==='
SELECT COUNT(*) AS entregues_sem_data
FROM orders
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NULL;

\echo '=== V3. Soma da receita mensal (view) deve ser igual a receita total da Q2 ==='
SELECT ROUND(SUM(receita), 2) AS soma_mensal FROM vw_receita_mensal;
