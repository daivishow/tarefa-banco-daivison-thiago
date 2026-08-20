USE ecommerce_nexashop;
-- Bloco 1 — Reconhecimento do banco
-- Tarefa 1.1 — Primeiro contato com os dados
SELECT *
FROM clientes
LIMIT 10;
SELECT *
FROM produtos
LIMIT 10;
SELECT *
FROM pedidos
LIMIT 10;
SELECT *
FROM avaliacoes
LIMIT 10;
-- AS consultas mostram uma pequena parte de cada tabela do banco.
-- São exibidos 10 registros de clientes, produtos, pedidos e avaliações.


USE ecommerce_nexashop;
-- Tarefa 1.2 - Catálogo de produtos para o marketing
SELECT
    nome,
    categoria,
    marca,
    preco AS `Valor (R$)`,
    estoque
FROM produtos;
-- Aqui mostra uma lista mais simples dos produtos cadastrados.
-- Em vez de exibir todas as informações da tabela, aparecem somente o nome,
-- a categoria, a marca, o preço e o estoque.


USE ecommerce_nexashop;
-- Tarefa 1.3 - Quantas categorias a loja realmente vende
SELECT DISTINCT categoria
FROM produtos
ORDER BY categoria ASC;
-- Esta consulta mostra quais categorias de produtos existem na loja. Como vários
-- produtos podem ter a mesma categoria, as repetições são removidas. No resultado,
-- cada categoria aparece apenas uma vez e em ordem alfabética.


USE ecommerce_nexashop;
-- Tarefa 1.4 Formas de pagamento e canais de venda aceitos
SELECT DISTINCT forma_pagamento
FROM pedidos;
SELECT DISTINCT canal_venda
FROM pedidos;
-- A consultas mostram quais formas de pagamento e quais canais de venda
-- aparecem nos pedidos. Como esses dados se repetem em vários registros,
-- cada opção é mostrada apenas uma vez para facilitar a visualização.

USE ecommerce_nexashop;
-- Bloco 3 - Indicadores agregados 
-- Tarefa 3.1 - Radar de ticket médio
SELECT
    COUNT(*) AS quantidade_pedidos,
    ROUND(AVG(valor_total), 2) AS ticket_medio,
    MIN(valor_total) AS menor_valor,
    MAX(valor_total) AS maior_valor
FROM pedidos
WHERE status = 'Aprovado';
-- A consulta cria um resumo dos pedidos aprovados.
-- resultado mostra quantos pedidos foram aprovados, qual foi o valor médio
-- das compras, qual foi o menor valor e qual foi o maior valor encontrado.

USE ecommerce_nexashop;
-- Tarefa 3.2 - Faturamento por forma de pagamento 
SELECT
    forma_pagamento,
    ROUND(SUM(valor_total), 2) AS faturamento_total
FROM pedidos
WHERE status = 'Aprovado'
GROUP BY forma_pagamento
ORDER BY faturamento_total DESC;
-- A consulta mostra quanto cada forma de pagamento gerou em vendas aprovadas.
-- Os pedidos são separados pelo tipo de pagamento e seus valores são somados.
-- A forma de pagamento com maior faturamento aparece primeiro no resultado.

USE ecommerce_nexashop;
-- Tarefa 3.3 - Onde estão os clientes da Nexashop
SELECT
    estado,
    COUNT(*) AS quantidade_clientes
FROM clientes
GROUP BY estado
ORDER BY quantidade_clientes DESC;
-- Esta consulta mostra quantos clientes existem em cada estado.
-- Os clientes são agrupados pelo estado cadastrado e depois é feita a contagem.
-- O estado com maior quantidade de clientes aparece primeiro.

USE ecommerce_nexashop;
-- Tarefa 3.4 - Estados Prioritários para expansão
SELECT
    estado,
    COUNT(*) AS quantidade_clientes
FROM clientes
GROUP BY estado
HAVING COUNT(*) > 200
ORDER BY quantidade_clientes DESC;
-- Esta consulta mostra apenas os estados que possuem mais de 200 clientes.
-- Primeiro os clientes são contados por estado e depois são mantidos somente
-- os estados que passam dessa quantidade, ajudando a identificar onde a loja
-- já possui uma presença maior de clientes.


USE ecommerce_nexashop;
-- Tarefa 3.5 - Perfil etário por segmento
SELECT
    segmento,
    ROUND(
        AVG(
            TIMESTAMPDIFF(YEAR, data_nascimento, CURDATE())
        ),
        1
    ) AS idade_media
FROM clientes
GROUP BY segmento;
-- Esta consulta calcula a idade média dos clientes de cada segmento.
-- A idade é calculada comparando a data de nascimento com a data atual.
-- Depois, os clientes são separados por segmento e é calculada a média
-- de idade de cada grupo.
DESCRIBE produtos;

USE ecommerce_nexashop;
-- Tarefa 3.6 - Valor de estoque parado por categoria 
SELECT
    categoria,
    ROUND(SUM(preco * estoque), 2) AS valor_total_estoque
FROM produtos
WHERE ativo = 1
GROUP BY categoria
ORDER BY valor_total_estoque DESC;
-- Esta consulta calcula quanto vale o estoque de cada categoria.
-- O preço de cada produto é multiplicado pela quantidade disponível e,
-- depois, esses valores são somados por categoria. A categoria com maior
-- valor total em estoque aparece primeiro.


USE ecommerce_nexashop;
-- Bloco 5 - Desafio Integrador - sem join
-- Tarefa 5.1 - Ranking de canal de venda e forma de pagamento 
SELECT
    canal_venda,
    forma_pagamento,
    COUNT(*) AS quantidade_pedidos,
    ROUND(SUM(valor_total), 2) AS faturamento
FROM pedidos
WHERE status = 'Aprovado'
GROUP BY canal_venda, forma_pagamento
HAVING COUNT(*) >= 200
ORDER BY faturamento DESC
LIMIT 5;
-- Aqui vai ser comparado canal de venda com forma de pagamento.
-- São considerados somente os pedidos aprovados.
-- Para cada combinação é mostrada a quantidade de pedidos e o faturamento.
-- Só aparecem combinações com pelo menos 200 pedidos e, no final,
-- são mostradas as 5 que mais faturaram.


USE ecommerce_nexashop;
-- Tarefa 5.2 - Categorias premium do catálogo
SELECT
    categoria,
    COUNT(*) AS quantidade_produtos,
    ROUND(AVG(preco), 2) AS preco_medio
FROM produtos
WHERE ativo = 1
GROUP BY categoria
HAVING AVG(preco) > 300
ORDER BY preco_medio DESC;
-- Nessa tablela mostra as categorias de produtos ativos que têm
-- preço médio maior que R$ 300. Também mostra quantos produtos existem em 
-- cada categoria e qual é a média.
-- As categorias com maior preço médio aparecem primeiro.


-- Tarefa 5.3 - Investigação da taxa de cancelamento
SELECT
    forma_pagamento,
    ROUND(
        AVG(
            CASE
                WHEN status = 'Cancelado' THEN 1
                ELSE 0
            END
        ) * 100, 2
    ) AS taxa_cancelamento
FROM pedidos
GROUP BY forma_pagamento
ORDER BY taxa_cancelamento DESC;
-- Esta consulta compara a taxa de cancelamento de cada forma de pagamento.
-- A ideia é verificar se o boleto realmente tem mais cancelamentos
-- ou se outra forma de pagamento tem uma taxa maior.
-- O resultado é colocado da maior taxa para a menor.