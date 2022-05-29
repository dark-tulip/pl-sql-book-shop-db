/*                DATABASE TRIGGERS               */
CREATE OR REPLACE TRIGGER check_amount
BEFORE
    UPDATE OR INSERT OF amount ON book
FOR EACH ROW
BEGIN
    IF (:new.amount < 0) THEN
        DBMS_OUTPUT.PUT_LINE('TRIGGER check_amount :: Amount cannot be negative!!!');
        RAISE_APPLICATION_ERROR(-20000, ' RAISE ERROR :: no negative AMOUNT for book ');  -- При raise error откатывается текущая транзакция
    END IF;
END;
/

CREATE OR REPLACE TRIGGER check_book_price
BEFORE
    UPDATE OR INSERT OF price ON book
FOR EACH ROW
BEGIN
    IF (:new.price < 0) THEN
        DBMS_OUTPUT.PUT_LINE('TRIGGER check_book_price :: Book PRICE cannot be negative!!!');
        RAISE_APPLICATION_ERROR(-20000, ' RAISE ERROR :: no negative PRICE for book ');  -- При raise error откатывается текущая транзакция
    END IF;
END;
/

CREATE OR REPLACE TRIGGER book_actions_logger
BEFORE
    UPDATE OR INSERT OR DELETE ON book
FOR EACH ROW
BEGIN
    CASE
        WHEN INSERTING THEN
            DBMS_OUTPUT.PUT_LINE('INSERT :: to BOOK table' || ' book_id '|| :new.book_id || ', title '|| :new.title);
        WHEN UPDATING('PRICE') THEN
            DBMS_OUTPUT.PUT_LINE('UPDATE :: PRICE for BOOK_ID = ' || :new.book_id || ', OLD PRICE = ' || :old.price || ', NEW PRICE = ' || :new.price);
        WHEN UPDATING('AMOUNT') THEN
            DBMS_OUTPUT.PUT_LINE('UPDATE :: AMOUNT for BOOK_ID = ' || :new.book_id || ', OLD AMOUNT = ' || :old.amount || ', NEW AMOUNT = ' || :new.amount);
        WHEN DELETING THEN
            DBMS_OUTPUT.PUT_LINE('DELETE :: from BOOK where book_id =' || :old.book_id);
        ELSE
            DBMS_OUTPUT.PUT_LINE('UNKNOWN COMMAND executed with book_table');
    END CASE;
END;
/




CREATE OR REPLACE FUNCTION count_book_price_by_amount(v_book_id NUMBER, v_amount NUMBER) 
/* Считает цену книги по количеству */
RETURN NUMBER IS
    total_sum NUMBER;   
BEGIN
    SELECT price * v_amount INTO total_sum FROM book WHERE book_id = v_book_id;
    RETURN total_sum;
END;

/

-- посчитать выручку авторов по проданным книгам
CREATE OR REPLACE PROCEDURE getAuthorsSalary IS
    CURSOR getAuthors IS (SELECT author_id, name_author, surname_author FROM author);
    v_author getAuthors%ROWTYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE(rpad('- ', 10, ' ') || rpad('Книга', 30, ' ') || rpad('Заказали', 15, ' ')  || rpad('На сумму', 20, ' ') );
    DBMS_OUTPUT.PUT_LINE(rpad('_', 70, '_') );
    FOR v_author in getAuthors LOOP
        DBMS_OUTPUT.PUT_LINE(getAuthors%ROWCOUNT || ') ' || v_author.name_author || ' ' || v_author.surname_author );
        DECLARE CURSOR getBooks IS (SELECT title, book_id FROM book_author JOIN book using(book_id) where author_id = v_author.author_id);
                v_book getBooks%ROWTYPE;
                total_sold    NUMBER := 0;
        BEGIN
            FOR v_book in getBooks LOOP
                DECLARE CURSOR getOrdersByBook IS (SELECT SUM(amount)  
                                                        FROM book_order 
                                                    WHERE book_id = v_book.book_id 
                                                    GROUP BY book_id);
                v_book_amount NUMBER; 
                
                BEGIN
                    DBMS_OUTPUT.PUT(lpad(' ', 10, ' ') || rpad(v_book.title, 30, ' '));
                    OPEN getOrdersByBook;
                        LOOP
                            FETCH getOrdersByBook INTO v_book_amount;
                            EXIT WHEN getOrdersByBook%notfound;
                                DBMS_OUTPUT.PUT(rpad((v_book_amount||' шт'), 15, ' ') || count_book_price_by_amount(v_book.book_id, v_book_amount) || ' тг');
                                total_sold := total_sold + count_book_price_by_amount(v_book.book_id, v_book_amount);
                        END LOOP;
                        
                        IF(getOrdersByBook%ROWCOUNT = 0) THEN
                            DBMS_OUTPUT.PUT_LINE(rpad('0 шт', 15, ' ') || '0 тг');
                        ELSE
                            DBMS_OUTPUT.PUT_LINE('');
                        END IF;
                    CLOSE getOrdersByBook;
                END;
            END LOOP;
            DBMS_OUTPUT.PUT_LINE(chr(10) || lpad('Продано на сумму: ', 28, ' ') || ' ' || total_sold || ' тг ' || chr(10));
        END;
    END LOOP;
END;
/

EXEC getAuthorsSalary;



CREATE TABLE audit_pkg_log (
  date_of_action  DATE,
  user_id         VARCHAR2(20),
  package_name    VARCHAR2(30)
);
/

CREATE OR REPLACE PACKAGE BOOK_ADMIN_PKG AS
    -- Истанция книги
    TYPE book_record IS RECORD (book_id NUMBER, title VARCHAR2(50), price NUMBER, AMOUNT NUMBER);
    -- Курсор для показа книг по убыванию цены
    CURSOR price_desc_book RETURN book_record;
    
    -- Исключение неправильной цены
    invalid_book_price  EXCEPTION;
    -- Исключение неправильного количества
    invalid_book_amount EXCEPTION;
    
    -- Функция для добавления новой книги 
    FUNCTION add_new_book (
        title   VARCHAR2,
        price   NUMBER,
        amount  NUMBER
    ) RETURN NUMBER;
    
    -- Перезгрузка процедур
    PROCEDURE delete_book (title VARCHAR2);
    PROCEDURE delete_book (book_id NUMBER);
    

    PROCEDURE change_amount (book_id NUMBER, amount NUMBER);
    FUNCTION nth_highest_price (n NUMBER) RETURN book_record;
    
END BOOK_ADMIN_PKG;
/

-- Package body

CREATE OR REPLACE PACKAGE BODY BOOK_ADMIN_PKG AS
    number_of_books  NUMBER;  -- private variable, visible only in this package
 
    -- Define cursor declared in package specification:
    CURSOR price_desc_book RETURN book_record IS
        SELECT book_id, title, price, amount
        FROM book
        ORDER BY price DESC;
    
    -- Define PRIVATE function, available only inside package
    -- Цена книги соответствует действительности
    FUNCTION book_price_ok (price NUMBER) 
    RETURN BOOLEAN IS
    BEGIN
        RETURN price > 0;
    END book_price_ok;
    
    -- Количество книг соответствует действительности
    FUNCTION book_amount_ok (amount NUMBER) 
    RETURN BOOLEAN IS
    BEGIN
        RETURN amount >= 0 AND amount <= 1000000;
    END book_amount_ok;
    
    
    -- ФУНКЦИЯ для добавления новой книги
    FUNCTION add_new_book (
        title   VARCHAR2,
        price   NUMBER,
        amount  NUMBER
    ) RETURN NUMBER IS new_book_id NUMBER;
    BEGIN
        IF book_amount_ok(amount) AND book_price_ok(price) THEN
            INSERT INTO book (title, price, amount) 
            VALUES (add_new_book.title, add_new_book.price, add_new_book.amount);
        ELSIF book_amount_ok(amount) = FALSE THEN
            RAISE invalid_book_amount;
        ELSE 
            RAISE invalid_book_price;
        END IF;
       
        SELECT MAX(book_id) 
        INTO new_book_id 
        FROM book; -- Взять последнюю книгу
        
        DBMS_OUTPUT.PUT_LINE('Добавлена новая книга BOOK_ID = ' || TO_CHAR(new_book_id));     

        RETURN new_book_id;    
        
        EXCEPTION 
            WHEN  invalid_book_amount THEN
                DBMS_OUTPUT.PUT_LINE('EXCEPTION :: INVALID BOOK AMOUNT!');
            WHEN  invalid_book_price THEN
                DBMS_OUTPUT.PUT_LINE('EXCEPTION :: INVALID BOOK PRICE!');
            

    END add_new_book;
    
    -- ПЕРЕГРУЗКА ПРОЦЕДУР
    PROCEDURE delete_book (book_id NUMBER) IS
    BEGIN
        DELETE FROM book WHERE book_id = delete_book.book_id;
    END delete_book;
    
    PROCEDURE delete_book (title VARCHAR2) IS
    BEGIN
        DELETE FROM book WHERE title = delete_book.title;
    END delete_book;
    
    
    PROCEDURE change_amount (book_id NUMBER, amount NUMBER) IS
    BEGIN
        IF book_amount_ok(amount) THEN
            UPDATE book
            SET amount = change_amount.amount
            WHERE book_id = change_amount.book_id;
        ELSE
            RAISE invalid_book_amount;
        END IF;
        EXCEPTION WHEN invalid_book_amount THEN
            DBMS_OUTPUT.PUT_LINE ('Задано недействительное кол-во книг');
    END change_amount;
    
    -- Энная запись с наибольшей ценой по порядку
    FUNCTION nth_highest_price (n NUMBER) 
        RETURN book_record 
    IS
        book_rec book_record;
    BEGIN
        OPEN price_desc_book;
        FOR i IN 1..n LOOP
            FETCH price_desc_book INTO book_rec;
        END LOOP;
        CLOSE price_desc_book;
        RETURN book_rec;  -- Возращает энное кол-во записей
    END nth_highest_price;
    
    BEGIN  -- При исполнении любого запроса из пакета записываются логи, initialization part of package body
        INSERT INTO audit_pkg_log (date_of_action, user_id, package_name)
        VALUES (SYSDATE, USER, 'BOOK_ADMIN_PKG');
END;
/


-- ТЕСТИРУЕМ НОВЫЙ ПАКЕТ
DECLARE
    new_book_id NUMBER(6);
BEGIN
    new_book_id := BOOK_ADMIN_PKG.add_new_book(
        'new book title',
        1000,
        22
    );
    
    DBMS_OUTPUT.PUT_LINE('The book_id IS: ' || TO_CHAR(new_book_id));
    book_admin_pkg.change_amount(new_book_id, 99);

    DBMS_OUTPUT.PUT_LINE ('2-ая по рейтингу дорогая книга ' || 
                            to_char(book_admin_pkg.nth_highest_price(2).price) || ' называется: ' ||
                            to_char(book_admin_pkg.nth_highest_price(2).title));
                            
    book_admin_pkg.delete_book(new_book_id);
END;
/


-- select * from audit_pkg_log;


-- Изменить формат представления даты
ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MM-YYYY HH24:MI:SS';


-- Просмотр информации о пакетах в словаре данных
--SELECT TEXT FROM user_source WHERE NAME = 'BOOK_ADMIN_PKG' AND TYPE = 'PACKAGE BODY';
--SELECT TEXT FROM user_source WHERE NAME = 'BOOK_ADMIN_PKG' AND TYPE = 'PACKAGE';



/************************************        DDL TRIGGERS          ************************************/

-- Триггер на запрет удаления любых объектов из схемы пользователя book_admin

CREATE OR REPLACE TRIGGER drop_trigger 
   BEFORE DROP ON book_admin.SCHEMA 
   BEGIN
      RAISE_APPLICATION_ERROR (
         num => -20000,
         msg => 'RAISE_APPLICATION_ERROR :: Cannot drop any object from book_admin');
   END;
/
-- drop table book_admin.book;
/



/************************************        DML TRIGGERS          ************************************/

-- Когда удаляется какой либо жанр из таблицы жанров, 
-- присвоить книгам назначенный этот жанр NULL значения

CREATE OR REPLACE TRIGGER genre_set_null
  AFTER DELETE OR UPDATE OF genre_id ON genre
  FOR EACH ROW  -- для каждой строки

BEGIN
  IF UPDATING AND :OLD.genre_id != :NEW.genre_id OR DELETING THEN
    UPDATE book_genre SET book_genre.genre_id = NULL
    WHERE book_genre.genre_id = :OLD.genre_id;
  END IF;
END;
/

--select * from genre;  -- GENRE_ID = 2 WAS  
--update genre set genre_id = 14 where genre_id = 2;
--select * from book_genre;



/************************************        AUDIT TRIGGER         ************************************/

-- ТРИГГЕР НА АУДИТ ДЕЙСТВИЙ В ТАБЛИЦЕ BOOK

-- CREATE SEQUENCE for  table --
CREATE SEQUENCE audit_book_table_seq
    increment by 1
    start with 1
    maxvalue 99999
    minvalue 1
    nocycle;
/

---Создание таблицы 
CREATE TABLE audit_book_table(
    audit_id       NUMERIC DEFAULT audit_book_table_seq.NEXTVAL PRIMARY KEY,
    username       VARCHAR2(20),
    cur_date       DATE,
    terminal       VARCHAR2(20),
    table_name     VARCHAR(40),
    action         VARCHAR(20),
    v_old_value    VARCHAR(50),
    v_new_value    VARCHAR(50)
);                 
/

CREATE OR REPLACE TRIGGER audit_book
AFTER INSERT OR UPDATE OR DELETE ON book
FOR EACH ROW
DECLARE
    current_date DATE;
    terminal     VARCHAR2(20);
BEGIN
    current_date := SYSDATE;
    terminal     := USERENV('TERMINAL');
    -- При вставке значения
    IF INSERTING THEN
        INSERT INTO audit_book_table(username, cur_date, terminal, table_name, action, v_old_value, v_new_value)
        VALUES(user, current_date, terminal, 'BOOK', 'INSERT', null, :new.book_id);
    -- При Удалении значения
    ELSIF DELETING THEN
        INSERT INTO audit_book_table(username, cur_date, terminal, table_name, action, v_old_value, v_new_value)
        VALUES(user, current_date, terminal, 'BOOK', 'DELETE',  :old.book_id, null);
    -- При обновлении значения
    ELSIF UPDATING THEN
        INSERT INTO audit_book_table(username, cur_date, terminal, table_name, action, v_old_value, v_new_value)
        VALUES(user, current_date, terminal, 'BOOK', 'UPDATE',  :old.book_id, :new.book_id);
    END IF;
    
    IF UPDATING('title') THEN
        INSERT INTO audit_book_table(username, cur_date, terminal, table_name, action, v_old_value, v_new_value)
        VALUES(USER, current_date, terminal, 'BOOK', 'UPDATE BOOK TITLE',  :old.title, :new.title);
    ELSIF UPDATING('price') THEN
        INSERT INTO audit_book_table(username, cur_date, terminal, table_name, action, v_old_value, v_new_value)
        VALUES(USER, current_date, terminal, 'BOOK', 'UPDATE BOOK PRICE',  :old.price, :new.price);
    ELSIF UPDATING('amount') THEN
        INSERT INTO audit_book_table(username, cur_date, terminal, table_name, action, v_old_value, v_new_value)
        VALUES(USER, current_date, terminal, 'BOOK', 'UPDATE BOOK AMOUNT',  :old.amount, :new.amount);
    END IF;
    
END;
/

---- ТЕСТИРУЕМ ТРИГГЕР НА АУДИТ
--EXEC book_pkg.addnewbook('test', 1000, 30);
--EXEC book_pkg.updatebookprice(1, 1699);
--EXEC book_pkg.updatebookamount(1, 53);
--EXEC book_pkg.updatebookprice(1, -1699);  -- RAISE ERROR
--select * from audit_book_table;


-- Qualifiers - КВАЛИФИКАТОРЫ 

-- DELETE :OLD
-- INSERT :NEW
-- UPDATE :OLD, :NEW

CREATE TABLE book_price_audit_table(
    book_id NUMBER,
    title   VARCHAR(100),
    old_book_price NUMBER,
    new_book_price NUMBER
);


CREATE TRIGGER audit_book_price_trigger 
AFTER INSERT OR UPDATE OR UPDATE ON book
FOR EACH ROW
BEGIN
    INSERT INTO book_price_audit_table(book_id, title, old_book_price, new_book_price)
    VALUES (:new.book_id, :new.title, :old.price, :new.price);   
END;
/


--select * from book;
--EXEC book_pkg.updatebookprice(1, 1400);
--select * from book_price_audit_table;



/************************************        EVENT TRIGGER         ************************************/

-- ТРИГГЕРЫ СОБЫТИЙ
CREATE TABLE book_admin.db_events_table(
    v_sysevent          VARCHAR2(40),
    v_login_user        VARCHAR2(40),
    v_instance_num      VARCHAR2(40),
    v_database_name     VARCHAR2(40),
    v_sysdate           VARCHAR2(40)
);
/
-- drop table book_admin.db_events_table;
/

CONNECT SYS/123 as SYSDBA;
-- Триггер отслеживающий состояние базы данных
CREATE OR REPLACE TRIGGER db_state_events_trigger_startup
AFTER STARTUP ON DATABASE
BEGIN
     INSERT INTO book_admin.db_events_table VALUES
     (ora_sysevent, ora_login_user, ora_instance_num, ora_database_name, sysdate);
     DBMS_OUTPUT.PUT_LINE('DATABASE :: STARTED UP ');

END;
/
CREATE OR REPLACE TRIGGER db_state_events_trigger_shutdown
BEFORE SHUTDOWN ON DATABASE
BEGIN
     INSERT INTO book_admin.db_events_table VALUES
     (ora_sysevent, ora_login_user, ora_instance_num, ora_database_name, sysdate);
     DBMS_OUTPUT.PUT_LINE('DATABASE :: CLOSED ');
END;
/

-- select * from book_admin.db_events_table;

CONNECT book_admin/123;


-- AFTER LOGIN
CREATE TABLE login_table (
    username VARCHAR2(20),
    log_date DATE,
    action   VARCHAR2(100)  
);
/
CREATE OR REPLACE TRIGGER log_on_trigger
AFTER LOGON ON book_admin.SCHEMA
BEGIN
    INSERT INTO login_table(username, log_date, action) 
    VALUES(USER, SYSDATE, 'LOGGING ON');
END;
/

-- BEFORE LOGOFF
CREATE OR REPLACE TRIGGER log_off_trigger
BEFORE LOGOFF ON book_admin.SCHEMA
BEGIN
    INSERT INTO login_table(username, log_date, action) 
    VALUES(USER, SYSDATE, 'LOGGIN OFF');
END;
/

-- select * from login_table;