# Runbook 01: banco apagado, recuperação a partir de backup

**Ambiente:** PostgreSQL 16 em Docker (laboratório local) | **Base:** Olist (9 tabelas, cerca de 1,5 milhão de linhas) | **Data:** 20/11/2026

## Resumo

O banco `olist` foi apagado por completo e recuperado a partir de um backup lógico, sem perda de linhas. A contagem das nove tabelas antes do incidente e depois da recuperação é idêntica.

## Incidente

Remoção do banco `olist` (`DROP DATABASE`), simulando um erro humano ou uma falha grave.

## Impacto

Indisponibilidade total do banco: nenhuma consulta funciona. Evidência: `FATAL: database "olist" does not exist`.

## Diagnóstico

1. Ao consultar `orders`, o `psql` respondeu que o banco não existia.
2. Como o erro indica ausência do banco (e não da tabela), a causa é a remoção do banco inteiro.

## Preparação (antes do incidente)

1. Registrar o estado correto: contagem de linhas das nove tabelas (`evidencias/contagem_antes.txt`, gerada por `contagem.sql`).
2. Fazer o backup no formato custom, que é comprimido e permite restauração seletiva:
   `docker exec lab-postgres pg_dump -U lab_admin -d olist -Fc -f /tmp/olist_backup.dump`
3. Copiar o backup para fora do container, para o computador:
   `docker cp lab-postgres:/tmp/olist_backup.dump backups\olist_backup.dump`
4. Verificar se o backup é legível:
   `docker exec lab-postgres pg_restore -l /tmp/olist_backup.dump`

## Procedimento de recuperação

1. Copiar o backup do computador para o container:
   `docker cp backups\olist_backup.dump lab-postgres:/tmp/olist_restore.dump`
2. Recriar o banco vazio:
   `docker exec lab-postgres psql -U lab_admin -d postgres -c "CREATE DATABASE olist;"`
3. Restaurar, parando no primeiro erro:
   `docker exec lab-postgres pg_restore -U lab_admin -d olist --exit-on-error /tmp/olist_restore.dump`
4. Provar a integridade: gerar de novo a contagem (`evidencias/contagem_depois.txt`) e compará-la com a anterior usando `Compare-Object`. Sem diferenças, a recuperação está íntegra.

## Resultado

| Medida | Valor |
|---|---|
| Tempo do backup | 4,18 s |
| Tamanho do backup | 43,9 MB |
| Tempo da restauração | 2,99 s |
| Diferenças entre as contagens antes e depois | nenhuma (9 de 9 tabelas idênticas) |

Os tempos foram medidos com `Measure-Command` em ambiente de laboratório local e não representam um ambiente de produção.

## Prevenção

- Automatizar o backup em horários fixos (Missão 04).
- Guardar cópias fora da máquina do banco: o backup só vale se sobreviver à perda do servidor.
- Testar a restauração periodicamente, porque um backup que nunca foi restaurado não é garantia.
- Restringir quem pode executar `DROP DATABASE` (permissões, Missão 04).

## Limitações

- O backup lógico (`pg_dump`) guarda apenas o banco `olist`. Usuários e permissões do servidor ficam fora dele e precisam de um backup à parte.
- Alterações feitas depois do backup seriam perdidas. Recuperar até um ponto exato no tempo exige backup físico e arquivamento de logs (Missão 02).

## Lições aprendidas

- Com o Docker Desktop fechado, os comandos falham com "failed to connect to the docker API". Causa: o motor do Docker não estava em execução. Solução: abrir o Docker Desktop e esperar o motor ficar ativo.
- Após reiniciar o computador, o container ficou parado (`docker ps` vazio). Solução: `docker compose up -d`. Os dados foram preservados no volume `pgdata`.
- Um `.gitignore` criado com o conteúdo errado não protegia a pasta de dados. Foi detectado com `git status` antes do commit, e por isso a conferência com `git status` virou etapa fixa antes de cada envio.