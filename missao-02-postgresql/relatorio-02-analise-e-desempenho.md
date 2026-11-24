# Relatório 02: análise de negócio, qualidade dos dados e desempenho de consulta

**Ambiente:** PostgreSQL 16 em Docker (laboratório local) | **Base:** Olist (9 tabelas, cerca de 1,5 milhão de linhas) | **Data:** 23/11/2026

## Resumo

Sete perguntas de negócio respondidas em SQL, três views com indicadores prontos, três verificações de qualidade dos dados e uma medição de desempenho. Um índice reduziu uma busca por CEP na tabela `geolocation` de 31,4 ms para 0,1 ms.

## Perguntas e respostas

Receita = soma de `payment_value` (inclui frete), somente pedidos com status `delivered`.

| # | Pergunta | Resultado |
|---|----------|-----------|
| Q1 | Quantos pedidos há em cada status? | 96.478 de 99.441 (97,0%) estão entregues; 625 cancelados e 609 indisponíveis |
| Q2 | Qual a receita total dos pedidos entregues? | R$ 15.422.461,77 em 96.477 pedidos |
| Q3 | Qual o ticket médio por pedido entregue? | R$ 159,86 |
| Q4 | Como evoluem pedidos e receita por mês? | De 750 pedidos em jan/2017 para 7.069 em jan/2018; pico em nov/2017 (7.289 pedidos, R$ 1.153.528,05) |
| Q5 | Quais categorias mais faturam? | `health_beauty` lidera (R$ 1.233.131,72); `bed_bath_table` vende mais itens (10.953), com preço médio menor |
| Q6 | Quantas entregas passaram da data estimada? | 7.826 de 96.470 entregas com data (8,11%) |
| Q7 | Quais estados concentram a receita? | SP tem 37,41%; SP, RJ e MG somam 62,54% |

## Qualidade dos dados

| Verificação | Resultado | Explicação |
|-------------|-----------|------------|
| V1. Pedidos entregues sem pagamento | 1 | Explica por que a Q2 (96.477) tem um pedido a menos que a Q1 (96.478) |
| V2. Pedidos entregues sem data de entrega | 8 | Explica por que a Q6 (96.470) tem oito a menos que a Q1 |
| V3. Soma da view mensal | R$ 15.422.461,77 | Igual à receita total da Q2: a view e a consulta original conferem |

## Views

- `vw_receita_mensal`: pedidos e receita por mês.
- `vw_receita_por_estado`: receita, participação (%) e ranking por estado, com função de janela.
- `vw_top_categorias`: itens e receita de itens por categoria, com o nome em inglês.

## Desempenho: índice na busca por CEP

Consulta: `SELECT COUNT(*) FROM geolocation WHERE geolocation_zip_code_prefix = '14409'`, em uma tabela com cerca de 1 milhão de linhas. Cada plano foi medido com `EXPLAIN (ANALYZE, BUFFERS)`, depois de uma execução de aquecimento.

| Medida | Antes do índice | Depois do índice |
|--------|-----------------|------------------|
| Plano | Parallel Seq Scan (lê a tabela inteira, com 2 processos auxiliares) | Index Only Scan em `idx_geolocation_zip` |
| Tempo de execução | 31,428 ms | 0,104 ms |
| Páginas de 8 kB lidas | 8.648 (cerca de 68 MB) | 4 |
| Acessos à tabela | leitura completa | nenhum (`Heap Fetches: 0`) |

O ganho foi de cerca de 300 vezes no tempo, porque o banco deixou de ler a tabela inteira e passou a consultar só o índice. Comando: `CREATE INDEX idx_geolocation_zip ON geolocation (geolocation_zip_code_prefix);`.

## Limitações

- A receita tem duas definições neste relatório: as Q2, Q3, Q4 e Q7 usam o valor pago (`payment_value`, com frete), e a Q5 usa o preço dos itens (`price`, sem frete). Por isso os totais não são comparáveis entre si.
- A série mensal é incompleta: não há pedidos entregues em 2016-11, 2016-12 tem um único pedido e os dados terminam em 2018-08. O pico de nov/2017 pode estar ligado à Black Friday, mas isso é uma hipótese, e os dados não provam a causa.
- Um pedido entregue sem pagamento fica fora da receita, e oito pedidos sem data de entrega ficam fora do cálculo de atrasos.
- O atraso é medido contra a data estimada, sem distinguir a gravidade (um dia ou um mês).
- O ganho do índice vale para consultas que usam só a coluna indexada, porque o banco responde pelo próprio índice. Consultas que pedem outras colunas ainda acessam a tabela. O custo do índice (espaço em disco e escritas mais lentas) não foi medido. A medição foi feita em ambiente local, com uma consulta, e os tempos variam entre execuções.
- Depois do índice, o planejador estimou 76 linhas e o resultado real foi 147, porque as estatísticas são calculadas por amostragem.

## Lições aprendidas

- Marcadores como `___` e `...` não são SQL: o banco respondeu `column "___" does not exist` e `syntax error`. Consultas completas, guardadas em arquivo, evitam esse tipo de erro e podem ser reexecutadas.
- Conferir os totais entre consultas (Q1, Q2 e Q6, e a soma da view mensal contra a Q2) revelou lacunas reais na base, que foram verificadas em seguida (V1 e V2).
- Um índice só ajuda o padrão de consulta que ele atende. Medir antes e depois com `EXPLAIN (ANALYZE, BUFFERS)` mostra o ganho com números.

## Arquivos

Scripts, na ordem: `01_consultas_analiticas.sql`, `02_views.sql`, `03_verificacoes.sql`, `04_explain.sql` e `05_criar_indice.sql`. As saídas estão em `evidencias/`. Exemplo de execução de um script: `Get-Content missao-02-postgresql\01_consultas_analiticas.sql -Raw | docker exec -i lab-postgres psql -U lab_admin -d olist -v ON_ERROR_STOP=1`.