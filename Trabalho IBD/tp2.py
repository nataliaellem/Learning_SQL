# -*- coding: utf-8 -*-
"""tp2.ipynb

Automatically generated by Colaboratory.

Original file is located at
    https://colab.research.google.com/drive/1ACocFRFXhA5iyJsfeQrNIoOGZ1zrzala
"""

import io
import sqlite3
import pandas as pd
from pathlib import Path

# Como os cpf's dos beneficiários não estão completos, ou seja, têm vários x
# para esconder o número, então provavelmente existem cpf's iguais,
# logo, para formar uma coluna de chave primária com estes cpf's, 
# serão usados somente os beneficiários que não possuem cpf's repetidos.
# Portanto, ao ser populada a tabela "BOLSA", serão colocadas apenas as bolsas dos
# beneficiários cujos cpf's não estão repetidos.
# Estas modificações serão feitas usando-se o 'GROUP BY'.

Path('ProuniRelatorio.db').touch()

conn = sqlite3.connect('ProuniRelatorio.db')
c = conn.cursor()

# c.execute('''CREATE TABLE bolsa (ANO_CONCESSAO_BOLSA VARCHAR(50), CODIGO_EMEC_IES_BOLSA VARCHAR(50), NOME_IES_BOLSA VARCHAR(50), 
# MUNICIPIO VARCHAR(50), CAMPUS VARCHAR(50), TIPO_BOLSA VARCHAR(50), MODALIDADE_ENSINO_BOLSA VARCHAR(50), NOME_CURSO_BOLSA VARCHAR(50), 
# NOME_TURNO_CURSO_BOLSA VARCHAR(50), CPF_BENEFICIARIO VARCHAR(50), SEXO_BENEFICIARIO VARCHAR(50), RACA_BENEFICIARIO VARCHAR(50), 
# DATA_NASCIMENTO VARCHAR(50), BENEFICIARIO_DEFICIENTE_FISICO VARCHAR(50), REGIAO_BENEFICIARIO VARCHAR(50), UF_BENEFICIARIO VARCHAR(50), 
# MUNICIPIO_BENEFICIARIO VARCHAR(50))''')

relatorio = pd.read_csv("https://raw.githubusercontent.com/nataliaellem/Learning_SQL/main/ProuniRelatorioDadosAbertos2020.csv", ';')

relatorio.to_sql('relatorio', conn, if_exists='append', index = False)

c.execute('''SELECT * FROM relatorio''').fetchall()

query = """
SELECT * FROM relatorio;
"""

df = pd.read_sql_query(query, conn)
df

# Descrevendo as colunas da tabela 'relatorio'

query = """
PRAGMA table_info([relatorio]);
"""

df = pd.read_sql_query(query, conn)
df

# Listando todas as tabelas do banco de dados

query = """
SELECT 
    name
FROM 
    sqlite_master 
WHERE 
    type ='table' AND 
    name NOT LIKE 'sqlite_%';
"""

df = pd.read_sql_query(query, conn)
df



# Criando a tabela CURSO

c.execute("""
CREATE TABLE IF NOT EXISTS CURSO (
  ID_CURSO INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, NOME_CURSO VARCHAR(100),
  NOME_TURNO_CURSO VARCHAR(50)
);
""")

# Populando a tabela CURSO com dados da tabela relatorio

c.execute("""INSERT INTO CURSO
(NOME_CURSO, NOME_TURNO_CURSO)
SELECT DISTINCT cast(NOME_CURSO_BOLSA as VARCHAR(100)),
cast(NOME_TURNO_CURSO_BOLSA as VARCHAR(50))
FROM relatorio;
""")

# Apaga a tabela CURSO 

c.execute(""" DROP TABLE CURSO;""")

query = """
SELECT * FROM CURSO;
"""
df = pd.read_sql_query(query, conn)
df

# Criando a tabela 'IES'

c.execute("""
    CREATE TABLE IF NOT EXISTS IES (
      ID_IES INTEGER PRIMARY KEY AUTOINCREMENT,
      CODIGO_EMEC_IES INTEGER, NOME_IES VARCHAR(100)
    );
""")

# Populando a tabela IES

c.execute("""
   INSERT INTO IES (
     CODIGO_EMEC_IES, NOME_IES)
   SELECT DISTINCT cast(CODIGO_EMEC_IES_BOLSA as INTEGER),
   cast(NOME_IES_BOLSA as VARCHAR(100)) FROM relatorio; 

""")

# Apaga a tabela IES 

c.execute(""" DROP TABLE IES;""")

query = """
SELECT * FROM IES;
"""
df = pd.read_sql_query(query, conn)
df

# Criando tabela BENEFICIARIO

c.execute("""
  CREATE TABLE IF NOT EXISTS BENEFICIARIO( 
    CPF VARCHAR(40) PRIMARY KEY, SEXO VARCHAR(20), 
    RACA_COR VARCHAR(40), DATA_NASCIMENTO VARCHAR(20),
    DEFICIENTE_FISICO CHAR, MUNICIPIO VARCHAR(50), 
    REGIAO VARCHAR(50), UF VARCHAR(10)
  );  
""")

# Populando tabela BENEFICIARIO 

c.execute("""
    INSERT INTO BENEFICIARIO (
      CPF, SEXO, 
      RACA_COR, DATA_NASCIMENTO,
      DEFICIENTE_FISICO, MUNICIPIO, 
      REGIAO, UF
    )
    SELECT cast(CPF_BENEFICIARIO as VARCHAR(40)),
      cast(SEXO_BENEFICIARIO as VARCHAR(20)), 
      cast(RACA_BENEFICIARIO as VARCHAR(40)),
      cast(DATA_NASCIMENTO as VARCHAR(20)),
      cast(BENEFICIARIO_DEFICIENTE_FISICO as CHAR),
      cast(MUNICIPIO_BENEFICIARIO as VARCHAR(50)),
      cast(REGIAO_BENEFICIARIO as VARCHAR(50)),
      cast(UF_BENEFICIARIO as VARCHAR(10))
    FROM relatorio
    GROUP BY CPF_BENEFICIARIO;
""")

# Apaga a tabela BENEFICIARIO 

c.execute(""" DROP TABLE BENEFICIARIO;""")

query = """
SELECT * FROM BENEFICIARIO;
"""
df = pd.read_sql_query(query, conn)
df

# Criando a tabela do relacionamento BENEFICIARIO-BOLSA 

c.execute("""
   CREATE TABLE IF NOT EXISTS BENEFICIARIO_BOLSA(
     ID_BOLSA INTEGER NOT NULL, CPF_BENEFICIARIO VARCHAR(40)
   ); 
""")

c.execute("""
  INSERT INTO BENEFICIARIO_BOLSA(
    ID_BOLSA, CPF_BENEFICIARIO
  )
  SELECT bo.ID_BOLSA, be.CPF 
  FROM BENEFICIARIO be JOIN BOLSA bo 
  ON be.CPF = bo.CPF_BENEFICIARIO
    
""")

query = """
SELECT * FROM BENEFICIARIO_BOLSA;
"""
df = pd.read_sql_query(query, conn)
df

# Criando e inserindo os valores na coluna 'ID_CURSO' da 
# tabela BOLSA

c.execute("""
  ALTER TABLE BOLSA ADD COLUMN ID_CURSO INTEGER;
""")

c.execute("""
  INSERT INTO BOLSA (
    ID_CURSO
  )
  SELECT c.ID_CURSO 
  FROM BOLSA b JOIN relatorio r 
  ON cast(r.CPF_BENEFICIARIO as VARCHAR(40)) = b.CPF_BENEFICIARIO
  JOIN CURSO c ON c.NOME_CURSO = r.NOME_CURSO_BOLSA; 
""")

# Criando a tabela 'BOLSA'

c.execute("""
CREATE TABLE IF NOT EXISTS BOLSA (
  ID_BOLSA INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, 
  ANO_CONCESSAO_BOLSA INTEGER, TIPO_DE_BOLSA VARCHAR(50), 
  MODALIDADE_ENSINO_BOLSA VARCHAR(50),
  CPF_BENEFICIARIO VARCHAR(40), ID_CURSO INTEGER
);
""")

# Passando algumas informações da tabela relatorio, que foi obtida do site do governo,
# para a tabela correspondente à entidade 'BOLSA'

c.execute("""INSERT INTO BOLSA (
  ANO_CONCESSAO_BOLSA,
  TIPO_DE_BOLSA,
  MODALIDADE_ENSINO_BOLSA,
  CPF_BENEFICIARIO,
  ID_CURSO
)
SELECT DISTINCT
  cast(r.ANO_CONCESSAO_BOLSA as INTEGER),
  cast(r.TIPO_BOLSA as VARCHAR(50)),
  cast(r.MODALIDADE_ENSINO_BOLSA as VARCHAR(50)),
  cast(ID_IES),
  cast(r.CPF_BENEFICIARIO as VARCHAR(40)),
  cast(c.ID_CURSO as INTEGER)
FROM relatorio r
JOIN CURSO c ON r.NOME_CURSO_BOLSA = c.NOME_CURSO AND r.NOME_TURNO_CURSO_BOLSA = c.NOME_TURNO_CURSO;
""")

# Exclui a tabela BOLSA

c.execute(""" DROP TABLE BOLSA;""")

query = """
PRAGMA table_info([BOLSA]);
"""

df = pd.read_sql_query(query, conn)
df

query = """
SELECT * FROM BOLSA;
"""
df = pd.read_sql_query(query, conn)
df