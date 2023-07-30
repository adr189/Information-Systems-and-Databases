-- ----------------------------------------------------------------------------
DROP TABLE com;
DROP TABLE internamento;
DROP TABLE hospital;
DROP TABLE utente;

-- ----------------------------------------------------------------------------
CREATE TABLE utente (
numero      NUMBER (9), -- Número de utente do SNS.
nome        VARCHAR (35)    CONSTRAINT nn_utente_nome NOT NULL,
sexo        CHAR (1)        CONSTRAINT nn_utente_sexo NOT NULL,
nascimento  DATE            CONSTRAINT nn_utente_nascimento NOT NULL,
localidade  VARCHAR (35)    CONSTRAINT nn_utente_localidade NOT NULL,
--
CONSTRAINT pk_utente
PRIMARY KEY (numero),
--
CONSTRAINT ck_utente_numero
CHECK (numero > 0),
--
CONSTRAINT ck_utente_sexo
CHECK (UPPER(sexo) IN ('F', 'M')),
--
CONSTRAINT ck_utente_nascimento
CHECK (TO_CHAR(nascimento, 'YYYY') > 1900) -- 'YYYY' é o ano da data.
);
-- ----------------------------------------------------------------------------
CREATE TABLE hospital (
nome                VARCHAR (35),
localidade          VARCHAR (35)    CONSTRAINT nn_hospital_localidade NOT NULL,
camas               NUMBER (4)      CONSTRAINT nn_hospital_camas NOT NULL,
--
CONSTRAINT pk_hospital
PRIMARY KEY (nome),
--
CONSTRAINT ck_hospital_camas
CHECK (camas > 0)
);
-- ----------------------------------------------------------------------------

CREATE TABLE internamento (
utente,
hospital,
desde   DATE,
ate     DATE, -- Se não estiver preenchido, o utente ainda está internado.
--
CONSTRAINT pk_internamento
PRIMARY KEY (utente, hospital, desde),
--
CONSTRAINT fk_internamento_utente
FOREIGN KEY (utente)
REFERENCES utente (numero),
--
CONSTRAINT fk_internamento_hospital
FOREIGN KEY (hospital)
REFERENCES hospital (nome),
--
CONSTRAINT ck_internamento_periodo
CHECK ((desde < ate) OR (ate IS NULL))
);
-- ----------------------------------------------------------------------------
CREATE TABLE com (
utente,
hospital,
desde,
sintoma VARCHAR (35), -- Ex. tosse.
--
CONSTRAINT pk_com
PRIMARY KEY (utente, hospital, desde, sintoma),
--
CONSTRAINT fk_com_internamento
FOREIGN KEY (utente, hospital, desde)
REFERENCES internamento (utente, hospital, desde)
);
-- ----------------------------------------------------------------------------

INSERT INTO hospital (nome, localidade, camas)
    VALUES ('hospital santa maria', 'Lisboa', 500);

INSERT INTO hospital (nome, localidade, camas)
    VALUES ('hospital francisco xavier', 'Sintra', 1234);

INSERT INTO hospital (nome, localidade, camas)
    VALUES ('hospital de castelo branco', 'Castelo Branco', 4321);

INSERT INTO hospital (nome, localidade, camas)
    VALUES ('hospital do porto', 'Porto', 5000);

INSERT INTO utente (numero, nome, sexo, nascimento, localidade)
    VALUES (010100101, 'Gonçalo Nunes', 'M', '03.03.2001', 'Lisboa');

INSERT INTO utente (numero, nome, sexo, nascimento, localidade)
    VALUES (010100102, 'Maria Nunes', 'F', '03.03.1970', 'Lisboa');

INSERT INTO utente (numero, nome, sexo, nascimento, localidade)
    VALUES (010100103, 'Alfredo Nunes', 'M', '03.03.1971', 'Lisboa');

INSERT INTO utente (numero, nome, sexo, nascimento, localidade)
    VALUES (010100104, 'Ana Nunes', 'F', '03.03.2005', 'Lisboa');

INSERT INTO utente (numero, nome, sexo, nascimento, localidade)
    VALUES (123456789, 'Bruno', 'M', '14.10.2000', 'Sintra');

INSERT INTO utente (numero, nome, sexo, nascimento, localidade)
    VALUES (987654321, 'Alexandra', 'F', '15.11.2000', 'Lisboa');

INSERT INTO utente (numero, nome, sexo, nascimento, localidade)
    VALUES (147258369, 'Boskovich', 'M', '16.12.2000', 'Lisboa');

INSERT INTO utente (numero, nome, sexo, nascimento, localidade)
    VALUES (963852741, 'Carol', 'F', '17.01.2001', 'Lisboa');

INSERT INTO utente (numero, nome, sexo, nascimento, localidade)
    VALUES (159753280, 'DD', 'M', '18.10.2001', 'Sintra');

INSERT INTO utente (numero, nome, sexo, nascimento, localidade)
    VALUES (778833650, 'Eva', 'F', '19.10.2001', 'Sintra');
    
INSERT INTO utente (numero, nome, sexo, nascimento, localidade)
    VALUES (879546803, 'Freddy', 'M', '20.10.2001', 'Castelo Branco');

INSERT INTO utente (numero, nome, sexo, nascimento, localidade)
    VALUES (764310985, 'Gonzalez', 'F', '21.10.2001', 'Castelo Branco');

INSERT INTO utente (numero, nome, sexo, nascimento, localidade)
    VALUES (001122339, 'Hugh', 'M', '22.10.2001', 'Castelo Branco');

INSERT INTO utente (numero, nome, sexo, nascimento, localidade)
    VALUES (175122360, 'Zack', 'M', '23.10.2001', 'Castelo Branco');

INSERT INTO utente (numero, nome, sexo, nascimento, localidade)
    VALUES (123000321, 'Zé', 'M', '23.10.1949', 'Porto');

INSERT INTO utente (numero, nome, sexo, nascimento, localidade)
    VALUES (123000322, 'Alice', 'F', '22.10.1948', 'Porto');

INSERT INTO utente (numero, nome, sexo, nascimento, localidade)
    VALUES (123000323, 'Tobias', 'M', '19.10.1947', 'Porto');

INSERT INTO utente (numero, nome, sexo, nascimento, localidade)
    VALUES (111222333, 'Catarina', 'F', '03.03.1999', 'Lisboa');

INSERT INTO internamento (utente, hospital, desde)
    VALUES (010100101, 'hospital santa maria', '03.03.2020');

INSERT INTO internamento (utente, hospital, desde)
    VALUES (010100102, 'hospital santa maria', '04.03.2020');

INSERT INTO internamento (utente, hospital, desde)
    VALUES (010100103, 'hospital santa maria', '05.03.2020');

INSERT INTO internamento (utente, hospital, desde)
    VALUES (010100104, 'hospital santa maria', '06.03.2020');

INSERT INTO internamento (utente, hospital, desde, ate)
    VALUES (123456789, 'hospital francisco xavier', '01.01.2020', '01.02.2020');

INSERT INTO internamento (utente, hospital, desde, ate)
    VALUES (987654321, 'hospital santa maria', '01.01.2020', '25.01.2020');

INSERT INTO internamento (utente, hospital, desde, ate)
    VALUES (159753280, 'hospital francisco xavier', '15.01.2020', '10.02.2020');

INSERT INTO internamento (utente, hospital, desde, ate)
    VALUES (778833650, 'hospital francisco xavier', '01.04.2021', '01.05.2021');

INSERT INTO internamento (utente, hospital, desde, ate)
    VALUES (147258369, 'hospital santa maria', '10.04.2020', '24.04.2020');

INSERT INTO internamento (utente, hospital, desde, ate)
    VALUES (963852741, 'hospital de castelo branco', '25.01.2020', '01.03.2020');
    
INSERT INTO internamento (utente, hospital, desde, ate)
    VALUES (879546803, 'hospital de castelo branco', '10.05.2021', '24.06.2021');
    
INSERT INTO internamento (utente, hospital, desde, ate)
    VALUES (764310985, 'hospital de castelo branco', '11.05.2021', '05.06.2021');

INSERT INTO internamento (utente, hospital, desde)
    VALUES (001122339, 'hospital de castelo branco','22.11.2020');

INSERT INTO internamento (utente, hospital, desde, ate)
    VALUES (175122360, 'hospital de castelo branco', '23.10.2020', '02.01.2021');

INSERT INTO internamento (utente, hospital, desde, ate)
    VALUES (963852741, 'hospital de castelo branco', '02.03.2020', '04.03.2020');

INSERT INTO internamento (utente, hospital, desde, ate)
    VALUES (963852741, 'hospital de castelo branco', '05.01.2020', '07.03.2020');

INSERT INTO internamento (utente, hospital, desde, ate)
    VALUES (963852741, 'hospital de castelo branco', '08.01.2020', '10.03.2020');

INSERT INTO internamento (utente, hospital, desde, ate)
    VALUES (963852741, 'hospital de castelo branco', '11.01.2020', '13.03.2020');

INSERT INTO internamento (utente, hospital, desde, ate)
    VALUES (123000321, 'hospital do porto', '15.01.2020', '15.03.2020');

INSERT INTO internamento (utente, hospital, desde, ate)
    VALUES (123000322, 'hospital do porto', '16.01.2020', '16.03.2020');

INSERT INTO internamento (utente, hospital, desde, ate)
    VALUES (123000323, 'hospital do porto', '17.01.2020', '17.03.2020');

INSERT INTO com (utente, hospital, desde, sintoma)
    VALUES (010100101, 'hospital santa maria', '03.03.2020', 'tosse');

INSERT INTO com (utente, hospital, desde, sintoma)
    VALUES (010100102, 'hospital santa maria', '04.03.2020', 'tosse');

INSERT INTO com (utente, hospital, desde, sintoma)
    VALUES (010100103, 'hospital santa maria', '05.03.2020', 'tosse');

INSERT INTO com (utente, hospital, desde, sintoma)
    VALUES (010100104, 'hospital santa maria', '06.03.2020', 'tosse');

INSERT INTO com (utente, hospital, desde, sintoma)
    VALUES (123456789, 'hospital francisco xavier', '01.01.2020', 'sono');

INSERT INTO com (utente, hospital, desde, sintoma)
    VALUES (987654321, 'hospital santa maria', '01.01.2020', 'febre');

INSERT INTO com (utente, hospital, desde, sintoma)
    VALUES (159753280, 'hospital francisco xavier', '15.01.2020', 'sono');

INSERT INTO com (utente, hospital, desde, sintoma)
    VALUES (778833650, 'hospital francisco xavier', '01.04.2021', 'febre ');

INSERT INTO com (utente, hospital, desde, sintoma)
    VALUES (147258369, 'hospital santa maria', '10.04.2020', 'febre');

INSERT INTO com (utente, hospital, desde, sintoma)
    VALUES (963852741, 'hospital de castelo branco', '25.01.2020', 'tosse');

INSERT INTO com (utente, hospital, desde, sintoma)
    VALUES (879546803, 'hospital de castelo branco', '10.05.2021', 'tosse');

INSERT INTO com (utente, hospital, desde, sintoma)
    VALUES (764310985, 'hospital de castelo branco', '11.05.2021', 'tosse');

INSERT INTO com (utente, hospital, desde, sintoma)
    VALUES (001122339, 'hospital de castelo branco','22.11.2020', 'tosse');

INSERT INTO com (utente, hospital, desde, sintoma)
    VALUES (175122360, 'hospital de castelo branco', '23.10.2020', 'sono');

INSERT INTO com (utente, hospital, desde, sintoma)
    VALUES (963852741, 'hospital de castelo branco', '02.03.2020', 'tosse');

INSERT INTO com (utente, hospital, desde, sintoma)
    VALUES (963852741, 'hospital de castelo branco', '05.01.2020', 'tosse');

INSERT INTO com (utente, hospital, desde, sintoma)
    VALUES (963852741, 'hospital de castelo branco', '08.01.2020', 'tosse');

INSERT INTO com (utente, hospital, desde, sintoma)
    VALUES (963852741, 'hospital de castelo branco', '11.01.2020', 'tosse');

INSERT INTO com (utente, hospital, desde, sintoma)
    VALUES (123000321, 'hospital do porto', '15.01.2020', 'tosse');

INSERT INTO com (utente, hospital, desde, sintoma)
    VALUES (123000322, 'hospital do porto', '16.01.2020', 'tosse');

INSERT INTO com (utente, hospital, desde, sintoma)
    VALUES (123000323, 'hospital do porto', '17.01.2020', 'tosse');

--------------------------------------------------------------------------------

COMMIT;


select camas
  from hospital
 WHERE camas IN (select camas
                        from hospital
                       WHERE camas > 1000);


-- PONTO 2
SELECT U.nome, U.numero
FROM utente U FULL OUTER JOIN internamento I ON (I.utente = U.numero),
     hospital H
WHERE U.sexo = 'F'
AND H.localidade = U.localidade
GROUP BY U.nome, U.numero
HAVING COUNT(I.utente) < 5
ORDER BY U.nome ASC, U.numero ASC;


-- PONTO 3
select DISTINCT U.numero, U.nome
  from utente U, internamento I, hospital H
 WHERE (to_char(U.nascimento, 'yyyy') < '1950')
 and (to_char(I.desde, 'yyyy') > '2000')
 and (U.localidade = 'Porto')
 and (H.nome = I.hospital)
 and (H.camas > (select AVG(camas)
                 from hospital))
order by U.nome ASC, U.numero ASC;


--PONTO 4
SELECT I.hospital, H.camas, I.ano, COUNT(I.hospital) internados, 
COUNT( case when U.sexo = 'M' then 1 end ) as Homens,
COUNT( case when U.sexo = 'F' then 1 end ) as Mulheres
FROM ( select hospital, to_char(desde, 'yyyy') ano, utente
        from internamento 
    group by hospital, desde, utente
    order by ano ) I, hospital H, utente U
WHERE H.nome = I.hospital
AND I.utente = U. numero
GROUP BY I.hospital, I.ano, H.camas
HAVING COUNT(I.hospital) = ANY ( Select MAX(internados) internados
                                   From ( Select COUNT(internados) internados, hospital, ano
                                            From ( Select hospital,COUNT(hospital) internados,
                                                     to_char(desde, 'yyyy') ano
                                                     From internamento
                                                 Group By hospital, desde )
                                        Group By hospital, ano )
                                Group By ano )
ORDER BY I.ano DESC, Homens ASC, Mulheres ASC;


select count(*)
  from internamento








var name1 NUMBER
exec :name1 := pkg_sns.regista_utente('Olivia', 'F', '15.10.2000', 'SINTRA');

var name2 NUMBER
exec :name2 := pkg_sns.regista_utente('Oscar', 'm', '15.10.2001', 'SINTRA');

var name3 NUMBER
exec :name3 := pkg_sns.regista_utente('Olga', 'F', '15.10.1999', 'SINTRA');

var name4 NUMBER
exec :name4 := pkg_sns.regista_utente('Oswald', 'M', '15.10.1998', 'SINTRA');


BEGIN pkg_sns.regista_hospital('hospital do porto', 'Porto', 5000); END;
/

BEGIN pkg_sns.regista_hospital('hospital do alagrve', 'Algarve', 5000); END;
/

BEGIN pkg_sns.regista_hospital('hospital de Castelo Branco', 'Castelo Branco', 1000); END;
/ 

RAISE_APPLICATION_ERROR(-20002,'An error was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);


























CREATE OR REPLACE PACKAGE pkg_sns IS

  FUNCTION regista_utente(
    nome_in       IN utente.nome%TYPE,
    sexo_in       IN utente.sexo%TYPE,
    nascimento_in IN utente.nascimento%TYPE,
    localidade_in IN utente.localidade%TYPE)
    RETURN NUMBER;

  PROCEDURE regista_hospital(
    nome_in        IN hospital.nome%TYPE,
    localidade_in  IN hospital.localidade%TYPE, 
    camas_in       IN hospital.camas%TYPE);

END pkg_sns;
/

CREATE SEQUENCE next_sns
  START WITH 100000000
  INCREMENT BY 1
  MAXVALUE 999999999
  NOCYCLE;

CREATE OR REPLACE PACKAGE BODY pkg_sns IS

  -- --------------------------------------------------------------------------
    FUNCTION regista_utente (
        nome_in       IN utente.nome%TYPE,
        sexo_in       IN utente.sexo%TYPE,
        nascimento_in IN utente.nascimento%TYPE,
        localidade_in IN utente.localidade%TYPE)
        RETURN NUMBER
    IS
        n NUMBER;
    BEGIN
        n := next_sns.NEXTVAL;
        INSERT INTO utente (numero, nome, sexo, nascimento, localidade)
             VALUES (n, nome_in, sexo_in, nascimento_in, localidade_in);
        RETURN n;

    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            RAISE_APPLICATION_ERROR(-20001,'Nº SNS invalido ' ||
                                     'ou já está em uso ');

        WHEN OTHERS THEN
            BEGIN
                IF (SQLCODE = -1400) THEN
                RAISE_APPLICATION_ERROR(-20002, 'Nenhum dos valores inseridos ' ||
                                            'podem ser nulos.');
                END IF;

                IF (SQLCODE = -2290) THEN
                RAISE_APPLICATION_ERROR(-20002, 'Uma ou mais restricões foram violadas. ' || 
                                                'Por favor verifique se: O sexo do utente é diferente de M ou F ou ' ||
                                                'se o ano da data de nascimento do utente é inferior a 1900. ');
                END IF;

                RAISE;
            END;
  END regista_utente;

  -- --------------------------------------------------------------------------

    PROCEDURE regista_hospital (
        nome_in        IN hospital.nome%TYPE,
        localidade_in  IN hospital.localidade%TYPE, 
        camas_in       IN hospital.camas%TYPE)

    IS
        hospital_update NUMBER;
        n_internados NUMBER;
    BEGIN
        SELECT COUNT(*)
          INTO n_internados
          FROM internamento
         WHERE hospital = nome_in;

        SELECT count(*)
          INTO hospital_update
          FROM hospital
         WHERE nome = nome_in;

        IF n_internados > camas_in THEN
            raise_application_error(-20003, 'O nº de camas tem de ser ' ||
                                            'igual ou superior ao nº de internados.');
        END IF;

        IF hospital_update = 1 THEN
            UPDATE hospital
               SET localidade = localidade_in, camas = camas_in
             WHERE nome = nome_in;
        ELSE
            INSERT INTO hospital (nome, localidade, camas)
                 VALUES (nome_in, localidade_in, camas_in);
        END IF;
    
    EXCEPTION
        WHEN OTHERS THEN
            BEGIN
                IF (SQLCODE = -1400) THEN
                RAISE_APPLICATION_ERROR(-20002, 'Nenhum dos valores inseridos' ||
                                                'podem ser nulos.');
                END IF;

                RAISE;
            END;
    
    END regista_hospital;

END pkg_sns;
/




CREATE OR REPLACE PACKAGE pkg_sns1 IS

    PROCEDURE remove_internamentos(
        utente_in    IN internamento.utente%TYPE,
        hospital_in  IN internamento.hospital%TYPE);

    PROCEDURE remove_hospital(
        nome_in  IN hospital.nome%TYPE);

    PROCEDURE remove_utente(
        numero_in  IN utente.numero%TYPE);

    FUNCTION lista_internamentos(
        utente_in   IN com.utente%TYPE, 
        sintoma_in  IN com.sintoma%TYPE)
        RETURN SYS_REFCURSOR;

END pkg_sns1;
/


CREATE OR REPLACE PACKAGE BODY pkg_sns1 IS
  
    PROCEDURE remove_internamentos (
        utente_in    IN internamento.utente%TYPE,
        hospital_in  IN internamento.hospital%TYPE)

    IS
    BEGIN

        IF (hospital_in IS NULL) AND (utente_in IS NULL) THEN
            DELETE from com;

            DELETE from internamento;

        ELSIF (hospital_in IS NULL) AND (utente_in IS NOT NULL) THEN
            DELETE from com
             WHERE utente = utente_in;

            DELETE from internamento
             WHERE utente = utente_in;
             
        ELSIF (hospital_in IS NOT NULL) AND (utente_in IS NULL) THEN
            DELETE from com
             WHERE hospital = hospital_in;

             DELETE from internamento
             WHERE hospital = hospital_in;

        ELSE
            DELETE FROM com
             WHERE (utente = utente_in)
               AND (hospital = hospital_in);

            DELETE FROM internamento
             WHERE (utente = utente_in)
               AND (hospital = hospital_in);
               
        END IF;
    
    EXCEPTION
        WHEN OTHERS THEN RAISE;
            
    
    END remove_internamentos;

  -- --------------------------------------------------------------------------

  PROCEDURE remove_hospital(
        nome_in  IN hospital.nome%TYPE)

    IS
    BEGIN
        BEGIN 
            pkg_sns1.remove_internamentos(NULL, nome_in); 
        END;

        DELETE FROM hospital
         WHERE nome = nome_in;     

    EXCEPTION
        WHEN OTHERS THEN RAISE;
            
    END remove_hospital;

  -- --------------------------------------------------------------------------

    PROCEDURE remove_utente(
        numero_in  IN utente.numero%TYPE)

    IS
    BEGIN
        BEGIN 
            pkg_sns1.remove_internamentos(numero_in, NULL); 
        END;

        DELETE FROM utente
         WHERE numero = numero_in;     

    EXCEPTION
        WHEN OTHERS THEN RAISE;
            
    END remove_utente;

  -- --------------------------------------------------------------------------

    FUNCTION lista_internamentos(
        utente_in   IN com.utente%TYPE, 
        sintoma_in  IN com.sintoma%TYPE)
        RETURN SYS_REFCURSOR

    IS
        c_internamentos SYS_REFCURSOR;
    BEGIN
        OPEN c_internamentos FOR
            select C.utente, U.nome, C.hospital, H.localidade, I.desde, I.ate
              from com C, utente U, hospital H, internamento I
             where C.utente = utente_in 
               and U.numero = C.utente
               and H.nome = C.hospital
               and I.desde = C.desde
               and C.sintoma = sintoma_in;
        RETURN c_internamentos; 

    EXCEPTION
        WHEN OTHERS THEN RAISE;

    END lista_internamentos;

END pkg_sns1;
/





BEGIN pkg_sns1.remove_internamentos(NULL, NULL); END;
/ 






INSERT INTO internamento (utente, hospital, desde, ate)
    VALUES (963852741, 'hospital de castelo branco', '25.01.2020', '01.03.2020');

INSERT INTO internamento (utente, hospital, desde, ate)
    VALUES (963852741, 'hospital de castelo branco', '02.03.2020', '04.03.2020');

INSERT INTO internamento (utente, hospital, desde, ate)
    VALUES (963852741, 'hospital de castelo branco', '05.01.2020', '07.03.2020');

INSERT INTO internamento (utente, hospital, desde, ate)
    VALUES (963852741, 'hospital de castelo branco', '08.01.2020', '10.03.2020');

INSERT INTO internamento (utente, hospital, desde, ate)
    VALUES (963852741, 'hospital de castelo branco', '11.01.2020', '13.03.2020');




INSERT INTO com (utente, hospital, desde, sintoma)
    VALUES (963852741, 'hospital de castelo branco', '25.01.2020', 'tosse');

INSERT INTO com (utente, hospital, desde, sintoma)
    VALUES (963852741, 'hospital de castelo branco', '02.03.2020', 'tosse');

INSERT INTO com (utente, hospital, desde, sintoma)
    VALUES (963852741, 'hospital de castelo branco', '05.01.2020', 'tosse');

INSERT INTO com (utente, hospital, desde, sintoma)
    VALUES (963852741, 'hospital de castelo branco', '08.01.2020', 'tosse');

INSERT INTO com (utente, hospital, desde, sintoma)
    VALUES (963852741, 'hospital de castelo branco', '11.01.2020', 'tosse');