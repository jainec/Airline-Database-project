CREATE SCHEMA companhiaAerea;

CREATE DOMAIN companhiaAerea.tipo_cpf AS VARCHAR(11);

CREATE TABLE companhiaAerea.codigo_postal(
	cep VARCHAR(10),	
	cidade VARCHAR(60) NOT NULL,
	estado VARCHAR(60) NOT NULL,
	pais VARCHAR(60) NOT NULL,	
	CONSTRAINT pk_codigoPostal PRIMARY KEY (cep)
);

CREATE TABLE companhiaAerea.passageiro(
	id_passageiro int DEFAULT -1,
	primeiro_nome VARCHAR(30) NOT NULL,
	sobrenome VARCHAR(30) NOT NULL,
	data_nasc DATE,
	sexo VARCHAR(10),
	rua VARCHAR(255) NOT NULL,
	numero int,
	cep VARCHAR(10),
	CONSTRAINT pk_passageiro PRIMARY KEY (id_passageiro),
	CONSTRAINT fk_codigo_postal FOREIGN KEY (cep) REFERENCES companhiaAerea.codigo_postal(cep)
	ON DELETE SET NULL ON UPDATE CASCADE	
);


CREATE TABLE companhiaAerea.pass_domestico(
	rg int,
	id_domestico int NOT NULL,
	CONSTRAINT pk_passDomestico PRIMARY KEY (rg),
	CONSTRAINT uq_id UNIQUE(id_domestico),
	CONSTRAINT fk_passageiro_d FOREIGN KEY (id_domestico) REFERENCES companhiaAerea.passageiro(id_passageiro)
	ON DELETE SET DEFAULT ON UPDATE CASCADE	
);


CREATE TABLE companhiaAerea.pass_internacional(
	num_passaporte VARCHAR(45),
	id_internacional int NOT NULL,
	CONSTRAINT pk_passInternacional PRIMARY KEY (num_passaporte),
	CONSTRAINT uq_idi UNIQUE(id_internacional),
	CONSTRAINT fk_passageiro_i FOREIGN KEY (id_internacional) REFERENCES companhiaAerea.passageiro(id_passageiro)
	ON DELETE SET DEFAULT ON UPDATE CASCADE	
);


CREATE TABLE companhiaAerea.pass_emails(
	pass_email VARCHAR(45),
	id_passageiro int,
	CONSTRAINT pk_passEmails PRIMARY KEY (pass_email, id_passageiro),
	CONSTRAINT fk_passEmails FOREIGN KEY (id_passageiro) REFERENCES companhiaAerea.passageiro(id_passageiro)
	ON DELETE SET DEFAULT ON UPDATE CASCADE
);


CREATE TABLE companhiaAerea.pass_telefones(
	pass_telefone int,
	id_passageiro int,
	CONSTRAINT pk_passTel PRIMARY KEY (pass_telefone, id_passageiro),
	CONSTRAINT fk_passTel FOREIGN KEY (id_passageiro) REFERENCES companhiaAerea.passageiro(id_passageiro)
	ON DELETE SET DEFAULT ON UPDATE CASCADE
);


CREATE TABLE companhiaAerea.aeroporto(
	codigo_aeroporto int,
	nome VARCHAR(150) NOT NULL ,
	rua VARCHAR(255) NOT NULL,
	cep VARCHAR(10),
	CONSTRAINT pk_aeroporto PRIMARY KEY(codigo_aeroporto),
	CONSTRAINT fk_codigo_postal FOREIGN KEY (cep) REFERENCES companhiaAerea.codigo_postal(cep)
	ON DELETE SET NULL ON UPDATE CASCADE
);


CREATE TABLE companhiaAerea.modelo_especificacoes(
	modelo VARCHAR(45),
	tripulacao int,
	envergadura real,
	cap_combustivel real,
	comprimento real,
	qtd_passageiros int,
	CONSTRAINT pk_modelo PRIMARY KEY(modelo)
);


CREATE TABLE companhiaAerea.aeronave(
	codigo_aeronave int,
	status_de_voo VARCHAR(40) NOT NULL,
	data_aquisicao DATE,
	modelo VARCHAR(45),
	CONSTRAINT pk_aeronave PRIMARY KEY (codigo_aeronave),
	CONSTRAINT fk_modelo FOREIGN KEY(modelo) REFERENCES companhiaAerea.modelo_especificacoes(modelo)
	ON DELETE SET NULL ON UPDATE CASCADE
);


CREATE TABLE companhiaAerea.voo(
	codigo_voo int,
	data_partida DATE NOT NULL,
	hora_partida TIME NOT NULL,
	data_chegada DATE NOT NULL,
	hora_chegada TIME NOT NULL,
	origem int,
        cod_aeronave int,
	CONSTRAINT pk_voo PRIMARY KEY(codigo_voo),
	CONSTRAINT fk_origem FOREIGN KEY (origem) REFERENCES companhiaAerea.aeroporto(codigo_aeroporto)
	ON DELETE SET NULL ON UPDATE CASCADE,
	CONSTRAINT fk_aeronave FOREIGN KEY (cod_aeronave) REFERENCES companhiaAerea.aeronave(codigo_aeronave)
	ON DELETE SET NULL ON UPDATE CASCADE
);


CREATE TABLE companhiaAerea.passagem(
	cod_reserva int,
	num_poltrona int,
	classe VARCHAR(20),
	data_embarque DATE NOT NULL,
	hora_embarque TIME NOT NULL,
	data_desembarque DATE NOT NULL,
	hora_desembarque TIME NOT NULL,
	data_compra DATE NOT NULL,
	valor_total real NOT NULL,
	cod_voo int,
	cod_passageiro int,
	CONSTRAINT pk_passagem PRIMARY KEY(cod_reserva),
	CONSTRAINT ck_valor_total CHECK(valor_total>0),
	CONSTRAINT fk_passageiro FOREIGN KEY (cod_passageiro) REFERENCES companhiaAerea.passageiro(id_passageiro)
	ON DELETE SET NULL ON UPDATE CASCADE,
	CONSTRAINT fk_voo FOREIGN KEY (cod_voo) REFERENCES companhiaAerea.voo(codigo_voo)
	ON DELETE SET NULL ON UPDATE CASCADE
);


CREATE TABLE companhiaAerea.destino(
	cod_voo int,
	cod_aeroporto int,
	isEscala boolean,
	CONSTRAINT pk_destino PRIMARY KEY(cod_voo, cod_aeroporto),
	CONSTRAINT fk_voo FOREIGN KEY(cod_voo) REFERENCES companhiaAerea.voo
	ON DELETE SET NULL ON UPDATE CASCADE,
	CONSTRAINT fk_aeroporto FOREIGN KEY(cod_aeroporto) REFERENCES companhiaAerea.aeroporto
	ON DELETE SET NULL ON UPDATE CASCADE
);


CREATE TABLE companhiaAerea.manutencao(
	numero int,
	datah DATE NOT NULL,
	hora TIME,
	tipo VARCHAR(20),
	componente VARCHAR(45) NOT NULL,
	cod_aeronave int,
	CONSTRAINT pk_manutencao PRIMARY KEY(numero, cod_aeronave),
	CONSTRAINT fk_aeronave FOREIGN KEY(cod_aeronave) REFERENCES companhiaAerea.aeronave(codigo_aeronave)
	ON DELETE CASCADE ON UPDATE CASCADE
);


CREATE TABLE companhiaAerea.funcionario(
	cadastro int,
	cpf companhiaAerea.tipo_cpf,
	primeiro_nome VARCHAR(30) NOT NULL,
	sobrenome VARCHAR(30) NOT NULL,
	salario real,
	data_admissao DATE,
	sexo VARCHAR(10),
	rua VARCHAR(255) NOT NULL,
	numero_casa int,
	cep VARCHAR(10),   
	CONSTRAINT pk_funcionario PRIMARY KEY (cadastro),
	CONSTRAINT ck_sal_negativo CHECK(salario>0),
	CONSTRAINT fk_codigo_postal FOREIGN KEY (cep) REFERENCES companhiaAerea.codigo_postal(cep)
	ON DELETE SET NULL ON UPDATE CASCADE	
);


CREATE TABLE companhiaAerea.func_emails(
	func_email VARCHAR(45),
	cad_funcionario int,
	CONSTRAINT pk_funcEmails PRIMARY KEY (func_email, cad_funcionario),
	CONSTRAINT fk_funcEmails FOREIGN KEY (cad_funcionario) REFERENCES companhiaAerea.funcionario(cadastro)
	ON DELETE SET NULL ON UPDATE CASCADE
);


CREATE TABLE companhiaAerea.func_telefones(
	func_telefone int,
	cad_funcionario int,
	CONSTRAINT pk_funcTel PRIMARY KEY (func_telefone, cad_funcionario),
	CONSTRAINT fk_funcTel FOREIGN KEY (cad_funcionario) REFERENCES companhiaAerea.funcionario(cadastro)
	ON DELETE SET NULL ON UPDATE CASCADE
);


CREATE TABLE companhiaAerea.piloto(
	cadastro_piloto int,
	num_licenca int NOT NULL,
	data_licenca DATE NOT NULL,
	horas_voo real,
	CONSTRAINT pk_piloto PRIMARY KEY (cadastro_piloto),
	CONSTRAINT uq_numLic UNIQUE(num_licenca),
	CONSTRAINT fk_piloto FOREIGN KEY (cadastro_piloto) REFERENCES companhiaAerea.funcionario(cadastro)
	ON DELETE SET NULL ON UPDATE CASCADE	
);


CREATE TABLE companhiaAerea.comissario(
	cadastro_comissario int,
	horas_voo real,
	CONSTRAINT pk_comissario PRIMARY KEY (cadastro_comissario),
	CONSTRAINT fk_comissario FOREIGN KEY (cadastro_comissario) REFERENCES companhiaAerea.funcionario(cadastro)
	ON DELETE SET NULL ON UPDATE CASCADE	
);


CREATE TABLE companhiaAerea.idiomas(
	idioma VARCHAR(20), 
	cad_comissario int,
	CONSTRAINT pk_idioma PRIMARY KEY (idioma, cad_comissario),
	CONSTRAINT fk_idioma FOREIGN KEY (cad_comissario) REFERENCES companhiaAerea.comissario(cadastro_comissario)
	ON DELETE SET NULL ON UPDATE CASCADE
);


CREATE TABLE companhiaAerea.tecnico(
	cadastro_tecnico int,
	formacao VARCHAR(45),
	especialidade VARCHAR(45),
	vinculo VARCHAR(45),
	CONSTRAINT pk_tecnico PRIMARY KEY (cadastro_tecnico),
	CONSTRAINT fk_tecnico FOREIGN KEY (cadastro_tecnico) REFERENCES companhiaAerea.funcionario(cadastro)
	ON DELETE SET NULL ON UPDATE CASCADE	
);

CREATE TABLE companhiaAerea.trabalha(
	cadastro_funcionario int,
	cod_aeronave int,
	CONSTRAINT pk_trabalha PRIMARY KEY (cadastro_funcionario, cod_aeronave),
	CONSTRAINT fk_func FOREIGN KEY (cadastro_funcionario) REFERENCES companhiaAerea.funcionario(cadastro)
	ON DELETE SET NULL ON UPDATE CASCADE,
	CONSTRAINT fk_aeronave FOREIGN KEY (cod_aeronave) REFERENCES companhiaAerea.aeronave(codigo_aeronave)
	ON DELETE SET NULL ON UPDATE CASCADE
);


CREATE TABLE companhiaAerea.realiza(
	num_manutencao int,
 	codigo_aeronave int,
	cadastro_tecnico int,
 	CONSTRAINT pk_realiza PRIMARY KEY (num_manutencao, codigo_aeronave, cadastro_tecnico),
 	CONSTRAINT fk_num_manutencao FOREIGN KEY (num_manutencao, codigo_aeronave) REFERENCES companhiaAerea.manutencao(numero, cod_aeronave)
 	ON DELETE SET NULL ON UPDATE CASCADE,
 	CONSTRAINT fk_cadastro_tecnico FOREIGN KEY (cadastro_tecnico) REFERENCES companhiaAerea.tecnico(cadastro_tecnico)
 	ON DELETE SET NULL ON UPDATE CASCADE
);
						-- POVOAMENTO

--CODIGOS POSTAIS
INSERT INTO companhiaAerea.codigo_postal VALUES('49000000', 'Aracaju', 'Sergipe', 'Brasil');
INSERT INTO companhiaAerea.codigo_postal VALUES('49200000', 'Estância', 'Sergipe', 'Brasil');
INSERT INTO companhiaAerea.codigo_postal VALUES('2345678', 'Simão Dias', 'Sergipe', 'Brasil');
INSERT INTO companhiaAerea.codigo_postal VALUES('123890', 'Chicago', 'Illinois', 'EUA');
INSERT INTO companhiaAerea.codigo_postal VALUES('21891289', 'Camden', 'Londres', 'Inglaterra');
INSERT INTO companhiaAerea.codigo_postal VALUES('4001', 'Toronto', 'Ontario', 'Canada');
INSERT INTO companhiaAerea.codigo_postal VALUES('5454', 'Portland', 'Oregon', 'EUA');
INSERT INTO companhiaAerea.codigo_postal VALUES('50259', 'Köln', 'Nordrhein-Westfalen', 'Alemanha');
INSERT INTO companhiaAerea.codigo_postal VALUES('71608900', 'Brasilia', 'Distrito Federal', 'Brasil');

--PASSAGEIROS
INSERT INTO companhiaAerea.passageiro VALUES(1, 'Filipe', 'Barreto', '1990/08/27', 'Masculino', 'Abbey Road', 1612, '49000000');
INSERT INTO companhiaAerea.passageiro VALUES(2, 'Jaine', 'Conceição', '1998/04/17', 'Feminino', 'Acrisio Esteves', 213, '49200000');
INSERT INTO companhiaAerea.passageiro VALUES(3, 'Curtis', 'Mayfield', '1950/06/03', 'Masculino', 'Chicago', 11100, '123890');
INSERT INTO companhiaAerea.passageiro VALUES(4, 'Amy', 'Winehouse', '1983/09/14', 'Feminino', 'Camden Town', 789, '21891289');
INSERT INTO companhiaAerea.passageiro VALUES(5, 'Geddy', 'Lee', '1953/07/29', 'Masculino', 'Willowdale', 2112, '4001');
INSERT INTO companhiaAerea.passageiro VALUES(6, 'Yasmin', 'Barreto', '1989/01/20', 'Feminino', 'Rua dos Bobos', 0, '2345678');
INSERT INTO companhiaAerea.passageiro VALUES(7, 'Michael', 'League', '1984/04/24', 'Masculino', 'Long Beach', 5498, '123890');
INSERT INTO companhiaAerea.passageiro VALUES(8, 'Esperanza', 'Spalding', '1984/10/10', 'Feminino', 'Portland', 516156, '5454');
INSERT INTO companhiaAerea.passageiro VALUES(9, 'Herbie', 'Hancock', '1940/04/12', 'Masculino', 'Cantaloupe Island', 8888, '123890');
INSERT INTO companhiaAerea.passageiro VALUES(10, 'Raul', 'Andrade', '01/12/1996', 'Masculino', 'Lalala', 190, '49000000');
INSERT INTO companhiaAerea.passageiro VALUES(11, 'Gabriel', 'Menezes', '24/10/1996', 'Masculino', 'Leonel Curvelo', 690, '49000000');
INSERT INTO companhiaAerea.passageiro VALUES(12, 'Max', 'Pütz', '18/09/1992', 'Masculino', 'Richard Strasse', 1200, '50259');

--PASSAGEIROS DOMÉSTICOS
INSERT INTO companhiaAerea.pass_domestico VALUES(12345, 2);
INSERT INTO companhiaAerea.pass_domestico VALUES(34567, 1);
INSERT INTO companhiaAerea.pass_domestico VALUES(89100, 6);
INSERT INTO companhiaAerea.pass_domestico VALUES(92929, 10);
INSERT INTO companhiaAerea.pass_domestico VALUES(72988, 11);

--PASSAGEIROS INTERNACIONAIS
INSERT INTO companhiaAerea.pass_internacional VALUES(67859, 3);
INSERT INTO companhiaAerea.pass_internacional VALUES(87354, 4);
INSERT INTO companhiaAerea.pass_internacional VALUES(09283, 5);
INSERT INTO companhiaAerea.pass_internacional VALUES(40239, 7);
INSERT INTO companhiaAerea.pass_internacional VALUES(65920, 8);
INSERT INTO companhiaAerea.pass_internacional VALUES(10928, 9);
INSERT INTO companhiaAerea.pass_internacional VALUES(22928, 12);

--PASSAGEIROS EMAILS
INSERT INTO companhiaAerea.pass_emails VALUES('jainecs@dcomp.ufs.br', 2);
INSERT INTO companhiaAerea.pass_emails VALUES('jayne-conceicao@hotmail.com', 2);
INSERT INTO companhiaAerea.pass_emails VALUES('filibefbn@gmail.com', 1);
INSERT INTO companhiaAerea.pass_emails VALUES('filipe.nascimento@dcomp.ufs.com', 1);
INSERT INTO companhiaAerea.pass_emails VALUES('curtis@hotmail.com', 3);
INSERT INTO companhiaAerea.pass_emails VALUES('winehouse@hotmail.com', 4);
INSERT INTO companhiaAerea.pass_emails VALUES('geddy@gmail.com', 5);
INSERT INTO companhiaAerea.pass_emails VALUES('yasmim.barreto@gmail.com', 6);
INSERT INTO companhiaAerea.pass_emails VALUES('micha.league@hotmail.com', 7);
INSERT INTO companhiaAerea.pass_emails VALUES('esperanza123@gmail.com', 8);
INSERT INTO companhiaAerea.pass_emails VALUES('hancock@gmail.com', 9);
INSERT INTO companhiaAerea.pass_emails VALUES('theraulandrade@hotmail.com', 10);
INSERT INTO companhiaAerea.pass_emails VALUES('gabrielsmenezes2@gmail.com', 11);
INSERT INTO companhiaAerea.pass_emails VALUES('max.puetz@hotmail.com', 12);

--PASSAGEIROS TELEFONES
INSERT INTO companhiaAerea.pass_telefones VALUES(799882609, 2);
INSERT INTO companhiaAerea.pass_telefones VALUES(799998242, 1);
INSERT INTO companhiaAerea.pass_telefones VALUES(759948789, 10);
INSERT INTO companhiaAerea.pass_telefones VALUES(799876777, 11);
INSERT INTO companhiaAerea.pass_telefones VALUES(016374856, 3);
INSERT INTO companhiaAerea.pass_telefones VALUES(028328978, 4);
INSERT INTO companhiaAerea.pass_telefones VALUES(382309802, 5);
INSERT INTO companhiaAerea.pass_telefones VALUES(983827382, 6);
INSERT INTO companhiaAerea.pass_telefones VALUES(382738293, 7);
INSERT INTO companhiaAerea.pass_telefones VALUES(928392320, 8);
INSERT INTO companhiaAerea.pass_telefones VALUES(291203802, 9);
INSERT INTO companhiaAerea.pass_telefones VALUES(128374940, 12);

--AEROPORTOS
INSERT INTO companhiaAerea.aeroporto VALUES(1000, 'Aeroporto Internacional Santa Maria', 'Avenida Não sei', '49000000');
INSERT INTO companhiaAerea.aeroporto VALUES(2000, 'Aeroporto de Colônia-Bonn', 'Kennedystrasse', '50259');
INSERT INTO companhiaAerea.aeroporto VALUES(3000, 'Aeroporto Internacional Pearson de Toronto', 'Silver Dart Dr', '4001');
INSERT INTO companhiaAerea.aeroporto VALUES(4000, 'Aeroporto Internacional de Brasilia', 'Lago Sul', '71608900');
INSERT INTO companhiaAerea.aeroporto VALUES(5000, 'Aeroporto da Cidade de Londres', 'Hartmann Rd', '21891289');


--MODELO-ESPECIFICAÇÕES
INSERT INTO companhiaAerea.modelo_especificacoes VALUES('Airbus A330-200F', 6, 60.3, 139.100, 59, 162);
INSERT INTO companhiaAerea.modelo_especificacoes VALUES('Embraer E-190', 4, 28.72, 110.200, 38.65, 106);
INSERT INTO companhiaAerea.modelo_especificacoes VALUES('BOEING 737', 6, 34.3, 135.000, 39.5, 170);
INSERT INTO companhiaAerea.modelo_especificacoes VALUES('ATR-72', 5, 27.05, 112.000, 21.27, 70);
INSERT INTO companhiaAerea.modelo_especificacoes VALUES('Concorde', 5, 25.6, 98.000, 61.65, 110);


--AERONAVES
INSERT INTO companhiaAerea.aeronave VALUES(110, 'Decolado', '11/01/2007', 'Airbus A330-200F');
INSERT INTO companhiaAerea.aeronave VALUES(120, 'Previsto', '12/04/2009', 'Airbus A330-200F');
INSERT INTO companhiaAerea.aeronave VALUES(130, 'Pousou', '13/05/2010', 'Embraer E-190');
INSERT INTO companhiaAerea.aeronave VALUES(140, 'Cancelado', '21/02/2003', 'BOEING 737');
INSERT INTO companhiaAerea.aeronave VALUES(150, 'Confirmado', '03/09/2015', 'BOEING 737');
INSERT INTO companhiaAerea.aeronave VALUES(160, 'Previsto', '04/08/2013', 'BOEING 737');
INSERT INTO companhiaAerea.aeronave VALUES(170, 'Confirmado', '12/10/2016', 'BOEING 737');
INSERT INTO companhiaAerea.aeronave VALUES(180, 'Previsto', '13/09/2014', 'ATR-72');
INSERT INTO companhiaAerea.aeronave VALUES(190, 'Confirmado', '15/09/2015', 'Concorde');

--VOOS
INSERT INTO companhiaAerea.voo VALUES(01, '20/09/2017', '10:10', '20/09/2017', '21:40', 1000, 120);
INSERT INTO companhiaAerea.voo VALUES(02, '30/09/2017', '12:00', '30/09/2017', '22:40', 2000, 110);
INSERT INTO companhiaAerea.voo VALUES(03, '25/10/2017', '19:10', '26/10/2017', '09:40', 3000, 150);
INSERT INTO companhiaAerea.voo VALUES(04, '01/01/2018', '18:10', '02/01/2018', '05:30', 4000, 130);
INSERT INTO companhiaAerea.voo VALUES(05, '02/01/2018', '19:10', '02/01/2018', '21:30', 4000, 180);
INSERT INTO companhiaAerea.voo VALUES(06, '05/02/2018', '15:10', '06/01/2018', '19:40', 5000, 190);

--PASSAGENS
INSERT INTO companhiaAerea.passagem VALUES(91, 20, 'Executiva', '20/09/2017', '10:10', '20/09/2017', '21:40', '15/08/2017', 500.0, 05, 1);
INSERT INTO companhiaAerea.passagem VALUES(92, 21, 'Primeira classe', '20/09/2017', '10:10', '20/09/2017', '21:40', '16/07/2017', 550.0, 05, 2);
INSERT INTO companhiaAerea.passagem VALUES(93, 22, 'Executiva', '20/09/2017', '10:10', '20/09/2017', '21:40', '13/08/2017', 500.0, 01, 3);
INSERT INTO companhiaAerea.passagem VALUES(94, 30, 'Primeira classe', '30/09/2017', '12:00', '30/09/2017', '20:00', '16/08/2017', 1500.0, 06, 11);
INSERT INTO companhiaAerea.passagem VALUES(95, 90, 'Econômica', '30/09/2017', '12:00', '30/09/2017', '20:00', '19/08/2017', 1500.0, 02, 4);
INSERT INTO companhiaAerea.passagem VALUES(96, 13, 'Econômica', '30/09/2017', '12:00', '30/09/2017', '20:00', '20/08/2017', 2000.0, 02, 5);
INSERT INTO companhiaAerea.passagem VALUES(97, 14, 'Primeira classe', '25/10/2017', '19:10', '26/10/2017', '09:40', '15/09/2017', 820.0, 03, 6);
INSERT INTO companhiaAerea.passagem VALUES(98, 60, 'Executiva', '25/10/2017', '19:10', '26/10/2017', '09:40', '16/09/2017', 820.0, 03, 7);
INSERT INTO companhiaAerea.passagem VALUES(99, 33, 'Econômica', '25/10/2017', '19:10', '26/10/2017', '09:40', '16/09/2017', 850.0, 03, 8);
INSERT INTO companhiaAerea.passagem VALUES(910, 36, 'Primeira classe', '01/01/2018', '18:10', '02/01/2018', '05:30', '20/10/2017', 07.0, 04, 9);
INSERT INTO companhiaAerea.passagem VALUES(911, 32, 'Econômica', '01/01/2018', '18:10', '02/01/2018', '05:30', '16/10/2017', 900.0, 04, 10);
INSERT INTO companhiaAerea.passagem VALUES(912, 19, 'Econômica', '01/01/2018', '18:10', '02/01/2018', '05:30', '30/09/2017', 900.0, 04, 12);

--DESTINOS
INSERT INTO companhiaAerea.destino VALUES(01, 1000, TRUE);
INSERT INTO companhiaAerea.destino VALUES(01, 3000, FALSE);
INSERT INTO companhiaAerea.destino VALUES(02, 4000, FALSE);
INSERT INTO companhiaAerea.destino VALUES(03, 1000, TRUE);
INSERT INTO companhiaAerea.destino VALUES(03, 4000, TRUE);
INSERT INTO companhiaAerea.destino VALUES(03, 2000, FALSE);
INSERT INTO companhiaAerea.destino VALUES(04, 5000, FALSE);
INSERT INTO companhiaAerea.destino VALUES(05, 1000, FALSE);
INSERT INTO companhiaAerea.destino VALUES(06, 4000, TRUE);
INSERT INTO companhiaAerea.destino VALUES(06, 1000, FALSE);

--MANUTENCOES
INSERT INTO companhiaAerea.manutencao VALUES(1, '2017/09/20', '15:40', 'Corretiva', 'Transmissão', 110);
INSERT INTO companhiaAerea.manutencao VALUES(2, '2017/08/20', '17:00', 'Preventiva', 'Turbina', 110);
INSERT INTO companhiaAerea.manutencao VALUES(3, '2017/09/01', '19:00', 'Corretiva', 'Motor', 110);
INSERT INTO companhiaAerea.manutencao VALUES(1, '2017/09/02', '08:00', 'Corretiva', 'Motor', 120);
INSERT INTO companhiaAerea.manutencao VALUES(2, '2017/09/02', '08:00', 'Corretiva', 'Motor', 120);
INSERT INTO companhiaAerea.manutencao VALUES(3, '2017/09/02', '08:00', 'Corretiva', 'Motor', 120);
INSERT INTO companhiaAerea.manutencao VALUES(4, '2017/09/02', '08:00', 'Corretiva', 'Motor', 120);
INSERT INTO companhiaAerea.manutencao VALUES(1, '2017/09/05', '09:50', 'Preventiva', 'Roda', 130);
INSERT INTO companhiaAerea.manutencao VALUES(1, '2017/09/05', '09:50', 'Preventiva', 'Roda', 140);
INSERT INTO companhiaAerea.manutencao VALUES(1, '2017/09/06', '11:00', 'Corretiva', 'Flap', 150);
INSERT INTO companhiaAerea.manutencao VALUES(2, '2017/09/11', '13:00', 'Preventiva', 'Turbina', 150);

--FUNCIONARIOS
INSERT INTO companhiaAerea.funcionario VALUES(11, '0728398209', 'José', 'Marcelo', 5200.0, '2015/05/17', 'Masculino', 'Qualquer uma', 234, '49000000');
INSERT INTO companhiaAerea.funcionario VALUES(21, '2328398209', 'Marília', 'Mendonça', 3500.0, '2014/06/19', 'Feminino', 'Reino Torto', 123, '49200000');
INSERT INTO companhiaAerea.funcionario VALUES(31, '5558398209', 'Luisa', 'Souza', 3000.0, '2015/09/17', 'Feminino', 'Pedro Alvares', 45, '49200000');
INSERT INTO companhiaAerea.funcionario VALUES(32, '0958398209', 'Marcos', 'Braga', 3000.0, '2016/07/21', 'Masculino', 'Marechal Deodoro', 55, '49000000');
INSERT INTO companhiaAerea.funcionario VALUES(33, '0368884687', 'Bruce', 'Dickinson', 8000.0, '2014/05/24', 'Masculino', 'Acacia Avenue', 22, '21891289');
INSERT INTO companhiaAerea.funcionario VALUES(34, '0115468784', 'Mikael', 'Akerfeldt', 10000.0, '2015/01/02', 'Masculino', 'Opeth', 10, '50259');
INSERT INTO companhiaAerea.funcionario VALUES(35, '0123453757', 'Jenny', 'Lee', 15000.0, '2014/03/05', 'Feminino', 'Toronto Avenue', 54, '4001');
INSERT INTO companhiaAerea.funcionario VALUES(36, '0135543573', 'Rick', 'Sanchez', 1000.0, '2017/01/05', 'Masculino', 'Earth C-137', 100, '123890');

--FUNCIONARIOS EMAILS
INSERT INTO companhiaAerea.func_emails VALUES('jose.marcelo@hotmail.com', 11);
INSERT INTO companhiaAerea.func_emails VALUES('marilia@hotmail.com', 21);
INSERT INTO companhiaAerea.func_emails VALUES('sousa.luisa@hotmail.com', 31);
INSERT INTO companhiaAerea.func_emails VALUES('marcos.braga@hotmail.com', 32);
INSERT INTO companhiaAerea.func_emails VALUES('bruce@maiden.com', 33);
INSERT INTO companhiaAerea.func_emails VALUES('akerfeldt@gmail.com', 34);
INSERT INTO companhiaAerea.func_emails VALUES('jenny@warpaint.com', 35);
INSERT INTO companhiaAerea.func_emails VALUES('rick@schwifty.com', 36);

--FUNCIONARIOS TELEFONES
INSERT INTO companhiaAerea.func_telefones VALUES(91028122, 11);
INSERT INTO companhiaAerea.func_telefones VALUES(21098213, 21);
INSERT INTO companhiaAerea.func_telefones VALUES(12010920, 31);
INSERT INTO companhiaAerea.func_telefones VALUES(54039203, 32);
INSERT INTO companhiaAerea.func_telefones VALUES(32154987, 33);
INSERT INTO companhiaAerea.func_telefones VALUES(89795132, 34);
INSERT INTO companhiaAerea.func_telefones VALUES(79845678, 35);
INSERT INTO companhiaAerea.func_telefones VALUES(21354386, 36);

--PILOTOS
INSERT INTO companhiaAerea.piloto VALUES(11, 12345, '2025/04/19', 290);
INSERT INTO companhiaAerea.piloto VALUES(33, 66666, '2020/01/10', 666);

--COMISSARIOS
INSERT INTO companhiaAerea.comissario VALUES(31, 130);
INSERT INTO companhiaAerea.comissario VALUES(32, 200);
INSERT INTO companhiaAerea.comissario VALUES(36, 200000);

--IDIOMAS
INSERT INTO companhiaAerea.idiomas VALUES('Inglês', 31);
INSERT INTO companhiaAerea.idiomas VALUES('Alemão', 31);
INSERT INTO companhiaAerea.idiomas VALUES('Francês', 31);
INSERT INTO companhiaAerea.idiomas VALUES('Inglês', 32);
INSERT INTO companhiaAerea.idiomas VALUES('Francês', 32);
INSERT INTO companhiaAerea.idiomas VALUES('Inglês', 36);
INSERT INTO companhiaAerea.idiomas VALUES('Francês', 36);
INSERT INTO companhiaAerea.idiomas VALUES('Klingon', 36);
INSERT INTO companhiaAerea.idiomas VALUES('Alemão', 36);
INSERT INTO companhiaAerea.idiomas VALUES('Mandarim', 36);

--TECNICOS
INSERT INTO companhiaAerea.tecnico VALUES(21, 'Técnico', 'Mecânica', 'Terceirizado');
INSERT INTO companhiaAerea.tecnico VALUES(34, 'Engenheiro', 'Eletricista', 'Contratado');
INSERT INTO companhiaAerea.tecnico VALUES(35, 'Engenheiro', 'Mecânica', 'Terceirizado');

--TRABALHA
INSERT INTO companhiaAerea.trabalha VALUES(11, 110);   --funcionario 11 trabalha na aeronave 110
INSERT INTO companhiaAerea.trabalha VALUES(21, 110);
INSERT INTO companhiaAerea.trabalha VALUES(31, 120);
INSERT INTO companhiaAerea.trabalha VALUES(32, 110);
INSERT INTO companhiaAerea.trabalha VALUES(11, 120);
INSERT INTO companhiaAerea.trabalha VALUES(11, 130);
INSERT INTO companhiaAerea.trabalha VALUES(11, 140);
INSERT INTO companhiaAerea.trabalha VALUES(11, 150);
INSERT INTO companhiaAerea.trabalha VALUES(21, 120);
INSERT INTO companhiaAerea.trabalha VALUES(21, 130);
INSERT INTO companhiaAerea.trabalha VALUES(21, 140);
INSERT INTO companhiaAerea.trabalha VALUES(21, 150);
INSERT INTO companhiaAerea.trabalha VALUES(31, 150);
INSERT INTO companhiaAerea.trabalha VALUES(31, 130);
INSERT INTO companhiaAerea.trabalha VALUES(32, 140);
INSERT INTO companhiaAerea.trabalha VALUES(33, 110);
INSERT INTO companhiaAerea.trabalha VALUES(33, 120);
INSERT INTO companhiaAerea.trabalha VALUES(33, 130);
INSERT INTO companhiaAerea.trabalha VALUES(33, 140);
INSERT INTO companhiaAerea.trabalha VALUES(33, 150);
INSERT INTO companhiaAerea.trabalha VALUES(35, 110);
INSERT INTO companhiaAerea.trabalha VALUES(35, 120);
INSERT INTO companhiaAerea.trabalha VALUES(36, 140);
INSERT INTO companhiaAerea.trabalha VALUES(36, 150);

--REALIZA
INSERT INTO companhiaAerea.realiza VALUES(1, 110, 21);   --manutencao numero 1 na aeronave 11 feita pelo tecnico 21
INSERT INTO companhiaAerea.realiza VALUES(2, 110, 35);
INSERT INTO companhiaAerea.realiza VALUES(3, 110, 21);
INSERT INTO companhiaAerea.realiza VALUES(1, 120, 35);
INSERT INTO companhiaAerea.realiza VALUES(2, 120, 34);
INSERT INTO companhiaAerea.realiza VALUES(3, 120, 21);
INSERT INTO companhiaAerea.realiza VALUES(4, 120, 35);
INSERT INTO companhiaAerea.realiza VALUES(1, 130, 21);
INSERT INTO companhiaAerea.realiza VALUES(1, 140, 35);
INSERT INTO companhiaAerea.realiza VALUES(1, 150, 34);
INSERT INTO companhiaAerea.realiza VALUES(2, 150, 21);


