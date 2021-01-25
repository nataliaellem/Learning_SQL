--Nome: Natália Ellem Moreira
--Turma: Módulo 2 subsequente


--Criando o banco de dados, as tabelas e inserindo dados

CREATE DATABASE EmpresaC;
USE EmpresaC

CREATE TABLE product (
    maker varchar(10) NOT NULL, 
    model varchar(50) NOT NULL, 
    type varchar(50) NOT NULL, 
    PRIMARY KEY(model)
);

CREATE TABLE pc (
    code int NOT NULL, 
    model varchar(50) NOT NULL,
    speed smallint NOT NULL,
    ram smallint NOT NULL,
    hd real NOT NULL,
    cd varchar(10) NOT NULL,
    price decimal(7, 2), 
    PRIMARY KEY (code)
);

CREATE TABLE laptop (
    code int NOT NULL, 
    model varchar(50) NOT NULL,
    speed smallint NOT NULL,
    ram smallint NOT NULL,
    hd real NOT NULL,
    price decimal(7, 2),
    screen tinyint NOT NULL,
    PRIMARY KEY (code)
);

CREATE TABLE printer (
    code int NOT NULL,
    model varchar(50) NOT NULL,
    color char(1) NOT NULL,
    type varchar(10) NOT NULL,
    price DECIMAL(7,2),
    PRIMARY KEY (code)    
);


INSERT INTO product(maker, model, type)
    VALUES ('B', '1121', 'PC'),
    ('A', '1232', 'PC'),     
    ('A', '1233', 'PC'),     
    ('E', '1260', 'PC'),     
    ('A', '1276', 'Printer'),
    ('D', '1288', 'Printer'),
    ('A', '1298', 'Laptop'), 
    ('C', '1321', 'Laptop'), 
    ('A', '1401', 'Printer'),
    ('A', '1408', 'Printer'),
    ('D', '1433', 'Printer'),
    ('E', '1434', 'Printer'),
    ('B', '1750', 'Laptop'), 
    ('A', '1752', 'Laptop'), 
    ('E', '2113', 'PC'),     
    ('E', '2112', 'PC');


INSERT INTO pc (code, model, speed, ram, hd, cd, price)
VALUES
(1, '1232', 500, 64 , 5, '12x', 600),
(2, '1121', 750, 128, 14, '40x', 850),
(3, '1233', 500, 64 , 5, '12x', 600),
(4, '1121', 600, 128, 14, '40x', 850),
(5, '1121', 600, 128 , 8, '40x', 850),
(6, '1233', 750, 128, 20, '50x', 950),
(7, '1232', 500, 32, 10, '12x', 400),
(8, '1232', 450, 64 , 8, '24x', 350),
(9, '1232', 450, 32, 10, '24x', 350),
(10, '1260', 500, 32, 10, '12x', 350),
(11, '1233', 900, 128, 40, '40x', 980),
(12, '1233', 800, 128, 20, '50x', 970);


INSERT INTO laptop (code, model, speed, ram, hd, price, screen)
    VALUES
    (1, '1298', 350,  32,  4,  700, 11),
    (2, '1321', 500,  64,  8,  970, 12),
    (3, '1750', 750, 128, 12, 1200, 14),
    (4, '1298', 600,  64, 10, 1050, 15),
    (5, '1752', 750, 128, 10, 1150, 14),
    (6, '1298', 450,  64, 10,  950, 12);


INSERT INTO printer()
    VALUES
    (6, '1288', 'n', 'Laser', 400),
    (5, '1408', 'n', 'Matrix', 270),
    (4, '1401', 'n', 'Matrix', 150),
    (3, '1434', 'y', 'Jet', 290),
    (2, '1433', 'y', 'Jet', 270),
    (1, '1276', 'n', 'Laser', 400);

--Exercício 1)
SELECT model, speed, hd from pc where price < 500;

-----------------------------------------------------------

--Exercício 2)
WITH maker_printer AS
    (SELECT product.maker AS Printer_maker, 
    product.model FROM product INNER JOIN printer 
    ON product.model=printer.model
    ) SELECT Printer_maker FROM maker_printer
    ORDER BY model;

-----------------------------------------------------------

--Exercício 3)
SELECT model, ram, screen FROM laptop WHERE price > 1000;

-----------------------------------------------------------

--Exercício 4) 
WITH maker_speed as
    (SELECT product.maker, laptop.speed, laptop.hd 
    FROM product INNER JOIN laptop 
    ON product.model=laptop.model)
    SELECT maker, speed FROM maker_speed
    WHERE hd >= 10;

-----------------------------------------------------------

--Exercício 5)
--Criando uma View que relaciona os models da 
--tabela products com os preços de todas as outras tabelas

CREATE VIEW products_prices AS
    SELECT product.model, product.maker, product.type, 
    laptop.price AS price FROM product 
    INNER JOIN laptop 
    ON product.model=laptop.model 
    UNION 
    SELECT product.model, product.maker, 
    pc.price FROM product INNER JOIN pc 
    ON product.model=pc.model
    UNION
    SELECT product.model, product.maker, 
    printer.price FROM product INNER JOIN printer
    ON product.model=printer.model;

--Consultando os modelos produzidos pelo fabricante 
--B na view criada
SELECT model, price FROM products_prices 
    WHERE maker='B';

-----------------------------------------------------------

--Exercício 6)

SELECT DISTINCT maker AS maker_pc_not_laptop 
FROM product WHERE type='PC' AND
maker NOT IN (SELECT DISTINCT maker
FROM product WHERE type='Laptop');

-----------------------------------------------------------

--Exercício 7)
--Se os laptops têm velocidade menor que as velocidades dos pcs
--então deve ser selecionada a menor velocidade de pc e comparada 
--com as dos laptops

WITH Laptop_speed AS
    (SELECT product.type AS type, product.model AS model, 
    laptop.speed AS laptop_speed, pc.speed AS pc_speed 
    FROM product LEFT JOIN laptop ON product.model=laptop.model 
    LEFT JOIN pc ON product.model=pc.model)
SELECT type, model, laptop_speed FROM Laptop_speed
WHERE laptop_speed<(SELECT min(pc_speed) FROM Laptop_speed);

-----------------------------------------------------------

--Exercício 8)
WITH printer_barata AS
    (SELECT product.maker AS maker, printer.price 
    AS printer_price FROM product INNER JOIN 
    printer ON product.model=printer.model
    WHERE printer.color='y')
SELECT maker AS fornecedor_impressora_mais_barata, 
printer_price AS price FROM printer_barata 
WHERE printer_price IN (SELECT min(printer_price) 
FROM printer_barata);

-----------------------------------------------------------

--Exercício 9)

SELECT maker_model.maker, COUNT(maker_model.model) AS model_count
FROM (
    SELECT product.maker, pc.model FROM product
    INNER JOIN pc ON pc.model = product.model
    GROUP BY pc.model
) AS maker_model
GROUP BY maker_model.maker
HAVING COUNT(maker_model.model) >= 3;

-----------------------------------------------------------

--Exercício 10)
WITH pcs_prices AS
(SELECT product.maker, pc.price FROM 
product INNER JOIN pc ON product.model=pc.model)
SELECT maker, max(price) FROM pcs_prices
GROUP BY maker; 

-----------------------------------------------------------

--Exercício 11)
--Usando a View 'products_prices' criada no exercício 5 
--que contém os preços de todos os produtos
SELECT model FROM products_prices WHERE price 
IN (SELECT max(price) FROM products_prices);

-----------------------------------------------------------

--Exercício 12)

--Criando uma view com os models dos pcs com a menor
--ram e maior velocidade entre os pcs com menor ram.
CREATE VIEW pc_maker AS
(SELECT maker, model FROM product WHERE model IN 
(SELECT model FROM pc WHERE speed IN
(select max(speed) from pc where ram IN 
    (SELECT min(ram) from pc)) AND ram IN 
    (SELECT min(ram) FROM pc)));

--Criando uma view temporária com os fabricantes de
--impressora e fazendo a consulta
WITH printer_maker AS
    (SELECT maker FROM product  
    WHERE model IN (SELECT model FROM pc_maker) 
    OR type='Printer') 
SELECT DISTINCT pc_maker.maker FROM pc_maker 
INNER JOIN printer_maker
ON printer_maker.maker = pc_maker.maker;

