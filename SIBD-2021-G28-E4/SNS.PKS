-- ----------------------------------------------------------------------------
-- SIBD, 2020-2021
-- Alexandre Rodrigues, Nº 54472
-- ----------------------------------------------------------------------------
 
CREATE OR REPLACE PACKAGE SNS IS
  -- Exceção Mensagem
  --  -20000 Nº SNS já está em uso.
  --  -20001 Nenhum dos valores inseridos pode ser nulo.
  --  -20002 Uma ou mais restricões foram violadas.  
  --         Por favor verifique se: O sexo do utente é diferente de M ou F ou
  --         se o ano da data de nascimento do utente é inferior a 1900.
  --  -20003 O nº de camas tem de ser igual ou superior ao nº de internados.
  --  -20004 O numero de camas tem de ser maior que 0.
  --  -20005 Este o utente já se encontra internado
  --  -20006 Não existem camas disponiveis no hospital pretendido
  --  -20007 Este o utente não se encontra internado
  --  -20008 Os dados a remover nao existem
  --  -20009 Não existe nenhuma instancia deste utente com os sintomas declarados

  -- Cria um novo registo de utente
  FUNCTION regista_utente(
    nome_in       IN utente.nome%TYPE,
    sexo_in       IN utente.sexo%TYPE,
    nascimento_in IN utente.nascimento%TYPE,
    localidade_in IN utente.localidade%TYPE)
    RETURN NUMBER;

  -- Cria um novo registo de hospital
  PROCEDURE regista_hospital(
    nome_in       IN hospital.nome%TYPE,
    localidade_in  IN hospital.localidade%TYPE, 
    camas_in       IN hospital.camas%TYPE);

  -- Cria um novo registo de um inicio de internamento
  PROCEDURE inicia_internamento(
    utente_in    IN com.utente%TYPE, 
    hospital_in  IN com.hospital%TYPE, 
    sintomas_in STRING);

  -- Cria um novo registo de um fim de internamento
  PROCEDURE termina_internamento(
    utente_in    IN com.utente%TYPE, 
    hospital_in  IN com.hospital%TYPE);
  
  -- Remove os internamentos especificados
  PROCEDURE remove_internamentos(
    utente_in    IN internamento.utente%TYPE,
    hospital_in  IN internamento.hospital%TYPE);
 
  -- Remove um hospital existente e todos os seus internamentos
  PROCEDURE remove_hospital(
    nome_in  IN hospital.nome%TYPE);

  -- Remove um utente existente e todos os seus internamentos registados
  PROCEDURE remove_utente(
    numero_in  IN utente.numero%TYPE);
  
  -- Demonstra uma lista de internamentos de um utente com um sintoma especifico
  FUNCTION lista_internamentos(
    utente_in   IN com.utente%TYPE, 
    sintoma_in  IN com.sintoma%TYPE)
    RETURN SYS_REFCURSOR;

END SNS;
/ 