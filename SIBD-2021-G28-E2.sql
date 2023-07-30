-- ----------------------------------------------------------------------------
-- SIBD, 2020-2021
-- Etapa 2
-- Alexandre Rodrigues, Nº 54472
-- ----------------------------------------------------------------------------

DROP TABLE teste;
DROP TABLE internado_desde;
DROP TABLE sintoma;
DROP TABLE utente CASCADE CONSTRAINTS;
DROP TABLE medico CASCADE CONSTRAINTS;
DROP TABLE laboratorio CASCADE CONSTRAINTS;
DROP TABLE hospital CASCADE CONSTRAINTS;
DROP TABLE instituicao_saude CASCADE CONSTRAINTS;
DROP TABLE em_contacto;
DROP TABLE data CASCADE CONSTRAINTS;
DROP TABLE local CASCADE CONSTRAINTS;
DROP TABLE pessoa CASCADE CONSTRAINTS;

-- ----------------------------------------------------------------------------

ALTER SESSION SET NLS_DATE_FORMAT = 'DD.MM.YYYY';

-- ----------------------------------------------------------------------------

CREATE TABLE pessoa (
    nif                     NUMBER(9),
    nome                    CHAR(35)        CONSTRAINT nn_pessoa_nome               NOT NULL,
    sexo                    CHAR(1)         CONSTRAINT nn_pessoa_sexo               NOT NULL,
    data_nascimento         DATE            CONSTRAINT nn_pessoa_data_nascimento    NOT NULL,
    telemovel               NUMBER(9),
    correio_eletronico      CHAR(35),
--
    CONSTRAINT pk_pessoa
        PRIMARY KEY (nif),
--    
    CONSTRAINT ck_pessoa_nif
        CHECK (nif > 0),
--
    CONSTRAINT ck_pessoa_telemovel
        CHECK (telemovel > 0),
--
    CONSTRAINT ck_pessoa_sexo
        CHECK (sexo IN ('M', 'F'))
--
);

CREATE TABLE local (
    coordenadas_gps         CHAR(20),  
    localidade              CHAR(30)        CONSTRAINT nn_local_localidade          NOT NULL,
    rua                     CHAR(40)        CONSTRAINT nn_local_rua                 NOT NULL,
    numero_porta            NUMBER(3)       CONSTRAINT nn_local_numero_porta        NOT NULL,
    codigo_postal           CHAR(8)         CONSTRAINT nn_local_codigo_postal       NOT NULL,
--
    CONSTRAINT pk_local
        PRIMARY KEY (coordenadas_gps),
--
    CONSTRAINT ck_local_n_porta         
        CHECK (numero_porta > 0)
--    
);

CREATE TABLE data (
    data_inicio             DATE,
    pessoa                  CONSTRAINT nn_data_inicio_pessoa NOT NULL,
--
    CONSTRAINT pk_data
        PRIMARY KEY (data_inicio),
--
    CONSTRAINT fk_data_pessoa
        FOREIGN KEY (pessoa)
        REFERENCES pessoa (nif)
--
); 

CREATE TABLE em_contacto (
    primeira_pessoa         CONSTRAINT nn_contacto_pessoa1  NOT NULL,
    segunda_pessoa          CONSTRAINT nn_contacto_pessoa2  NOT NULL,
    data_contacto           CONSTRAINT nn_contacto_data     NOT NULL,
    coordenadas_gps         CONSTRAINT nn_contacto_local    NOT NULL,
--
    CONSTRAINT pk_em_contacto
        PRIMARY KEY (primeira_pessoa, segunda_pessoa, data_contacto, coordenadas_gps),
--
    CONSTRAINT fk_primeira_pessoa
        FOREIGN KEY (primeira_pessoa)
        REFERENCES pessoa (nif)
        ON DELETE CASCADE,
--
    CONSTRAINT fk_segunda_pessoa
        FOREIGN KEY (segunda_pessoa)
        REFERENCES pessoa (nif)
        ON DELETE CASCADE,
--
    CONSTRAINT fk_contacto_data
        FOREIGN KEY (data_contacto)
        REFERENCES data (data_inicio),
--
    CONSTRAINT fk_contacto_gps
        FOREIGN KEY (coordenadas_gps)
        REFERENCES local (coordenadas_gps),
--
    CONSTRAINT ck_ria_1_
        CHECK (nif_primeira_pessoa <> nif_segunda_pessoa)
--    
);
--
-- RIA 1 -> Não se pode registar um contacto de uma pessoa consigo propria
--

CREATE TABLE instituicao_saude (
    nome                   CHAR(50),
    telefone               NUMBER(9)        CONSTRAINT nn_instituicao_telefone        NOT NULL,
--
    CONSTRAINT pk_instituicao_saude
        PRIMARY KEY (nome),
--
    CONSTRAINT ck_instituicao_telefone
        CHECK (telefone > 0),
--
    CONSTRAINT un_ria_11
        UNIQUE (telefone)
--
);
--
-- RIA 11 -> Não pode haver duas instituições de saúde com o mesmo número de telefone.
--

CREATE TABLE hospital (
    nome,
    numero_camas           NUMBER(4)        CONSTRAINT nn_hospital_numero_camas         NOT NULL,
--
    CONSTRAINT pk_hospital
        PRIMARY KEY (nome),
--
    CONSTRAINT fk_hospital_nome
        FOREIGN KEY (nome)
        REFERENCES instituicao_saude (nome)
        ON DELETE CASCADE
-- 
);

CREATE TABLE laboratorio (
    nome,
    licenca_funcionamento   NUMBER(10)      CONSTRAINT nn_laboratorio_licenca           NOT NULL,
--
    CONSTRAINT pk_laboratorio
        PRIMARY KEY (nome),
--
    CONSTRAINT fk_laboratorio_nome
        FOREIGN KEY (nome)
        REFERENCES instituicao_saude (nome),
--
    CONSTRAINT un_ria_14
        UNIQUE (licenca_funcionamento),
--
    CONSTRAINT ck_laboratorio_licenca
        CHECK (licenca_funcionamento > 0)
--
);
--
-- RIA 14 -> Não pode haver dois laboratórios com o mesmo número de licença de funcionamento.
--

CREATE TABLE medico (
    nif,
    cedula                   NUMBER(15)      CONSTRAINT nn_medico_cedula                    NOT NULL,
--    
    CONSTRAINT pk_medico
        PRIMARY KEY (nif),
--
    CONSTRAINT fk_medico_pessoa
        FOREIGN KEY (nif)
        REFERENCES pessoa(nif),
--
    CONSTRAINT un_ria_12 
        UNIQUE (cedula),
--
    CONSTRAINT ck_medico_nif
        CHECK (nif > 0),
--
    CONSTRAINT ck_medico_cedula  
        CHECK (cedula > 0)
--            
);
--
-- RIA 12 -> Não pode haver dois médicos com a mesma cédula profissional.
--

CREATE TABLE utente (
    nif,
    numero_sns               NUMBER(15)      CONSTRAINT nn_utente_numero_sns                    NOT NULL,
--
    CONSTRAINT pk_utente
        PRIMARY KEY (nif),
--
    CONSTRAINT fk_utente_nif
        FOREIGN KEY (nif)
        REFERENCES pessoa (nif),
--
    CONSTRAINT un_ria_13  
        UNIQUE (numero_sns),
--        
    CONSTRAINT ck_utente_nif
        CHECK (nif > 0),
--
    CONSTRAINT ck_utente_numero_sns
        CHECK (numero_sns > 0)
--            
);
--
-- RIA 13 -> Não pode haver dois utentes com o mesmo número de SNS.
--
CREATE TABLE sintoma (
    nome_sintoma                CHAR(15),
    pessoa,
--
    CONSTRAINT pk_sintoma
        PRIMARY KEY (nome_sintoma),
--
    CONSTRAINT fk_sintoma_pessoa
        FOREIGN KEY (pessoa)
        REFERENCES pessoa (nif)
        ON DELETE CASCADE
--
);

CREATE TABLE internado_desde (
    hospital,
    utente,
    sintoma,
    data_inicio,
    data_fim_internamento       DATE        CONSTRAINT nn_data_fim_internamento     NOT NULL,
    gravidade_clinica           CHAR(10),
--
    CONSTRAINT pk_internado_desde
        PRIMARY KEY (hospital, data_inicio, sintoma, utente),
--
    CONSTRAINT fk_internamento_hospital
        FOREIGN KEY (hospital)
        REFERENCES hospital (nome),
--
    CONSTRAINT fk_internamento_utente
        FOREIGN KEY (utente)
        REFERENCES utente (nif),
--
    CONSTRAINT fk_internamento_sintoma
        FOREIGN KEY (sintoma)
        REFERENCES sintoma (nome_sintoma),
--
    CONSTRAINT fk_internamento_data_inicio
        FOREIGN KEY (data_inicio)
        REFERENCES  data (data_inicio),
--
    CONSTRAINT ck_ria_4
        CHECK (data_fim_internamento > data_inicio)
--        
);
--
-- RIA 4 -> A data de fim de um internamento tem de ser posterior à data de início.
--

CREATE TABLE teste (
    numero_processo             NUMBER(10),
    data_colheita               DATE            CONSTRAINT nn_teste_data_colheita       NOT NULL,
    tipo_amostra                CHAR(15)        CONSTRAINT nn_teste_tipo_amostra        NOT NULL,
    resultado                   CHAR(10)        CONSTRAINT nn_teste_resultado           NOT NULL,
    instituicao_saude                           CONSTRAINT nn_teste_instituicao_saude   NOT NULL,
    medico                                      CONSTRAINT nn_teste_medico              NOT NULL,
    utente                                      CONSTRAINT nn_teste_utente              NOT NULL,
--
    CONSTRAINT pk_teste
        PRIMARY KEY (numero_processo, utente),
--
    CONSTRAINT fk_teste_instituicao_saude
        FOREIGN KEY (instituicao_saude)
        REFERENCES instituicao_saude(nome),
--
    CONSTRAINT fk_teste_medico
        FOREIGN KEY (medico)
        REFERENCES medico(nif),
--
    CONSTRAINT fk_teste_utente
        FOREIGN KEY (utente)
        REFERENCES utente(nif),
--
    CONSTRAINT ck_ria_15
        CHECK (medico <> utente)
--        
);
--
-- RIA 15 -> O médico responsável por um teste não pode ser o utente que fez esse teste.
--

-- ----------------------------------------------------------------------------
-- Restrições de Integridade Adicionais:

-- RIA 6 -> A data de início de um internamento tem de ser posterior à data de nascimento do utente. (Restrição Não Suportado)

-- RIA 7 -> A data da colheita de um teste tem de ser posterior à data de nascimento do utente. (Restrição Não Suportado)

-- RIA 8 -> Num dado momento, o número de utentes internados num hospital tem de ser inferior ou
-- igual ao número de camas desse hospital. (Restrição Não Suportado)

-- RIA 9 -> Médico OVERLAPS Utente.

-- RIA 10 -> Hospital AND Laboratório COVER Instituição de Saúde.

-- RIA 16 -> Um teste só pode ter resultado depois de atribuído o médico responsável. (Restrição Não Suportado)
-- ----------------------------------------------------------------------------
INSERT INTO pessoa (nif, nome, sexo, data_nascimento)
     VALUES (123456789, 'Pessoa Um', 'M', '01.01.1975');

INSERT INTO pessoa (nif, nome, sexo, data_nascimento)
     VALUES (987654321, 'Pessoa Dois', 'F', '02.01.1974');
-- -----
INSERT INTO local (coordenadas_gps, localidade, rua, numero_porta, codigo_postal)
     VALUES ('38.736946, -9.142685', 'Lisboa', 'Rua de lisboa', 77, '2000-200');
-- -----
INSERT INTO data (data_inicio, pessoa)
     VALUES ('20.10.2020', 987654321);
-- -----
INSERT INTO em_contacto (nif_primeira_pessoa, nif_segunda_pessoa, data_contacto, coordenadas_gps)
     VALUES (123456789, 987654321, '20.10.2020', '38.736946, -9.142685');

INSERT INTO instituicao_saude (nome, telefone)
     VALUES ('hospital santa maria', 987654321);

INSERT INTO instituicao_saude (nome, telefone)
     VALUES ('laboratório germano de sousa', 912345678);     
-- -----
INSERT INTO hospital (nome, numero_camas)
     VALUES ('hospital santa maria', 500);
-- -----
INSERT INTO  (nome, licenca_funcionamento)
     VALUES ('laboratório germano de sousa', 1546532168);
-- -----
INSERT INTO pessoa (nif, nome, sexo, data_nascimento)
     VALUES (147852369, 'El Medico', 'M', '10.05.1960');
-- -----
INSERT INTO medico (nif, cedula)
     VALUES (147852369, 078420420159753);

INSERT INTO utente (nif, numero_sns)
     VALUES (987654321, 159873526841397);

INSERT INTO sintoma (nome_sintoma, pessoa)
     VALUES ('Muita Tosse', 987654321);

INSERT INTO internado_desde (hospital, utente, sintoma, data_inicio, data_fim_internamento, gravidade_clinica)
     VALUES ('hospital santa maria', 987654321, 'Muita Tosse', '20.10.2020', '15.01.2021', 'Alta');

INSERT INTO teste (numero_processo, data_colheita, tipo_amostra, resultado, instituicao_saude, medico, utente)
     VALUES (1002336841, '22.10.2020', 'nasofaríngeo', 'Negativo', 'hospital santa maria', 147852369, 987654321);     

