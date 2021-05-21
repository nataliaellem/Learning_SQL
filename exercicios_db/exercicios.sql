--Nome: Natália Ellem Moreira
--Matrícula: 2020955215
--Turma: Subsequente módulo 2
--Lista 5 BD

---------------------------- EXERCÍCIO 1 ------------------------------------------------

--Abaixo estão as queries do arquivo gerado pelo MysqlWorkbench referantes ao exercício 1.

------------------------------------------------------------------------------------------

-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema EstudanteDisciplina
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema EstudanteDisciplina
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `EstudanteDisciplina` ;
USE `EstudanteDisciplina` ;

-- -----------------------------------------------------
-- Table `EstudanteDisciplina`.`Estudante`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `EstudanteDisciplina`.`Estudante` (
  `CPF` INT NOT NULL,
  `Nome` VARCHAR(45) NULL,
  `NumMatricula` CHAR(11) NULL,
  PRIMARY KEY (`CPF`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `EstudanteDisciplina`.`Telefone`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `EstudanteDisciplina`.`Telefone` (
  `idTelefone` INT NOT NULL,
  `Telefone` VARCHAR(45) NULL,
  `Estudante_CPF` INT NOT NULL,
  PRIMARY KEY (`idTelefone`, `Estudante_CPF`),
  INDEX `fk_Telefone_Estudante1_idx` (`Estudante_CPF` ASC),
  CONSTRAINT `fk_Telefone_Estudante1`
    FOREIGN KEY (`Estudante_CPF`)
    REFERENCES `EstudanteDisciplina`.`Estudante` (`CPF`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `EstudanteDisciplina`.`Disciplina`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `EstudanteDisciplina`.`Disciplina` (
  `idDisciplina` INT NOT NULL,
  `Nome` VARCHAR(45) NULL,
  `DepID` INT NULL,
  PRIMARY KEY (`idDisciplina`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `EstudanteDisciplina`.`Estudante_has_Disciplina`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `EstudanteDisciplina`.`Estudante_has_Disciplina` (
  `Estudante_CPF` INT NOT NULL,
  `Disciplina_idDisciplina` INT NOT NULL,
  PRIMARY KEY (`Estudante_CPF`, `Disciplina_idDisciplina`),
  INDEX `fk_Estudante_has_Disciplina_Disciplina1_idx` (`Disciplina_idDisciplina` ASC),
  INDEX `fk_Estudante_has_Disciplina_Estudante_idx` (`Estudante_CPF` ASC),
  CONSTRAINT `fk_Estudante_has_Disciplina_Estudante`
    FOREIGN KEY (`Estudante_CPF`)
    REFERENCES `EstudanteDisciplina`.`Estudante` (`CPF`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Estudante_has_Disciplina_Disciplina1`
    FOREIGN KEY (`Disciplina_idDisciplina`)
    REFERENCES `EstudanteDisciplina`.`Disciplina` (`idDisciplina`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;



SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

------------------------------------------------------------------------------------------

--Inserindo dados para testar o banco criado

INSERT INTO Estudante 
    VALUES (123, 'Anne', 1010),
    (234, 'Gilbert', 2020),
    (345, 'Daiana', 3030);

INSERT INTO Disciplina 
  VALUES (10, 'Introdução a banco de Dados', 100),
  (11, 'Aeds', 101),
  (12, 'Matemática Discreta', 102),
  (13, 'POO', 103),
  (14, 'ILC', 104);

INSERT INTO Telefone 
  VALUES (1, '9999-9999', 123),
  (2, '9999-8888', 123),
  (3, '8888-8888', 234),
  (4, '7777-9999', 234),
  (5, '5555-5555', 345);

INSERT INTO Estudante_has_Disciplina
  VALUES (123, 11),
  (234, 11),
  (345, 11),
  (123, 10),
  (234, 10),
  (123, 12),
  (234, 12),
  (345, 14),
  (123, 14);
  (234, 13);


------------------------------------------------------------------------------------------

---------------------------- EXERCÍCIO 2 ------------------------------

-- 1. Sim, é possível criar um banco de dados a partir dessa estrutura, sem criar os relacionamentos.
-- 2. Isso causa um problema, pois quando for necessário fazer queries que dependem de duas tabelas diferentes,
-- dependendo da complexidade do banco de dados, haverá uma grande dificuldade em descobrir os relacionamentos,
-- o que dificulta o processo, pois o conhecimento destes relacionamentos é necessário para fazer queries que 
-- dependem de mais de uma tabela.
-- 3. Caso o modelo de database seja feito como na figura 6, o arquivo gerado pelo Mysql Workbench está abaixo:

-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema EstudanteDisciplina
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema EstudanteDisciplina
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `EstudanteDisciplina` ;
USE `EstudanteDisciplina` ;


-- -----------------------------------------------------
-- Table `EstudanteDisciplina`.`Estudante`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `EstudanteDisciplina`.`Estudante` (
  `CPF` INT NOT NULL,
  `Nome` VARCHAR(45) NULL,
  `NumMatricula` VARCHAR(11) NULL,
  PRIMARY KEY (`CPF`))
ENGINE = MRG_MyISAM;


-- -----------------------------------------------------
-- Table `EstudanteDisciplina`.`Disciplina`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `EstudanteDisciplina`.`Disciplina` (
  `idDisciplina` INT NOT NULL,
  `Nome` VARCHAR(45) NULL,
  `DepID` INT NULL,
  PRIMARY KEY (`idDisciplina`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `EstudanteDisciplina`.`Telefone`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `EstudanteDisciplina`.`Telefone` (
  `idTelefone` INT NOT NULL,
  `Estudante_CPF` INT NOT NULL,
  `Telefone` VARCHAR(45) NULL,
  PRIMARY KEY (`idTelefone`, `Estudante_CPF`))
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;


------------------------------------------------------------------------------------------

--------------------------- EXERCÍCIO 4 --------------------------------

-- Modelo físico do banco de dados com a entidade adicional 'Departamento'.
 

-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema EstudanteDisciplina
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema EstudanteDisciplina
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `EstudanteDisciplina` ;
USE `EstudanteDisciplina` ;

-- -----------------------------------------------------
-- Table `EstudanteDisciplina`.`table1`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `EstudanteDisciplina`.`table1` (
)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `EstudanteDisciplina`.`Estudante`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `EstudanteDisciplina`.`Estudante` (
  `CPF` INT NOT NULL,
  `Nome` VARCHAR(45) NULL,
  `NumMatricula` VARCHAR(11) NULL,
  PRIMARY KEY (`CPF`))
ENGINE = MRG_MyISAM;


-- -----------------------------------------------------
-- Table `EstudanteDisciplina`.`Departamento`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `EstudanteDisciplina`.`Departamento` (
  `idDisciplina` INT NOT NULL,
  `idDepartamento` INT NOT NULL,
  `NomeDepartamento` VARCHAR(45) NULL,
  PRIMARY KEY (`idDisciplina`, `idDepartamento`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `EstudanteDisciplina`.`Disciplina`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `EstudanteDisciplina`.`Disciplina` (
  `idDisciplina` INT NOT NULL,
  `Nome` VARCHAR(45) NULL,
  `DepID` INT NULL,
  `Departamento_idDisciplina` INT NOT NULL,
  `Departamento_idDepartamento` INT NOT NULL,
  PRIMARY KEY (`idDisciplina`, `Departamento_idDisciplina`, `Departamento_idDepartamento`),
  INDEX `fk_Disciplina_Departamento1_idx` (`Departamento_idDisciplina` ASC, `Departamento_idDepartamento` ASC) VISIBLE,
  CONSTRAINT `fk_Disciplina_Departamento1`
    FOREIGN KEY (`Departamento_idDisciplina` , `Departamento_idDepartamento`)
    REFERENCES `EstudanteDisciplina`.`Departamento` (`idDisciplina` , `idDepartamento`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `EstudanteDisciplina`.`Telefone`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `EstudanteDisciplina`.`Telefone` (
  `idTelefone` INT NOT NULL,
  `Estudante_CPF` INT NOT NULL,
  `Telefone` VARCHAR(45) NULL,
  `Estudante_CPF1` INT NOT NULL,
  PRIMARY KEY (`idTelefone`, `Estudante_CPF`, `Estudante_CPF1`),
  INDEX `fk_Telefone_Estudante1_idx` (`Estudante_CPF1` ASC) VISIBLE,
  CONSTRAINT `fk_Telefone_Estudante1`
    FOREIGN KEY (`Estudante_CPF1`)
    REFERENCES `EstudanteDisciplina`.`Estudante` (`CPF`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `EstudanteDisciplina`.`Estudante_has_Disciplina`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `EstudanteDisciplina`.`Estudante_has_Disciplina` (
  `Estudante_CPF` INT NOT NULL,
  `Disciplina_idDisciplina` INT NOT NULL,
  PRIMARY KEY (`Estudante_CPF`, `Disciplina_idDisciplina`),
  INDEX `fk_Estudante_has_Disciplina_Disciplina1_idx` (`Disciplina_idDisciplina` ASC) VISIBLE,
  INDEX `fk_Estudante_has_Disciplina_Estudante_idx` (`Estudante_CPF` ASC) VISIBLE,
  CONSTRAINT `fk_Estudante_has_Disciplina_Estudante`
    FOREIGN KEY (`Estudante_CPF`)
    REFERENCES `EstudanteDisciplina`.`Estudante` (`CPF`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Estudante_has_Disciplina_Disciplina1`
    FOREIGN KEY (`Disciplina_idDisciplina`)
    REFERENCES `EstudanteDisciplina`.`Disciplina` (`idDisciplina`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;



------------------------------------------------------------------------------------------

--------------------------- EXERCÍCIO 5 --------------------------------

-- Criação do banco de dados a partir do comando "forward engineer" do mysql workbench gera o seguinte comando:


-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema EstudanteDisciplina
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema EstudanteDisciplina
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `EstudanteDisciplina` ;
USE `EstudanteDisciplina` ;

-- -----------------------------------------------------
-- Table `EstudanteDisciplina`.`table1`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `EstudanteDisciplina`.`table1` (
)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `EstudanteDisciplina`.`Desempenho_Trimestral`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `EstudanteDisciplina`.`Desempenho_Trimestral` (
  `idTrimestre` INT NOT NULL,
  `idEstudante` INT NOT NULL,
  `Desempenho` VARCHAR(45) NULL,
  PRIMARY KEY (`idTrimestre`, `idEstudante`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `EstudanteDisciplina`.`Estudante`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `EstudanteDisciplina`.`Estudante` (
  `idEstudante` INT NOT NULL,
  `Nome` VARCHAR(45) NULL,
  `Ano_letivo` VARCHAR(45) NULL,
  `Responsáveis` VARCHAR(45) NULL,
  `Idade` INT NULL,
  `Escola_anterior` VARCHAR(45) NULL,
  `Desempenho_Trimestral_idTrimestre` INT NOT NULL,
  `Desempenho_Trimestral_idEstudante` INT NOT NULL,
  PRIMARY KEY (`idEstudante`, `Desempenho_Trimestral_idTrimestre`, `Desempenho_Trimestral_idEstudante`),
  INDEX `fk_Estudante_Desempenho_Trimestral1_idx` (`Desempenho_Trimestral_idTrimestre` ASC, `Desempenho_Trimestral_idEstudante` ASC) VISIBLE)
ENGINE = MRG_MyISAM;


-- -----------------------------------------------------
-- Table `EstudanteDisciplina`.`Disciplina`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `EstudanteDisciplina`.`Disciplina` (
  `idDisciplina` INT NOT NULL,
  `Nome` VARCHAR(45) NULL,
  `Carga_horária` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`idDisciplina`, `Carga_horária`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `EstudanteDisciplina`.`Endereço`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `EstudanteDisciplina`.`Endereço` (
  `idEstudante` INT NOT NULL,
  `Rua` VARCHAR(45) NULL,
  `Número` INT NULL,
  `Complemento` VARCHAR(45) NULL,
  `Cidade` VARCHAR(45) NULL,
  `Estado` VARCHAR(45) NULL,
  `País` VARCHAR(45) NULL,
  `Cep` VARCHAR(45) NULL,
  `Estudante_idEstudante` INT NOT NULL,
  PRIMARY KEY (`idEstudante`, `Estudante_idEstudante`),
  INDEX `fk_Endereço_Estudante1_idx` (`Estudante_idEstudante` ASC) VISIBLE,
  CONSTRAINT `fk_Endereço_Estudante1`
    FOREIGN KEY (`Estudante_idEstudante`)
    REFERENCES `EstudanteDisciplina`.`Estudante` (`idEstudante`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `EstudanteDisciplina`.`Disciplina_em_curso`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `EstudanteDisciplina`.`Disciplina_em_curso` (
  `Estudante_CPF` INT NOT NULL,
  `Disciplina_idDisciplina` INT NOT NULL,
  PRIMARY KEY (`Estudante_CPF`, `Disciplina_idDisciplina`),
  INDEX `fk_Estudante_has_Disciplina_Disciplina1_idx` (`Disciplina_idDisciplina` ASC) VISIBLE,
  INDEX `fk_Estudante_has_Disciplina_Estudante_idx` (`Estudante_CPF` ASC) VISIBLE,
  CONSTRAINT `fk_Estudante_has_Disciplina_Estudante`
    FOREIGN KEY (`Estudante_CPF`)
    REFERENCES `EstudanteDisciplina`.`Estudante` (`idEstudante`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Estudante_has_Disciplina_Disciplina1`
    FOREIGN KEY (`Disciplina_idDisciplina`)
    REFERENCES `EstudanteDisciplina`.`Disciplina` (`idDisciplina`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `EstudanteDisciplina`.`Disciplinas_cursadas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `EstudanteDisciplina`.`Disciplinas_cursadas` (
  `Estudante_CPF` INT NOT NULL,
  `Disciplina_idDisciplina` INT NOT NULL,
  PRIMARY KEY (`Estudante_CPF`, `Disciplina_idDisciplina`),
  INDEX `fk_Estudante_has_Disciplina_Disciplina2_idx` (`Disciplina_idDisciplina` ASC) VISIBLE,
  INDEX `fk_Estudante_has_Disciplina_Estudante1_idx` (`Estudante_CPF` ASC) VISIBLE)
ENGINE = MRG_MyISAM;


-- -----------------------------------------------------
-- Table `EstudanteDisciplina`.`Ocorrencias`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `EstudanteDisciplina`.`Ocorrencias` (
  `idEstudante` INT NOT NULL,
  `Descricao_ocorrencia` VARCHAR(45) NULL,
  `Estudante_idEstudante` INT NOT NULL,
  PRIMARY KEY (`idEstudante`, `Estudante_idEstudante`),
  INDEX `fk_Ocorrencias_Estudante1_idx` (`Estudante_idEstudante` ASC) VISIBLE,
  CONSTRAINT `fk_Ocorrencias_Estudante1`
    FOREIGN KEY (`Estudante_idEstudante`)
    REFERENCES `EstudanteDisciplina`.`Estudante` (`idEstudante`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `EstudanteDisciplina`.`Notas_e_frequencias_dos_estudante_por_disciplina`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `EstudanteDisciplina`.`Notas_e_frequencias_dos_estudante_por_disciplina` (
  `idEstudante` INT NOT NULL,
  `idDisciplina` INT NOT NULL,
  PRIMARY KEY (`idEstudante`, `idDisciplina`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `EstudanteDisciplina`.`Notas_e_frequencias_has_Disciplina_em_curso`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `EstudanteDisciplina`.`Notas_e_frequencias_has_Disciplina_em_curso` (
  `Notas_e_frequencias_idEstudante` INT NOT NULL,
  `Notas_e_frequencias_idDisciplina` INT NOT NULL,
  `Disciplina_em_curso_Estudante_CPF` INT NOT NULL,
  `Disciplina_em_curso_Disciplina_idDisciplina` INT NOT NULL,
  PRIMARY KEY (`Notas_e_frequencias_idEstudante`, `Notas_e_frequencias_idDisciplina`, `Disciplina_em_curso_Estudante_CPF`, `Disciplina_em_curso_Disciplina_idDisciplina`),
  INDEX `fk_Notas_e_frequencias_has_Disciplina_em_curso_Disciplina_e_idx` (`Disciplina_em_curso_Estudante_CPF` ASC, `Disciplina_em_curso_Disciplina_idDisciplina` ASC) VISIBLE,
  INDEX `fk_Notas_e_frequencias_has_Disciplina_em_curso_Notas_e_freq_idx` (`Notas_e_frequencias_idEstudante` ASC, `Notas_e_frequencias_idDisciplina` ASC) VISIBLE,
  CONSTRAINT `fk_Notas_e_frequencias_has_Disciplina_em_curso_Notas_e_freque1`
    FOREIGN KEY (`Notas_e_frequencias_idEstudante` , `Notas_e_frequencias_idDisciplina`)
    REFERENCES `EstudanteDisciplina`.`Notas_e_frequencias_dos_estudante_por_disciplina` (`idEstudante` , `idDisciplina`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Notas_e_frequencias_has_Disciplina_em_curso_Disciplina_em_1`
    FOREIGN KEY (`Disciplina_em_curso_Estudante_CPF` , `Disciplina_em_curso_Disciplina_idDisciplina`)
    REFERENCES `EstudanteDisciplina`.`Disciplina_em_curso` (`Estudante_CPF` , `Disciplina_idDisciplina`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

