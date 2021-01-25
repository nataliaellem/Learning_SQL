--LISTA 2 BD

----------------------------------------------------
------------------ EXERCÍCIO 1 ---------------------

CREATE DATABASE CidadeEstado;
USE CidadeEstado

--Criando tabela Cidades
CREATE TABLE Cidades (c_id int NOT NULL AUTO_INCREMENT, 
UF char(2), Cidade VARCHAR(40), PRIMARY KEY(c_id));

--Criando tabela Estados
CREATE TABLE Estados (id INT NOT NULL AUTO_INCREMENT, 
sigla char(2), Estado VARCHAR(20), PRIMARY KEY(id));

--Inserindo dados em Estados
INSERT INTO Estados(sigla,Estado) 
VALUES('AC','ACRE'),
    ('AL','ALAGOAS'),
    ('AP','AMAPÁ'),
    ('AM','AMAZONAS'),
    ('BA','BAHIA'),
    ('CE','CEARÁ'),
    ('DF','DISTRITO FEDERAL'),
    ('ES','ESPÍRITO SANTO'),
    ('GO','GOIÁS'),
    ('MA','MARANHÃO'),
    ('MT','MATO GROSSO'),
    ('MS','MATO GROSSO DO SUL'),
    ('MG','MINAS GERAIS'),
    ('PA','PARÁ'),
    ('PB','PARAÍBA'),
    ('PR','PARANÁ'),
    ('PE','PERNAMBUCO'),
    ('PI','PIAUÍ'),
    ('RJ','RIO DE JANEIRO'),
    ('RN','RIO GRANDE DO NORTE'),
    ('RS','RIO GRANDE DO SUL'),
    ('RO','RONDONIA'),
    ('RR','RORAIMA'),
    ('SC','SANTA CATARINA'),
    ('SP','SÃO PAULO'),
    ('SE','SERGIPE'),
    ('TO','TOCANTINS');

--Inserindo dados em Cidades (2 cidades para cada estado)
INSERT INTO Cidades(UF, Cidade)
VALUES('AC', 'Acrelândia'),
    ('AC', 'Assis Brasil'),
    ('AL', 'Água Branca'),
    ('AL', 'Anadia'),
    ('AM', 'Alvarães'),
    ('AM', 'Amaturá'),
    ('AP', 'Serra do Navio'),
    ('AP', 'Amapá'),
    ('BA', 'Abaíra'),
    ('BA', 'Abaré'),
    ('CE', 'Abaiara'),
    ('CE', 'Acarapé'),
    ('DF', 'Brasília'),
    ('ES', 'Afonso Cláudio'),
    ('ES', 'Águia Branca'),
    ('GO', 'Abadia de Goiás'),
    ('GO', 'Abadiânia'),
    ('MA', 'Açailândia'),
    ('MA', 'Afonso Cunha'),
    ('MG', 'Abadia dos Dourados'),
    ('MG', 'Abaeté'),
    ('MS', 'Água Clara'),
    ('MS', 'Alcinópolis'),
    ('MT', 'Acorizal'),
    ('MT', 'Água Boa'),
    ('PA', 'Abaetuba'),
    ('PA', 'Abel Figueiredo'),
    ('PB', 'Água Branca'),
    ('PB', 'Aguiar'),
    ('PE', 'Abreu de Lima'),
    ('PE', 'Afogados da Ingazeira'),
    ('PI', 'Acauã'),
    ('PI', 'Agricolândia'),
    ('PR', 'Abatiá'),
    ('PR', 'Adrianópolis'),
    ('RJ', 'Angra dos Reis'),
    ('RJ', 'Aperibé'),
    ('RN', 'Acari'),
    ('RN', 'Açu'),
    ('RO', 'Alta Floresta D´oeste'),
    ('RO', 'Ariquemes'),
    ('RR', 'Amajari'),
    ('RR', 'Alto Alegre'),
    ('RS', 'Aceguá'),
    ('RS', 'Água Santa'),
    ('SC', 'Abdon Batista'),
    ('SC', 'Abelardo Luz'),
    ('SE', 'Amparo de São Francisco'),
    ('SE', 'Aquidabã'),
    ('SP', 'Adamantina'),
    ('SP', 'Adolfo'),
    ('TO', 'Abreulândia'),
    ('TO', 'Aguiarnópolis');
--Outra forma de Inserir os dados em Cidades:
load data local infile 'Lista_dois_municipios_por_estado.csv' 
into table Cidades 
fields terminated by ',' 
enclosed by '"' 
lines terminated by '\n' 
IGNORE 1 ROWS;

--Exercícios queries pedidas:

--2) Nomes das Cidaddes e dos Estados armazendos no banco
select Estados.Estado AS Nomes_estados, 
Cidades.Cidade AS Nomes_Cidades from 
Cidades inner join Estados on Estados.sigla=Cidades.UF;

--3) Cidades, estados e siglas
select Estados.sigla AS Sigla_estado, 
Estados.Estado AS Nome_estado, 
Cidades.Cidade AS Nome_Cidade 
from Cidades inner join Estados 
on Estados.sigla=Cidades.UF;

--4) Cidades e Estados cujas siglas começam com A
select Estados.sigla AS Sigla_estado, 
Estados.Estado AS Nome_estado, 
Cidades.Cidade AS Nome_Cidade 
from Cidades inner join Estados 
on Estados.sigla=Cidades.UF 
where Estados.sigla IN 
(select sigla from Estados where sigla LIKE 'A%');
--Outra forma mais reduzida:
SELECT Cidades.Cidade, Estados.Estado 
FROM Cidades INNER JOIN Estados 
ON Cidades.UF=Estados.sigla 
WHERE Estados.sigla LIKE 'A%';

--5) Cidades e estados cujas siglas começam com A ou com M
SELECT Cidades.Cidade, Estados.Estado 
FROM Cidades INNER JOIN Estados 
ON Cidades.UF=Estados.sigla 
WHERE Estados.sigla LIKE 'A%' OR Estados.sigla LIKE 'M%';
--Outra forma:
select Estados.sigla AS Sigla_estado, 
Estados.Estado AS Nome_estado, 
Cidades.Cidade AS Nome_Cidade 
from Cidades inner join Estados 
on Estados.sigla=Cidades.UF 
where Estados.sigla IN 
(select sigla from Estados where sigla LIKE 'A%' OR sigla LIKE 'M%');
--Esta segunda forma gasta 0,001 a mais de segundos 
--para executar do que a outra acima 


--6) Siglas dos estados com mais de duas cidades 
--armazenadas na tabela Cidades
SELECT sigla from Estados where exists 
(SELECT UF, count(*) AS Num_Cidades 
from Cidades WHERE Estados.sigla=Cidades.UF 
group by UF having Num_Cidades>2);


--7) Estados e suas respectivas quantidades de cidades
--armazenadas, para os estados que têm mais de 3 cidades
select Estados.Estado, count(Cidades.Cidade) AS 'Número Cidades no Banco' 
from Estados INNER JOIN Cidades 
ON Estados.sigla=Cidades.UF group by Estados.Estado 
having count(Cidades.Cidade)>3;


--8) Estados e suas siglas, os quais possuem cidades armazenadas 
--que iniciam com 'Belo'
SELECT Estado, sigla from Estados where exists 
(select UF from Cidades where Cidade LIKE 'Belo%' 
AND Estados.sigla=Cidades.UF);


--9) Inserindo a cidade Belo Monte da tabela Cidades:
INSERT INTO Cidades (UF, Cidade) 
values('AL', 'Belo Monte');
--Consulta do exercício anterior mas com o join on:
SELECT Estados.Estado, UF AS sigla 
from Cidades JOIN Estados ON Estados.sigla=UF 
WHERE Cidade LIKE "Belo%";


--10) 
SELECT Cidades.Cidade, Estados.Estado, UF AS sigla 
from Cidades JOIN Estados ON Estados.sigla=UF 
WHERE Cidade LIKE "Belo%";

--------------------------------------------
--------------- EXERCÍCIO 2 ----------------
--------------------------------------------
--1) Criando tabela Regioes
CREATE TABLE Regioes 
(R_id int NOT NULL AUTO_INCREMENT, 
UF VARCHAR(2) NOT NULL, 
Regiao VARCHAR(30) NOT NULL, 
PRIMARY KEY(R_id));


--2) Inserindo informações para alguns estados
insert into Regioes (UF,Regiao)
values('AC','Norte'),
('AM','Norte'),
('BA','Nordeste'),
('AL','Nordeste'),
('MG','Sudeste'),
('SP','Sudeste'),
('RG','Sul'),
('MT','Centro-Oeste');

--3) Cidades, estados e regioes dos estados que têm informações
--de região na tabela Regioes
 select Cidades.Cidade, Estados.Estado, Regioes.Regiao 
 from Estados inner join Regioes 
 ON Estados.sigla=Regioes.UF 
 INNER JOIN Cidades 
 ON Cidades.UF=Regioes.UF;

--4) 
 SELECT Cidades.Cidade, Estados.Estado, Regioes.Regiao 
 FROM Regioes LEFT JOIN Estados ON Estados.sigla=Regioes.UF 
 LEFT JOIN Cidades ON Cidades.UF=Estados.sigla;
--Atualizando a tabela com um estado na região sul
update Regioes set UF = 'RS' where UF='RG';


--5)
update Regioes set UF = 'RG' where UF='RS';
update Regioes set UF = 'MM' where UF='MG';
--Consulta do exercício anterior:
SELECT Cidades.Cidade, Estados.Estado, Regioes.Regiao 
FROM Regioes LEFT JOIN Estados ON Estados.sigla=Regioes.UF 
LEFT JOIN Cidades ON Cidades.UF=Estados.sigla;


--6) Todas as Cidades armazenadas na tabela Cidades:
SELECT Cidades.Cidade, Estados.Estado, Regioes.Regiao 
FROM Regioes RIGHT JOIN Estados ON Estados.sigla=Regioes.UF 
RIGHT JOIN Cidades ON Cidades.UF=Estados.sigla;
