-- ----------------------------------------------------------------------------
-- SIBD, 2020-2021
-- Alexandre Rodrigues, Nº 54472
-- ----------------------------------------------------------------------------

-- Sequencia geradora de Nºs de SNS
CREATE SEQUENCE next_sns
  START WITH 1
  INCREMENT BY 1
  MAXVALUE 999999999
  NOCYCLE;

CREATE OR REPLACE PACKAGE BODY SNS IS
 
  -- --------------------------------------------------------------------------
    -- Cria um novo registo de utente
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
            RAISE_APPLICATION_ERROR(-20000,'Nº SNS já está em uso.');

        WHEN OTHERS THEN
            BEGIN
                IF (SQLCODE = -1400) THEN
                --Exceção por violação de restrição CHECK (-1400)
                RAISE_APPLICATION_ERROR(-20001, 'Nenhum dos valores inserido' ||
                                            'podem ser nulo.');
                END IF;

                IF (SQLCODE = -2290) THEN
                --Exceção por violação de restrição CHECK (-2290)
                RAISE_APPLICATION_ERROR(-20002, 'Uma ou mais restricões foram violadas. ' || 
                                                'Por favor verifique se: O sexo do utente é diferente de M ou F ou ' ||
                                                'se o ano da data de nascimento do utente é inferior a 1900.');
                END IF;

                RAISE;
            END;
  END regista_utente;

  -- --------------------------------------------------------------------------
    -- Cria um novo registo de hospital
    PROCEDURE regista_hospital (
        nome_in        IN hospital.nome%TYPE,
        localidade_in  IN hospital.localidade%TYPE, 
        camas_in       IN hospital.camas%TYPE)

    IS
        hospital_update NUMBER;
        n_internados NUMBER;
    BEGIN
        -- Verifica quantos internamentos é que um dado hospital tem
        SELECT COUNT(*)
          INTO n_internados
          FROM internamento
         WHERE hospital = nome_in;

        -- Verifica se o hospital já existe
        SELECT COUNT(*)
          INTO hospital_update
          FROM hospital
         WHERE nome = nome_in;

        -- Se o numero de internamentos do hospital for
        -- maior que o numero de camas (atualizado) então
        -- é levantada uma excessão  
        IF n_internados > camas_in THEN
            RAISE_APPLICATION_ERROR(-20003, 'O nº de camas tem de ser ' ||
                                            'igual ou superior ao nº de internados.');
        END IF;

        -- Se o hospital já existir então faz um UPDATE
        -- senão cria um novo registo de hospital 
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
                --Exceção por violação de restrição CHECK (-1400)
                RAISE_APPLICATION_ERROR(-20001, 'Nenhum dos valores inseridos' ||
                                                'podem ser nulos.');
                END IF;

                IF (SQLCODE = -2290) THEN
                --Exceção por violação de restrição CHECK (-2290)
                RAISE_APPLICATION_ERROR(-20004, 'O numero de camas tem de ser maior que 0');
                END IF;

                RAISE;
            END;
    
    END regista_hospital;
  -- --------------------------------------------------------------------------
    -- Cria um novo registo do inicio de um internamento
    PROCEDURE inicia_internamento (
        utente_in    IN com.utente%TYPE, 
        hospital_in  IN com.hospital%TYPE, 
        sintomas_in  STRING)

    IS
        data_inicio DATE;
        n_camas NUMBER;
        n_internados NUMBER;
        utente_registado NUMBER;

    BEGIN
        data_inicio := SYSDATE;

        -- Verifica se o utente ainda não está internado
        SELECT COUNT(*)
          INTO utente_registado
          FROM internamento
         WHERE utente = utente_in
           AND ate IS NULL;

        IF utente_registado > 0 THEN
          -- Se o utente estiver internado então levanta-se esta excessão 
          RAISE_APPLICATION_ERROR(-20005, 'Este o utente já se encontra internado');
        END IF;

        -- Verifica quantos utentes estão internados neste hospital
        SELECT COUNT(*)
          INTO n_internados
          FROM internamento
         WHERE hospital = hospital_in;

        -- Verifica quantos camas o hospital tem
        SELECT camas
          INTO n_camas
          FROM hospital
         WHERE nome = hospital_in;

        IF n_internados + 1 > n_camas THEN
          -- Se o hospital já não tiver camas disponiveis então levanta-se esta excessão 
          RAISE_APPLICATION_ERROR(-20006, 'Não existem camas disponiveis no hospital pretendido');
        END IF;

        INSERT INTO internamento (utente, hospital, desde)
                 VALUES (utente_in, hospital_in, data_inicio);
        BEGIN
            FOR sintoma IN (SELECT TRIM(regexp_substr(sintomas_in, '[^,]+', 1, LEVEL)) AS nome
                    FROM DUAL
                    CONNECT BY regexp_substr(sintomas_in, '[^,]+', 1, LEVEL) IS NOT NULL) LOOP

            INSERT INTO com (utente, hospital, desde, sintoma)
                 VALUES (utente_in, hospital_in, data_inicio, sintoma.nome);
        END LOOP;
        END;

    EXCEPTION
        WHEN OTHERS THEN
            BEGIN
                IF (SQLCODE = -1400) THEN
                --Exceção por violação de restrição CHECK (-2290)
                RAISE_APPLICATION_ERROR(-20001, 'Nenhum dos valores inseridos' ||
                                                'podem ser nulos.');
                END IF;

                RAISE;
            END;

    END inicia_internamento;

    -- --------------------------------------------------------------------------
    -- Cria um novo registo do fim de um internamento
    PROCEDURE termina_internamento(
        utente_in    IN com.utente%TYPE, 
        hospital_in  IN com.hospital%TYPE)
       
    IS
        data_fim DATE;
        data_inicio DATE;
        utente_registado NUMBER;

    BEGIN
        data_fim := SYSDATE;

        -- Verifica se o utente está internado
        SELECT COUNT(*)
          INTO utente_registado
          FROM internamento
         WHERE utente = utente_in
           AND hospital = hospital_in
           AND ate IS NOT NULL;

        IF utente_registado > 0 THEN
          -- Se o utente não estiver internado então levanta-se esta excessão  
          RAISE_APPLICATION_ERROR(-20007, 'Este o utente não se encontra internado');
        END IF;
        
        --Recolhe a data do incio do internamento
        SELECT desde
          INTO data_inicio
          FROM internamento
         WHERE utente = utente_in
           AND hospital = hospital_in;

        UPDATE internamento
           SET ate = data_fim
         WHERE utente = utente_in
           AND hospital = hospital_in;

    EXCEPTION
        WHEN OTHERS THEN
            BEGIN
                IF (SQLCODE = -1400) THEN
                --Exceção por violação de restrição CHECK (-2290)
                RAISE_APPLICATION_ERROR(-20001, 'Nenhum dos valores inseridos' ||
                                                'podem ser nulos.');
                END IF;

                RAISE;
            END;
           
    END termina_internamento;

  -- --------------------------------------------------------------------------
    -- Remove os internamentos especificados
    PROCEDURE remove_internamentos (
        utente_in    IN internamento.utente%TYPE,
        hospital_in  IN internamento.hospital%TYPE)

    IS
    BEGIN
        --Se o utente e o hospital forem NULL então
        --são removidos todos os internamentos de todos os hospitais
        IF (hospital_in IS NULL) AND (utente_in IS NULL) THEN
            DELETE from com;
            DELETE from internamento;

        --Se o hospital for NULL então 
        --são removidos todos os internamentos do utente especificado 
        ELSIF (hospital_in IS NULL) AND (utente_in IS NOT NULL) THEN
            DELETE from com
             WHERE utente = utente_in;

            DELETE from internamento
             WHERE utente = utente_in;

        --Se o utente for NULL então 
        --são removidos todos os internamentos do hospital especificado     
        ELSIF (hospital_in IS NOT NULL) AND (utente_in IS NULL) THEN
            DELETE from com
             WHERE hospital = hospital_in;

             DELETE from internamento
             WHERE hospital = hospital_in;

        --Se o utente e o hospital não forem NULL então 
        --são removidos apenas os internamentos especificados
        ELSE
            DELETE FROM com
             WHERE (utente = utente_in)
               AND (hospital = hospital_in);

            DELETE FROM internamento
             WHERE (utente = utente_in)
               AND (hospital = hospital_in);
               
        END IF;
    
    IF (SQL%ROWCOUNT = 0) THEN
            --Nenhuma linha foi afetada pelo comando DELETE.
            RAISE_APPLICATION_ERROR(-20008, 'Os dados a remover nao existem.');
        END IF;

    EXCEPTION 
        WHEN OTHERS THEN RAISE;
    END remove_internamentos;

  -- --------------------------------------------------------------------------
    -- Remove um hospital existente e todos os seus internamentos
    PROCEDURE remove_hospital(
        nome_in  IN hospital.nome%TYPE)

    IS
    BEGIN
        BEGIN
            --Chama a função remove_internamentos para remover
            --todos os internamentos do hospital especificado  
            SNS.remove_internamentos(NULL, nome_in); 
        END;

        DELETE FROM hospital
         WHERE nome = nome_in;     
        
        IF (SQL%ROWCOUNT = 0) THEN
            --Nenhuma linha foi afetada pelo comando DELETE.
            RAISE_APPLICATION_ERROR(-20008, 'Os dados a remover nao existem.');
        END IF;

    EXCEPTION 
        WHEN OTHERS THEN RAISE;
    END remove_hospital;

  -- --------------------------------------------------------------------------
    -- Remove um utente existente e todos os seus internamentos registados
    PROCEDURE remove_utente(
        numero_in  IN utente.numero%TYPE)

    IS
    BEGIN
        BEGIN 
            --Chama a função remove_internamentos para remover
            --todos os internamentos do hospital especificado
            SNS.remove_internamentos(numero_in, NULL); 
        END;

        DELETE FROM utente
         WHERE numero = numero_in;     

        IF (SQL%ROWCOUNT = 0) THEN
            --Nenhuma linha foi afetada pelo comando DELETE.
            RAISE_APPLICATION_ERROR(-20008, 'Os dados a remover nao existem.');
        END IF;

    EXCEPTION 
        WHEN OTHERS THEN RAISE;
    END remove_utente;
 
  -- --------------------------------------------------------------------------
    -- Demonstra uma lista de internamentos de um utente com um sintoma especifico
    FUNCTION lista_internamentos(
        utente_in   IN com.utente%TYPE, 
        sintoma_in  IN com.sintoma%TYPE)
        RETURN SYS_REFCURSOR

    IS
        c_internamentos SYS_REFCURSOR;
    BEGIN
        -- Obtenção do utente especificado nos parametros
        OPEN c_internamentos FOR
            SELECT C.utente, U.nome, C.hospital, H.localidade, I.desde, I.ate
              FROM com C, utente U, hospital H, internamento I
             WHERE C.utente = utente_in 
               AND U.numero = C.utente
               AND H.nome = C.hospital
               AND I.desde = C.desde
               AND C.sintoma = sintoma_in;
               
        IF (c_internamentos%NOTFOUND) THEN
            --Esta instancia não existe.
            RAISE_APPLICATION_ERROR(-20009, 'Não existe nenhuma instancia deste utente'
                                                ||' com os sintomas declarados.');
        END IF;
        RETURN c_internamentos; 

    EXCEPTION
        WHEN OTHERS THEN RAISE;

    END lista_internamentos;

END SNS;
/