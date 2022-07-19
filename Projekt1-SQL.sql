-- Komentarz jednolinjkowy

-- Do not check foreign key constraints
SET FOREIGN_KEY_CHECKS = 0;

-- Projekt 1 - SQL
-- 1. Stwórz Bazę „Sklep odzieżowy”
CREATE DATABASE Sklep_odzieżowy;
USE Sklep_odzieżowy;

-- 2. Utwórz tabelę „Producenci” z kolumnami:
--    id producenta
--    nazwa producenta
--    adres producenta
--    nip producenta
--    data podpisania umowy z producentem
-- Do każdej kolumny ustaw odpowiedni „constraint”
CREATE TABLE Producenci (
id_producenta int primary key, -- musi być unique albo primary key
nazwa_producenta varchar(30) unique,
adres_producenta varchar(50) unique,
nip_producenta bigint(10) unique,
dataPodpisaniaUmowyZ_producentem DATE not null);

-- 3. Utwórz tabelę „Produkty” z kolumnami:
--    id produktu
--    id producenta
--    nazwa produktu
--    opis produktu
--    cena netto zakupu
--    cena brutto zakupu
--    cena netto sprzedaży
--    cena brutto sprzedaży
--    procent VAT sprzedaży
-- Do każdej kolumny ustaw odpowiedni „constraint”
CREATE TABLE Produkty (
id_produktu int unique, -- musi być unique albo primary key
id_producenta int not null, -- musi być unique
nazwa_produktu varchar(30) default null,
opis_produktu set ("damska", 'męska', 'dziecięca', 'unisex'),
cena_netto_zakupu decimal(10,2) check(cena_netto_zakupu >=0),
cena_brutto_zakupu decimal(10,2) check(cena_brutto_zakupu >=0),
cena_netto_sprzedaży decimal(10,2) check(cena_netto_sprzedaży >=0),
cena_brutto_sprzedaży decimal(10,2) check(cena_brutto_sprzedaży >=0),
procent_VAT_sprzedaży decimal(10,2) DEFAULT NULL);

-- 4. Utwórz tabelę „Zamówienia” z kolumnami:
--    id zamówienia
--    id klienta
--    id produktu
--    Data zamówienia
-- Do każdej kolumny ustaw odpowiedni „constraint”
CREATE TABLE Zamówienia (
id_zamówienia int unique, -- musi być unique albo primary key
id_klienta int unique, -- musi być unique albo primary key
id_produktu int not null, -- nie może być UNIQUE albo primary key
Data_zamówienia date not null);

-- 5. Utwórz tabelę „Klienci” z kolumnami:
--    id klienta
--    id zamówienia
--    imię
--    nazwisko
--    adres
-- Do każdej kolumny ustaw odpowiedni „constraint”
CREATE TABLE Klienci (
id_klienta int NOT NULL PRIMARY KEY, -- musi być unique albo primary key
id_zamówienia int not null,
imię varchar(20) DEFAULT NULL,
nazwisko varchar(30) DEFAULT NULL,
adres varchar(100) UNIQUE);

-- 6. Połącz tabele ze sobą za pomocą kluczy obcych:
--    Produkty – Producenci
--    Zamówienia – Produkty
--    Zamówienia - Klienci

-- select * from Produkty;
-- select * from Zamówienia;
-- select * from Klienci;

ALTER TABLE Produkty ADD CONSTRAINT producenci_fk FOREIGN KEY (id_producenta) 
REFERENCES Producenci(id_producenta);

-- ALTER TABLE Produkty DROP FOREIGN KEY producenci_fk;

ALTER TABLE Zamówienia ADD CONSTRAINT produkt_fk FOREIGN KEY (id_produktu) 
REFERENCES Produkty(id_produktu);

ALTER TABLE Zamówienia ADD CONSTRAINT klienci_fk FOREIGN KEY (id_klienta) 
REFERENCES Klienci(id_klienta);

-- 7. Każdą tabelę uzupełnij danymi wg:
--    Tabela „Producenci” – 4 pozycje
--    Tabela „Produkty” – 20 pozycji
--    Tabela „Zamówienia” – 10 pozycji
--    Tabela „Klienci” – 10 pozycji

INSERT INTO Producenci (
id_producenta, 
nazwa_producenta, 
adres_producenta, 
nip_producenta,
dataPodpisaniaUmowyZ_producentem) 
values 
(1, 'LPP', 'Gdańsk 80-769, Łąkowa 39/44', 345492786, '2003-01-08'), 
(2, 'Dagna', 'Gdynia 81-355, wójta Jana Radtkego 35/2', 221875906, '2004-08-01'), 
(3, 'ALPINO', 'Gdańsk 80-354, Subisława 22', 332597831, '2010-03-01'), 
(4, 'Casual', 'Gdynia 81-507, Lecha Bądkowskiego 4', 116978430, '2018-01-19');

select * from Producenci;

INSERT INTO Produkty (
id_produktu, 
id_producenta, 
nazwa_produktu, 
opis_produktu,
cena_netto_zakupu, 
cena_brutto_zakupu, 
cena_netto_sprzedaży, 
cena_brutto_sprzedaży,
procent_VAT_sprzedaży) 
values 
(1, 1, 'sukienka','damska', 39.99, 42.00, 42.99, 44.99, .09), -- wybierany
-- (2, 2, 'spodnie','męska', 42.99, 45.99, 46.99, 48.99, .13), 
(2, 2, null,'męska', 42.99, 45.99, 46.99, 48.99, .13), 
(3, 3, 'bluzka','męska', 33.99, 35.99, 38.99, 39.99, .23), -- wybierany 
(4, 4, 'podkoszulek','dziecięca', 43.99, 45, 48, 49, .07), 
(5, 1, 'czapka','dziecięca', 28.99, 30, 32.99, 34.10, .09), -- wybierany
(6, 2, 'majtki','męska', 34.99, 37, 38.99, 39.99, .13),
(7, 3, 'kapelusz','męska', 35.99, 38.99, 40.00, 42.00, .23), -- wybierany
(8, 4, 'czapka','damska', 38.99, 39.99, 41.99, 43.99, .07),
(9, 1, 'golf','damska', 26.99, 29.99, 32.99, 34.99, .07), -- wybierany
(10, 2, 'czapka','dziecięca', 34.99, 38, 39.99, 41.99, .07), -- wybierany
(11, 3, 'kapelusz','męska', 35.99, 38, 39.99, 41.99, .09),
(12, 4, 'parasol','unisex', 38.99, 40, 41.99, 42.99, .23),
(13, 1, 'podkoszulek','dziecięca', 26.98, 30, 32.99, 33.99, .13), -- wybierany
-- (14, 2, 'szalik','damska', 27.30, 30, 33.99, 35.99, .13),
(14, 2, null,'damska', 27.30, 30, 33.99, 35.99, .13),
(15, 3, 'czapka','unisex', 28.19, 30, 33.99, 34.99, .23),
(16, 4, 'kurtka','męska', 28.89, 30, 32.99, 33.99, .09), -- wybierany
(17, 1, 'spodnie','dziecięca', 31.99, 34.99, 35.00, 36.99, .23), -- wybierany
(18, 2, 'sukienka','damska', 30.30, 32.99, 34.99, 35.99, .13), -- wybierany
-- (19, 3, 'sukienka','damska', 39.99, 41.99, 43.99, 44.99, .07),
(19, 3, 'sukienka','damska', 39.99, 41.99, 43.99, 44.99, null),
(20, 4, 'jeansy','męska', 31.87, 33.99, 36.99, 37.99, .09); -- wybierany

select * from Produkty;

INSERT INTO Zamówienia (
id_zamówienia, 
id_klienta, 
id_produktu, 
Data_zamówienia)
values
(1, 1, 18,'2019-02-18'), 
-- (2, 2, 16,'2017-05-05'), 
(2, 2, 16,'2022-04-04'), 
(3, 3, 7,'2014-08-08'), 
(4, 4, 5,'2022-03-08'), 
-- (5, 5, 3,'2021-09-18'),
(5, 5, 13,'2021-09-18'),
(6, 6, 9,'2020-03-07'),
(7, 7, 10,'2022-04-04'),
(8, 8, 20,'2013-01-10'),
(9, 9, 1,'2018-11-11'),
(10, 10, 13,'2016-12-15');

select * from Zamówienia;

INSERT INTO Klienci (
id_klienta, 
id_zamówienia, 
imię, 
nazwisko,
adres)
values
(1, 1, 'Marek', 'Nowak', 'Puławy 38'), 
(2, 2, null, 'Michalczyk', 'Liszki 64'), 
(3, 3, 'Paweł', null, 'Mrągowo 127'), 
(4, 4, 'Łukasz', 'Kowalski', 'Sopot 16'), 
(5, 5, null, 'Bujnowski', 'Warszawa 32/8a'),
(6, 6, 'Robert', 'Jędrzejczyk', 'Kraków, Pawia 8'),
(7, 7, 'Iwona', 'Mądry', 'Jasło 44'),
(8, 8, 'Klaudia', 'Miś', 'Stalowa Wola 12'),
(9, 9, 'Marysia', 'Hajduga', 'Mielec, ul. Nowa 128'),
(10, 10, 'Justyna', 'Korus', 'Rzeszów, Kwiatkowskiego 12');

select * from Klienci;

-- 8. Wyświetl wszystkie produkty z wszystkimi danymi od producenta który znajduje się 
-- na pozycji 1 w tabeli „Producenci”
select nazwa_produktu, b.id_producenta, b.nazwa_producenta, b.adres_producenta, b.nip_producenta,
b.dataPodpisaniaUmowyZ_producentem from Produkty a
inner join Producenci b on a.id_producenta = b.id_producenta
where b.id_producenta = 1;

-- 9. Posortuj te produkty alfabetycznie po nazwie
select nazwa_produktu, b.id_producenta, b.nazwa_producenta, b.adres_producenta, b.nip_producenta,
b.dataPodpisaniaUmowyZ_producentem from Produkty a
inner join Producenci b on a.id_producenta = b.id_producenta
where b.id_producenta = 1
order by a.nazwa_produktu;

-- 10. Wylicz średnią cenę za produktu od producenta z pozycji 1
select 
round(avg(a.cena_netto_zakupu), 2) as "cena netto zakupu",
round(avg(a.cena_brutto_zakupu), 2) as "cena brutto zakupu", 
round(avg(a.cena_netto_sprzedaży), 2) as "cena netto sprzedaży",
round(avg(a.cena_brutto_sprzedaży), 2) as "cena brutto sprzedaży" 
from Produkty a
inner join Producenci b on a.id_producenta = b.id_producenta
where b.id_producenta = 1;

-- 11. Wyświetl dwie grupy produktów tego producenta:
--       Połowa najtańszych to grupa: „Tanie”
select a.nazwa_produktu Tanie, a.cena_brutto_zakupu
from Produkty a 
inner join Producenci b on a.id_producenta = b.id_producenta
where b.id_producenta = 1 and a.cena_brutto_zakupu < 33.40;
--       Pozostałe to grupa: „Drogie”
select a.nazwa_produktu Drogie, a.cena_brutto_zakupu
from Produkty a 
inner join Producenci b on a.id_producenta = b.id_producenta
where b.id_producenta = 1 and a.cena_brutto_zakupu >= 33.40;
-- pozypatnie case podzielić, nazwac kolumnę typ produktów, case drogie, tanie ...
-- UNION

-- 12. Wyświetl produkty zamówione, wyświetlając tylko ich nazwę
select a.nazwa_produktu
from Produkty a
join Zamówienia b
on a.id_produktu = b.id_produktu;

-- 13. Wyświetl wszystkie produkty zamówione – ograniczając wyświetlanie do 5 pozycji
select a.nazwa_produktu
from Produkty a
join Zamówienia b
on a.id_produktu = b.id_produktu
limit 5;

-- 14. Policz łączną wartość wszystkich zamówień
select round(sum(a.cena_brutto_sprzedaży), 2) as Łączna_Wartość_Wszystkich_Zamówień
from Produkty a
join Zamówienia b
on a.id_produktu = b.id_produktu;

-- 15. Wyświetl wszystkie zamówienia wraz z nazwą produktu sortując je wg daty od najstarszego do najnowszego
select b.id_zamówienia, a.nazwa_produktu, b.Data_zamówienia
from Produkty a
join Zamówienia b on a.id_produktu = b.id_produktu
order by b.Data_zamówienia;

-- 16. Sprawdź czy w tabeli produkty masz uzupełnione wszystkie dane – wyświetl pozycje dla których brakuje danych
select * 
from Produkty
where id_produktu is null or
id_producenta is null or
nazwa_produktu is null or
opis_produktu is null or
cena_netto_zakupu is null or
cena_brutto_zakupu is null or
cena_netto_sprzedaży is null or
cena_brutto_sprzedaży is null or
procent_VAT_sprzedaży is null; -- Czy tutaj nie da się tej wymiany po where uprościć?

-- 17. Wyświetl produkt najczęściej sprzedawany wraz z jego ceną
select count(a.id_produktu) as most_often, a.cena_brutto_sprzedaży as cena
from Produkty a
join Zamówienia b
on a.id_produktu = b.id_klienta
group by cena
order by most_often desc
limit 1;

select *
from Produkty a
join Zamówienia b
on a.id_produktu = b.id_klienta;

-- with najczęściej zamawiana, potem z tabeli produktowej znaleźć to ID korzystajac z in lub równa się

-- 18. Znajdź dzień w którym najwięcej zostało złożonych zamówień
select Data_zamówienia 
from Zamówienia
group by Data_zamówienia
order by Data_zamówienia desc
limit 1;
