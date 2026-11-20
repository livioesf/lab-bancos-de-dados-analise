# Laboratório de Bancos de Dados para Análise de Dados

PostgreSQL, MySQL, SQL Server e Oracle: carga de dados, consultas analíticas, desempenho e runbooks de suporte.

## Objetivo

Praticar SQL e rotinas de suporte em quatro bancos relacionais, usando a mesma base de dados em todos. Cada exercício de suporte é tratado como um incidente: o que aconteceu, como foi diagnosticado, como foi recuperado e quanto tempo levou.

## Base de dados

A base usada é o *Brazilian E-Commerce Public Dataset by Olist*, publicada no Kaggle: https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce. Ela reúne cerca de 100 mil pedidos de 2016 a 2018, em nove tabelas relacionadas: clientes, geolocalização, pedidos, itens do pedido, pagamentos, avaliações, produtos, vendedores e tradução de categorias.

Os arquivos não estão neste repositório. Para reproduzir o laboratório, baixe o zip na página acima e extraia os CSVs na pasta `dados/`, na raiz do projeto. Créditos à Olist pela disponibilização dos dados; a licença de uso é a informada na página do Kaggle.

## Tecnologias

- SQL
- Docker e Docker Compose
- Git e GitHub

Os bancos de dados são adicionados conforme cada missão é concluída, e as ferramentas usadas aparecem no runbook correspondente.

## Missões

| # | Missão | Status |
|---|--------|--------|
| 01 | PostgreSQL: modelagem, carga dos dados, backup e restore com desastre simulado | Planejada |
| 02 | PostgreSQL: consultas analíticas, views, plano de execução e índice | Planejada |
| 03 | MySQL, SQL Server e Oracle: mesma carga e mesmas consultas, com a tabela de diferenças entre dialetos | Planejada |
| 04 | Runbooks de suporte em cada banco: acesso, permissões e backup básico | Planejada |
| 05 | Dashboard conectado ao banco | Planejada |

## Formato dos runbooks

Todos seguem o mesmo padrão: incidente, impacto, diagnóstico, procedimento de recuperação, tempo gasto, prevenção e lições aprendidas.

## Autor

Lívio Emmanuel Silva Freire
[LinkedIn](https://linkedin.com/in/livio-emmanuel) | [GitHub](https://github.com/livioesf)

## Licença

MIT
