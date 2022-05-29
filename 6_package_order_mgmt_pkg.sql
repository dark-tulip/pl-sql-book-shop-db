/************************************** Пакет для авторасчета стоимости заказа (ORDER MANAGEMENT PACKAGE)  **************************************/

CREATE OR REPLACE PACKAGE book_order_pkg AS 

    FUNCTION create_new_order(client_id NUMBER, book_id NUMBER, amount NUMBER, clients_comment VARCHAR2) RETURN NUMBER;

    PROCEDURE update_amount_of_book_in_order(order_id NUMBER, book_id NUMBER, new_amount NUMBER);
    
    PROCEDURE add_new_book_to_order(order_id NUMBER, book_id NUMBER, amount NUMBER);
    
    PROCEDURE main_orders_recounter;


END book_order_pkg;
/

CREATE OR REPLACE PACKAGE BODY book_order_pkg AS 

    
    FUNCTION get_book_price_by_id(v_id IN NUMBER) 
    /* Функция чтобы получить по идентификатору цену книги */
    RETURN VARCHAR2 IS
        v_book_price NUMBER;
    BEGIN
        SELECT price INTO v_book_price FROM book
        WHERE book_id = v_id;
        
        RETURN v_book_price;

        EXCEPTION WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('get_book_price_by_id :: NO_DATA_FOUND :: Такой книги не существует');
            RAISE_APPLICATION_ERROR(-20000, ' :: EXCEPTION');
    END get_book_price_by_id;


    
    FUNCTION is_book_amount_ok(book_id NUMBER, amount NUMBER) 
    /* Количество книг соответствует действительности */
    
    RETURN BOOLEAN IS
        book_in_warehouse NUMBER; -- кол-во вниг на складе
    BEGIN
        SELECT amount 
            INTO book_in_warehouse 
            FROM book 
            WHERE book_id = is_book_amount_ok.book_id;  -- Вывести кол-во ЭТИХ книг со склада
        DBMS_OUTPUT.PUT_LINE('BOOK_ID = ' || is_book_amount_ok.book_id || '. Кол-во книг на складе: ' || book_in_warehouse);
        RETURN amount > 0 AND amount <= book_in_warehouse; 
    END is_book_amount_ok;



    FUNCTION create_new_order(client_id NUMBER, book_id NUMBER, amount NUMBER, clients_comment VARCHAR2) RETURN  
    /* Функция для создания нового заказа */

    NUMBER IS 
        new_order_id     NUMBER;
        total_book_price NUMBER;
    BEGIN

        -- Получить новый идентификатор
        SELECT MAX(order_id) + 1 INTO new_order_id FROM orders;
        total_book_price := get_book_price_by_id(create_new_order.book_id) * create_new_order.amount; -- Цена * Кол-во
        
        -- Добавить запись в таблицу
        INSERT INTO BOOK_ORDER (order_id, book_id, amount, price, product_discount)
        VALUES (new_order_id, create_new_order.book_id, create_new_order.amount, total_book_price, null);
        
        -- Добавить запись в таблицу заказов
        INSERT INTO ORDERS (order_id, order_comment, client_id, order_price)
        VALUES (new_order_id, create_new_order.clients_comment, create_new_order.client_id, total_book_price);
        
        RETURN new_order_id;
        
    END create_new_order;
    
    
    
    PROCEDURE add_new_book_to_order(order_id NUMBER, book_id NUMBER, amount NUMBER) AS 
        /* Процедура для добавления новой книги в корзину (заказ)  */

        v_order_id        NUMBER;
        v_book_id         NUMBER;
        total_book_price  NUMBER;
        total_order_price NUMBER;
    BEGIN
        -- Проверка существования заказа
        SELECT order_id INTO v_order_id from orders WHERE order_id = add_new_book_to_order.order_id;
        SELECT book_id  INTO v_book_id  FROM book   WHERE book_id  = add_new_book_to_order.book_id;

        total_book_price := get_book_price_by_id(v_book_id) * amount; -- вычисление общей цены по Цена * Кол-во

        -- Добавляем заказ в book_order
        INSERT INTO book_order (order_id, book_id, amount, price) 
        VALUES (v_order_id, v_book_id, add_new_book_to_order.amount, total_book_price);
        
        
        -- Вычисляем общую сумму чека + СКИДКА ПРОДУКТА
        SELECT SUM(PRICE + NVL(PRODUCT_DISCOUNT, 0) * PRICE) INTO total_order_price FROM book_order WHERE ORDER_ID = v_order_id;  
            
        -- Изменяем цену в общем заказе (корзине)
        UPDATE ORDERS SET order_price = total_order_price WHERE ORDER_ID = v_order_id;
        
        EXCEPTION WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('add_new_book_to_order :: Такого номера заказа или номера книги не существует!');
    END add_new_book_to_order;
    
    
    
    PROCEDURE update_amount_of_book_in_order(order_id NUMBER, book_id NUMBER, new_amount NUMBER) AS 
        /* Процедура для ОБНОВЛЕНИЯ кол-ва книг в корзине (заказ)  */
        v_order_id       NUMBER;
        v_book_id        NUMBER;
        total_book_price  NUMBER; -- Для вычисления кол-ва книг по цене книги в таблице BOOK_ORDER
        total_order_price NUMBER; -- Для Вычисления (обновления цены) в чеке полного заказа, таблица ORDER
    BEGIN
        -- Проверка существования заказа и книги
        SELECT order_id INTO v_order_id FROM orders     WHERE order_id = update_amount_of_book_in_order.order_id;
        SELECT book_id  INTO v_book_id  FROM book       WHERE book_id  = update_amount_of_book_in_order.book_id;

        -- ЕСЛИ КНИГ достаточно на складе и кол-во книг валидное
        IF (is_book_amount_ok(v_book_id, new_amount)) THEN
            total_book_price := get_book_price_by_id(v_book_id) * new_amount; -- вычисление общей цены по Цена * Кол-во
    
            -- Добавляем заказ в book_order
            UPDATE book_order SET amount = new_amount       WHERE order_id = v_order_id AND book_id = v_book_id;
            UPDATE book_order SET price  = total_book_price WHERE order_id = v_order_id AND book_id = v_book_id;
            
            -- Вычисляем общую сумму чека + СКИДКА ПРОДУКТА
            SELECT SUM(PRICE + NVL(PRODUCT_DISCOUNT, 0) * PRICE) INTO total_order_price FROM book_order WHERE ORDER_ID = v_order_id;  
            
            -- Изменяем цену в общем заказе (корзине)
            UPDATE ORDERS SET order_price = total_order_price WHERE ORDER_ID = v_order_id;
        ELSE 
            DBMS_OUTPUT.PUT_LINE('НЕДОСТАТОЧНО КНИГ :: Такого кол-ва книг не найдено на складе');
        END IF;
        EXCEPTION WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('update_amount_of_book_in_order :: Такого номера заказа или книги не существует');
        
    END update_amount_of_book_in_order;


    PROCEDURE main_orders_recounter AS
        CURSOR order_cursor IS (SELECT order_id, client_discount from orders); 
        v_order order_cursor%ROWTYPE;
        v_order_price NUMBER := 0;
    BEGIN
        FOR v_order in order_cursor LOOP
            DBMS_OUTPUT.PUT_LINE('Заказ № ' || v_order.order_id);

            DECLARE 
                total_book_price_by_amount NUMBER := 0;
                CURSOR book_order_cursor IS (SELECT book_id, amount, product_discount FROM book_order WHERE order_id = v_order.order_id); 
                v_book_order book_order_cursor%ROWTYPE;
            BEGIN
                FOR v_book_order in book_order_cursor LOOP
                    -- Общая цена книги по количеству
                    total_book_price_by_amount := get_book_price_by_id(v_book_order.book_id) * v_book_order.AMOUNT;
                    -- Общая цена книги по количеству с учетом скидки
                    total_book_price_by_amount := total_book_price_by_amount - total_book_price_by_amount * NVL(v_book_order.product_discount, 0) / 100;
                        
                    DBMS_OUTPUT.PUT_LINE(rpad('   Цена книги по кол-ву: ' || total_book_price_by_amount, 40, ' ') || 
                                         rpad(' BOOK_ID: ' || v_book_order.book_id, 15, ' ') || 
                                         rpad(' AMOUNT: '  || v_book_order.amount, 15, ' '));

                    UPDATE book_order SET PRICE = total_book_price_by_amount
                        WHERE ORDER_ID = v_order.order_id AND book_id = v_book_order.book_id;  -- Сумма заказа по кол-ву по книге и скидке продукта
                    v_order_price := v_order_price + total_book_price_by_amount; -- Общая сумма заказа
                END LOOP;
            END; 
            
            -- Учесть скидку клиента
            v_order_price := v_order_price - v_order_price * v_order.client_discount / 100;
            -- Обновить общую сумму заказа
            UPDATE ORDERS SET ORDER_PRICE = v_order_price WHERE ORDER_ID = v_order.order_id;
            DBMS_OUTPUT.PUT_LINE(rpad('Итог: ' || v_order_price, 40, ' '));
            DBMS_OUTPUT.PUT_LINE(rpad('*', 70, '*'));

            v_order_price:= 0; -- Обнулить переменную для следующей итерации
            
        END LOOP;
        
    END main_orders_recounter;


END book_order_pkg;
/


--select * from book_order;
--select * from book;
--EXEC book_order_pkg.add_new_book_to_order(order_id=>2,book_id=>1,amount=>3);
--EXEC book_order_pkg.update_amount_of_book_in_order(1, 8, 10);
--EXEC book_order_pkg.main_orders_recounter;
--select * from orders;