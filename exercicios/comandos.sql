-- Tarefa A - Criando as tabelas

CREATE TABLE raca (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    descricao TEXT NOT NULL,
    poderes_concedidos_raca TEXT NOT NULL
);

CREATE TABLE origem (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    descricao TEXT NOT NULL,
    poderes_concedidos_origem TEXT NOT NULL
);

CREATE TABLE habilidade (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT NOT NULL,
    origem VARCHAR(50) NOT NULL,
    ativo BOOLEAN NOT NULL DEFAULT TRUE,
    nivel_habilidade INT NOT NULL,
    raca_pers_id INT REFERENCES raca(id) ON DELETE SET NULL,
    origem_pers_id INT REFERENCES origem(id) ON DELETE SET NULL,
    classe_pers_id INT -- Suponho que referencie uma tabela "classe" (não mostrada no modelo)
);

-- Tarefa B - Inserindo registros

-- Inserindo duas raças
INSERT INTO raca (nome, descricao, poderes_concedidos_raca) VALUES 
('Humano', 'Versátil e adaptável.', 'Pode escolher um talento extra no nível 1.'),
('Elfo', 'Ágil e inteligente.', 'Visão no escuro e +2 em Percepção.');

-- Inserindo duas origens
INSERT INTO origem (nome, descricao, poderes_concedidos_origem) VALUES 
('Nobre', 'Criado entre a elite.', 'Recebe 500 T$ extras no início do jogo.'),
('Forasteiro', 'Viajante sem raízes.', 'Consegue vantagem em testes de sobrevivência.');

-- Inserindo duas habilidades
INSERT INTO habilidade (nome, descricao, origem, ativo, nivel_habilidade, raca_pers_id, origem_pers_id) VALUES 
('Ataque Preciso', 'Permite realizar ataques com maior chance de acerto.', 'Marcial', TRUE, 3, 1, NULL),
('Resistência Natural', 'Garante bônus contra venenos.', 'Mística', TRUE, 2, 2, 2);

-- ==============================
-- Tarefa C - Atualização simples
-- ==============================

-- Alterando a descrição de uma habilidade
UPDATE habilidade 
SET descricao = 'Permite ataques mais precisos e críticos.' 
WHERE nome = 'Ataque Preciso';

-- ==============================
-- Tarefa D - Atualização com condição composta
-- ==============================

-- Alterando nível de habilidades místicas e ativas
UPDATE habilidade 
SET nivel_habilidade = nivel_habilidade + 1 
WHERE origem = 'Mística' AND ativo = TRUE;

-- ==============================
-- Tarefa E - Atualização de dois campos com condição
-- ==============================

-- Atualizando nome e poder concedido de uma raça específica
UPDATE raca 
SET nome = 'Meio-Elfo', poderes_concedidos_raca = 'Ganha um talento extra e visão no escuro.' 
WHERE nome = 'Elfo';

-- ==============================
-- Tarefa F - Remoção com condição simples
-- ==============================

-- Removendo a habilidade "Resistência Natural"
DELETE FROM habilidade WHERE nome = 'Resistência Natural';

-- ==============================
-- Tarefa G - Remoção com condição composta
-- ==============================

-- Removendo origens que não concedem poderes específicos
DELETE FROM origem WHERE poderes_concedidos_origem IS NULL OR poderes_concedidos_origem = '';

-- ==============================
-- Tarefa H - Remoção baseada em outra tabela
-- ==============================

-- Removendo raças que não possuem habilidades associadas
DELETE FROM raca 
WHERE id NOT IN (SELECT DISTINCT raca_pers_id FROM habilidade WHERE raca_pers_id IS NOT NULL);

-- ==============================
-- Tarefa I - Seleção com condição simples
-- ==============================

-- Exibir todas as habilidades ativas
SELECT * FROM habilidade WHERE ativo = TRUE;

-- ==============================
-- Tarefa J - Seleção com condição composta
-- ==============================

-- Exibir raças que possuem "Visão no escuro" e algum bônus de Percepção
SELECT * FROM raca 
WHERE poderes_concedidos_raca LIKE '%Visão no escuro%' 
AND poderes_concedidos_raca LIKE '%Percepção%';

-- ==============================
-- Tarefa K - Seleção com INNER JOIN (duas tabelas)
-- ==============================

-- Exibir habilidades e suas raças associadas
SELECT h.nome AS habilidade, r.nome AS raca 
FROM habilidade h
INNER JOIN raca r ON h.raca_pers_id = r.id;

-- ==============================
-- Tarefa L - Seleção com INNER JOIN (três tabelas)
-- ==============================

-- Exibir habilidades, raças e origens associadas
SELECT h.nome AS habilidade, r.nome AS raca, o.nome AS origem 
FROM habilidade h
INNER JOIN raca r ON h.raca_pers_id = r.id
INNER JOIN origem o ON h.origem_pers_id = o.id;

-- ==============================
-- Tarefa M - Seleção com OUTER JOIN (LEFT JOIN)
-- ==============================

-- Exibir todas as habilidades e suas raças associadas, incluindo aquelas sem raça definida
SELECT h.nome AS habilidade, r.nome AS raca
FROM habilidade h
LEFT JOIN raca r ON h.raca_pers_id = r.id;

-- ==============================
-- Tarefa N - Seleção com FULL OUTER JOIN
-- ==============================

-- Exibir todas as raças e origens, mesmo que não tenham relação direta
SELECT r.nome AS raca, o.nome AS origem
FROM raca r
FULL OUTER JOIN origem o ON r.id = o.id;
