-- Komentarz jednolinjkowy
-- Do not check foreign key constraints, służy do wyłączenia sprawdzania klucza obcego w MySQL.
SET FOREIGN_KEY_CHECKS = 0;

-- Projekt 1 - SQL
-- 1. Stwórz Bazę „Sklep odzieżowy”
CREATE DATABASE Sklep_odzieżowy;

-- Instrukcja USE mówi MySQL, aby używał nazwanej bazy danych jako domyślnej (bieżącej) bazy danych dla kolejnych instrukcji.
USE Sklep_odzieżowy;

-- 2. Utwórz tabelę „Producenci” z kolumnami:
--    id producenta
--    nazwa producenta
--    adres producenta
--    nip producenta
--    data podpisania umowy z producentem
-- Do każdej kolumny ustaw odpowiedni „constraint”
CREATE TABLE Producenci (
    id_producenta INT PRIMARY KEY, -- musi być unique albo primary key, wiąże się to z foreign key
    nazwa_producenta VARCHAR(30) UNIQUE,
    adres_producenta VARCHAR(50) UNIQUE,
    nip_producenta BIGINT(10) UNIQUE,
    dataPodpisaniaUmowyZ_producentem DATE NOT NULL
);

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
    id_produktu INT UNIQUE, -- musi być unique albo primary key, wiąże się to z foreign key
    id_producenta INT NOT NULL,
    nazwa_produktu VARCHAR(30) DEFAULT NULL,
    opis_produktu SET('damska', 'męska', 'dziecięca', 'unisex'),
    cena_netto_zakupu DECIMAL(10 , 2 ) CHECK (cena_netto_zakupu >= 0),
    cena_brutto_zakupu DECIMAL(10 , 2 ) CHECK (cena_brutto_zakupu >= 0),
    cena_netto_sprzedaży DECIMAL(10 , 2 ) CHECK (cena_netto_sprzedaży >= 0),
    cena_brutto_sprzedaży DECIMAL(10 , 2 ) CHECK (cena_brutto_sprzedaży >= 0),
    procent_VAT_sprzedaży DECIMAL(10 , 2 ) DEFAULT NULL
);

-- 4. Utwórz tabelę „Zamówienia” z kolumnami:
--    id zamówienia
--    id klienta
--    id produktu
--    Data zamówienia
-- Do każdej kolumny ustaw odpowiedni „constraint”
CREATE TABLE Zamówienia (
    id_zamówienia INT NOT NULL,
    id_klienta INT NOT NULL,
    id_produktu INT NOT NULL,
    Data_zamówienia DATE NOT NULL
);

-- 5. Utwórz tabelę „Klienci” z kolumnami:
--    id klienta
--    id zamówienia
--    imię
--    nazwisko
--    adres
-- Do każdej kolumny ustaw odpowiedni „constraint”
CREATE TABLE Klienci (
    id_klienta INT NOT NULL PRIMARY KEY, -- musi być unique albo primary key, wiąże się to z foreign key
    id_zamówienia INT NOT NULL,
    imię VARCHAR(20) DEFAULT NULL,
    nazwisko VARCHAR(30) DEFAULT NULL,
    adres VARCHAR(100) UNIQUE
);

-- 6. Połącz tabele ze sobą za pomocą kluczy obcych:
--    Produkty – Producenci
--    Zamówienia – Produkty
--    Zamówienia - Klienci

ALTER TABLE Produkty ADD CONSTRAINT producenci_fk FOREIGN KEY (id_producenta) 
REFERENCES Producenci(id_producenta); -- Jeden producent może mieć wiele produktów dlatego Producenci(id_producenta) primary key

-- Składnia na usunięcie klucza obcego z istniejącej już tabeli 
-- ALTER TABLE Produkty DROP FOREIGN KEY producenci_fk;

ALTER TABLE Zamówienia ADD CONSTRAINT produkt_fk FOREIGN KEY (id_produktu) 
REFERENCES Produkty(id_produktu); -- Jeden produkt może mieć wiele zamówień dlatego Produkty(id_produktu) primary key

ALTER TABLE Zamówienia ADD CONSTRAINT klienci_fk FOREIGN KEY (id_klienta) 
REFERENCES Klienci(id_klienta); -- Jeden klient może mieć wiele zamówień dlatego Klienci(id_klienta) primary key

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

-- Wyświetlenie wartości wszystkich pól tabeli Producenci 
SELECT * FROM Producenci;

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
   (1, 1, 'sukienka','damska', 39.99, 42.00, 42.99, 44.99, .09),
   (2, 2, null,'męska', 42.99, 45.99, 46.99, 48.99, .13), 
   (3, 3, 'bluzka','męska', 33.99, 35.99, 38.99, 39.99, .23),
   (4, 4, 'podkoszulek','dziecięca', 43.99, 45, 48, 49, .07), 
   (5, 1, 'czapka','dziecięca', 28.99, 30, 32.99, 34.10, .09),
   (6, 2, 'majtki','męska', 34.99, 37, 38.99, 39.99, .13),
   (7, 3, 'kapelusz','męska', 35.99, 38.99, 40.00, 42.00, .23),
   (8, 4, 'czapka','damska', 38.99, 39.99, 41.99, 43.99, .07),
   (9, 1, 'golf','damska', 26.99, 29.99, 32.99, 34.99, .07),
   (10, 2, 'czapka','dziecięca', 34.99, 38, 39.99, 41.99, .07),
   (11, 3, 'kapelusz','męska', 35.99, 38, 39.99, 41.99, .09),
   (12, 4, 'parasol','unisex', 38.99, 40, 41.99, 42.99, .23),
   (13, 1, 'podkoszulek','dziecięca', 26.98, 30, 32.99, 33.99, .13),
   (14, 2, null,'damska', 27.30, 30, 33.99, 35.99, .13),
   (15, 3, 'czapka','unisex', 28.19, 30, 33.99, 34.99, .23),
   (16, 4, 'kurtka','męska', 28.89, 30, 32.99, 33.99, .09),
   (17, 1, 'spodnie','dziecięca', 31.99, 34.99, 35.00, 36.99, .23),
   (18, 2, 'sukienka','damska', 30.30, 32.99, 34.99, 35.99, .13),
   (19, 3, 'sukienka','damska', 39.99, 41.99, 43.99, 44.99, null),
   (20, 4, 'jeansy','męska', 31.87, 33.99, 36.99, 37.99, .09);
   
-- Wyświetlenie wartości wszystkich pól tabeli Produkty 
SELECT * FROM Produkty;

INSERT INTO Zamówienia (
   id_zamówienia, 
   id_klienta, 
   id_produktu, 
   Data_zamówienia)
values
   (1, 1, 18,'2019-02-18'), 
   (2, 2, 16,'2022-04-04'), 
   (3, 3, 7,'2014-08-08'), 
   (4, 4, 5,'2022-03-08'), 
   (5, 5, 13,'2021-09-18'),
   (6, 6, 9,'2020-03-07'),
   (7, 7, 10,'2022-04-04'),
   (8, 8, 20,'2013-01-10'),
   (9, 9, 1,'2018-11-11'),
   (10, 10, 13,'2016-12-15');

-- Wyświetlenie wartości wszystkich pól tabeli Zamówienia 
SELECT * FROM Zamówienia;

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

-- Wyświetlenie wartości wszystkich pól tabeli Klienci 
SELECT * FROM Klienci;

-- 8. Wyświetl wszystkie produkty z wszystkimi danymi od producenta który znajduje się 
-- na pozycji 1 w tabeli „Producenci”
SELECT 
    nazwa_produktu,
    b.id_producenta,
    b.nazwa_producenta,
    b.adres_producenta,
    b.nip_producenta,
    b.dataPodpisaniaUmowyZ_producentem
FROM
    Produkty a
        INNER JOIN
    Producenci b ON a.id_producenta = b.id_producenta
WHERE
    b.id_producenta = 1;

-- 9. Posortuj te produkty alfabetycznie po nazwie
SELECT 
    nazwa_produktu,
    b.id_producenta,
    b.nazwa_producenta,
    b.adres_producenta,
    b.nip_producenta,
    b.dataPodpisaniaUmowyZ_producentem
FROM
    Produkty a
        INNER JOIN
    Producenci b ON a.id_producenta = b.id_producenta
WHERE
    b.id_producenta = 1
ORDER BY a.nazwa_produktu;

-- 10. Wylicz średnią cenę za produktu od producenta z pozycji 1
SELECT 
    ROUND(AVG(a.cena_netto_zakupu), 2) AS 'cena netto zakupu',
    ROUND(AVG(a.cena_brutto_zakupu), 2) AS 'cena brutto zakupu',
    ROUND(AVG(a.cena_netto_sprzedaży), 2) AS 'cena netto sprzedaży',
    ROUND(AVG(a.cena_brutto_sprzedaży), 2) AS 'cena brutto sprzedaży'
FROM
    Produkty a
        INNER JOIN
    Producenci b ON a.id_producenta = b.id_producenta
WHERE
    b.id_producenta = 1;

-- 11. Wyświetl dwie grupy produktów tego producenta:
--       Połowa najtańszych to grupa: „Tanie”
-- Metoda INNER JOIN plus podzapytanie
SELECT 
    a.nazwa_produktu Tanie, a.cena_brutto_zakupu
FROM
    Produkty a
        INNER JOIN
    Producenci b ON a.id_producenta = b.id_producenta
WHERE
    b.id_producenta = 1
        AND a.cena_brutto_zakupu < (SELECT 
            ROUND(AVG(c.cena_brutto_zakupu), 2)
        FROM
            Produkty c
                INNER JOIN
            Producenci d ON c.id_producenta = d.id_producenta
        WHERE
            d.id_producenta = 1);
            
--       Pozostałe to grupa: „Drogie”
-- Metoda INNER JOIN plus podzapytanie
SELECT 
    a.nazwa_produktu Drogie, a.cena_brutto_zakupu
FROM
    Produkty a
        INNER JOIN
    Producenci b ON a.id_producenta = b.id_producenta
WHERE
    b.id_producenta = 1
        AND a.cena_brutto_zakupu >= (SELECT 
            ROUND(AVG(c.cena_brutto_zakupu), 2)
        FROM
            Produkty c
                INNER JOIN
            Producenci d ON c.id_producenta = d.id_producenta
        WHERE
            d.id_producenta = 1);

-- Podzapytanie CASE. Nazwa kolumny "typ_produktu", podział na: "Tanie" i "Drogie".
SELECT 
    a.nazwa_produktu,
    a.cena_brutto_zakupu,
    CASE
        WHEN
            cena_brutto_zakupu < (SELECT 
                    ROUND(AVG(c.cena_brutto_zakupu), 2)
                FROM
                    Produkty c
                        INNER JOIN
                    Producenci d ON c.id_producenta = d.id_producenta
                WHERE
                    d.id_producenta = 1)
        THEN
            'Tanie'
        ELSE 'Drogie'
    END AS typ_produktu
FROM
    Produkty a
        INNER JOIN
    Producenci b ON a.id_producenta = b.id_producenta
WHERE
    a.id_producenta = 1
ORDER BY a.cena_brutto_zakupu;

-- Metoda UNION
(SELECT 
    a.nazwa_produktu,
    a.cena_brutto_zakupu,
    CASE
        WHEN
            cena_brutto_zakupu < (SELECT 
                    ROUND(AVG(c.cena_brutto_zakupu), 2)
                FROM
                    Produkty c
                        INNER JOIN
                    Producenci d ON c.id_producenta = d.id_producenta
                WHERE
                    d.id_producenta = 1)
        THEN
            'Tanie'
    END AS typ_produktu
FROM
    Produkty a
        INNER JOIN
    Producenci b ON a.id_producenta = b.id_producenta
WHERE
    b.id_producenta = 1
        AND a.cena_brutto_zakupu < (SELECT 
            ROUND(AVG(c.cena_brutto_zakupu), 2)
        FROM
            Produkty c
                INNER JOIN
            Producenci d ON c.id_producenta = d.id_producenta
        WHERE
            d.id_producenta = 1)) UNION (SELECT 
    a.nazwa_produktu,
    a.cena_brutto_zakupu,
    CASE
        WHEN
            cena_brutto_zakupu >= (SELECT 
                    ROUND(AVG(c.cena_brutto_zakupu), 2)
                FROM
                    Produkty c
                        INNER JOIN
                    Producenci d ON c.id_producenta = d.id_producenta
                WHERE
                    d.id_producenta = 1)
        THEN
            'Drogie'
    END AS typ_produktu
FROM
    Produkty a
        INNER JOIN
    Producenci b ON a.id_producenta = b.id_producenta
WHERE
    b.id_producenta = 1
        AND a.cena_brutto_zakupu >= (SELECT 
            ROUND(AVG(c.cena_brutto_zakupu), 2)
        FROM
            Produkty c
                INNER JOIN
            Producenci d ON c.id_producenta = d.id_producenta
        WHERE
            d.id_producenta = 1));

-- 12. Wyświetl produkty zamówione, wyświetlając tylko ich nazwę
SELECT 
    a.nazwa_produktu
FROM
    Produkty a
        JOIN
    Zamówienia b ON a.id_produktu = b.id_produktu;

-- 13. Wyświetl wszystkie produkty zamówione – ograniczając wyświetlanie do 5 pozycji
SELECT 
    a.nazwa_produktu
FROM
    Produkty a
        JOIN
    Zamówienia b ON a.id_produktu = b.id_produktu
LIMIT 5;

-- 14. Policz łączną wartość wszystkich zamówień
SELECT 
    ROUND(SUM(a.cena_brutto_sprzedaży), 2) AS Łączna_Wartość_Wszystkich_Zamówień
FROM
    Produkty a
        JOIN
    Zamówienia b ON a.id_produktu = b.id_produktu;

-- 15. Wyświetl wszystkie zamówienia wraz z nazwą produktu sortując je wg daty od najstarszego do najnowszego
SELECT 
    b.id_zamówienia, a.nazwa_produktu, b.Data_zamówienia
FROM
    Produkty a
        JOIN
    Zamówienia b ON a.id_produktu = b.id_produktu
ORDER BY b.Data_zamówienia;

-- 16. Sprawdź czy w tabeli produkty masz uzupełnione wszystkie dane – wyświetl pozycje dla których brakuje danych
SELECT 
    *
FROM
    Produkty
WHERE
    id_produktu IS NULL
        OR id_producenta IS NULL
        OR nazwa_produktu IS NULL
        OR opis_produktu IS NULL
        OR cena_netto_zakupu IS NULL
        OR cena_brutto_zakupu IS NULL
        OR cena_netto_sprzedaży IS NULL
        OR cena_brutto_sprzedaży IS NULL
        OR procent_VAT_sprzedaży IS NULL;

-- 17. Wyświetl produkt najczęściej sprzedawany wraz z jego ceną
-- Metoda CREATE VIEW
CREATE VIEW london_1 AS
    SELECT 
        COUNT(a.id_produktu) AS zliczanie, a.id_produktu
    FROM
        Zamówienia a
    GROUP BY a.id_produktu
    ORDER BY zliczanie DESC
    LIMIT 1;

-- Zapytanie wybierające z widoku
SELECT 
    nazwa_produktu, cena_brutto_sprzedaży
FROM
    Produkty
WHERE
    id_produktu = (SELECT 
            id_produktu
        FROM
            london_1);
   
-- WITH – Klauzula
with temporary_view as (
   select id_produktu
   from Zamówienia
   group by id_produktu
   order by count(id_produktu) desc
   limit 1
)
select id_produktu, cena_brutto_sprzedaży, nazwa_produktu
from Produkty
where id_produktu = (select id_produktu from temporary_view);

-- 18. Znajdź dzień w którym najwięcej zostało złożonych zamówień
-- Część zapytania (1 krok):
-- Używam GROUP BY, sumuję ile najwięcej zamówień było i grupuję po dacie.
SELECT 
    Data_zamówienia, COUNT(id_zamówienia) liczba_zamówień
FROM
    Zamówienia
GROUP BY Data_zamówienia;

-- Całkowite zapytanie:
-- Sortuję, ograniczyć do jedynki i powinieneś zliczam ile tych zamówień było
SELECT 
    Data_zamówienia, COUNT(id_zamówienia) liczba_zamówień
FROM
    Zamówienia
GROUP BY Data_zamówienia
ORDER BY Data_zamówienia DESC
LIMIT 1;
