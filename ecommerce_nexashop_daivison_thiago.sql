-- Atividade 0 (Individual)

USE ecommerce_nexashop;
SELECT
'clientes' AS tabela, COUNT(*) AS total FROM clientes
UNION ALL
SELECT
'produtos' AS tabela, COUNT(*) AS total FROM produtos
UNION ALL
SELECT
'pedidos' AS tabela, COUNT(*) AS total FROM pedidos
UNION ALL
SELECT
'avaliacoes' AS tabela, COUNT(*) AS total FROM avaliacoes;

-- Bloco 2 — Filtros, busca textual e ordenação
-- Tarefa 2.1 — Clientes ativos da região Sul

SELECT estado, nome, cidade, status
FROM clientes
WHERE (estado = 'SC' OR estado = 'PR' OR estado = 'RS')
AND status = 'Ativo';

/* A tradução do código seria da seguinte maneira:
Selecione e mostre as informações dos clientes nesta ordem: estado -> nome -> cidade e o status, diretamente do banco
de dados de clientes, ONDE os clientes dos estados de: SC, PR e RS estão ativos. Após filtrado, me envie o resultado.*/


