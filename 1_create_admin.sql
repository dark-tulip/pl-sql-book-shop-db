ALTER SYSTEM SET DB_CREATE_FILE_DEST = '$ORACLE_HOME/rdbms/test';

CREATE TABLESPACE perm_ts DATAFILE 'perm_1.dbf' SIZE 1M
    EXTENT MANAGEMENT LOCAL
    SEGMENT SPACE MANAGEMENT AUTO;
   
CREATE TEMPORARY TABLESPACE temp_ts
    TEMPFILE 'temp_1.dbf' 
    SIZE 5M AUTOEXTEND ON;

--  Location of the table space files
select * from v$parameter where value like '%/rdbms/test%'
union
select * from v$parameter where value like '%/u01/app/oracle/product/19.3.0/dbhome_1/dbs%';

SELECT * FROM v$datafile;

-- Create a new user in Oracle
CREATE USER book_admin
    IDENTIFIED BY 123
    DEFAULT TABLESPACE   perm_ts
    TEMPORARY TABLESPACE temp_ts
    QUOTA UNLIMITED ON   perm_ts;


-- Assign SYSTEM privileges to new user in Oracle
GRANT CREATE SESSION       TO book_admin;
GRANT CREATE TABLE         TO book_admin;
GRANT CREATE VIEW          TO book_admin;
GRANT CREATE ANY TRIGGER   TO book_admin;
GRANT CREATE ANY PROCEDURE TO book_admin;
GRANT CREATE SEQUENCE      TO book_admin;
GRANT CREATE SYNONYM       TO book_admin;

-- после создания таблиц можно еще раз посмотреть табличное простарнство
SELECT * from dba_tables where tablespace_name = 'PERM_TS';