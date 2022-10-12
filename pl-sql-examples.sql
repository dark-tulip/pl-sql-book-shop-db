-- ======================================================= 2 LAB WORK Управление пользователями и безопасностью

-- Код для создания Админа

-- DROP USER admin CASCADE;
CREATE USER admin IDENTIFIED BY 123;

grant create session      to admin with admin option;  --grant create session to test   
grant create table        to admin with admin option;  --Разрешаем создавать таблицы пользователю
grant create procedure    to admin with admin option;  --Разрешаем создавать процедуры
grant create trigger      to admin with admin option;  --Разрешаем создавать триггеры
grant create view         to admin with admin option;  --Разрешаем создавать представления
grant create sequence     to admin with admin option;  --Разрешаем создвавть счетчики
grant create TABLESPACE   to admin with admin option;  --Разрешаем создвавть 
grant create USER         to admin with admin option;  --Разрешаем создвавть 
grant create role         to admin with admin option;  --Разрешаем создвавть 
grant create ANY TABLE    to admin with admin option;  --Разрешаем создвавть 


--Разрешаем изменять таблицы, процедуры, триггеры и профиль
grant alter any table     to admin with admin option;    
grant alter any procedure to admin with admin option;
grant alter any trigger   to admin with admin option;
grant alter profile       to admin with admin option;

grant drop any table      to admin with admin option;
grant drop any procedure  to admin with admin option;
grant drop any trigger    to admin with admin option;
grant drop any view       to admin with admin option;
grant drop profile        to admin with admin option;
grant drop user           to admin with admin option;

--Разрешаем - ЭТО ВСЕ ТЕПЕРЬ ДАЕТ САМ HR
--grant all on HR.departments to admin with grant option; 
--grant all on HR.countries   to admin with grant option; 
--grant all on HR.employees   to admin with grant option; 
--grant all on HR.jobs        to admin with grant option; 
--grant all on HR.job_history to admin with grant option; 
--grant all on HR.regions     to admin with grant option; 
--grant all on HR.locations   to admin with grant option; 

-- Выделить неограниченную квоту
GRANT UNLIMITED TABLESPACE TO admin;
GRANT resource TO admin WITH ADMIN OPTION;


------- GRANT ALL PRIVILEGES TO admin WITH ADMIN OPTION;

-------------- CREATE ROLE FOR USER5 and USER2 --------------
CREATE ROLE us5_u2_role

-- GRANT ALL ON HR.jobs TO us5_u2_role;  -- Это тоже дает HR

GRANT SELECT ON us2.t1 TO us5_u2_role;
GRANT INSERT ON us2.t1 TO us5_u2_role;
GRANT DELETE ON us2.t1 TO us5_u2_role;
GRANT CREATE TABLE     TO us5_u2_role;

GRANT us5_u2_role TO us5;
GRANT us5_u2_role TO us2;

SELECT * FROM DBA_ROLE_PRIVS where GRANTED_ROLE='US5_U2_ROLE';

-------------- CREATE PROFILE FOR USER1 and USER2 --------------
CREATE PROFILE users_profile LIMIT
    SESSIONS_PER_USER 3
    CONNECT_TIME 120
    IDLE_TIME 180
    PASSWORD_VERIFY_FUNCTION verify_function_11g;

SELECT * FROM DBA_PROFILES where PROFILE='USERS_PROFILE'; -- привилегии роли


ALTER SYSTEM SET RESOURCE_LIMIT=TRUE;     -- Применить ограничения на ресурсы

-- Добавить пользователей в профиль
ALTER USER us1 PROFILE users_profile;
ALTER USER us2 PROFILE users_profile;

-- Код, который написал Админ

select * from user_tab_privs;
select * from user_sys_privs;

select * from role_sys_privs;
select * from role_tab_privs;

select * from all_tab_privs_recd where owner='HR';

--drop user us1 cascade;
--drop user us2 cascade;

-- ========= USER 1 ==========
CREATE USER us1 IDENTIFIED BY 123 
DEFAULT TABLESPACE USERS       --табличное пространство
QUOTA 500M ON USERS            --Добавляем квоту на дисковое пространство.

GRANT
    CREATE SESSION,
    CREATE TABLE,
    CREATE USER
TO us1 WITH ADMIN OPTION;

-- ========= USER 2 ==========
CREATE USER us2 IDENTIFIED BY 123 
DEFAULT TABLESPACE USERS
QUOTA 500M ON USERS;

GRANT
    CREATE SESSION,
    CREATE TABLE,
    CREATE USER,
TO us2 WITH ADMIN OPTION;

GRANT ALTER TABLE to us2 WITH ADMIN OPTION;

----================ HR GRANTS ================--
--GRANT SELECT, INSERT, UPDATE ON HR.countries to us1, us2 WITH GRANT OPTION;

-- GRANT TO CREATE TABLE ON US2 to US4
GRANT CREATE ANY TABLE TO us4;

-- Код, который написал HR

--Разрешаем АДМИНУ - ЭТО ВСЕ ТЕПЕРЬ ДАЕТ САМ HR
grant all on HR.departments to admin with grant option; 
grant all on HR.countries   to admin with grant option; 
grant all on HR.employees   to admin with grant option; 
grant all on HR.jobs        to admin with grant option; 
grant all on HR.job_history to admin with grant option; 
grant all on HR.regions     to admin with grant option; 
grant all on HR.locations   to admin with grant option; 

-- Для роли разрешаем все в таблице jobs
GRANT ALL ON HR.jobs TO us5_u2_role;

--================ HR GRANTS to USER 1 and USER 2 ================--
GRANT SELECT, INSERT, UPDATE ON HR.countries to us1, us2 WITH GRANT OPTION;

-- Код USER 1

CREATE USER us3 IDENTIFIED BY 123 
DEFAULT TABLESPACE USERS               --табличное пространство
QUOTA 500M ON USERS;                   --Добавляем квоту на дисковое пространство.

GRANT
    CREATE SESSION,
    CREATE TABLE,
    CREATE USER
TO us3;


SELECT * FROM hr.countries;  -- USER 1 can select from HR.countries

-- USER copies HR.countries and creates table us1.countries from 
CREATE TABLE  us1.countries AS (SELECT * FROM hr.countries);
SELECT * FROM us1.countries; 

-- give permissions to USER3 
GRANT SELECT, INSERT, UPDATE ON us1.countries to us3;

-- USER 1 CAN INSERT TO hr.countries
INSERT INTO hr.countries
VALUES (12, 'KAZ', 2)

-- Код USER 2

----- ===== USER 2 CREATES TABLES ===== ----
CREATE TABLE t1 (
    t1_id   NUMBER(10) NOT NULL,
    t1_name VARCHAR(20)
);

INSERT INTO t1 VALUES (1, 'test1');
INSERT INTO t1 VALUES (2, 'test2');
INSERT INTO t1 VALUES (3, 'test3');

select * from user_tables;

-- ========= USER 4 ==========
CREATE USER us4 IDENTIFIED BY 123 
DEFAULT TABLESPACE USERS
QUOTA 500M ON USERS;

GRANT
    CREATE SESSION,
    CREATE TABLE,
    CREATE USER
TO us4 WITH ADMIN OPTION;


--- ====== GIVE PRIVS TO OWN TABLE === ----
GRANT SELECT, INSERT, UPDATE, DELETE  ON t1 to us4 WITH GRANT OPTION;
REVOKE UPDATE, DELETE ON t1 from us4;

GRANT UPDATE, DELETE  ON t1 to us4; 
GRANT SELECT, INSERT  ON t1 to us3;

SELECT * FROM user_tab_privs_made;

GRANT ALTER ON us2.t1 TO us4 with grant option;  -- Разрешить редактирвоать таблицу
GRANT CREATE TABLE    TO us4 with admin option;  -- Разрешить создавать таблицу

SELECT * FROM user_tab_privs_made;

 -- Таблица USER 2 которому USER 4 создал таблицу
select * from US2.t2;  
GRANT SELECT ON t2 to us4 WITH GRANT OPTION;

-- Код USER 3

SELECT * FROM us1.countries;  

-- Код USER 4

--- USER 4 made scripts ----
select * from user_sys_privs;
select * from user_tab_privs;

select * from us2.t1; --- USER 4 can select from this table
ALTER TABLE us2.t1 ADD column_us4 varchar2(20);
DESC us2.t1;


CREATE TABLE US2.t2 as (select * from us2.t1); -- USER 4 созжал таблицу для USER 2
 -- НО Только после того как user 2 даст grant на select в таблице, команда заработает 
select * from US2.t2; 

SELECT * FROM all_tables where tablespace_name='USERS';


-- ========= USER 5 ==========
CREATE USER us5 IDENTIFIED BY 123 
DEFAULT TABLESPACE USERS
QUOTA 500M ON USERS;

GRANT
    CREATE SESSION,
    CREATE TABLE,
    CREATE USER
TO us5 WITH ADMIN OPTION;


GRANT INSERT, UPDATE, DELETE  ON t2 to us5 WITH GRANT OPTION;
select * from user_tab_privs_made

INSERT INTO hr.countries VALUES (15, 'KAZ_USER2', 2);





-- ======================================================= 4 LAB WORK Специальные операторы и функции СУБД ORACLE


SELECT
    "A1"."FIRST_NAME"    "FIRST_NAME",
    "A1"."LAST_NAME"     "LAST_NAME",
    "A1"."DEPARTMENT_ID" "DEPARTMENT_ID",
    "A1"."JOB_ID"        "JOB_ID",
    "A1"."SALARY" * 1.1  "SALARY*1.1"
FROM
    "HR"."EMPLOYEES" "A1"
ORDER BY
    "A1"."DEPARTMENT_ID",
    "A1"."SALARY" * 1.1 DESC,
    "A1"."LAST_NAME";

-- Запрос по должностям и их зарплатам
SELECT
    "A1"."JOB_ID"      "Должность",
    MAX("A1"."SALARY") "Максимальная зарплата по должности",
    MIN("A1"."SALARY") "Минимальная зарплата по должности",
    to_char(
        AVG("A1"."SALARY"), '999999999.99'
    )                  "Средняя ЗП"
FROM
    "HR"."EMPLOYEES" "A1"
GROUP BY
    "A1"."JOB_ID"
ORDER BY
    to_char(
        AVG("A1"."SALARY"), '999999999.99'
    );


-- Запрос по должностям и их зарплатам с отделом
SELECT
    "A1"."DEPARTMENT_NAME" "Отдел",
    "A2"."JOB_ID"          "Должность",
    MAX("A2"."SALARY")     "Максимальная зарплата по должности",
    MIN("A2"."SALARY")     "Минимальная зарплата по должности",
    to_char(AVG("A2"."SALARY"), '999999999.99')  "Средняя ЗП"
FROM
    "HR"."EMPLOYEES"   "A2",
    "HR"."DEPARTMENTS" "A1"
WHERE
    "A2"."DEPARTMENT_ID" = "A1"."DEPARTMENT_ID"
GROUP BY
    "A2"."JOB_ID",
    "A1"."DEPARTMENT_NAME",
    "A1"."DEPARTMENT_NAME",
    "A2"."JOB_ID"
ORDER BY
    "A1"."DEPARTMENT_NAME",
    "A2"."JOB_ID";
    
    
select * from hr.employees;
select * from hr.departments;

-- Где оклад больше средней ЗП у департамента ПРОДАЖИ (Sales)
SELECT 
    first_name as "NAME", 
    last_name as "SALARY", 
    salary as "OKLAD"
FROM hr.employees 
where salary > (SELECT avg(salary) 
                FROM hr.employees, hr.departments 
                WHERE hr.employees.department_id = hr.departments.department_id 
                AND hr.departments.department_name = 'Sales');

-- 1. === CASE CHANGING FUNCTIONS
SELECT 'The job for ' || UPPER(last_name) || ' is ' || LOWER(job_id) as "EMPLOYEE DETAILS"
FROM hr.employees;
-- === INITCAP (Familya Imya Otchestvo) case
SELECT employee_id, UPPER(last_name), department_id from hr.employees WHERE INITCAP(last_name) = 'Higgins';

-- 2. === функции манипулирования с символами и строками
select concat('Hello', 'World') from dual;            -- HelloWorld
select substr('Hello, World', 1, 5) from dual;        -- Hello
select INSTR('Hello', 'o') from dual;                 -- 5
select lpad('Hello', 10, '*') from dual;              -- *****Hello
select rpad('Hello', 10, '*') from dual;              -- Hello*****
select replace('JACK AND JUE', 'J', 'BL') from dual;  -- BLACK AND BLUE
select trim('H' from 'HelloWorld') from dual;         -- elloWorld

-- Выборка сотрудников REP и подсчет скольок букв А в их фамилии
select employee_id, 
        concat(first_name || ' ' , last_name) name , 
        job_id, 
        length(last_name), 
        instr(last_name, 'a') "Contains 'a'?"
from hr.employees where substr(job_id, 4) = 'REP';


select translate(department_name, 'as', 'a') from hr.departments where department_id in(10,20,30,40);

-- 3. === Числовые функции

select round(45.926, 2), trunc(45.926, 2), mod(1600, 300), round(45.926, -1) from dual;
-- DUAL - фиктивная таблица для получения результатов выполнения функций и вычислений

select last_name, salary, mod(salary, 5000) from hr.employees where job_id='SA_REP';

-- 4. ДАТЫ === НАСТРОЙКА ФОРМАТА ВРЕМЕНИ ДЛЯ СЕАНСА
select value from nls_session_parameters where parameter = 'NLS_DATE_FORMAT';
select sysdate from dual;
alter session set nls_date_format = 'yyyy-mm-dd hh24:MI:SS';
select sysdate from dual;

alter session set nls_date_format = 'Day HH:MI:SS am';
select sysdate from dual;

select date '1995-08-28' + 3 from dual;
select 3 + date '1995-08-28' from dual;
select sysdate + 1 / 24 from dual;           --  now + hour;
select sysdate - date '2022-1-1' from dual;  -- кол-во дней после нового года
select systimestamp - timestamp '2022-1-1 0:0:0' from dual;  

select last_name, (sysdate - hire_date) / 7 as weeks from hr.employees where department_id = 90; -- кол-во недель с начала работы

select to_char(to_date('26.12.2012', 'dd.mm.yyyy'), 'd') from dual;  -- день недели
select trunc(to_date('21.11.2011', 'dd.mm.yyyy'), 'D') from dual;    -- дата первого дня этой недели


-- 1) Задание. Показать завтрашнюю дату в формате: Tomorrow is second day of January
-- d   - день недели
-- dd  - день месяца 
-- ddd - день года
select  'Tomorrow is the ' || 
        to_char(to_date('31.03.2022', 'dd.mm.yyyy') + 1, 'dd')  || ' day of ' ||     -- Завтра первый день апреля                                           
        to_char(to_date('31.03.2022', 'dd.mm.yyyy') + 1, 'Month') as "День недели и месяц" 
from dual;  -- день недели


-- 2) Задание. Приняли на работу в этот день недели
select * from hr.employees;

SELECT
    to_char( to_date(hire_date), 'd')   AS "День недели",
    to_char( to_date(hire_date), 'day') AS "День недели2",
    COUNT(*)                            AS "Приняли на работу"
FROM
    hr.employees
GROUP BY to_char(to_date(hire_date), 'd'),  to_char( to_date(hire_date), 'day')
ORDER BY 1;


-- 3) Задание. Фамилия должность и оклад всех служащих в должности SALES REPRESENTATIVE (SA_REP) или STOCK CLERK (ST_CLERK),
--             оклады которых не равны 2500, 3500 или 7000
select * from hr.employees;

select last_name, job_id, salary from hr.employees 
where (job_id='SA_REP' or job_id='ST_CLERK') and salary not in (2500, 3500, 7000);


-- 4) Задание. фамилии служащих с загланой, остальные строчные, длина фамилии, и начинается на J, A, M
select INITCAP(last_name) as last_name , length(last_name) as surname_length from hr.employees
where REGEXP_LIKE (last_name,'^A|^J|^M')
order by 1, 2;


-- 5) Задание. Фамилия служащего, кол-во месяцев со дня найма округленное до целого, 
--             отсортирвоать по кол-ву отработанных месяцев
select 
    last_name, 
    round(months_between(sysdate, hire_date)) as MONTH_WORKED, 
    to_char(hire_date, 'yyyy-mm-dd')          as HIRE_DATE 
from hr.employees
order by 2;


-- 6) Задание. Отчет по department_id c min and max заралоптой, ранней и поздней датой прихода на работу и с кол-вом сотрудников  
SELECT 
    departments.department_id, 
    departments.department_name, 
    to_char(min(hire_date), 'yyyy-mm-dd') as "Самая первая дата прихода на работу",  
    to_char(max(hire_date), 'yyyy-mm-dd') as "В последний раз наняли сотрудника",
    max(salary)                           as "Максимальная зарплата",
    min(salary)                           as "Минимальная зарплата",               
    count(*)                              as "Кол-во сотрудников"
FROM hr.departments
INNER JOIN hr.employees 
    ON hr.departments.department_id = hr.employees.department_id
    GROUP BY departments.department_id, departments.department_name;

    
-- 7) Задание. Фамилии и оклады всех служащих. Длина стообца 15 символов с запонением $ слева
select last_name, lpad(to_char(salary), 15, '$') from hr.employees;


-- 8) Задание. Имена сотрудников содержащие как минимум 2 буквы 'n'
select 
    last_name, 
    REGEXP_COUNT(last_name, 'n') "n in name" 
from hr.employees 
where REGEXP_COUNT(last_name, 'n') >= 2;


-- 9) фамилия, дата найма, день пересмотра зарплаты (первый ПН после 6 месяцев службы)
select  
        last_name, 
        hire_date, 
        to_char(ADD_MONTHS(hire_date, 6), 'DAY')                       as "DAY OF WEEK AFTER ADD SIX MONTH",
        8 - to_char(ADD_MONTHS(hire_date, 6), 'D')                     as "DAYS LEFT TO MOND",

        to_char(ADD_MONTHS(hire_date, 6) + 8 - to_char(ADD_MONTHS(hire_date, 6), 'D'))  as "DATE OF RECOUNTING",
        to_char(ADD_MONTHS(hire_date, 6) + 8 - to_char(ADD_MONTHS(hire_date, 6), 'D'),
                                               'DAY, "The" DDthsp "of" MONTH, YYYY')    as "DAY OF RECOUNTING STRING"
from hr.employees;


--10) Задание. Сотрудники работающие больше 15 лет. Фамилия, дата найма день недели когда был нанят на работу
select 
    last_name||' '||first_name, 
    hire_date, 
    to_char(hire_date, 'DAY')                      as "DAY OF WEEK", 
    to_char(hire_date, 'd')                        as "DAY", 
    floor(months_between(sysdate, hire_date) / 12) as "YEARS"
from hr.employees
where floor(months_between(sysdate, hire_date) / 12) >= 15
order by 4;


-- 11) Задание. Фамиоия, сумма комиссионных каждого служащего. Если не зарабатывает "NO COMMISSION"
select 
    last_name, 
    coalesce(commission_pct, 0) as "PERCENT",
    coalesce(to_char(commission_pct * salary), 'NO COMMISSION') as "COMMISSION"
from hr.employees;


-- 12) Задание. Фамилия и оклады со свездочками за каждую 1000 долларов
select 
    last_name, 
    salary, 
    round(salary / 1000)                 as "THOUSANDS",         
    rpad('*', round(salary / 1000), '*') as "EMP_AND_SALARIES"
from hr.employees;


-- 13) Задание. Используя Decode выводит для каждой страны регион
                -- EUROPE
                -- AMERICA
                -- ASIA
                -- AFRICA
select distinct country_name from hr.countries
order by 1;

SELECT country_name,
    decode(country_name,
    'Argentina',    'AMERICA',
    'Australia',    'AUSTRALIA',
    'Belgium',      'EUROPE',
    'Brazil',       'AMERICA',
    'Canada',       'AMERICA',
    'China',        'ASIA',
    'Denmark',      'EUROPE',
    'Egypt',        'AFRICA',
    'France',       'EUROPE',
    'Germany',      'EUROPE',
    'India',        'ASIA',
    'Israel',       'ASIA',
    'Italy',        'EUROPE',
    'Japan',        'ASIA',
    'China',        'ASIA',
    'Kuwait',       'ASIA',
    'Malaysia',     'ASIA',
    'Mexico',       'AMERICA',
    'Netherlands',  'EUROPE',
    'Nigeria',      'AFRICA',
    'Singapore',    'ASIA',
    'Switzerland',  'EUROPE',
    'Zambia',       'AFRICA',
    'Zimbabwe',     'AFRICA',
    'United Kingdom',           'EUROPE',
    'United States of America', 'AMERICA'
    ) as "CONTINENT CODE"
from hr.countries
order by 2;





-- ======================================================= 5 LAB WORK Сложные операторы и многострочные функции SQL СУБД Oracle

-- === Многострочные подзапросы
select last_name, salary, department_id from hr.employees
where salary in (2500, 4200, 4400, 6000, 7000, 8300, 8600, 17000);

-- сотрудники выполняющие менеджерские функции
select first_name as name, last_name as surname from hr.employees
where employee_id = any (select manager_id from hr.employees);

-- === Парные и непарные сравнения

-- Подчиняются одному и тому же сотруднику
select employee_id, manager_id, department_id from hr.employees
where (manager_id, department_id) IN (SELECT manager_id, department_id from hr.employees where employee_id IN (178, 174))
and employee_id not in (178, 174);
  
-- Сотрудники только с минимальной заработной платой
select first_name as "Name", 
       last_name  as "Surname", 
       job_id     as "Должность", 
       salary     as "Оклад"
from hr.employees
where (job_id, salary) in 
    (select job_id, min_salary from  hr.jobs);

select * from hr.employees;
-- Сотрудники - начальники
select last_name, manager_id, employee_id, emp.department_id from hr.employees emp
where emp.employee_id in (select mgr.manager_id from hr.employees mgr);

-- не имеющих в своем подчинении других сотрудников
select last_name, manager_id,  employee_id, emp.department_id  from hr.employees emp
where emp.employee_id not in (select manager_id from hr.employees where manager_id is not null);

-- === Коррелированные подзапросы
-- Все сотрудники зарабатывающие больше чем ср зп в их отделе
select employee_id from hr.employees outer where salary > 
(select avg(salary) from hr.employees where department_id = outer.department_id);

-- сотрудники у которых рабочие места изменены как минимум дважды
select e.employee_id, e.last_name, e.job_id from hr.employees e
    where (select count(*) from hr.job_history where employee_id = e.employee_id) >= 2;

-- департаменты расположенные в Европе
select department_name, city from hr.departments
natural join (select location_id, city, country_id 
              from hr.locations 
              join hr.countries using(country_id)
              join hr.regions using(region_id)
              where region_name = 'Europe');

-- === Inline views

select a.last_name, a.salary, a.department_id, b.maxsal
from hr.employees a, 
(select department_id, max(salary) maxsal 
    from hr.employees 
        group by department_id) b
where a.department_id = b.department_id
      and a.salary = b.maxsal
order by 3;

--- === Квантор существования
select employee_id, 
       last_name, 
       salary, 
       department_id 
from hr.employees x 
where salary > (select avg(salary) from hr.employees 
                where department_id = x.department_id) 
order by department_id, salary desc;

-- получить менеджеров
select employee_id,
       last_name, 
       job_id, 
       department_id 
       from hr.employees outer
where exists (select 'X' from hr.employees 
              where manager_id = outer.employee_id);

-- === Natural join  - объединение по всем одноименным столбцам
select employee_id, last_name, location_id, department_id
from hr.employees e
natural join HR.departments d;

-- === JOINS, Inner join

select e.employee_id, 
       e.last_name,
       e.department_id, 
       d.department_id,
       d.department_name,
       d.location_id
from hr.employees e, hr.departments d
where e.department_id = d.department_id;


select e.employee_id, 
       e.last_name,
       e.department_id, 
       d.department_id,
       d.department_name,
       d.location_id
from hr.employees e join hr.departments d
on e.department_id = d.department_id;

select e.employee_id, 
       e.last_name,
       e.department_id, 
       d.department_id,
       d.department_name,
       d.location_id
from hr.employees e left join hr.departments d   -- все записи из левой, недостающее null
on e.department_id = d.department_id;

select e.employee_id, 
       e.last_name,
       e.department_id, 
       d.department_id,
       d.department_name,
       d.location_id
from hr.employees e right join hr.departments d   -- все записи из правой, недостающее null
on e.department_id = d.department_id;



select e.last_name,
       e.department_id, 
       d.department_id,
       d.department_name,
       d.location_id
from hr.employees e cross join hr.departments d; --  декартово произведение каждая запись с каждой их другой таблицы

-- === using USING
select l.city, d.department_name 
    from hr.locations l
        join hr.departments d 
        using (location_id)
where location_id = 1400;

-- TOP N analyzis
select rownum as senior, e.last_name, e.hire_date
    from (select last_name, hire_date 
              from hr.employees 
              order by hire_date) e
where rownum <= 4;



-- ==  Аналитические функции
select department_id, job_id, sum(salary) sum_sal -- Тут нельзя показать last name
    from hr.employees
    group by department_id, job_id;

-- Тут можно показать last name
-- OVER (означает что функция аналитическая, после принимает срез данных для группировки) 
-- partition by - разлделяет га группы по заданному критерию
select  last_name, 
        department_id, 
        job_id, 
        sum(salary) over (partition by department_id, job_id) sum_sal
from hr.employees;

select  last_name, 
        department_id, 
        job_id, 
        salary,
        sum(salary) over (partition by department_id) sum_sal
from hr.employees;
    
-- ===  Функции ранжирования
select last_name, 
       salary, 
       ROW_NUMBER() over (order by salary desc) as desc_csalalry, 
       ROW_NUMBER() over (order by salary) as asc_salary,
       RANK()       over (order by salary) as salrank,
       DENSE_RANK() over (order by salary) as saldenserank
from hr.employees;

-- ROWNUM
select * from  (select row_number() over (order by 1 asc) as rownumber, 
                country_name from hr.countries) 
where rownumber <= 10;


-- Топ 10 молодых специалистов

-- ROW_NUMBER() attributes a unique value to each row
-- RANK()       attributes the same row number to the same value, оставляя нумерации (совпадая с rownum)
-- DENSE_RANK() attributes the same row number to the same value, НЕ оставляя нумерации

select DENSE_RANK() over (order by hire_date desc) as rd,
       RANK()       over (order by hire_date desc) as r,
       employee_id, 
       last_name, 
       hire_date
from hr.employees 
where rownum <= 10;

-- best and worst grouped by department
select  last_name, 
        department_id, 
        salary, 
        min(salary) keep (dense_rank first order by salary) over (partition by department_id) "Worst",
        max(salary) keep (dense_rank last  order by salary) over (partition by department_id) "Best"
from hr.employees
where department_id in (30, 60)
order by department_id, salary;

select  last_name, 
        salary, 
        hire_date, 
        first_value(hire_date) 
                over (order by salary rows between 
                            unbounded preceding and 
                            unbounded following) as lv
from (select * from hr.employees where department_id = 90
order by hire_date);


select 
        rownum id, 
        dense_rank() over (partition by department_id order by 1) id_in_dept,
        department_id, 
        job_id, 
        last_name, 
        salary, 
        salary_rank 
from (select 
            rownum, 
            department_id, 
            job_id, 
            last_name, 
            salary, 
            salary_rank
          from (select 
                department_id, 
                job_id, 
                last_name, 
                salary, 
                dense_rank() over (partition by department_id order by salary desc) salary_rank
                from hr.employees where department_id in (10, 30, 50, 90)
          ) a 
) b
order by department_id, id_in_dept;


select (salary) from hr.employees where department_id in (30, 60);


select  first_name ||' '|| last_name "FIO", 
        employee_id, 
        salary, 
        rank() over (order by salary asc) "RANK",
        dense_rank() over (order by salary asc) "DESNE_RANK"
from hr.employees;

-- === UNION
select employee_id, job_id from hr.employees
union
select employee_id, job_id from hr.job_history;


--  UNION  для различных полей
select department_id, to_number(null) location, hire_date from hr.employees
union 
select department_id, location_id, to_date(null)          from hr.departments;


select employee_id, job_id, department_id from hr.employees
UNION ALL
select employee_id, job_id, department_id from hr.job_history
order by employee_id;


select employee_id, job_id, department_id from hr.employees
intersect
select employee_id, job_id, department_id from hr.job_history;

select employee_id, job_id from hr.employees
MINUS
select employee_id, job_id from hr.job_history;

--== Управление порядком строк
select 'sing' as "My dream", 3 a_DUMBO  from dual
UNION
select 'I''d like to teach', 1 a_DUMBO  from dual
UNION
select 'the world to', 2 a_DUMBO        from dual
order by a_DUMBO;


-- === Расширение оператора GROUP BY

-- Данные по зарплатам и обзий итог ROLLUP - статистические выражения в заданных столбцах
select department_id, nvl(job_id, '-'), sum(salary) from hr.employees
where department_id < 60
group by rollup(department_id, job_id);

-- CUBE - все комбинации заданных столбцов
select department_id, nvl(job_id, '-'), sum(salary) from hr.employees
where department_id < 60
group by cube(department_id, job_id);

-- GROUPING
select department_id, job_id, sum(salary),
        grouping(department_id) grp_dept,
        grouping(job_id) grp_job
from hr.employees
where department_id < 50
group by rollup(department_id, job_id);


select department_id, job_id, manager_id, avg(salary) from HR.employees
group by
    grouping sets
         ((department_id, job_id, manager_id),
          (department_id, manager_id), 
          (job_id, manager_id));
          
select 
        department_id, 
        job_id, 
        manager_id, 
        avg(salary) 
from hr.employees
group by cube(department_id, job_id, manager_id);

SELECT
    department_id,
    job_id,
    manager_id,
    AVG(salary)
FROM hr.employees
GROUP BY department_id, job_id, manager_id
UNION ALL

SELECT
    department_id,
    NULL,
    manager_id,
    AVG(salary)
FROM hr.employees
GROUP BY department_id, manager_id
UNION ALL

SELECT
    NULL,
    job_id,
    manager_id,
    AVG(salary)
FROM hr.employees
GROUP BY job_id, manager_id;


--== Объединение группировки
select 
        department_id, 
        job_id, 
        manager_id, 
        sum(salary) 
from HR.employees
group by department_id, 
    rollup(job_id),
    cube(manager_id);

--== INPUT FROM USER - Запрос значения у пользователя
select 
        employee_id, 
        last_name, 
        salary, department_id 
from hr.employees
where employee_id = &employee_id;

-- == INPUT column name from table
-- INPUT condition for ordering
select  employee_id, 
        last_name, 
        job_id, 
        &column_name 
from hr.employees
order by &order_column;

--== Двойнгой амперсанд для ввода значения только один раз &&
select  employee_id, 
        last_name, 
        job_id, 
        &&column_name
from hr.employees
order by &column_name;

select * from &&table_name; -- При запуске во второй раз значение запоминается и не запрашивается

-- === ВЫВОД В ТЕКСТОВОМ ВИДЕ (Не таблица) - f5
select  first_name, 
        last_name, 
        salary
from hr.employees
where department_id = &Номер_отдела;


--=== MERGE

create table hr.copy_emp as 
    select * from hr.employees;


merge into copy_emp c
    using hr.employees e
        on (c.employee_id = e.employee_id)
when matched then       -- Если запись ЕСТЬ существует - ОБНОВИТЬ
    update set  
        c.first_name = e.first_name,
        c.last_name = e.last_name,
        c.email = e.email,
        c.phone_number = e.phone_number,
        c.job_id = e.job_id,
        c.salary = e.salary,
        c.commission_pct = e.commission_pct,
        c.manager_id = e.manager_id,
        c.department_id = e.department_id
when not matched then    -- Если записи не существует - ДОБАВИТЬ   
    insert values 
        (e.employee_id,      
         e.first_name,
         e.last_name,
         e.email,
         e.phone_number,
         e.hire_date,
         e.job_id,
         e.salary,
         e.commission_pct,
         e.manager_id, 
         e.department_id);
                   
select * from hr.employees;
select * from hr.copy_emp;

-- Список департаментов имеющих фонд заработной платы большей 1/8 фонда всего предприятия

with summary as (
        select 
                d.department_name as department,
                sum(e.salary)     as dept_total
                
        from     hr.employees e, hr.departments d
        where    e.department_id = d.department_id
        group by d.department_name
    )
select department, dept_total
    from summary
    where dept_total > (select sum(dept_total) * 1/8 from summary)
order by dept_total desc;


-- в теле основного запроса использует dept_costs, avg_costs
with 
    dept_costs as (
        select d.department_name, sum(e.salary) as dept_total
            from hr.employees e 
                join hr.departments d
                on e.department_id = d.department_id
            group by d.department_name
    ),    
    avg_cost as (
        select  avg(dept_total) as dept_avg 
                from dept_costs
    )
select * from dept_costs where dept_total > (select dept_avg from avg_cost);



-- Запрос с WITH и без WITH
select  e1.last_name, 
        e1.salary, 
        e1.department_id, 
        e2.average
from hr.employees e1,
    (select round(avg(salary)) as average 
            from hr.employees) e2
where e1.salary > e2.average
order by salary;

with 
    t1 as (select last_name, salary 
            from hr.employees
    ),
    t2 as (select round(avg(salary)) as average 
            from hr.employees
    )
select last_name, salary, average from t1, t2;



--=== РЕКУРСИЯ
with numbers(n) as ( 
    select 1 as n from dual
        union all
    select n + 1 as n from numbers
        where n < 5)
select n from numbers;

with anchor1234(n) as (
    select 1 from dual union all
    select 2 from dual union all
    select 3 from dual union all
    select 4 from dual
), numbers (n) as (
    select n from anchor1234
        union all
    select n + 1 as n
    from numbers
    where n < 5
    
)  select n from numbers;

with period (year) as (
    select 2002 as year 
        from dual
        union all
    select year + 1 as year 
        from period
        where year < 2010)
    select p.year, count(e.employee_id)
        from hr.employees e right outer join period p
        on p.year =  extract ( year from e.hire_date )
group by p.year
order by p.year;


-- Показать менеджеров и сотрудников пока employee_id = 101
select employee_id, last_name, job_id, manager_id, level 
    from hr.employees
    start with employee_id = 101
connect by prior manager_id = employee_id;

-- LEVEL - для кореного = 1, потомков = 2
-- START WITH - для идентификации коренных строк
-- CONNECT BY - для связи строк потомков и строк предков
start with employee_id = 100;
select lpad(' ', 2 * (level -1)) || last_name org_chart,
        employee_id,
        department_id, 
        manager_id, 
        job_id
from hr.employees
start with job_id = 'AD_PRES'
connect by prior employee_id = manager_id;



select  lpad(' ', (level-1) * 3) || level || ' '||last_name as tree, 
        employee_id, 
        job_id, 
        manager_id
from hr.employees
connect by prior employee_id = manager_id;


-- С путем иерархии
select  first_name, 
        last_name, 
        level - 1 ,                                        
        SYS_CONNECT_BY_PATH(first_name || last_name, '/')
from hr.employees 
start with employee_id = 100
connect by prior employee_id = manager_id
order by level;


-- сортировка в перделах уровня иерархии
select  first_name, 
        last_name, 
        level - 1 ,                                        
        SYS_CONNECT_BY_PATH(first_name || last_name, '/')
from hr.employees 
start with employee_id = 100
connect by prior employee_id = manager_id
order siblings by first_name;

-- Запрос вниз по иерархии должностей
select  level -1 as "LEVEL",
        sys_connect_by_path(job_id, '/') TREE, 
        last_name FAM
from hr.employees
start with job_id = 'AD_PRES'
CONNECT BY PRIOR employee_id=manager_id;


-- Запрос в строку
select sys_connect_by_path(last_name, '-->') TREE
from hr.employees 
connect by prior manager_id=employee_id;

--1. Создайте запрос для вывода номера отдела, фамилии служащего и фамилий всех служащих, 
--   работающих в одном отделе с данным служащим. Дайте столбцам соответствующие имена.
select 
        department_id, 
        last_name,         
        employee_id  
from hr.employees emp
order by 1;

-- select * from hr.employees;
-- select * from hr.departments;

--2. Создайте запрос для вывода фамилии и даты найма каждого служащего, 
-- работающего в одном отделе с Zlotkey, Исключите Zlotkey из выходных данных.

select e.last_name, 
       e.department_id 
from hr.employees e 
       where department_id in 
            (select department_id 
             from hr.employees where last_name = 'Zlotkey');


--3. Создайте запрос для вывода фамилии, номера отдела и должности каждого служащего, отдел которого находится в location ID = 1700.
select  last_name,  
        job_id,
        department_id,
        location_id
from hr.employees 
        join HR.departments 
        using(department_id) 
where location_id = 1700
order by 2;

--4. Получите номер отдела, фамилию и должность для каждого служащего, 
--   работающего в административном департаменте (Executive).
select 
    department_id, 
    department_name,
    last_name,
    job_id 
from hr.employees join hr.departments using(department_id)
where department_name = 'Executive';

--5. Создайте запрос для вывода фамилии, номера отдела и оклада всех служащих, 
-- чей номер отдела и оклад совпадают с номером отдела и окладом любого служащего, зарабатывающего комиссионные.
select * from hr.employees;

select last_name, department_id, salary, commission_pct
from hr.employees outer
where (department_id, salary) 
       in (select department_id, salary 
                  from hr.employees 
                   where   outer.department_id = department_id and  -- Нету с одинаковой зарплатой и с комиссионными и без в одном департаменте
                           outer.salary = salary and
                           commission_pct is not null)
and commission_pct is null;  


select last_name, department_id, salary, nvl(to_char(commission_pct), '-')
from hr.employees outer
where salary
       in (select salary 
                  from hr.employees 
                  where   outer.salary = salary and  -- Есть с одинаковой зарплатой и в разных департаментах
                          commission_pct is not null)
and commission_pct is null;

select * from hr.employees where salary = 11000;

--6. Выведите фамилию, номер отдела и оклад всех служащих, чей оклад и комиссионные 
-- совпадают с окладом и комиссионными любого служащего, работающего в LOCATION ID = 1700.

select  last_name,
        department_id, 
        salary, 
        commission_pct,
        location_id
from hr.employees
join hr.departments using(department_id)
where location_id = 1700;

select * from hr.departments 
where location_id = 1700;

select  last_name,
        department_id, 
        salary, 
        nvl(commission_pct, 0) ,
        salary + nvl(commission_pct, 0) * salary "total_salary"
from HR.employees
join hr.departments using(department_id)
     where location_id <> 1700
     and   (salary + nvl(commission_pct, 0) * salary) in 
           (select 
                    salary - nvl(commission_pct, 0) * salary
            from hr.employees join hr.departments using(department_id)
            where location_id = 1700)
order by department_id;


--7. Создайте запрос для вывода фамилии, даты найма и оклада всех служащих, 
-- которые получают такой же оклад и такие же комиссионные, как Kochhar.
--Примечание: не отображайте Kochhar в результирующем множестве.

select  last_name, 
        hire_date, 
        salary, 
        nvl(commission_pct, 0) 
from hr.employees 
where   (salary, nvl(commission_pct, 0)) in 
            (select salary,  nvl(commission_pct, 0) 
                from hr.employees 
                   where last_name = 'Kochhar')
and last_name <> 'Kochhar';

--8. Выведите сведения о тех сотрудниках (номер сотрудника, фамилию и номер отдела), кто проживает в городах, начинающихся на Т.

select * from hr.departments;
select * from HR.locations;

select employee_id, last_name, city, department_id, location_id
       from hr.employees
       join hr.departments using(department_id)
       join hr.locations   using(location_id)
where upper(city) like 'T%';

--9. Найдите всех сотрудников, у которых нет руководителей с использованием оператора NOT EXISTS

select last_name, nvl(to_char(manager_id), 'нет значения') from hr.employees 
        where (last_name, nvl(manager_id, 0))
        not in (select last_name, manager_id from hr.employees where manager_id is not null);
        
select last_name, nvl(to_char(manager_id), 'нет значения') from hr.employees outer
        where not exists (select 1 from hr.employees 
                                 where manager_id = outer.manager_id);
        
--10. Создайте скрипт-файл loademp.sql для интерактивной загрузки строк в таблицу MY EMPLOYEE. 
-- Соедините первую букву имени с семью первыми буквами фамилии 
-- для получения идентификатора пользователя для данного служащего.

create table hr.MY_EMP (
    id varchar(8) primary key,
    full_name varchar(50)
);

select  upper(substr(first_name, 0, 1)) || 
        upper(substr(last_name, 0, 7)) as KEY,
        last_name || ' ' || first_name as FIO
FROM hr.employees;

--insert into hr.MY_EMP
--select  upper(substr(first_name, 0, 1)) || 
--        upper(substr(last_name, 0, 7)) as KEY,
--        last_name || ' ' || first_name as FIO
--FROM hr.employees;

insert into hr.MY_EMP (id, full_name) 
    values ( 
                concat(upper(substr('&&first_name', 0, 1)), 
                       upper(substr('&&last_name',  0, 7))), -- KEY
                concat('&last_name', '&first_name'));        -- FIO
            
undefine full_name;
undefine first_name;
undefine last_name;
undefine id;
-- drop table hr.MY_EMP;

SELECT * FROM hr.MY_EMP;

--11. Выведите все департаменты и их директоров, в которых работают больше 30-ти сотрудников.
select * from hr.departments;

select  department_id, 
        manager_id, 
        count(*) over (partition by department_id) total
from hr.employees;


select  department_id, 
        (select manager_id 
                from hr.departments 
                where department_id = e.department_id) manager,
        (select last_name||' '|| first_name 
                from hr.employees 
                where employee_id = (select manager_id 
                                            from hr.departments 
                                            where department_id = e.department_id)) FIO,
        count(*)
from hr.employees e
group by department_id
having count(*) > 30;


--12. Выведите всех сотрудников, которые не состоят ни в одном департаменте.

select * from hr.employees 
         where department_id is null;

-- исправить
--13. Получить список сотрудников менеджеры которых
--    устроились на работу в январе месяце любого года и длина job title этих сотрудников больше 15-ти символов.

with januaryManagers as (select distinct manager_id,

        to_char((select hire_date 
        from hr.employees 
        where employee_id = outer.manager_id), 'mm')

from hr.employees outer
where to_char((select hire_date 
        from hr.employees 
        where employee_id = outer.manager_id), 'mm') = '01'
)

select * from hr.employees where manager_id in (select manager_id from januaryManagers);


--14. Создайте последовательность для столбца главного ключа таблицы DE DEPT. 
-- Последовательность должна начинаться с 200 и иметь максимальное значение 1000. 
-- Шаг приращения значений - 10. Назовите последовательность dept_id_seq.

drop sequence dept_id_seq;
drop table de_dept;

create sequence dept_id_seq
    increment by 10
    start with 200
    maxvalue 1000;

create table de_dept(
    id numeric default dept_id_seq.nextval primary key
);

insert into de_dept(id) values(dept_id_seq.nextval);
insert into de_dept(id) values(dept_id_seq.nextval);

select * from de_dept;

--15. Напишите запрос для поиска всех сотрудников, зарабатывающих больше средней зарплаты по их отделу. 
-- Выведите фамилию, оклад, номер отдела и среднюю зарплату по отделу. 
-- Отсортируйте по средней зарплате. 
-- Используйте псевдонимы для столбцов, полученных запросом, как показано в примере. 

-- TODO ПОДУМАТЬ

select salary from hr.employees where department_id = 60;

select sum(salary) / count(salary) from hr.employees where department_id = 60;


select  employee_id, 
        last_name, 
        salary + salary * nvl(commission_pct, 0) "sal", 
        department_id,
        round((select avg(salary) from hr.employees where department_id = outer.department_id ), 1) as startdart_avg
        from hr.employees outer 
        where salary + salary * nvl(commission_pct, 0) > (select avg(salary) 
                        from hr.employees 
                        where department_id = outer.department_id)
order by salary;


--16. Создать с отступом отчет, показывающий иерархии управления, 
-- начиная с сотрудника, LAST NAME которого является Kochhar. 
-- Печать фамилию сотрудника, ID менеджера, а также ID отдела, 
-- Дайте имена псевдонимов для столбцов, как показано на образце. 

select (lpad(' ', 2 * (level-1)) || level || ')'||last_name||' '||first_name) as "Сотрудник",
        manager_id             "ID Менеджера",
        (select last_name||' '||substr(first_name,0,1)||'.' from hr.employees where employee_id = outer.manager_id) "Менеджер", 
        job_id             "ID отдела",
        employee_id        "ID сотрудника",
        department_id      "ID департамента"
from hr.employees outer
start with lower(last_name) = 'kochhar'
connect by prior employee_id = manager_id;

--
--17. Раздать сотрудникам места в порядке убывания возрастания зарплат, используя функции ранжирования 

select  first_name ||' '|| last_name "FIO", 
        salary, 
        rank()       over (order by salary desc) "RANK",
        dense_rank() over (order by salary desc) "DESNE_RANK"
from hr.employees;


--18. Выдать список специалистов по продажам в каждом отделе,
--    имеющих одну из трех максимальных зарплат".
select last_name, department_id, job_id, salary from hr.employees
    where job_id in ('SA_MAN', 'SA_REP') 
          and salary in
          (with salaries as (select distinct salary 
                from hr.employees 
           order by 1 desc) 
select * from salaries where rownum <= 3);






-- ========================================================== 6 LAB WORK Сложные операторы и многострочные функции

SET SERVEROUTPUT ON;  -- Чтобы показывать в script output



-- TASK 1. Создайте и выполните простой анонимный блок, который выводит на экран «Hello, world». 
-- Или можно через VIEW -> DBMS OUTPUT
begin 
    dbms_output.put_line('Date: ' || sysdate || ' Hello, world!');
end;


--TASK 2. Модифицируйте программу, которую вы написали в задании 
--a. Добавьте секцию объявления переменных. Объявите следующие переменные: 
--i. Переменную today типа DATE. Инициализируйте ее значением Sysdate. 

DECLARE 
    today date := sysdate;
begin 
    dbms_output.put_line('Date: ' || today);
end;


--ii. Переменную tomorrow такого же типа как today, используя %TYPE. 

DECLARE 
    today DATE := SYSDATE;
    tomorrow today%TYPE := SYSDATE + 1;
BEGIN 
    dbms_output.put_line('Date today: ' || today);
    dbms_output.put_line('Date tomorrow: ' || tomorrow);
END;


--b. В основной секции инициализируйте переменную tomorrow значением, равным дате завтрашнего дня (добавьте 1 к переменной today). Выведите на экран значения переменных today и tomorrow после вывода на экран «Hello, world». 

DECLARE 
    today DATE := SYSDATE;
    tomorrow today%TYPE := SYSDATE + 1;
BEGIN 
    dbms_output.put_line('HELLO WORLD!');
    dbms_output.put_line('Date today: ' || today);
    dbms_output.put_line('Date tomorrow: ' || tomorrow);
END;

--TASK 3. Используя таблицу DEPARTMENTS, выведите максимальный department id.

DECLARE 
    dept_id hr.departments.department_id%TYPE;
BEGIN
    SELECT max(department_id) into dept_id from hr.departments;    
    DBMS_OUTPUT.PUT_LINE('MAX department id is: '|| dept_id);
END;


-- TASK 4. Используя таблицу EMPLOYEE, выведите информацию о сотруднике c employee id=110.
-- Сообщение должно выглядеть так: Привет, John Твоя зарплата $8200 

-- TASK 4
DEFINE emp_id = 110;
DECLARE
    v_emp_name hr.employees.first_name%TYPE;
    v_emp_sal  hr.employees.salary%TYPE;
BEGIN
    SELECT first_name, salary 
        INTO v_emp_name, v_emp_sal 
        FROM hr.employees 
        WHERE employee_id = &emp_id;
        
    DBMS_OUTPUT.PUT_LINE('HELLO: '|| v_emp_name);
    DBMS_OUTPUT.PUT_LINE('Your salary is: '|| v_emp_sal);
END;


-- TASK 5
--5. Модифицируйте программу. 
--Сравните зарплату Джона со средней, минимальной и максимальной зарплатой в его департаменте. 
--Если больше, то напишите «больше», если меньше, то «меньше», если равна, то «равна». 

DEFINE emp_id = 110;
DECLARE
    v_dept_id          hr.employees.department_id%TYPE;
    v_emp_name         hr.employees.first_name%TYPE;
    v_emp_sal          hr.employees.salary%TYPE;
    v_min_sal_in_dept  hr.employees.salary%TYPE;
    v_avg_sal_in_dept  hr.employees.salary%TYPE;
    v_max_sal_in_dept  hr.employees.salary%TYPE;
BEGIN
    SELECT 
        first_name, 
        salary,    
        department_id INTO 
        v_emp_name, v_emp_sal, v_dept_id 
    FROM hr.employees 
    WHERE employee_id = &emp_id;
    
    SELECT 
        min(salary),       
        avg(salary),       
        max(salary) INTO 
        v_min_sal_in_dept, v_avg_sal_in_dept, v_max_sal_in_dept 
    FROM hr.employees 
    WHERE department_id = v_dept_id;
    
    DBMS_OUTPUT.PUT_LINE('HELLO: '|| v_emp_name);
    DBMS_OUTPUT.PUT_LINE('Your salary is: $'|| v_emp_sal);
    
    DBMS_OUTPUT.PUT_LINE('MIN salary in your department is: $'|| v_min_sal_in_dept);
    DBMS_OUTPUT.PUT_LINE('AVG salary in your department is: $'|| v_avg_sal_in_dept);
    DBMS_OUTPUT.PUT_LINE('MAX salary in your department is: $'|| v_max_sal_in_dept);
    
    IF v_emp_sal > v_min_sal_in_dept THEN
        DBMS_OUTPUT.PUT_LINE('Your salary greater than minimal salary for: $'|| to_char(v_emp_sal - v_min_sal_in_dept));
    ELSE
        DBMS_OUTPUT.PUT_LINE('Your salary is MINIMAL: $'|| v_emp_sal);
    END IF;
    
    IF v_emp_sal >= v_avg_sal_in_dept THEN
        DBMS_OUTPUT.PUT_LINE('Your salary greater than AVG salary for: $'|| to_char(v_emp_sal - v_avg_sal_in_dept));
    ELSE
        DBMS_OUTPUT.PUT_LINE('Your salary smaller than AVG salary for: $'|| to_char(v_avg_sal_in_dept - v_emp_sal));
    END IF;
    
    IF v_emp_sal < v_max_sal_in_dept THEN
        DBMS_OUTPUT.PUT_LINE('Your salary smaller than maximum salary for: $'|| to_char(v_max_sal_in_dept - v_emp_sal));
    ELSE
        DBMS_OUTPUT.PUT_LINE('Your salary is MAXIMAL in your department: $'|| to_char(v_emp_sal));
    END IF;  
END;
/

select min(salary), avg(salary), max(salary) from hr.employees where department_id = 100;


--6. Модифицируйте программу, которую вы написали в задании 4. 
--Выведите на экран столько звездочек (*), сколько целых тысяч в зарплате Джона. 
--(Подсказка: для округления числа использовать структуру number(n,m))


-- TASK 6
DEFINE emp_id = 110;
DECLARE
    v_emp_name hr.employees.first_name%TYPE;
    v_emp_sal  hr.employees.salary%TYPE;
    v_sal_thouthands NUMBER;
    v_stars          VARCHAR(20);
BEGIN
    SELECT first_name, salary, round(salary / 1000) 
        INTO v_emp_name, v_emp_sal, v_sal_thouthands
        FROM hr.employees 
        WHERE employee_id = &emp_id;
        
    DBMS_OUTPUT.PUT_LINE('HELLO: '|| v_emp_name);
    DBMS_OUTPUT.PUT_LINE('Your salary is: '|| v_emp_sal);
    
    FOR i in 1..v_sal_thouthands LOOP
        SELECT rpad('*', i, '*') INTO v_stars from dual;
        DBMS_OUTPUT.PUT_LINE(to_char(i) || ') ' || v_stars);
    END LOOP;
END;

-- WITHOUT ROUND FUNCTION

-- TASK 6 part 2 - WITHOUT ROUND
DEFINE emp_id = 110;
DECLARE
    v_emp_name hr.employees.first_name%TYPE;
    v_emp_sal  hr.employees.salary%TYPE;
    v_sal_thouthands NUMBER(10,0);
    v_stars          VARCHAR(20);
BEGIN
    SELECT first_name, salary, salary / 1000
        INTO v_emp_name, v_emp_sal, v_sal_thouthands
        FROM hr.employees 
        WHERE employee_id = &emp_id;
        
    DBMS_OUTPUT.PUT_LINE('HELLO: '|| v_emp_name);
    DBMS_OUTPUT.PUT_LINE('Your salary is: '|| v_emp_sal);
    
    FOR i in 1..v_sal_thouthands LOOP
        SELECT rpad('*', i, '*') INTO v_stars from dual;
        DBMS_OUTPUT.PUT_LINE(to_char(i) || ') ' || v_stars);
    END LOOP;
END;


--TASK 7. Выведите информацию о сотрудниках, отсортировав их по идентификационному номеру, 
--работающих в первых трех попавшихся департаментах.

DECLARE
    emp_name hr.employees.last_name%TYPE;
    dept_id  hr.employees.department_id%TYPE;
BEGIN
    FOR i IN 100..113 LOOP
        SELECT last_name, department_id INTO emp_name, dept_id FROM hr.employees WHERE employee_id = i;
        DBMS_OUTPUT.PUT_LINE(emp_name ||' ' || dept_id);
    END LOOP;
END;




WITH firstThreeDeps AS (
    SELECT DISTINCT department_id FROM (
        SELECT department_id, 
            COUNT(department_id) OVER (ORDER BY employee_id) dept_order_cnt FROM (
                SELECT  department_id,  
                        employee_id, 
                        ROW_NUMBER() 
                        OVER (partition BY  department_id ORDER BY employee_id) as dept_emp_cnt
            FROM hr.employees ORDER BY employee_id
        ) WHERE dept_emp_cnt=1
    ) WHERE dept_order_cnt <=3 
)
SELECT * FROM  hr.employees join firstThreeDeps USING(department_id) 
ORDER BY employee_id;


--  Функция для подсчета кол-ва сотрудников в первых трех департаментах
CREATE OR REPLACE FUNCTION firstThreeDepsCount RETURN NUMBER IS 
    depsCnt NUMBER;
BEGIN
    WITH firstThreeDeps AS (
    SELECT DISTINCT department_id FROM (
        SELECT department_id, 
            COUNT(department_id) OVER (ORDER BY employee_id) dept_order_cnt FROM (
                SELECT  department_id,  
                        employee_id, 
                        ROW_NUMBER() 
                        OVER (partition BY  department_id ORDER BY employee_id) as dept_emp_cnt
                FROM hr.employees ORDER BY employee_id
            ) WHERE dept_emp_cnt=1
        ) WHERE dept_order_cnt <=3 
    ) SELECT count(*) INTO depsCnt FROM  hr.employees join firstThreeDeps USING(department_id);
RETURN depsCnt;
END firstThreeDepsCount;


select firstThreeDepsCount() from dual;


-- TASK 8. Используя тип запись 

DECLARE TYPE emp_table_type IS TABLE OF
    hr.employees%ROWTYPE INDEX BY PLS_INTEGER;
    my_emp_table emp_table_type;
BEGIN
    FOR i IN 100..(99+firstThreeDepsCount())
    LOOP
        SELECT *  INTO my_emp_table(i) FROM hr.employees
        WHERE employee_id = i; 
    END LOOP;
    
    FOR i IN my_emp_table.FIRST..my_emp_table.LAST
    LOOP
        DBMS_OUTPUT.PUT_LINE(my_emp_table(i).last_name || ' ' ||my_emp_table(i).department_id);
    END LOOP;
END;
/

-- TASK 9. Вывод в обратном порядке

DECLARE TYPE emp_table_type IS TABLE OF
    hr.employees%ROWTYPE INDEX BY PLS_INTEGER;
    my_emp_table emp_table_type;
BEGIN
    FOR i IN 100..(99+firstThreeDepsCount())
    LOOP
        SELECT *  INTO my_emp_table(i) FROM hr.employees
        WHERE employee_id = i; 
    END LOOP;
    
    FOR i IN REVERSE my_emp_table.FIRST..my_emp_table.LAST
    LOOP
        DBMS_OUTPUT.PUT_LINE(my_emp_table(i).last_name || ' ' ||my_emp_table(i).department_id);
    END LOOP;
END;
/

-- TASK 10. список фамилий и имен всех сотрудников из таблицы EMPLOYEES, отсортировав их по фамилии
-- с явно заданным курсором

DECLARE
    CURSOR getEmployees IS SELECT * FROM hr.employees order by last_name;   -- Объявляется курсор
	v_emp getEmployees%ROWTYPE;                          -- переменная запись, где будут хранится данные
BEGIN
    DBMS_OUTPUT.PUT_LINE('С явно заданным курсором');					
	OPEN getEmployees;   	-- Открывается курсор.

	LOOP  	                -- Запускается цикл чтения.
		FETCH getEmployees INTO v_emp;     -- Выбираются данные	
		EXIT WHEN getEmployees%NOTFOUND;
		DBMS_OUTPUT.PUT_LINE(v_emp.last_name || ' ' || v_emp.first_name);					
	END LOOP;

	CLOSE getEmployees;  -- Закрывается курсор
END;
/

-- без явно заданного курсора
DECLARE
    CURSOR getEmployees IS SELECT * FROM hr.employees order by last_name;   -- Объявляется курсор
	v_emp getEmployees%ROWTYPE;                          -- переменная запись, где будут хранится данные
BEGIN
    DBMS_OUTPUT.PUT_LINE('Без явно заданного курсора');					

	FOR v_emp in getEmployees LOOP  	        
			DBMS_OUTPUT.PUT_LINE(v_emp.last_name || ' ' || v_emp.first_name);					
	END LOOP;
END;
/


/* TASK 11. Выведите фамилии и номера департаментов сотрудников, отсортировав их по фамилии, 
работающих в первых трех попавшихся департаментах. 
Сообщение должно выглядеть так: Abel 80 Ande 80 Atkinson 50 Austin 60 */


WITH uniq_deps AS (
    SELECT department_id 
    FROM hr.employees 
    GROUP BY department_id
) 
SELECT *  FROM uniq_deps 
OFFSET 9 ROWS 
FETCH NEXT 3 ROWS ONLY;
/

-- без явно заданного курсора
DECLARE
    cnt NUMBER := 1;
    CURSOR getEmployees IS 
        SELECT * FROM hr.employees 
            WHERE department_id 
                IN (WITH uniq_deps AS (
                    SELECT department_id 
                    FROM hr.employees 
                    GROUP BY department_id
                ) 
                    SELECT *  FROM uniq_deps 
                    OFFSET 9 ROWS 
                    FETCH NEXT 3 ROWS ONLY
                ) and rownum < 10 order by last_name;  
	v_emp getEmployees%ROWTYPE;   -- переменная запись, где будут хранится данные
BEGIN
    DBMS_OUTPUT.PUT_LINE('Фамилии и номера сотрудников в первых трех попавшихся департаментах');					
	FOR v_emp in getEmployees LOOP  	        
			DBMS_OUTPUT.PUT_LINE(to_char(cnt)|| ') ' || v_emp.last_name || ' ' || v_emp.department_id);
            cnt:=cnt+1;
	END LOOP;
END;
/

/*
TASK 12. Создайте анонимный блок, который бы обновлял номера регионов для служащих отделов. 
a) Напишите обработчик исключений, который будет выдавать сообщение о том, что указанный регион не существует 
б) Напишите обработчик исключений, который бы выдавал пользователю сообщение о том, что для указанного региона уже есть отдел с таким названием 
b) Напишите обработчик исключений, который выдавал бы пользователю сообщение о том, что указанный номер отдела не существует (используйте атрибут SQL%NOTFOUND и возбудите исключение вручную). 
*/

-- a) Напишите обработчик исключений, который будет выдавать сообщение о том, что указанный регион не существует 
DECLARE
    loc_id NUMBER := 999;
    city_name hr.locations.city%TYPE;
BEGIN
    BEGIN
        SELECT city INTO city_name 
            FROM hr.locations WHERE location_id = loc_id;  
        EXCEPTION WHEN NO_DATA_FOUND 
        THEN DBMS_OUTPUT.PUT_LINE('LOCATION NOT FOUND for location_id = ' || loc_id);
    END;
    
    IF SQL%NOTFOUND THEN
        DBMS_OUTPUT.PUT_LINE('SQL DATA NOT FOUND');
    ELSIF SQL%FOUND THEN
        DBMS_OUTPUT.PUT_LINE('DATA FOUND');
    END IF;
END;
/

-- б) Напишите обработчик исключений, который бы выдавал пользователю сообщение о том, что для указанного региона уже есть отдел с таким названием 

DECLARE
    loc_id NUMBER;
    city_name hr.locations.city%TYPE := 'Roman';

BEGIN
    BEGIN
        SELECT location_id INTO loc_id 
            FROM hr.locations WHERE city = city_name;  
        EXCEPTION WHEN NO_DATA_FOUND 
        THEN DBMS_OUTPUT.PUT_LINE('The city ' || city_name || ' not exists, you can add it');
    END;
    
    IF SQL%NOTFOUND THEN
        DBMS_OUTPUT.PUT_LINE('SQL DATA NOT FOUND');
    ELSIF SQL%FOUND THEN
        DBMS_OUTPUT.PUT_LINE('CITY ALREADY EXISTS: ' || city_name);
    END IF;
END;
/

-- c) Напишите обработчик исключений, который выдавал бы пользователю сообщение о том, что указанный номер отдела не существует (используйте атрибут SQL%NOTFOUND и возбудите исключение вручную). 

DECLARE
    dept_id NUMBER := 10;
    dept_name hr.departments.department_name%TYPE ;
BEGIN
    BEGIN
        SELECT department_name INTO dept_name 
            FROM hr.departments WHERE department_id = dept_id;  
        EXCEPTION WHEN NO_DATA_FOUND 
        THEN DBMS_OUTPUT.PUT_LINE('The department_id = ' || dept_id || ' not found');
    END;
    
    IF SQL%NOTFOUND THEN
        DBMS_OUTPUT.PUT_LINE('SQL DATA NOT FOUND');
    ELSIF SQL%FOUND THEN
        DBMS_OUTPUT.PUT_LINE('DEPARTMENT ALREADY EXISTS: ' || dept_name);
    END IF;
END;
/


-- TASK 13. Напишите анонимный блок для вывода фамилии и названия отдела для служащих, 
-- чья заработная плата лежит в диапазоне плюс-минус 100$ от введенного значения.


DECLARE 

    TYPE emp_table_type IS TABLE OF hr.employees%ROWTYPE INDEX BY PLS_INTEGER;
    max_sal hr.employees.salary%TYPE;
    min_sal hr.employees.salary%TYPE;
    v_sal NUMBER;
    v_sal_found_cnt NUMBER := 0;
     
    CURSOR getEmployees IS (select * from hr.employees);
    e_salary_not_found EXCEPTION;
    
BEGIN
    v_sal := &v_sal;
    select max(salary) INTO max_sal from hr.employees;
    select min(salary) INTO min_sal from hr.employees;
    
    DBMS_OUTPUT.PUT_LINE('Введенная зарплата: ' || v_sal);
    DBMS_OUTPUT.PUT_LINE('MAX SALARY IS: ' || max_sal);
    DBMS_OUTPUT.PUT_LINE('MIN SALARY IS: ' || min_sal);
    
    IF (v_sal > max_sal + 100) THEN
        DBMS_OUTPUT.PUT_LINE('Введенная зарплата больше максимальной на '|| to_char(v_sal - max_sal));
        raise e_salary_not_found;
        
    ELSIF (v_sal < min_sal + 100) THEN
        DBMS_OUTPUT.PUT_LINE('Введенная зарплата меньше минимальной на '|| to_char(min_sal - v_sal));
        raise e_salary_not_found;

    ELSE
        DBMS_OUTPUT.PUT_LINE('Все пользователи у которых зарплата отличается на +/- 100 долларов от введенной');

        FOR emp in getEmployees LOOP 
            IF ABS(v_sal - emp.salary) <= 100 THEN
                DBMS_OUTPUT.PUT_LINE(emp.employee_id || ') '||rpad(emp.last_name || emp.first_name, 20, ' ') || rpad(emp.salary, 10, ' '));
                v_sal_found_cnt := v_sal_found_cnt+1;
            END IF;
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('Всего найдено сотрудников: ' || v_sal_found_cnt);

    END IF;

    EXCEPTION WHEN e_salary_not_found THEN
        DBMS_OUTPUT.PUT_LINE('Сработало исключение. Такой зарплаты не существует');
END;

/


-- ============================================================================= 7 LAB WORK Управляющие структуры


CREATE OR REPLACE FUNCTION work_years(emp_id IN NUMBER) 
RETURN NUMBER IS 
    worked_years NUMBER;
BEGIN
    SELECT (EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM hire_date))
    INTO worked_years 
    FROM hr.employees 
    WHERE employee_id = emp_id;
    
    RETURN worked_years;
END;
/



SELECT work_years(100) FROM dual;

--Задание 1. Напишите код PL/SQL, который бы: 
--1. Запрашивал информацию о номере сотрудника (employee id) в таблице hr.employees. 
--2. На основе информации о номере сотрудника производил проверку количества лет, которое отработал сотрудник. 

SET SERVEROUTPUT ON;

DECLARE 
    TYPE emp_table_type IS TABLE OF hr.employees%ROWTYPE INDEX BY PLS_INTEGER;
    emp_table emp_table_type;

    emp_row hr.employees%ROWTYPE;
    emp_id hr.employees.employee_id%TYPE;
    emp_work_years NUMBER;
    sal_percent NUMBER;
    new_emp_sal NUMBER;

BEGIN
    emp_id := &emp_id;
    SELECT * INTO emp_row FROM HR.employees WHERE employee_id = emp_id;
    DBMS_OUTPUT.PUT_LINE(emp_row.last_name || ' ' || emp_row.first_name || ' Кол-во отработанных лет: ' || work_years(emp_row.employee_id));
    
    -- 3. После этого нужно изменить значение заработной платы (столбец salary) 
    -- для данного сотрудника в соответствии со следующими условиями: 
    
    emp_work_years := work_years(emp_row.employee_id);
    
    --если сотрудник проработал меньше 10 лет, то зарплата повышается на 5 процентов; 
    --если сотрудник проработал 10 лет или больше, то зарплата повышается на 10 процентов; 
    --если сотрудник проработал 15 лет или больше, то зарплата повышается на 15 процентов. 

    sal_percent := CASE 
        WHEN emp_work_years < 10 THEN 1.05
        WHEN emp_work_years < 15 THEN 1.1
        ELSE 1.15
    END;  
    
    DBMS_OUTPUT.PUT_LINE('Зарплата увеличена на: '|| sal_percent || ' %');
    
    SELECT ROUND(salary * sal_percent) 
        INTO new_emp_sal 
        FROM hr.employees 
        WHERE employee_id = emp_id;
    
    DBMS_OUTPUT.PUT_LINE('Была зарплата: '|| emp_row.salary || ' $');
    DBMS_OUTPUT.PUT_LINE('Прибавлено к зарплате: '|| to_char(new_emp_sal - emp_row.salary) || ' $');

    UPDATE HR.employees 
        SET salary = new_emp_sal
        WHERE employee_id = emp_id;

    DBMS_OUTPUT.PUT_LINE('Установленная зарплата: '|| new_emp_sal || ' $');

END;
/

SELECT salary, ROUND(salary * 1.15) from hr.employees where employee_id = 100;

/

CREATE OR REPLACE FUNCTION ten_years_date(emp_id IN NUMBER) 
RETURN VARCHAR2 IS 
    jubiley_date VARCHAR2(20); -- Юбилейная дата 10 лет
BEGIN

    SELECT TO_CHAR(add_months(hire_date, 12 * 10), 'dd-MON-yyyy')
        INTO jubiley_date 
        FROM hr.employees 
    WHERE employee_id = emp_id;
    
    RETURN jubiley_date;
END;
/

CREATE OR REPLACE FUNCTION format_emp_date(emp_id IN NUMBER) 
RETURN VARCHAR2 IS 
    v_date VARCHAR2(20); -- Юбилейная дата 10 лет
BEGIN

    SELECT TO_CHAR(hire_date, 'dd-MON-yyyy')
        INTO v_date 
        FROM hr.employees 
    WHERE employee_id = emp_id;
    
    RETURN v_date;
END;
/


SELECT hire_date, ten_years_date(employee_id) from hr.employees where employee_id = 100;


--Задание 3. Вычислить либо общее количество лет, которые сотрудник проработал на фирме 
-- либо дату десятилетия его рабочей деятельности в зависимости от флага. 

DECLARE 
    CURSOR getEmployees IS SELECT * FROM hr.employees order by hire_date;   -- Объявляется курсор
	v_emp getEmployees%ROWTYPE;     
    emp_work_years NUMBER;
    work_more_than_ten_years NUMBER := 0;
BEGIN
    
    DBMS_OUTPUT.PUT_LINE(rpad('_', 100, '_'));

    DBMS_OUTPUT.PUT_LINE(
            RPAD('FIO', 20, ' ') || 
            RPAD('Дата приема на работу',    25, ' ') || 
            RPAD('Кол-во отработанных лет ', 25, ' ') || 
            RPAD('Дата юбилея ',             25, ' ') || '');
    
    DBMS_OUTPUT.PUT_LINE(rpad('_', 100, '_'));
        
    FOR v_emp in getEmployees LOOP  
        emp_work_years :=  work_years(v_emp.employee_id);

        DBMS_OUTPUT.PUT_LINE(
            RPAD((v_emp.last_name || ' ' || v_emp.first_name), 20, ' ') || 
            RPAD(format_emp_date(v_emp.employee_id), 25, ' ') || 
            RPAD(emp_work_years,                     25, ' ') || 
            RPAD(ten_years_date(v_emp.employee_id) , 25, ' ')
        );
        
        IF emp_work_years >= 10 THEN
            work_more_than_ten_years := work_more_than_ten_years + 1;
        END IF;
        
	END LOOP;
    
    DBMS_OUTPUT.PUT_LINE(chr(13)||'Проработали больше 10 лет: ' || work_more_than_ten_years || ' сотрудников'); --chr(13) - начать с новой строки

END;
/

--
--• Создайте таблицу STAG со следующими полями (id number, emp_id, FIO varchar2, ord id number, ord name varchar2, commentar varchar2). Заполните таблицу данными, имеющимися в базе (используйте данные из таблиц). Для задания первичного ключа создайте последовательность. 
--• с четными номерами добавьте в столбец комментария сообщение «стаж XXX лет», где XХХ- вычисленное количество отработанных сотрудником лет. 
--• с нечетными номерами добавьте в столбец комментария сообщение «До 10-тилетия раб. деят. Осталось XХX лет», где XХX - вычисленное количество лет, которые осталось проработать сотруднику до 10- тилетнего юбилея. 
--• количество сотрудников, проработавших на фирме более 10 лет. Вывести сообщение «ХХХ сотрудников проработало на фирме более 10 лет», где XХX - вычисленное количество сотрудников. 
--• Если у сотрудника в текущую дату (sysdate) - юбилей, сообщение «Поздравляем вывести на СОТРУДНИК ИМЯ с 10-тилетием его рабочей деятельности!»
--

CREATE SEQUENCE stag_table_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE  -- cache определяет, сколько значений последовательности будут сохранены в памяти для быстрого доступа
             -- nocache означает, что ни одно из значений последовательности не хранятся в памяти. 
    NOCYCLE;
    
-- DROP TABLE STAG;
CREATE TABLE STAG (
    stag_id   NUMERIC DEFAULT stag_table_seq.NEXTVAL PRIMARY KEY,
    emp_id    NUMERIC,
    FIO       VARCHAR2(50),
    commentar VARCHAR2(200) 
);

/
DECLARE 
    CURSOR getEmployees IS SELECT * FROM hr.employees order by hire_date;   -- Объявляется курсор
	v_emp getEmployees%ROWTYPE;     
    emp_work_years NUMBER;
    work_more_than_ten_years NUMBER := 0;
    work_more_than_20_years  NUMBER := 0;

    FIO       VARCHAR2(50);
    v_comment VARCHAR2(200);
    
BEGIN
    
    DBMS_OUTPUT.PUT_LINE(rpad('_', 100, '_'));

    FOR v_emp in getEmployees LOOP  
        emp_work_years :=  work_years(v_emp.employee_id);
        FIO := (v_emp.last_name || ' ' || v_emp.first_name);
        
                
        IF emp_work_years = 20 THEN
            v_comment := ('Поздравляем с 20-тилетием его рабочей деятельности!');
        ELSIF MOD(emp_work_years, 2) = 1 AND emp_work_years < 20 THEN 
            v_comment := ('До 20-тилетия раб. деят. Осталось '|| to_char(20 - emp_work_years) ||' years');
        ELSE
            v_comment := ('Cтаж '|| to_char(emp_work_years) ||' лет');
        END IF;

        
        BEGIN
            SELECT FIO INTO FIO FROM STAG WHERE emp_id = v_emp.employee_id;
            
            EXCEPTION WHEN NO_DATA_FOUND THEN
            null;
        END;
        
        IF SQL%NOTFOUND THEN
                INSERT INTO STAG (emp_id, FIO, commentar) VALUES (v_emp.employee_id, FIO, v_comment);
                DBMS_OUTPUT.PUT_LINE('INSERT :: ' || RPAD(FIO, 20, ' '));
        ELSIF SQL%FOUND THEN 
                UPDATE STAG SET
                    STAG.FIO = FIO,
                    STAG.commentar = v_comment
                WHERE emp_id = v_emp.employee_id;
                DBMS_OUTPUT.PUT_LINE('UPDATE :: ' || RPAD(FIO, 20, ' ') || v_comment);
        END IF;

        IF emp_work_years >= 20 THEN
            work_more_than_20_years := work_more_than_20_years + 1;
        ELSIF emp_work_years >= 10 THEN
            work_more_than_ten_years := work_more_than_ten_years + 1;
        END IF;

	END LOOP;
    
    DBMS_OUTPUT.PUT_LINE(chr(13)||'Проработали больше 10 лет: ' || work_more_than_ten_years || ' employee'); --chr(13) - начать с новой строки
    DBMS_OUTPUT.PUT_LINE(chr(13)||'Проработали больше 20 лет: ' || work_more_than_20_years || ' employee'); 
    
END;
/

select * from stag;

-- ============================================================================= 8 LAB WORK КУРСОРЫ


--1. Если в таблице COUNTRIES есть Россия (id='RF'), то поменять на Казахстан используя курсор. 
-- Если нет, то добавить Казахстан в таблицу. 
-- Вывести способ, которым был добавлен Казахстан (INSERT или UPDATE).

select * from hr.countries;
select * from hr.regions;
/
delete from hr.countries where country_id = 'RF';

BEGIN
    -- Если в таблице COUNTRIES есть Россия (id='RF'), то поменять на Казахстан 
    UPDATE hr.countries 
        SET   country_name = 'Kazakhstan' 
        WHERE country_id='RF';
            
    IF SQL%NOTFOUND THEN  -- Если нет, то добавить Казахстан в таблицу. 
        INSERT INTO hr.countries 
                VALUES ('RF', 'Kazakhstan', (SELECT region_id FROM hr.regions WHERE region_name = 'Asia'));
        DBMS_OUTPUT.PUT_LINE('INSERT :: new value :: KAZAKHSTAN');
    ELSE
        DBMS_OUTPUT.PUT_LINE('UPDATE :: value with code RF updated to KAZAKHSTAN');
    END IF;
END;
/
rollback;


--2. Выведите список фамилий и имен всех сотрудников из таблицы EMPLOYEES, 
-- отсортировав их по фамилии. Решите двумя способами 
-- (используя курсорный цикл без объявления курсора и явно заданный курсор).

DECLARE
    CURSOR getEmployees IS SELECT * FROM hr.employees order by last_name;   -- Объявляется курсор
	v_emp getEmployees%ROWTYPE;                          -- переменная запись, где будут хранится данные
BEGIN
    DBMS_OUTPUT.PUT_LINE(' == С явно заданным курсором');					
	OPEN getEmployees;   	-- Открывается курсор.

	LOOP  	                -- Запускается цикл чтения.
		FETCH getEmployees INTO v_emp;     -- Выбираются данные	
		EXIT WHEN getEmployees%NOTFOUND;
		DBMS_OUTPUT.PUT_LINE(v_emp.last_name || ' ' || v_emp.first_name);					
	END LOOP;

	CLOSE getEmployees;  -- Закрывается курсор
END;
/

-- без явно заданного курсора
DECLARE
    CURSOR getEmployees IS SELECT * FROM hr.employees order by last_name;   -- Объявляется курсор
	v_emp getEmployees%ROWTYPE;                          -- переменная запись, где будут хранится данные
BEGIN
    DBMS_OUTPUT.PUT_LINE(' == Без явно заданного курсора');					

	FOR v_emp in getEmployees LOOP  	        
			DBMS_OUTPUT.PUT_LINE(v_emp.last_name || ' ' || v_emp.first_name);					
	END LOOP;
END;
/

--3. Выведите фамилии и названия департаментов сотрудников, отсортировав их по фамилии, 
-- работающих в первых трех попавшихся департаментах.
-- Сообщение должно выглядеть так: Abel 80 Ande 80 Atkinson 50 Austin 60

SELECT last_name, 
       department_name 
FROM hr.employees 
    JOIN hr.departments 
    USING(department_id) 
WHERE department_id IN (select department_id from hr.departments where rownum <= 3)  --  В первых трех попавшихся департамента
ORDER BY last_name; 


DECLARE
    CURSOR getEmployees IS (
                            SELECT last_name, 
                                    department_name 
                            FROM hr.employees 
                                JOIN hr.departments 
                                USING(department_id) 
                            WHERE department_id IN (select department_id from hr.departments where rownum <= 3))  --  В первых трех попавшихся департамента
                            ORDER BY last_name;  
	v_emp getEmployees%ROWTYPE;                       
BEGIN
    DBMS_OUTPUT.PUT_LINE(rpad('LAST NAME' , 20, ' ') || rpad('DEPARTMENT NAME', 20, ' '));	
    DBMS_OUTPUT.PUT_LINE(rpad('_', 40, '_'));	
	FOR v_emp in getEmployees LOOP  	        
			DBMS_OUTPUT.PUT_LINE(rpad(v_emp.last_name , 20, ' ') || rpad(v_emp.department_name, 20, ' '));					
	END LOOP;
END;
/



--4. Выведите название и id первых n департаментов, отсортированных по названию (число п вводится с клавиатуры).
--Для каждого департамента выведите список (фамилия, должность) сотрудников, чья зарплата меньше средней. 
--Фамилии клерков выведите заглавными буквами. Используйте курсоры с параметрами. 
CREATE OR REPLACE FUNCTION count_avg_in_dept(v_dept_id IN NUMBER)
RETURN NUMBER IS
    avg_in_dept NUMBER;
BEGIN
    SELECT AVG(salary) INTO avg_in_dept FROM hr.employees WHERE department_id = v_dept_id;
    RETURN avg_in_dept;
END;
/

SELECT count_avg_in_dept(10) FROM DUAL;
select * from hr.employees;
DECLARE
    dept_cnt NUMBER := 1;
    n number := &n;
    CURSOR getDepartments IS (SELECT * FROM hr.departments WHERE rownum <= n);
    v_dept getDepartments%ROWTYPE;
    v_avg_sal_in_dept NUMBER;
BEGIN
    FOR v_dept in getDepartments LOOP
        v_avg_sal_in_dept :=  ROUND(count_avg_in_dept(v_dept.department_id));
        IF v_avg_sal_in_dept > 0 THEN
            DBMS_OUTPUT.PUT_LINE(dept_cnt || ') ' ||v_dept.department_name || ', AVG salary: ' || v_avg_sal_in_dept);
            DECLARE 
                CURSOR getEmployeesFromDept IS (SELECT * from hr.employees WHERE department_id = v_dept.department_id AND salary <= v_avg_sal_in_dept) ORDER BY job_id, salary;
                v_emp getEmployeesFromDept%ROWTYPE;
                v_emp_name hr.employees.last_name%TYPE;
            BEGIN
                FOR v_emp in getEmployeesFromDept LOOP
                    v_emp_name :=  v_emp.last_name;
                    IF v_emp.job_id like '%CLERK%' THEN
                        v_emp_name := upper(v_emp_name);
                    END IF;
                    DBMS_OUTPUT.PUT_LINE('      ' || rpad(v_emp_name, '15', ' ') || ' ' || v_emp.job_id || ', ' || v_emp.salary);
                END LOOP;
            END;
        ELSE
            DBMS_OUTPUT.PUT_LINE(dept_cnt || ') ' ||v_dept.department_name || ', no employees');
        END IF;
        dept_cnt := dept_cnt + 1;
    END LOOP;
END;
/
--5. Напишите и запустите блок PL/SQL, который создает отчет со списком регионов мира, 
--стран в этих регионах, а также количество городов в странах. 
--Ограничьте свои регионы регионами Америки (имя региона, например, «%America%»). 
--Упорядочите выходные данные по имени региона и по названию страны в каждом регионе. 

CREATE OR REPLACE Function get_region_id_by_name(v_region_name IN VARCHAR2) 
/* Функция чтобы получить по названию региона идентификатор региона */
RETURN NUMBER IS
    v_region_id NUMBER;
BEGIN
    SELECT region_id INTO v_region_id FROM hr.regions
    WHERE region_name LIKE v_region_name;
RETURN v_region_id;
END;
/


select * from hr.regions WHERE region_name like '%America%';

select * from hr.countries where region_id = get_region_id_by_name('%America%');

select * from hr.locations;

DECLARE
    CURSOR  getRegions   IS (SELECT * FROM hr.regions WHERE region_id = get_region_id_by_name('%America%'));  
	v_reg   getRegions%ROWTYPE;    
BEGIN
    /********** GO BY REGIONS **************/
	FOR v_reg in getRegions LOOP  	        
			DBMS_OUTPUT.PUT_LINE(rpad(v_reg.region_id||')', 2, ' ') || rpad(v_reg.region_name, 20, ' '));	
            
            /********** GO BY COUNTRIES **************/
            DECLARE
                CURSOR getCountries IS (SELECT * FROM hr.countries WHERE region_id = v_reg.region_id) ORDER BY country_name;  
                v_country getCountries%ROWTYPE; 
            BEGIN
                FOR v_country in getCountries LOOP 
                    DBMS_OUTPUT.PUT_LINE(rpad(' ', 5, ' ') || rpad(v_country.country_id, 3, ' ') || rpad(v_country.country_name, 30, ' '));	
                    
                     /********** GO BY CITIES **************/
                    DECLARE
                        CURSOR getCities IS (SELECT * FROM hr.locations WHERE country_id = v_country.country_id) ORDER BY city;  
                        v_city getCities%ROWTYPE; 
                        v_city_cnt NUMBER := 0;
                    BEGIN
                        FOR v_city in getCities LOOP 
                            DBMS_OUTPUT.PUT_LINE(rpad(' ', 10, ' ') || rpad(v_city.city , 30, ' '));
                            v_city_cnt := v_city_cnt + 1;
                        END LOOP;
                        DBMS_OUTPUT.PUT_LINE(rpad(' ', 10, ' ') || '- Кол-во городов в стране: '|| v_city_cnt);		
                    END;
                    /********** END GO BY CITIES **************/
                END LOOP;
            END;
            /********** END GO BY COUNTRIES **************/
	END LOOP;
    /********** END GO BY REGIONS **************/
END;


