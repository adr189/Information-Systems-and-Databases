-- ----------------------------------------------------------------------------
-- SIBD, 2020-2021
-- Alexandre Rodrigues, Nº 65582
-- ----------------------------------------------------------------------------

variable y NUMBER
exec :y := SNS.regista_utente('Vasco','M','10.12.2000 12:00:40','Lisboa')

exec :y := SNS.regista_utente('Wanda','F','16.12.2000 12:00:40','Lisboa')

exec :y := SNS.regista_utente('William','M','10.10.2000 12:00:40','Lisboa')

exec :y := SNS.regista_utente('Debby','F','16.10.2000 12:00:40','Lisboa')

exec :y := SNS.regista_utente('Edgar','M','20.12.2000 12:00:40','Lisboa')

exec :y := SNS.regista_utente('Alice','F','16.12.2000 12:00:40','Lisboa')

exec :y := SNS.regista_utente('Bob','M','10.10.2000 12:00:40','Lisboa')

exec :y := SNS.regista_utente('Fernanda','F','16.10.2000 12:00:40','Lisboa')

exec :y := SNS.regista_utente('Subaru','M','16.10.2000 12:00:40','Lisboa')

BEGIN 
SNS.regista_hospital('Hospital A', 'Lisboa', 2600); 
END;
/

BEGIN 
SNS.regista_hospital('Hospital B', 'Faro', 2000); 
END;
/

BEGIN 
SNS.regista_hospital('Hospital C', 'Leiria', 4000); 
END;
/

BEGIN 
SNS.inicia_internamento(1, 'Hospital A', 'febre, tosse'); 
END;
/

BEGIN 
SNS.inicia_internamento(2, 'Hospital B', 'febre, tosse'); 
END;
/

BEGIN 
SNS.inicia_internamento(3, 'Hospital C', 'febre, tosse'); 
END;
/

BEGIN 
SNS.inicia_internamento(4, 'Hospital A', 'febre, tosse'); 
END;
/

BEGIN 
SNS.inicia_internamento(5, 'Hospital B', 'febre, tosse'); 
END;
/

BEGIN 
SNS.inicia_internamento(6, 'Hospital C', 'febre, tosse'); 
END;
/

BEGIN 
SNS.inicia_internamento(7, 'Hospital A', 'febre, tosse'); 
END;
/

BEGIN 
SNS.inicia_internamento(8, 'Hospital B', 'febre, tosse'); 
END;
/

BEGIN 
SNS.inicia_internamento(9, 'Hospital C', 'febre, tosse'); 
END;
/

-- Faz com que o processo pare durante 1 segundo.  
DBMS_SESSION.SLEEP (1);
-- Faz com que o processo pare durante 1 segundo.   
DBMS_SESSION.SLEEP (1);
-- Faz com que o processo pare durante 1 segundo.  
DBMS_SESSION.SLEEP (1);
-- Faz com que o processo pare durante 1 segundo.   
DBMS_SESSION.SLEEP (1);
-- Faz com que o processo pare durante 1 segundo.   
DBMS_SESSION.SLEEP (1);

BEGIN 
SNS.termina_internamento(1, 'Hospital A'); 
END;
/

BEGIN 
SNS.termina_internamento(2, 'Hospital B'); 
END;
/

BEGIN 
SNS.termina_internamento(3, 'Hospital C'); 
END;
/

BEGIN 
SNS.remove_internamentos(1, 'Hospital A'); 
END;
/

BEGIN 
SNS.remove_internamentos(2, 'Hospital B'); 
END;
/

BEGIN 
SNS.remove_internamentos(3, 'Hospital C');
END;
/

BEGIN 
SNS.remove_utente(7); 
END;
/

BEGIN 
SNS.remove_utente(8); 
END;
/

BEGIN 
SNS.remove_utente(9); 
END;
/

BEGIN 
SNS.remove_hospital('Hospital C'); 
END;
/

variable x refcursor
exec :x := SNS.lista_internamentos(4,'tosse')

BEGIN 
SNS.remove_internamentos(4, NULL); 
END;
/

BEGIN 
SNS.remove_internamentos(NULL, 'Hospital B'); 
END;
/
-- DROP PACKAGE SNS;
-- DROP SEQUENCE next_sns; 