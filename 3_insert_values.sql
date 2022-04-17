----------------------- ЗАПОЛНЯЕМ ТАБЛИЦУ АВТОРЫ  -----------------------

INSERT INTO author (surname_author, name_author, othc_author) VALUES ('Булгаков', 'Михаил', 'Афанасьевич');
INSERT INTO author (surname_author, name_author, othc_author) VALUES ('Достоевский', 'Фёдор', 'Михайлович');
INSERT INTO author (surname_author, name_author, othc_author) VALUES ('Есенин', 'Сергей', 'Александрович');
INSERT INTO author (surname_author, name_author, othc_author) VALUES ('Пастернак', 'Борис', 'Леонидович');
INSERT INTO author (surname_author, name_author, othc_author) VALUES ('Лермонтов', 'Михаил', 'Юрьевич');
INSERT INTO author (surname_author, name_author, othc_author) VALUES ('Лондон', 'Джек', null);
INSERT INTO author (surname_author, name_author, othc_author) VALUES ('Пушкин', 'Александр', 'Сергеевич');
INSERT INTO author (surname_author, name_author, othc_author) VALUES ('Джейн', 'Остин', null);
INSERT INTO author (surname_author, name_author, othc_author) VALUES ('Пауло', 'Коэльо', null);

select * from author;

----------------------- ЗАПОЛНЯЕМ ТАБЛИЦУ ЖАНРЫ  -----------------------

-- CREATE SEQUENCE for genre table --
create sequence genre_seq
    increment by 1
    start with 1
    maxvalue 99999
    minvalue 1
    nocycle;
    
-- Получить следующее значение из последовательности
-- select genre_seq.nextval from dual; 

-- Удаляем таблицу чтоьбы пересозадть с последовательностью
DROP TABLE genre CASCADE CONSTRAINTS PURGE; 
--DROP sequence genre_seq;

---Создание таблицы GENRE - жанры
CREATE TABLE genre
(
		genre_id   NUMERIC DEFAULT genre_seq.NEXTVAL PRIMARY KEY,
		name_genre NVARCHAR2(30)
);


-- Для генерации следующего значения первичного ключа
-- Можно для столбца genre_id давать знаечние как genre_seq.nextval 
INSERT INTO genre(name_genre) VALUES('Роман');
INSERT INTO genre(name_genre) VALUES('Поэзия');
INSERT INTO genre(name_genre) VALUES('Приключения');
INSERT INTO genre(name_genre) VALUES('Фантастика');
INSERT INTO genre(name_genre) VALUES('Деловая литература');
INSERT INTO genre(name_genre) VALUES('Художественная литература');
INSERT INTO genre(name_genre) VALUES('Наука');
INSERT INTO genre(name_genre) VALUES('Сказки');
INSERT INTO genre(name_genre) VALUES('Проза');
INSERT INTO genre(name_genre) VALUES('Детская литература');
INSERT INTO genre(name_genre) VALUES('Учебники');

select * from genre;


----------------------- ЗАПОЛНЯЕМ ТАБЛИЦУ КНИГИ  -----------------------

INSERT INTO book(title, price, amount) VALUES ('Мастер и Маргарита', 670.99, 3);
INSERT INTO book(title, price, amount) VALUES ('Белая гвардия', 540.50, 5);
INSERT INTO book(title, price, amount) VALUES ('Идиот', 460.00, 10);
INSERT INTO book(title, price, amount) VALUES ('Братья Карамазовы', 799.01, 2);
INSERT INTO book(title, price, amount) VALUES ('Игрок', 480.50, 10);
INSERT INTO book(title, price, amount) VALUES ('Стихотворения и поэмы', 650.00, 15);
INSERT INTO book(title, price, amount) VALUES ('Черный человек', 570.20, 6);
INSERT INTO book(title, price, amount) VALUES ('Лирика', 518.99, 2);
INSERT INTO book(title, price, amount) VALUES ('Победитель остается один', 2133, 100);
INSERT INTO book(title, price, amount) VALUES ('Алхимик', 2666, 24);
INSERT INTO book(title, price, amount) VALUES ('Встречи. Ежедневник на 2021', 5336, 14);
INSERT INTO book(title, price, amount) VALUES ('Манускрипт, найденный в Акко', 1438, 33);
INSERT INTO book(title, price, amount) VALUES ('Книга воина света', 1438, 22);
INSERT INTO book(title, price, amount) VALUES ('Валькирии', 1438, 7);
INSERT INTO book(title, price, amount) VALUES ('Алеф', 2354, 48);
INSERT INTO book(title, price, amount) VALUES ('Морфий', 766, 108);
INSERT INTO book(title, price, amount) VALUES ('Собачье сердце', 1054, 66);
INSERT INTO book(title, price, amount) VALUES ('Белая гвардия', 731, 47);
INSERT INTO book(title, price, amount) VALUES ('Евгений Онегин', 755, 32);
INSERT INTO book(title, price, amount) VALUES ('Станционный смотритель', 428, 28);
INSERT INTO book(title, price, amount) VALUES ('Капитанская дочка', 4186, 25);
INSERT INTO book(title, price, amount) VALUES ('Дубровский', 1120, 98);
INSERT INTO book(title, price, amount) VALUES ('Герой нашего времени', 1338, 33);
INSERT INTO book(title, price, amount) VALUES ('Малое собрание сочинений', 2038, 24);
INSERT INTO book(title, price, amount) VALUES ('Маленькие трагедии', 502, 12);
INSERT INTO book(title, price, amount) VALUES ('Метель', 428, 46);
INSERT INTO book(title, price, amount) VALUES ('Медный всадник', 901, 10);
INSERT INTO book(title, price, amount) VALUES ('Руслан и Людмила', 715, 9);
INSERT INTO book(title, price, amount) VALUES ('Гордость и предубеждение', 930, 60);

select * from book;

----------------------- ЗАПОЛНЯЕМ ТАБЛИЦУ ШАГИ ПОКУПКИ  -----------------------

INSERT INTO step(name_step) VALUES ('Оплата');
INSERT INTO step(name_step) VALUES ('Упаковка');
INSERT INTO step(name_step) VALUES ('Транспортировка');
INSERT INTO step(name_step) VALUES ('Доставка');

select * from step;

----------------------- ЗАПОЛНЯЕМ ТАБЛИЦУ BOOK-GENRE - жанры книг  -----------------------

INSERT INTO book_genre (book_id, genre_id) VALUES (1, 1);
INSERT INTO book_genre (book_id, genre_id) VALUES (2, 1);
INSERT INTO book_genre (book_id, genre_id) VALUES (3, 1);
INSERT INTO book_genre (book_id, genre_id) VALUES (4, 1);
INSERT INTO book_genre (book_id, genre_id) VALUES (5, 1);
INSERT INTO book_genre (book_id, genre_id) VALUES (6, 2);
INSERT INTO book_genre (book_id, genre_id) VALUES (7, 2);
INSERT INTO book_genre (book_id, genre_id) VALUES (8, 2);
INSERT INTO book_genre (book_id, genre_id) VALUES (9, 9);
INSERT INTO book_genre (book_id, genre_id) VALUES (10, 9);
INSERT INTO book_genre (book_id, genre_id) VALUES (11, 9);
INSERT INTO book_genre (book_id, genre_id) VALUES (12, 9);
INSERT INTO book_genre (book_id, genre_id) VALUES (13, 9);
INSERT INTO book_genre (book_id, genre_id) VALUES (14, 9);
INSERT INTO book_genre (book_id, genre_id) VALUES (15, 9);
INSERT INTO book_genre (book_id, genre_id) VALUES (16, 6);
INSERT INTO book_genre (book_id, genre_id) VALUES (17, 6);
INSERT INTO book_genre (book_id, genre_id) VALUES (18, 6);
INSERT INTO book_genre (book_id, genre_id) VALUES (19, 6);
INSERT INTO book_genre (book_id, genre_id) VALUES (20, 9);
INSERT INTO book_genre (book_id, genre_id) VALUES (21, 9);
INSERT INTO book_genre (book_id, genre_id) VALUES (22, 9);
INSERT INTO book_genre (book_id, genre_id) VALUES (23, 9);
INSERT INTO book_genre (book_id, genre_id) VALUES (24, 6);
INSERT INTO book_genre (book_id, genre_id) VALUES (25, 6);
INSERT INTO book_genre (book_id, genre_id) VALUES (26, 6);
INSERT INTO book_genre (book_id, genre_id) VALUES (27, 9);
INSERT INTO book_genre (book_id, genre_id) VALUES (28, 2);
INSERT INTO book_genre (book_id, genre_id) VALUES (29, 6);

select * from book_genre;

----------------------- ЗАПОЛНЯЕМ ТАБЛИЦУ BOOK-GENRE - авторы книг  -----------------------

INSERT INTO book_author(book_id, author_id) VALUES (1, 1);
INSERT INTO book_author(book_id, author_id) VALUES (2, 1);
INSERT INTO book_author(book_id, author_id) VALUES (3, 2);
INSERT INTO book_author(book_id, author_id) VALUES (4, 2);
INSERT INTO book_author(book_id, author_id) VALUES (5, 2);
INSERT INTO book_author(book_id, author_id) VALUES (6, 3);
INSERT INTO book_author(book_id, author_id) VALUES (7, 3);
INSERT INTO book_author(book_id, author_id) VALUES (8, 3);
INSERT INTO book_author(book_id, author_id) VALUES (9, 9);
INSERT INTO book_author(book_id, author_id) VALUES (10, 9);
INSERT INTO book_author(book_id, author_id) VALUES (11, 9);
INSERT INTO book_author(book_id, author_id) VALUES (12, 9);
INSERT INTO book_author(book_id, author_id) VALUES (13, 9);
INSERT INTO book_author(book_id, author_id) VALUES (14, 9);
INSERT INTO book_author(book_id, author_id) VALUES (15, 9);
INSERT INTO book_author(book_id, author_id) VALUES (16, 1);
INSERT INTO book_author(book_id, author_id) VALUES (17, 1);
INSERT INTO book_author(book_id, author_id) VALUES (18, 1);
INSERT INTO book_author(book_id, author_id) VALUES (19, 7);
INSERT INTO book_author(book_id, author_id) VALUES (20, 7);
INSERT INTO book_author(book_id, author_id) VALUES (21, 7);
INSERT INTO book_author(book_id, author_id) VALUES (22, 7);
INSERT INTO book_author(book_id, author_id) VALUES (23, 7);
INSERT INTO book_author(book_id, author_id) VALUES (24, 7);
INSERT INTO book_author(book_id, author_id) VALUES (25, 7);
INSERT INTO book_author(book_id, author_id) VALUES (26, 7);
INSERT INTO book_author(book_id, author_id) VALUES (27, 7);
INSERT INTO book_author(book_id, author_id) VALUES (28, 7);
INSERT INTO book_author(book_id, author_id) VALUES (29, 8);

----------------------- ЗАПОЛНЯЕМ ТАБЛИЦУ ГОРОДА -----------------------

INSERT INTO city(name_city) VALUES ('Алматы');
INSERT INTO city(name_city) VALUES ('Астана');
INSERT INTO city(name_city) VALUES ('Шымкент');
INSERT INTO city(name_city) VALUES ('Тараз');
INSERT INTO city(name_city) VALUES ('Талдыкорган');
INSERT INTO city(name_city) VALUES ('Кызылорда');
INSERT INTO city(name_city) VALUES ('Караганда');
INSERT INTO city(name_city) VALUES ('Актау');
INSERT INTO city(name_city) VALUES ('Атырау');
INSERT INTO city(name_city) VALUES ('Семей');

----------------------- ЗАПОЛНЯЕМ ТАБЛИЦУ УЛИЦЫ  -----------------------

INSERT INTO street(street_name) VALUES ('Талапты'); 
INSERT INTO street(street_name) VALUES ('Ынтымак');
INSERT INTO street(street_name) VALUES ('Достык');
INSERT INTO street(street_name) VALUES ('Шевченко');
INSERT INTO street(street_name) VALUES ('Жандосова');
INSERT INTO street(street_name) VALUES ('Тимирязева');
INSERT INTO street(street_name) VALUES ('Саина');
INSERT INTO street(street_name) VALUES ('Байтурсынова');
INSERT INTO street(street_name) VALUES ('Самал-3');
INSERT INTO street(street_name) VALUES ('микрорайон-3');
INSERT INTO street(street_name) VALUES ('микрорайон-1');
INSERT INTO street(street_name) VALUES ('микрорайон-2');
INSERT INTO street(street_name) VALUES ('микрорайон-4');
INSERT INTO street(street_name) VALUES ('микрорайон-5');
INSERT INTO street(street_name) VALUES ('микрорайон-6');

commit;
/*****************************************************************/
-- IF YOU HAVE AN ERROR ORA-01658: не могу создать INITIAL экстент для сегмента в разделе PERM_TS
-- USE THIS from sys
CONNECT sys/123 as sysdba;

ALTER DATABASE 
    DATAFILE 'perm_1.dbf'
    AUTOEXTEND ON
    MAXSIZE UNLIMITED;
/*****************************************************************/

CONNECT book_admin/123;

----------------------- ЗАПОЛНЯЕМ ТАБЛИЦУ ТОЧКИ ДОСТАВКИ  -----------------------

INSERT INTO delivery_point(city_id, street_id, home_number) VALUES (1, 6, 34);
INSERT INTO delivery_point(city_id, street_id, home_number) VALUES (1, 7, 34);
INSERT INTO delivery_point(city_id, street_id, home_number) VALUES (2, 3, 15);
INSERT INTO delivery_point(city_id, street_id, home_number) VALUES (2, 2, 15);
INSERT INTO delivery_point(city_id, street_id, home_number) VALUES (3, 2, 15);
INSERT INTO delivery_point(city_id, street_id, home_number) VALUES (3, 8, 15);
INSERT INTO delivery_point(city_id, street_id, home_number) VALUES (4, 9, 15);
INSERT INTO delivery_point(city_id, street_id, home_number) VALUES (5, 1, 15);
INSERT INTO delivery_point(city_id, street_id, home_number) VALUES (6, 1, 15);
INSERT INTO delivery_point(city_id, street_id, home_number) VALUES (4, 2, 15);
INSERT INTO delivery_point(city_id, street_id, home_number) VALUES (3, 2, 15);
INSERT INTO delivery_point(city_id, street_id, home_number) VALUES (2, 6, 15);
INSERT INTO delivery_point(city_id, street_id, home_number) VALUES (7, 4, 15);
INSERT INTO delivery_point(city_id, street_id, home_number) VALUES (8, 3, 15);
INSERT INTO delivery_point(city_id, street_id, home_number) VALUES (4, 7, 15);
INSERT INTO delivery_point(city_id, street_id, home_number) VALUES (3, 7, 15);
INSERT INTO delivery_point(city_id, street_id, home_number) VALUES (1, 8, 15);
INSERT INTO delivery_point(city_id, street_id, home_number) VALUES (1, 2, 15);
INSERT INTO delivery_point(city_id, street_id, home_number) VALUES (2, 9, 15);

select * from delivery_point;

----------------------- ЗАПОЛНЯЕМ ТАБЛИЦУ СПОСОБЫ ДОСТАВКИ  -----------------------

INSERT INTO delivery_type(delivery_type_name) VALUES ('Доставка');
INSERT INTO delivery_type(delivery_type_name) VALUES ('Самовывоз');
INSERT INTO delivery_type(delivery_type_name) VALUES ('Почта');

select * from delivery_type;

----------------------- ЗАПОЛНЯЕМ ТАБЛИЦУ КЛИЕНТЫ -----------------------

INSERT INTO client (name_client, surname_client, email_clinet, phone_client, password_client, client_discount, city_id, street_id)
    VALUES ('Павел', 'Никитин',  'baranov@test', '77776453524', 'password', NULL, 1, 2);
INSERT INTO client (name_client, surname_client, email_clinet, phone_client, password_client, client_discount, city_id, street_id)
    VALUES ('Катя', 'Ян', 'abramova@test', '77776445524', 'password', NULL, 2, 2);
INSERT INTO client (name_client, surname_client, email_clinet, phone_client, password_client, client_discount, city_id, street_id)
    VALUES ('Иван', 'Лопатков', 'semenov@test', '77776445524', 'password', NULL, 3, 5);
INSERT INTO client (name_client, surname_client, email_clinet, phone_client, password_client, client_discount, city_id, street_id)
    VALUES ('Галина', 'Сервеевна', 'galin@test', '77776445524', 'password', NULL, 4, 6);
INSERT INTO client (name_client, surname_client, email_clinet, phone_client, password_client, client_discount, city_id, street_id)
    VALUES ('Алина', 'Андреева', 'nikitovna@test', '77776445524', 'password', NULL, 1, 7);
INSERT INTO client (name_client, surname_client, email_clinet, phone_client, password_client, client_discount, city_id, street_id)
    VALUES ('Никита', 'Андреев', 'nikita@test', '77776445524', 'password', NULL, 2, 1);
INSERT INTO client (name_client, surname_client, email_clinet, phone_client, password_client, client_discount, city_id, street_id)
    VALUES ('Анастасия', 'Васильевна', 'anastasiya@test', '77776445524', 'password', NULL, 2, 1);
INSERT INTO client (name_client, surname_client, email_clinet, phone_client, password_client, client_discount, city_id, street_id)
    VALUES ('Ксения', 'Веселькова', 'kcenya@test', '77776445524', 'password', NULL, 5, 2);
INSERT INTO client (name_client, surname_client, email_clinet, phone_client, password_client, client_discount, city_id, street_id)
    VALUES ('Варвара', 'Барышева', 'varvara@test', '77776445524', 'password', NULL, 6, 4);
INSERT INTO client (name_client, surname_client, email_clinet, phone_client, password_client, client_discount, city_id, street_id)
    VALUES ('Ирина', 'irina@test', 'irinka@test', '77776445524', 'password', NULL, 3, 3);
INSERT INTO client (name_client, surname_client, email_clinet, phone_client, password_client, client_discount, city_id, street_id)
    VALUES ('Алла', 'Андреева',  'allochka04@test', '77776445524', 'password', NULL, 2, 5);
INSERT INTO client (name_client, surname_client, email_clinet, phone_client, password_client, client_discount, city_id, street_id)
    VALUES ('Екатерина', 'Шелкова',  'pavel@test', '77776555524', 'password', NULL, 1, 1);
INSERT INTO client (name_client, surname_client, email_clinet, phone_client, password_client, client_discount, city_id, street_id)
    VALUES ('Арина', 'Махмудина',  'arinka@test', '77776499524', 'password', NULL, 1, 1);
INSERT INTO client (name_client, surname_client, email_clinet, phone_client, password_client, client_discount, city_id, street_id)
    VALUES ('Павел', 'Никитин',  'baranov@test', '777777453524', 'password', NULL, 1, 2);
INSERT INTO client (name_client, surname_client, email_clinet, phone_client, password_client, client_discount, city_id, street_id)
    VALUES ('Катя', 'Ян', 'abramova@test', '77776441124', 'password', NULL, 2, 2);
INSERT INTO client (name_client, surname_client, email_clinet, phone_client, password_client, client_discount, city_id, street_id)
    VALUES ('Иван', 'Лопатков', 'semenov@test', '77976445524', 'password', NULL, 3, 5);
INSERT INTO client (name_client, surname_client, email_clinet, phone_client, password_client, client_discount, city_id, street_id)
    VALUES ('Галина', 'Сервеевна', 'galin@test', '77976445524', 'password', NULL, 4, 6);
INSERT INTO client (name_client, surname_client, email_clinet, phone_client, password_client, client_discount, city_id, street_id)
    VALUES ('Алина', 'Андреева', 'nikitovna@test', '77796445524', 'password', NULL, 1, 7);
INSERT INTO client (name_client, surname_client, email_clinet, phone_client, password_client, client_discount, city_id, street_id)
    VALUES ('Никита', 'Андреев', 'nikita@test', '77776495524', 'password', NULL, 2, 1);
INSERT INTO client (name_client, surname_client, email_clinet, phone_client, password_client, client_discount, city_id, street_id)
    VALUES ('Анастасия', 'Васильевна', 'anastasiya@test', '77776445524', 'password', NULL, 2, 1);
INSERT INTO client (name_client, surname_client, email_clinet, phone_client, password_client, client_discount, city_id, street_id)
    VALUES ('Ксения', 'Веселькова', 'kcenya@test', '77776445524', 'password', NULL, 5, 2);
INSERT INTO client (name_client, surname_client, email_clinet, phone_client, password_client, client_discount, city_id, street_id)
    VALUES ('Варвара', 'Барышева', 'varvara@test', '5555555555', 'password', NULL, 6, 4);
INSERT INTO client (name_client, surname_client, email_clinet, phone_client, password_client, client_discount, city_id, street_id)
    VALUES ('Ирина', 'irina@test', 'irinka@test', '77776466524', 'password', NULL, 3, 3);
INSERT INTO client (name_client, surname_client, email_clinet, phone_client, password_client, client_discount, city_id, street_id)
    VALUES ('Алла', 'Андреева',  'allochka04@test', '77976445524', 'password', NULL, 2, 5);
INSERT INTO client (name_client, surname_client, email_clinet, phone_client, password_client, client_discount, city_id, street_id)
    VALUES ('Екатерина', 'Шелкова',  'pavel@test', '97776445524', 'password', NULL, 1, 1);
INSERT INTO client (name_client, surname_client, email_clinet, phone_client, password_client, client_discount, city_id, street_id)
    VALUES ('Арина', 'Махмудина',  'arinka@test', '77766445524', 'password', NULL, 1, 1);

select * from client;

----------------------- ЗАПОЛНЯЕМ ТАБЛИЦУ ЗАКАЗЫ  -----------------------

INSERT INTO orders (order_comment, client_id, order_price, delivery_type_id, delivery_point_id, payment_date, client_discount)
    VALUES ('Доставка только вечером', 1, 0, 1, 1, sysdate, 0);
INSERT INTO orders (order_comment, client_id, order_price, delivery_type_id, delivery_point_id, payment_date, client_discount)
    VALUES ('Упаковать каждую книгу по отдельности', 2, 0, 2, 4, sysdate, 0);
INSERT INTO orders (order_comment, client_id, order_price, delivery_type_id, delivery_point_id, payment_date, client_discount)
    VALUES (NULL, 3, 0, 1, 3, sysdate, 10);
INSERT INTO orders (order_comment, client_id, order_price, delivery_type_id, delivery_point_id, payment_date, client_discount)
    VALUES ('Чем быстрее тем лучше', 4, 0, 1, 5, sysdate, 5);
    
select * from orders;

----------------------- ЗАПОЛНЯЕМ ТАБЛИЦУ ЗАКАЗЫ КНИГ ПО КОЛИЧЕСТВУ -----------------------

INSERT INTO book_order(order_id, book_id, amount) VALUES (1, 1, 1);
INSERT INTO book_order(order_id, book_id, amount) VALUES (1, 7, 2);
INSERT INTO book_order(order_id, book_id, amount) VALUES (2, 8, 2);
INSERT INTO book_order(order_id, book_id, amount) VALUES (3, 3, 2);
INSERT INTO book_order(order_id, book_id, amount) VALUES (3, 2, 1);
INSERT INTO book_order(order_id, book_id, amount) VALUES (3, 1, 1);
INSERT INTO book_order(order_id, book_id, amount) VALUES (4, 5, 1);
INSERT INTO book_order(order_id, book_id, amount) VALUES (4, 9, 3);
INSERT INTO book_order(order_id, book_id, amount) VALUES (4, 1, 2);
INSERT INTO book_order(order_id, book_id, amount) VALUES (4, 15, 2);
INSERT INTO book_order(order_id, book_id, amount) VALUES (4, 7, 1);
INSERT INTO book_order(order_id, book_id, amount) VALUES (4, 2, 1);
INSERT INTO book_order(order_id, book_id, amount) VALUES (4, 4, 1);
INSERT INTO book_order(order_id, book_id, amount) VALUES (4, 3, 1);
INSERT INTO book_order(order_id, book_id, amount) VALUES (4, 29, 2);
INSERT INTO book_order(order_id, book_id, amount) VALUES (4, 6, 1);

select * from book_order;

----------------------- ЗАПОЛНЯЕМ ТАБЛИЦУ ШАГИ ЗАКАЗОВ  -----------------------

-- ТУТ ДАТА В ФОРМАТЕ 27.02.22  ДД ММ ГГ
INSERT INTO order_step(order_id, step_id, order_start_date, order_end_date) VALUES (1, 1, '08.02.20', '08.02.20');
INSERT INTO order_step(order_id, step_id, order_start_date, order_end_date) VALUES (1, 2, '12.02.20', '13.02.20');
INSERT INTO order_step(order_id, step_id, order_start_date, order_end_date) VALUES (1, 3, '20.02.20', '21.02.20');
INSERT INTO order_step(order_id, step_id, order_start_date, order_end_date) VALUES (1, 4, '08.03.20', '08.03.20');
INSERT INTO order_step(order_id, step_id, order_start_date, order_end_date) VALUES (2, 1, '28.02.20', '28.02.20');
INSERT INTO order_step(order_id, step_id, order_start_date, order_end_date) VALUES (2, 2, '28.02.20', '01.03.20');
INSERT INTO order_step(order_id, step_id, order_start_date, order_end_date) VALUES (2, 3, '02.03.20', NULL);
INSERT INTO order_step(order_id, step_id, order_start_date, order_end_date) VALUES (2, 4, NULL, NULL);
INSERT INTO order_step(order_id, step_id, order_start_date, order_end_date) VALUES (3, 1, '05.03.20', '05.03.20');
INSERT INTO order_step(order_id, step_id, order_start_date, order_end_date) VALUES (3, 2, '07.032005', '08.03.20');
INSERT INTO order_step(order_id, step_id, order_start_date, order_end_date) VALUES (3, 3, '09.03.20', '09.03.20');
INSERT INTO order_step(order_id, step_id, order_start_date, order_end_date) VALUES (3, 4, '09.03.20', NULL);
INSERT INTO order_step(order_id, step_id, order_start_date, order_end_date) VALUES (4, 1, '09.03.20', NULL);
INSERT INTO order_step(order_id, step_id, order_start_date, order_end_date) VALUES (4, 2, NULL, NULL);
INSERT INTO order_step(order_id, step_id, order_start_date, order_end_date) VALUES (4, 3, NULL, NULL);
INSERT INTO order_step(order_id, step_id, order_start_date, order_end_date) VALUES (4, 4, NULL, NULL);

select * from order_step;
