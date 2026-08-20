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

-- Bloco 2 — Filtros, busca textual e ordenação Bloco 4 — Classificação com CASE e regras de negócio
-- Tarefa 2.1 — Clientes ativos da região Sul

SELECT estado, nome, cidade, status
FROM clientes
WHERE (estado = 'SC' OR estado = 'PR' OR estado = 'RS')
AND status = 'Ativo';

/* A tradução do código seria da seguinte maneira:
Selecione e mostre as informações dos clientes nesta ordem: estado -> nome -> cidade e o status, diretamente do banco
de dados de clientes, ONDE os clientes dos estados de: SC, PR e RS estão ativos. Após filtrado, me envie o resultado.*/

-- Tarefa 2.2 Busca de cliente por nome (tela de atendimento)

SELECT id, nome, email,telefone                           
FROM clientes
WHERE nome LIKE '%Silva%';
/**/

-- Tarefa 2.3 Busca de cliente por nome (tela de atendimento)

SELECT nome, email, cidade, estado                         
FROM clientes
WHERE telefone IS NULL;             
  
-- Tarefa 2.4 Pedidos de ticket intermediário aprovados

SELECT id, valor_total, status, forma_pagamento                    
FROM pedidos
WHERE status = 'Aprovado'              
    AND valor_total BETWEEN 100 AND 500 
ORDER BY valor_total DESC;    

-- Tarefa 2.5 Alerta de reposição de estoque

SELECT nome, categoria, estoque
FROM produtos
WHERE status = 'Ativo'                 
AND estoque < 10       
ORDER BY estoque ASC;   

-- Tarefa 2.6 — Alcance das campanhas de cupom

SELECT id, valor_total, cupom_desconto                    
FROM pedidos
WHERE cupom_desconto IS NOT NULL; 

-- Bloco 4 — Classificação com CASE e regras de negócio        
-- Tarefa 4.1 - Classificando avaliações

SELECT id, nota,  
    CASE
        WHEN nota = 5 THEN 'Excelente'     
        WHEN nota = 4 THEN 'Boa'          
        WHEN nota = 3 THEN 'Regular'       
        WHEN nota IN (1, 2) THEN 'Insatisfatória' 
    END AS faixa_avaliacao           
FROM avaliacoes;

-- Tarefa 4.2 — Quantas avaliações caem em cada faixa

SELECT
    CASE
        WHEN nota = 5 THEN 'Excelente'     -- mesma regra da tarefa 4.1
        WHEN nota = 4 THEN 'Boa'
        WHEN nota = 3 THEN 'Regular'
        WHEN nota IN (1, 2) THEN 'Insatisfatória'
    END AS faixa_avaliacao,           
    COUNT(*) AS total_avaliacoes      
FROM avaliacoes
GROUP BY faixa_avaliacao              
ORDER BY total_avaliacoes DESC;

-- Tarefa 4.3 — Taxa de aprovação de pedidos

SELECT
    ROUND(
        AVG(CASE WHEN status = 'Aprovado' THEN 1 ELSE 0 END) * 100
        , 2
    ) AS taxa_aprovacao_percentual 
FROM pedidos; 

-- Tarefa 4.4 — Perfil de relacionamento dos clientes                        

SELECT
    CASE
        WHEN TIMESTAMPDIFF(YEAR, data_cadastro, CURDATE()) < 1
            THEN 'Novo'                    
        WHEN TIMESTAMPDIFF(YEAR, data_cadastro, CURDATE()) BETWEEN 1 AND 3
            THEN 'Fiel'                   
        ELSE 'Veterano'                 
    END AS perfil_relacionamento,       
    COUNT(*) AS total_clientes         
FROM clientes
GROUP BY perfil_relacionamento        
ORDER BY total_clientes DESC; 

-- Bloco 6 (exemplo)       

SELECT
  c.cidade,
  SUM(p.valor_total) AS faturamento
FROM clientes c
JOIN pedidos p
  ON c.id = p.cliente_id
WHERE p.status = 'Aprovado'
GROUP BY c.cidade
ORDER BY faturamento DESC
LIMIT 5;
   
