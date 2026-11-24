-- Missao 02: indice para acelerar a busca por CEP
CREATE INDEX idx_geolocation_zip ON geolocation (geolocation_zip_code_prefix);
ANALYZE geolocation;
