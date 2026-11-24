-- Missao 02: plano de execucao de uma busca por CEP na tabela geolocation (cerca de 1 milhao de linhas)
EXPLAIN (ANALYZE, BUFFERS)
SELECT COUNT(*) FROM geolocation WHERE geolocation_zip_code_prefix = '14409';
