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
    END CASE;
END;
/

-- delete from book where book_id = 42;
-- update book set price = 1600 where book_id = 57;


-- exec book_pkg.addNewBook('test12', 1, 100);
-- exec book_pkg.updatebookamount(57, 2);

-- SELECT * from book;


-- select book_pkg.getGenreNameByID(genre_id) from genre;

-- exec book_pkg.addNewGenre('test2');
-- exec book_pkg.addNewAuthor('test_name2', 'test_sur2', 'test2');
-- exec book_pkg.addNewBook('newBook22', 1000, 76);

-- select * from author;
-- exec book_pkg.show_order_by_author_surname('Булгаков');
-- select * from book;

-- select * from v$datafile;