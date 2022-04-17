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
