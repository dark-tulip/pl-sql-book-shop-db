-- Триггер вызывающий процедуру обновления цены во всех заказах при любом изменении в таблице книг

create or replace trigger price_stabilizer_trigger
    AFTER insert or update or delete on book
begin
    DBMS_OUTPUT.PUT_LINE(' ==================== NEW CHECK =================== ');
    book_order_pkg.main_orders_recounter; -- вызов процедуры
    
    DBMS_OUTPUT.PUT_LINE(' ==================== TRIGGER STABILIZED VALUES =================== ');
end;
/

-- Можно обновить цену используя проуедуру
--EXEC book_pkg.updatebookprice(1, 3333);   
--UPDATE BOOK SET PRICE = 4444 WHERE book_id = 1; -- Можно обновить цену стандартным SQL запросом

---- Таблицы зависимые от центы экземпляра книги - все они будут обновлены по действи. триггера
--select * from book ORDER BY book_id;
--select * from book_order where order_id = 1;
--select * from orders;