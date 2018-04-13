--CONSULTAS:

--1)Apenas uma pode ser simples, ou seja, usar somente o básico SELECT, FROM, WHERE.
--Listar os funcionarios que possuem salario maior que 5000

SELECT * FROM companhiaAerea.funcionario WHERE salario > 5000;

---------------------------------------------------------------------------------------

--2)JOIN de várias tabelas variando o uso de NATURAL, USING e ON
--Listar o nome, numero do passaporte, endereco e emails dos passageiros internacionais

SELECT p.primeiro_nome, p.sobrenome, pi.num_passaporte, cp.cidade, cp.estado, cp.pais, p.rua, p .numero, pemail.pass_email 
FROM companhiaAerea.pass_internacional pi JOIN companhiaAerea.passageiro p ON(p.id_passageiro = pi.id_internacional) JOIN
companhiaAerea.codigo_postal cp USING(cep) NATURAL JOIN companhiaAerea.pass_emails pemail;

---------------------------------------------------------------------------------------

--3)ORDER BY
--Listar as manutencoes feitas nas aeronaves ordenadas crescentemente pelo codigo da aeronave
SELECT * FROM companhiaAerea.manutencao ORDER BY cod_aeronave;

---------------------------------------------------------------------------------------

--4)GROUP BY, HAVING e operações aritméticas
-- Listar os modelos de aeronave os quais a companhia possui menos de 3 unidades
SELECT count(*) AS quantidade, modelo FROM companhiaAerea.aeronave GROUP BY modelo HAVING count(*) < 3;

---------------------------------------------------------------------------------------

--5)Strings (like, uso de funções)
--Listar em letras maiúsculas os emails dos funcionarios que usam hotmail
SELECT upper(func_email) FROM companhiaAerea.func_emails WHERE func_email LIKE '%@hotmail.com';

---------------------------------------------------------------------------------------

--6)JOIN de duas tabelas (usando OUTER JOIN)
--Listar todas as aeronaves e suas manutenções, inclusive as que nao receberam nenhuma manutenção ainda

SELECT * FROM companhiaAerea.aeronave LEFT OUTER JOIN companhiaAerea.manutencao ON (cod_aeronave = codigo_aeronave)

---------------------------------------------------------------------------------------

--7)Aninhada usando WITH
--Listar nome do funcionario, cadastro e quantas aeronaves ele trabalha

WITH count_aeronaves AS (SELECT cadastro_funcionario AS cadastrof, count(cod_aeronave) AS qtd_aeronaves 
FROM companhiaAerea.trabalha t JOIN companhiaAerea.aeronave a ON (t.cod_aeronave = a.codigo_aeronave) 
GROUP BY cadastro_funcionario)
SELECT primeiro_nome, sobrenome, cadastrof, qtd_aeronaves FROM count_aeronaves JOIN companhiaAerea.funcionario f 
ON (count_aeronaves.cadastrof = f.cadastro);

---------------------------------------------------------------------------------------

--8)Aninhada usando IN
--Listar os passageiros que moram em Sergipe
--Listar os voos que tem como destino Sergipe
--Verificar se algum passageiro que é de Sergipe está em algum voo que está indo para Sergipe (passageiro voltando pra casa)
--Listar os nomes deles
--Listar os passageiros nativos de Sergipe que estão voltando para sua cidade natal

SELECT p.primeiro_nome, p.sobrenome FROM companhiaAerea.passageiro p NATURAL JOIN companhiaAerea.codigo_postal cp JOIN companhiaAerea.passagem pa
ON(p.id_passageiro = pa.cod_passageiro) WHERE cp.estado = 'Sergipe' AND pa.cod_voo IN
(SELECT v.codigo_voo FROM companhiaAerea.voo v JOIN companhiaAerea.destino d ON(v.codigo_voo = d.cod_voo) JOIN companhiaAerea.aeroporto a 
ON(a.codigo_aeroporto = d.cod_aeroporto) NATURAL JOIN companhiaAerea.codigo_postal cp 
WHERE d.isEscala = FALSE AND cp.estado = 'Sergipe')

---------------------------------------------------------------------------------------

--9) Aninhada usando FROM dentro
--Listar os Técnicos que prestaram manutenção na aeronave de Código: 110
SELECT * FROM (SELECT DISTINCT r.cadastro_tecnico FROM companhiaAerea.realiza r WHERE r.codigo_aeronave = '110') AS tecAero 
JOIN (SELECT * FROM companhiaAerea.tecnico t JOIN companhiaAerea.funcionario f ON (t.cadastro_tecnico = f.cadastro)) AS dadosTec 
ON (tecAero.cadastro_tecnico = dadosTec.cadastro)

---------------------------------------------------------------------------------------

--10) Passageiros internacionais que nasceram entre de 1950 e 1980
SELECT * FROM companhiaAerea.pass_internacional i JOIN companhiaAerea.passageiro p ON (i.id_internacional = p.id_passageiro)
WHERE p.data_nasc < '1980/01/01' AND p.data_nasc > '1950/01/01'
