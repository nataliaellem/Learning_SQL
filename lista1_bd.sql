-- LISTA 1 INTRODUÇÃO A BANCO DE DADOS



--EXERCÍCIO 1 - BD WORLD

-- Questão 1
USE wORld;
SELECT Code, Name FROM Country ORDER BY Code LIMIT 10; 


-- Questão 2
SELECT filtered_country.Code, filtered_country.Name FROM (
    SELECT Code, Name
    FROM Country
    ORDER BY Code DESC
    LIMIT 10
) AS filtered_country ORDER BY filtered_country.Code ASC;


-- Questão 3
SELECT Code, Name FROM Country WHERE Name LIKE 'United%';


-- Questão 4
SELECT count(*) AS NumPaises FROM Country;


-- Questão 5
SELECT CountryCode, count(Language) AS NumLanguages 
FROM CountryLanguage 
GROUP BY CountryCode 
ORDER BY CountryCode ASc LIMIT 10;


-- Questão 6
SELECT CountryLanguage.CountryCode, CountryLanguage.Language
FROM CountryLanguage
JOIN (
    SELECT CountryCode
    FROM CountryLanguage
    GROUP BY CountryCode
    ORDER BY CountryCode
    LIMIT 20
) AS FilteredCountryLanguages ON FilteredCountryLanguages.CountryCode = CountryLanguage.CountryCode
ORDER BY CountryLanguage.CountryCode;
--Outra forma de resolver a questão:
--Primeiro encontra-se o vigésimo país, que tem o código BGD
select CountryCode from CountryLanguage group by CountryCode limit 20;
--Depois mostra a consulta pedida
select CountryCode, Language from CountryLanguage where CountryCode <= 'BGD' order by CountryCode asc;


--Questão 7
SELECT CountryLanguage.CountryCode, CountryLanguage.Language
FROM CountryLanguage
JOIN (
    SELECT CountryCode
    FROM CountryLanguage
    GROUP BY CountryCode
    ORDER BY CountryCode
    LIMIT 20
) AS FilteredCountryLanguages ON FilteredCountryLanguages.CountryCode = CountryLanguage.CountryCode 
WHERE IsOfficial = 'T'
ORDER BY CountryLanguage.CountryCode;


--Questão 8
SELECT CountryCode, count(IsOfficial) AS NumOfficialLangs 
FROM CountryLanguage 
WHERE IsOfficial='T' 
GROUP BY CountryCode 
having NumOfficialLangs>1 
ORDER BY CountryCode ASC;
select CountryCode from CountryLanguage where IsOfficial='T' 
group by CountryCode limit 20;
--Como o vigésimo código que apareceu foi BIH, então:
select CountryCode, Language as Oficial_Language from CountryLanguage 
where CountryCode<='BIH' and IsOfficial='T' order by CountryCode asc;


--Questão 9
SELECT Region FROM Country GROUP BY Region;


--Questão 10
SELECT Code, Name, LifeExpectancy FROM Country WHERE Region LIKE 'NORdic%';


--Questão 11
SELECT Name, SurfaceArea FROM Country ORDER BY SurfaceArea DESC LIMIT 10;


--Questão 12
SELECT Code, SurfaceArea FROM Country ORDER BY SurfaceArea LIMIT 5;


--Questão 13
SELECT Code, SurfaceArea FROM Country WHERE Region LIKE '%Europe%' ORDER BY SurfaceArea LIMIT 5;


--Questão 14
SELECT Code, Population FROM Country ORDER BY Population DESC LIMIT 5;


--Questão 15
SELECT Name, SurfaceArea FROM Country  
WHERE Name LIKE '%Germany%' 
OR Name LIKE '%France%'  
OR Name LIKE '%United Kingdom%' 
OR Name LIKE '%PORtugal%'  
OR Name LIKE '%Spain%' 
OR Name LIKE '%Italy%' 
ORDER BY SurfaceArea;


--Questão 16
SELECT Continent, count(Name) AS NumPaises FROM Country GROUP BY Continent;


--Questão 17
SELECT count(*) AS NumCity FROM City;


--Questão 18
SELECT Name, Population FROM City WHERE CountryCode='bra';


--Questão 19
SELECT count(*) AS NumBraCities FROM City WHERE CountryCode='bra';



--Questão 20
SELECT CountryCode, count(Name) AS NumCities FROM City GROUP BY CountryCode;



--EXERCÍCIO 2

--Criando o banco de dados "Agenda"
CREATE DATABASE Agenda;
USE Agenda;

--Criando 3 tabelas: uma com informações básicas dos contatos, 
--outra com a localidade deles e outra com as redes sociais deles.

create table Contatos(
    id INT NOT NULL, Nome VARCHAR(50) NOT NULL, Apelido VARCHAR(20), Relacao VARCHAR(50), 
    FrequenciaDeContato ENUM('DIARIO', 'SEMANAL', 'ANUAL', 'RARAMENTE' ), 
    Telefones VARCHAR(20), Status ENUM('ativo', 'desativado'), DataUltimoContato DATE, Observacao VARCHAR(50)
);


create table LocalizacaoContatos (
    id INT NOT NULL, Nome VARCHAR(50) NOT NULL, Cidade VARCHAR(50), Estado VARCHAR(50), Pais VARCHAR(20)
);


create table ContatosRedesSociais(
    id INT NOT NULL, Nome VARCHAR(50), Email VARCHAR(50), Whatsapp VARCHAR(20), Twitter VARCHAR(20), Instagram VARCHAR(20), Facebook VARCHAR(20), 
    DataUltimaConversa DATE
);

--Inserindo dados ficticios nas tabelas:

insert into Contatos
    values (1, 'Anastacia Pereira', 'Nastacia', 'vizinha', 'SEMANAL', '319999-9999', 'ativo', '2021/01/07', NULL), 
    (2, 'Pedro Moreira', 'Pedro', 'filho', 'DIARIO', '8888-8888', 'ativo', '2021/01/07', NULL), 
    (3, 'Maria', 'Maria', 'prima', 'SEMANAL', '7777-7777', 'ativo', '2020/12/30', NULL);

insert into LocalizacaoContatos 
    values(1, 'Anastacia Pereira', 'Belo Horizonte', 'MG', 'Brasil'),
    (2, 'Pedro Moreira', 'Belo Horizonte', 'MG', 'Brasil'),
    (3, 'Maria', 'Belo Horizonte', 'MG', 'Brasil');

insert into ContatosRedesSociais 
    values(1, 'Anastacia Pereira', 'anastacia@gmail.com', '319999-9999', NULL, 'anastacia', NULL, '2020/05/03'),
    (2, 'Pedro Moreira', NULL, NULL, NULL, NULL, NULL, NULL),
    (3, 'Maria', 'maria@gmail.com', '7777-7777', 'maria', NULL, 'maria', '2020/12/30');


--Algumas consultas básicas que podem ser feitas nas tabelas:

--Vendo o nome de todos os contatos ativos
select Nome from Contatos where Status='ativo';
--Vendo com quantos contatos a pessoa conversou em cada dia no mês de dezembro de 2020
select DataUltimoContato, count(DataUltimoContato) AS Coversas_dezembro_de_2020 
from Contatos group by DataUltimoContato 
having DataUltimoContato<'2021/01/01' AND DataUltimoContato>'2020/11/30';
--Selecionando todos os contatos com frequencia de contato diario
select Nome AS Contatos_Com_Frequencia_Diaria from Contatos where FrequenciaDeContato= 'DIARIO';
--Selecionar os primeiros 2 contatos, em ordem alfabética, que moram no Brasil
select Nome as Contatos_que_moram_no_Brasil from LocalizacaoContatos where Pais='Brasil' order by Nome asc limit 2;
--Consultando todos os contatos que têm twitter
select Nome as Contatos_que_tem_twitter, Twitter from ContatosRedesSociais where Twitter is not NULL;
