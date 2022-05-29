
/************************************** Triggers for any action **************************************/

/** Триггеры на аудит любых действий в базе данных **/

CREATE TABLE audit_objects_table (
    action_date    DATE,
    type_of_action VARCHAR2(20),
    called_by_user VARCHAR2(30),
    instance_num   NUMBER,
    database_name  VARCHAR2(50),
    object_owner   VARCHAR2(30),
    object_type    VARCHAR2(20),
    object_name    VARCHAR2(30)
);


CREATE PROCEDURE insert_actions_for_log_table AS
BEGIN
   INSERT INTO audit_objects_table
      (action_date, type_of_action, called_by_user,
       instance_num, database_name,
       object_owner, object_type, object_name)
   VALUES
      (sysdate, ora_sysevent, ora_login_user,
       ora_instance_num, ora_database_name,
       ora_dict_obj_owner, ora_dict_obj_type, ora_dict_obj_name);
END;
/

-- TRIGGER FOR CREATE ANY OBJECT ON BOOK_ADMIN SCHEMA
CREATE OR REPLACE TRIGGER create_trigger
AFTER CREATE ON book_admin.SCHEMA
BEGIN
    DBMS_OUTPUT.PUT_LINE(ora_login_user || ' CREATED OBJECT :: ' ||  sysdate);
    insert_actions_for_log_table;
END;
/
 
-- TRIGGER FOR ALTER ANY OBJECT ON BOOK_ADMIN SCHEMA
CREATE OR REPLACE TRIGGER alter_trigger
AFTER ALTER ON book_admin.SCHEMA
BEGIN
    DBMS_OUTPUT.PUT_LINE(ora_login_user || ' ALTERED OBJECT :: ' ||  sysdate);
    insert_actions_for_log_table;
END;
/
 
-- TRIGGER FOR DROP ANY OBJECT ON BOOK_ADMIN SCHEMA
CREATE OR REPLACE TRIGGER drop_object_trigger
AFTER DROP ON book_admin.SCHEMA
BEGIN
    DBMS_OUTPUT.PUT_LINE(ora_login_user || ' DROPPED OBJECT :: ' ||  sysdate);
    insert_actions_for_log_table;
END;
/

------- STARTED TO TEST TRIGGERS
--ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MM-YYYY HH24:MI:SS';
--
--select * from audit_objects_table;
--
--DROP TABLE book_admin.audit_objects_table2;

/************************************** Триггер для отслеживания IP адресов подключенных к БД **************************************/

/*  Триггер для отслеживания IP адресов подключения к экземпляру БД */

CREATE TABLE users_login_table (
    v_login_date DATE,
    v_client_ip  VARCHAR2(20),
    v_db_name    VARCHAR2(30),
    v_user       VARCHAR(30)
);
/

--https://docs.oracle.com/en/database/oracle/oracle-database/19/lnpls/plsql-triggers.html#GUID-266DBF6D-AA74-490C-ADE5-962C10708C2D
--CONNECT sys/123 as sysdba;
--CONNECT book_admin/123;

/
CREATE OR REPLACE TRIGGER check_logon
AFTER LOGON ON book_admin.SCHEMA
BEGIN
  IF (ora_sysevent = 'LOGON') THEN
    DBMS_OUTPUT.PUT_LINE('LOGON NEW USER' || sysdate || ' logged: ' || ora_client_ip_address || ' to database: ' || ora_database_name || ' user ' || user);
    INSERT INTO book_admin.users_login_table VALUES (sysdate, ora_client_ip_address, ora_database_name, ora_login_user);
  END IF;
END;
/

-- select * from users_login_table;