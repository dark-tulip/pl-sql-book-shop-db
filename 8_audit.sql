/************************************** Назначение аудита объектам в схеме пользователя book_admin **************************************/

-- Можно таким образом - от book_admin, для каждой таблицы регистрировать действия в таблицу

CREATE TABLE audit_DML_actions_table(
    called_user     VARCHAR(30),
    action_date     DATE,
    action_terminal VARCHAR2(30),
    action_type     VARCHAR(20)
);
/

CREATE OR REPLACE TRIGGER audit_DML_actions
AFTER INSERT OR UPDATE OR DELETE ON book_admin.book
FOR EACH ROW 
DECLARE 
    v_ACTION VARCHAR2(10);
BEGIN     
	IF INSERTING THEN
		  v_ACTION := 'INSERT';
	ELSIF UPDATING THEN
		  v_ACTION := 'UPDATE';
	ELSIF DELETING THEN
		  v_ACTION := 'DELETE';
	END IF;
	
	INSERT INTO audit_DML_actions_table
		VALUES (USER, SYSDATE, USERENV('TERMINAL'), v_ACTION);
    
END;
/


/************************************** Встроенное решение от ORACLE для аудита любых DML действий – назначенным объектам **************************************/

-- ВСЕ действия выполняем от SYS

CONNECT SYS/123 as sysdba;
-- AUDIT_TRAIL enables or disables database auditing.

 --  Oracle будет сохранять записи аудита в журнале аудита базы данных, доступном для просмотра в виде представления DBA_AUDIT_TRAIL (хранящемся в таблице SYS.AUD$).
ALTER SYSTEM SET AUDIT_TRAIL=DB, EXTENDED SCOPE=SPFILE;  -- The new value takes effect after the database is restarted.
--ALTER SYSTEM SET AUDIT_SYS_OPERATIONS=TRUE;

-- журнал аудита может содержать следующие типы данных:
-- учетное имя для входа в операционную систему;
-- имя пользователя базы данных;
-- идентификаторы терминала и сеанса;
-- имя выполненной операции или операции, для которой была предпринята попытка выполнения;
-- метка даты и времени;
-- SQL-текст, запустивший аудит.

AUDIT SELECT, INSERT, UPDATE, DELETE ON BOOK_ADMIN.book;
AUDIT SELECT, INSERT, UPDATE, DELETE ON BOOK_ADMIN.genre;
AUDIT SELECT, INSERT, UPDATE, DELETE ON BOOK_ADMIN.book_genre;
AUDIT SELECT, INSERT, UPDATE, DELETE ON BOOK_ADMIN.author;
AUDIT SELECT, INSERT, UPDATE, DELETE ON BOOK_ADMIN.book_author;

AUDIT SELECT, INSERT, UPDATE, DELETE ON BOOK_ADMIN.client;
AUDIT SELECT, INSERT, UPDATE, DELETE ON BOOK_ADMIN.city;
AUDIT SELECT, INSERT, UPDATE, DELETE ON BOOK_ADMIN.street;

AUDIT SELECT, INSERT, UPDATE, DELETE ON BOOK_ADMIN.delivery_type;
AUDIT SELECT, INSERT, UPDATE, DELETE ON BOOK_ADMIN.delivery_point;
AUDIT SELECT, INSERT, UPDATE, DELETE ON BOOK_ADMIN.order_step;
AUDIT SELECT, INSERT, UPDATE, DELETE ON BOOK_ADMIN.step;

AUDIT SELECT, INSERT, UPDATE, DELETE ON BOOK_ADMIN.orders;
AUDIT SELECT, INSERT, UPDATE, DELETE ON BOOK_ADMIN.book_order;


--SELECT * FROM book_admin.book;
--EXEC book_pkg.updatebookprice(1, 4000);
--
--SELECT * FROM SYS.AUD$;
--
--SELECT userid, terminal, OBJ$NAME, spare1, ntimestamp#, sqltext, current_user FROM SYS.AUD$;


CONNECT book_admin/123;