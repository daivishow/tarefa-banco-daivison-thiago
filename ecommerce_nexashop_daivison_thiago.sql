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

SELECT id, nome, email, telefone                           
FROM clientes
WHERE nome LIKE '%Silva%';
/*A tradução do código seria da seguinte maneira:
Selecione e mostre o id, nome, email e telefone dos clientes, diretamente do banco de dados de
clientes, ONDE o nome do cliente contenha o termo 'Silva' em qualquer parte do texto. Depois,
me envie o resultado.*/

-- Tarefa 2.3 Busca de cliente por nome (tela de atendimento)

SELECT nome, email, cidade, estado                         
FROM clientes
WHERE telefone IS NULL;
      
/*A tradução do código seria da seguinte maneira:
Selecione e mostre o nome, email, cidade e estado dos clientes, diretamente do banco de dados
de clientes, ONDE o campo telefone estiver vazio (nulo). Depois, me envie o resultado.*/  
  
-- Tarefa 2.4 Pedidos de ticket intermediário aprovados

SELECT id, valor_total, status, forma_pagamento                    
FROM pedidos
WHERE status = 'Aprovado'              
    AND valor_total BETWEEN 100 AND 500 
ORDER BY valor_total DESC;

/* A tradução do código seria da seguinte maneira:
Selecione e mostre o id, valor_total, status e forma_pagamento dos pedidos, diretamente do
banco de dados de pedidos, ONDE o status seja 'Aprovado' E o valor_total esteja entre R$100 e
R$500. Depois, organize o resultado do maior valor para o menor e me envie o resultado.*/

-- Tarefa 2.5 Alerta de reposição de estoque

SELECT nome, categoria, estoque
FROM produtos
WHERE ativo = 1             
    AND estoque < 10
ORDER BY estoque ASC;

-- SHOW COLUMNS FROM produtos; 
/*A tradução do código seria da seguinte maneira:
Selecione e mostre o nome, categoria e estoque dos produtos, diretamente do banco de dados de
produtos, ONDE o produto esteja ativo (ativo = 1) E o estoque seja menor que 10 unidades. Depois,
organize o resultado do menor estoque para o maior e me envie o resultado.*/

-- Tarefa 2.6 — Alcance das campanhas de cupom

SELECT id, valor_total, cupom_desconto                    
FROM pedidos
WHERE cupom_desconto IS NOT NULL; 

/*A tradução do código seria da seguinte maneira:
Selecione e mostre o id, valor_total e cupom_desconto dos pedidos, diretamente do banco de
dados de pedidos, ONDE o campo cupom_desconto não estiver vazio, ou seja, os pedidos que
efetivamente usaram algum cupom. Depois, me envie o resultado.*/

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

/*A tradução do código seria da seguinte maneira:
Selecione e mostre o id e a nota de cada avaliação, diretamente do banco de dados de
avaliacoes, e crie uma nova coluna chamada faixa_avaliacao ONDE: se a nota for 5, classifique
como 'Excelente'; se for 4, como 'Boa'; se for 3, como 'Regular'; e se for 1 ou 2, como
'Insatisfatória'. Depois, me envie o resultado.*/

-- Tarefa 4.2 — Quantas avaliações caem em cada faixa

SELECT
    CASE
        WHEN nota = 5 THEN 'Excelente'    
        WHEN nota = 4 THEN 'Boa'
        WHEN nota = 3 THEN 'Regular'
        WHEN nota IN (1, 2) THEN 'Insatisfatória'
    END AS faixa_avaliacao,           
    COUNT(*) AS total_avaliacoes      
FROM avaliacoes
GROUP BY faixa_avaliacao              
ORDER BY total_avaliacoes DESC;

/*A tradução do código seria da seguinte maneira:
Selecione a classificação de cada avaliação (a mesma faixa_avaliacao da tarefa anterior) e
conte quantas avaliações existem, diretamente do banco de dados de avaliacoes, agrupando o
resultado por essa faixa. Depois, organize da faixa com mais avaliações para a com menos e me
envie o resultado.*/

-- Tarefa 4.3 — Taxa de aprovação de pedidos

SELECT
    ROUND(
        AVG(CASE WHEN status = 'Aprovado' THEN 1 ELSE 0 END) * 100
        , 2
    ) AS taxa_aprovacao_percentual 
FROM pedidos; 

/*A tradução do código seria da seguinte maneira:
Calcule, diretamente do banco de dados de pedidos, a média de pedidos com status 'Aprovado'
(contando 1 para aprovado e 0 para os demais), multiplique por 100 para virar percentual e
arredonde em 2 casas decimais. Depois, me envie o resultado como taxa_aprovacao_percentual.*/

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

/*A tradução do código seria da seguinte maneira:
Calcule, diretamente do banco de dados de clientes, a diferença em anos entre a data de
cadastro e a data de hoje, e classifique cada cliente ONDE: se essa diferença for menor que 1
ano, classifique como 'Novo'; se estiver entre 1 e 3 anos, como 'Fiel'; caso contrário, como
'Veterano'. Depois, conte quantos clientes existem em cada perfil, organize do maior para o
menor e me envie o resultado.*/    

-- debug