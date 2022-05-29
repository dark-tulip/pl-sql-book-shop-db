/*****  STARTED TO CREATE PACKAGES *********/

CREATE OR REPLACE PACKAGE book_pkg AS 
    PROCEDURE show_order_by_author_surname(author_surname VARCHAR2);
    
    FUNCTION getGenreNameByID   (v_id IN NUMBER) RETURN VARCHAR2;
    FUNCTION getBookNameByID    (v_id IN NUMBER)       RETURN VARCHAR2;
    FUNCTION getAuthorNameByID  (v_id IN NUMBER)       RETURN VARCHAR2;
    FUNCTION getClientNameByID  (v_id IN NUMBER)       RETURN VARCHAR2;
    FUNCTION getCityNameByID    (v_id IN NUMBER)       RETURN VARCHAR2;

    PROCEDURE addNewGenre       (genre_name IN VARCHAR2);
    PROCEDURE addNewAuthor      (author_name IN VARCHAR2, author_surname IN VARCHAR2, author_othc IN VARCHAR2);
    PROCEDURE addNewBook        (book_title IN VARCHAR2, price NUMBER, amount NUMBER);
    
    PROCEDURE updateBookAmount  (v_book_id IN VARCHAR2, new_amount IN NUMBER);
    PROCEDURE updateBookPrice   (v_book_id IN VARCHAR2, new_price IN NUMBER);

END book_pkg; 
/


CREATE OR REPLACE PACKAGE BODY book_pkg AS 


FUNCTION getGenreNameByID(v_id IN NUMBER) 
/* Функция чтобы получить по идентификатору название */
RETURN VARCHAR2 IS
    v_genre_name VARCHAR2(50);
BEGIN
    SELECT name_genre INTO v_genre_name FROM genre
    WHERE genre_id = v_id;
RETURN v_genre_name;
END;


FUNCTION getBookNameByID(v_id IN NUMBER) 
/* Функция чтобы получить по идентификатору название */
RETURN VARCHAR2 IS
    v_book_name VARCHAR2(50);
BEGIN
    SELECT title INTO v_book_name FROM book
    WHERE book_id = v_id;
RETURN v_book_name;
END;


FUNCTION getAuthorNameByID(v_id IN NUMBER) 
/* Функция чтобы получить по идентификатору название */
RETURN VARCHAR2 IS
    v_author_name VARCHAR2(50);
BEGIN
    SELECT name_author INTO v_author_name FROM author
    WHERE author_id = v_id;
RETURN v_author_name;
END;


FUNCTION getCityNameByID(v_id IN NUMBER) 
/* Функция чтобы получить по идентификатору название */
RETURN VARCHAR2 IS
    v_name VARCHAR2(50);
BEGIN
    SELECT name_city INTO v_name FROM city
    WHERE city_id = v_id;
RETURN v_name;
END;


FUNCTION getClientNameByID(v_id IN NUMBER) 
/* Функция чтобы получить по идентификатору название */
RETURN VARCHAR2 IS
    v_name VARCHAR2(60);
BEGIN
    SELECT (name_client || ' ' ||surname_client) INTO v_name FROM client
    WHERE client_id = v_id;
RETURN v_name;
END;


-- ПРОЦЕДУРА Вывести клиентов, которые заказывали книги определенного автора.
PROCEDURE show_order_by_author_surname(author_surname VARCHAR2) IS

    CURSOR getOrdersByAuthor IS (
        SELECT
            order_id,
            title,
            client_id,
            author_id
        FROM
            orders
            INNER JOIN book_order USING ( order_id )
            INNER JOIN book USING ( book_id )
            INNER JOIN book_author USING ( book_id )
        WHERE
            author_id = (
                SELECT author_id
                FROM   author
                WHERE  surname_author = show_order_by_author_surname.author_surname
            )
        );
        v_ord getOrdersByAuthor%ROWTYPE;
    BEGIN
        DBMS_OUTPUT.PUT_LINE(rpad('Order ID', 10, ' ') || rpad('BOOK TITLE' , 30, ' ')|| rpad('CLIENT NAME', 30, ' '));

        FOR v_ord in getOrdersByAuthor LOOP
            DBMS_OUTPUT.PUT_LINE(rpad(v_ord.order_id, 10, ' ') || rpad(v_ord.title , 30, ' ')|| rpad(getClientNameByID(v_ord.client_id), 30, ' '));
        END LOOP;

    END;


PROCEDURE addNewGenre(genre_name IN VARCHAR2) IS
v_genre_name VARCHAR(50);
BEGIN
    
    SELECT name_genre INTO v_genre_name FROM genre WHERE name_genre = genre_name;
    DBMS_OUTPUT.PUT_LINE('Value ' || genre_name || ' already exists!');

    EXCEPTION WHEN NO_DATA_FOUND THEN
        INSERT INTO GENRE(NAME_GENRE) VALUES(genre_name);
        DBMS_OUTPUT.PUT_LINE('Value ' || genre_name || ' added successful');
END;


PROCEDURE addNewAuthor(author_name IN VARCHAR2, author_surname IN VARCHAR2, author_othc IN VARCHAR2) IS
full_name VARCHAR(80);
BEGIN
    
    SELECT (NAME_AUTHOR || ' ' || SURNAME_AUTHOR || ' ' || OTHC_AUTHOR) INTO full_name 
            FROM author 
            WHERE NAME_AUTHOR = author_name and 
                  SURNAME_AUTHOR = author_surname and
                  OTHC_AUTHOR = author_othc;
                  
    DBMS_OUTPUT.PUT_LINE('Value ' || full_name || ' already exists!');

    EXCEPTION WHEN NO_DATA_FOUND THEN
        INSERT INTO author(NAME_AUTHOR, SURNAME_AUTHOR, OTHC_AUTHOR) VALUES(author_name, author_surname, author_othc);
        DBMS_OUTPUT.PUT_LINE('Value ' || author_name || ' ' || author_surname || ' ' || author_othc || ' added successful');
END;


PROCEDURE addNewBook(book_title IN VARCHAR2, price NUMBER, amount NUMBER) IS
v_title VARCHAR(80);
BEGIN
    SELECT title INTO v_title 
            FROM book 
            WHERE book_title = title;
                  
    DBMS_OUTPUT.PUT_LINE('Value ' || v_title || ' already exists!');

    EXCEPTION WHEN NO_DATA_FOUND THEN
        INSERT INTO book(TITLE, PRICE, AMOUNT) VALUES(book_title, price, amount);
        DBMS_OUTPUT.PUT_LINE('Value ' || book_title || ' ' || price || '$ ' || amount || 'pcs. added successful');
END;


    
PROCEDURE updateBookAmount(v_book_id IN VARCHAR2, new_amount IN NUMBER) IS
BEGIN
    UPDATE book
        SET   amount = new_amount 
        WHERE book_id = v_book_id;
            
    IF SQL%NOTFOUND THEN 
        DBMS_OUTPUT.PUT_LINE('Book not found!');
    ELSE
        DBMS_OUTPUT.PUT_LINE('UPDATE :: amount of book_id ' || v_book_id || ' updated to ' || new_amount);
    END IF;

END;

PROCEDURE updateBookPrice(v_book_id IN VARCHAR2, new_price IN NUMBER) IS
BEGIN
    UPDATE book
        SET   price = new_price 
        WHERE book_id = v_book_id;
            
    IF SQL%NOTFOUND THEN 
        DBMS_OUTPUT.PUT_LINE('Book not found!');
    ELSE
        DBMS_OUTPUT.PUT_LINE('UPDATE :: PRICE of book_id ' || v_book_id || ' updated to ' || new_price);
    END IF;

END;


END book_pkg; 
/