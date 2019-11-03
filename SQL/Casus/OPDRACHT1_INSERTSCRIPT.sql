/*******************************************************************************************
	Door:
		Daan Sperling - 605908
		Erik Knaake - 598368
	
	Naam conventies:
	Woorden worden gescheiden door underscores, met uitzondering waar dit anders stond in het strokendiagram.
	Tabellen beginnen met een hoofletter
	Collumns beginnen met een kleine letter
	Primary keys zijn opgebouwd als: PK_TabeNaam
	Foreign keys zijn opgebouwd als: FK_TabelNaam_GerefereerdeTabel
	Check constraints zijn opgebouwd als: CHK_TabelNaam_GecheckteVariabele/Omschrijving
	Er wordt een underscore toegevoegd als een naam al als keyword is geregristreerd

	Er is gekozen om de database te maken in de volgorde: 
	1. Genre
	2. Movie (referenced zichzelf)
	3. Movie_Genre (referenced Movie en Genre)
	4. Payment
	5. Contract_
	6. Country
	7. Person
	8. Movie_Cast (referenced Person en Movie)
	9. Movie_Directors (referenced Person en Movie)
	10. Customer (referenced Payment, Contract_ en Country)
	11. WatchHistory (referenced Customer en Movie)
	Om te voldoen aan de hierboven aangegeven foreign keys
*******************************************************************************************/


-- Om te beginnen werken we in FletNix
use FletNix
go

-- 
--Maak de FletNix database leeg
delete Movie_Genre -- maakt het mogelijk Genre te verwijderen
delete Genre

delete Movie_Directors --maakt het met onderstaande mogelijk om Person te verwijderen
delete Movie_Cast
delete Person

delete WatchHistory --maakt het mogelijk customer te verwijderen
delete Customer --maakt verwijderen 3 onderstaande mogelijk
delete Country
delete Contract_
delete Payment

delete Movie
go

/*******************************************************************************************
    Genre als eerste, heeft een verwijzing naar de hoofd tabellen
*******************************************************************************************/

insert into Genre (genre_name, description_)
values('Sci-Fi', null),
    ('Horror', null);

/*******************************************************************************************
    Movie als tweede, heeft 1 verwijzing vanuit Genre
*******************************************************************************************/

insert into Movie (movie_id, title, duration, description_, publication_year, cover_image, previous_part, price, URL_)
values(0, 'The Matrx', 147, null, 1999, null, null, 9.99, 'https://youtu.be/m8e-FF8MsqU'), 
(1, 'The Matrix-Reloaded', 138, null, 2003, null, 1, 8.95, 'https://youtu.be/kYzz0FSgpSU'),
(2, 'The Matrix-Revolutions', 129, null, 2003, null, 2, 9.99, 'https://youtu.be/hMbexEPAOQI'),
(3, 'Star Wars: Episode I: The Phantom Menace', 136, null, 1999, 
    'https://upload.wikimedia.org/wikipedia/en/4/40/Star_Wars_Phantom_Menace_poster.jpg', null, 11.99, 'https://youtu.be/I6hOlI9cg4o'),
(4, 'Star Wars: Episode II: Attack of the Clones', 137, null, 2002, null, 3, 22.99, 'https://youtu.be/gYbW1F_c9eM'),
(5, 'Star Wars: Episode III: Return of the Sith', 140, null, 2005, null, 4, 22.99, 'https://youtu.be/5UnjrG_N8hU'),
(6, 'Star Wars: Episode IV: A New Hope', 125, null, 1977, 
    'https://images-na.ssl-images-amazon.com/images/I/91H91NbI2xL._SL1500_.jpg', 5, 22.99, 'https://youtu.be/9gvqpFbRKtQ');

/*******************************************************************************************
    Movie_Genre vervolgens, krijgt een verwijzing uit zowel movie als person
*******************************************************************************************/

insert into Movie_Genre (Movie_id, genre_name)
values(0,'Sci-Fi'),
    (1,'Sci-Fi'),
    (2,'Sci-Fi'),
    (3,'Sci-Fi'),
    (4,'Sci-Fi'),
    (5,'Sci-Fi'),
    (6,'Sci-Fi');

/*******************************************************************************************
    Payment nu, verwijst naar Customer
*******************************************************************************************/

insert into Payment(payment_method)
values('I-Deal'),
('Paypal'),
('Creditcard');

/*******************************************************************************************
    Contract, verwijst ook naar Customer
*******************************************************************************************/

insert into Contract_(contract_type,price_per_month,discount_percentage)
values('Standard',8, 0),
('Extra',11,10), 
('Premium',14,20),
('None',0,0);

/*******************************************************************************************
    Country, verwijst ook naar Customer
*******************************************************************************************/

insert into Country (country_name)
values('Netherlands'),
('United States of America'),
('Germany'),
('Belgium'),
('United Kingdom');


/*******************************************************************************************
    Alle verwijzingen zijn aangemaakt, nu de tabel waar ze allemaal heen verwijzen: Person
*******************************************************************************************/

insert into Person (person_id, lastname, firstname, gender)
values(0, 'Wachowski', 'Lana', 'F'), 
    (1, 'Wachowski', 'Lilly', 'F'), 
    (2, 'Reeves', 'Keanu', 'M'), 
    (3, 'Fishburne', 'Lauerence', 'M'), 
    (4, 'Moss', 'Carrie-Anne', 'F'),
    (5, 'Lucas', 'George', 'M'),
    (6, 'Neeson', 'Liam', 'M'),
    (7, 'McGregor', 'Ewan', 'M'),
    (8, 'Portman', 'Natalie', 'F'),
    (9, 'Fisher', 'Carrie', 'F'),
    (10, 'Ford', 'Harrison', 'M'),
    (11, 'Hamill', 'Mark', 'M');



/*******************************************************************************************
    Na Person kunnen we de personen een rol geven. zoals de Cast van een Film
*******************************************************************************************/

insert into Movie_Cast(movie_id, person_id, role_)
values(0, 2, 'Neo'), 
(0, 3, 'Morpheus'), 
(0, 4, 'Trinity'), 
(1, 2, 'Neo'), 
(1, 3, 'Morpheus'), 
(1, 4, 'Trinity'),
(2, 2, 'Neo'), 
(2, 3, 'Morpheus'), 
(2, 4, 'Trinity'),
(3, 6, 'Qui-Gon Jinn'),
(3, 7, 'Obi-Wan Kenobi'),
(3, 8, 'Padmé'),
(4, 6, 'Qui-Gon Jinn'),
(4, 7, 'ObiWan Kenobi'),
(4, 8, 'Padmé'),
(5, 6, 'Qui-Gon Jinn'),
(5, 7, 'ObiWan Kenobi'),
(5, 8, 'Padmé'),
(6, 9, 'Pincess Leia'),
(6, 10, 'Han Solo'),
(6, 11, 'Luke Skywalker');

/*******************************************************************************************
... of een film directen: Movie_Directors
*******************************************************************************************/

insert into Movie_Directors (movie_id, person_id)
values(0, 0), 
(0, 1), 
(1, 0), 
(1, 1),
(2, 0),
(2, 1),
(3, 5),
(4, 5),
(5, 5),
(6, 5);


/*******************************************************************************************
    Customer heeft ook al zijn verwijzingen gekregen. dus kan ook gemaakt worden
*******************************************************************************************/

insert into Customer(customer_mail_address,lastname,firstname,payment_method,payment_card_number,contract_type,
subscription_start,subscription_end,user_name_,password_,country_name,gender,birth_date)
values('daansperling@hotmail.com','Sperling','Daan','I-Deal','Classified','Extra', '2017-NOV-17',
    NULL,'tokindforyou','P@ssW0rd','Netherlands','M', '1996-FEB-11'),
('erikknaake@gmail.com','Knaake','Erik','Paypal','Classified','None', '2017-NOV-17',
     '2017-DEC-17','Erik','D!TiSeEnWaChTwO0Rd','Netherlands','M', '2000-JAN-18'),
('harlerein@han.nl','Rein','Harle', 'I-Deal','Classified','Standard', '2017-NOV-17',
    NULL,'UltraHarle','P@ssw0rd_ISM','Germany','M', '1958-DEC-14'),
('jacobdubbel@hotmail.com','Dubbel','Jacob','PayPal','Classified','Premium', '2017-NOV-17',
    NULL,'skankhunt42','Welkom01','United States of America','M', '1990-MAR-19'),
('robsperling@ziggo.nl','Sperling','Rob','I-Deal','Classified','Extra', '2017-NOV-17',
    NULL,'IdefixKomt','k0ekjesz!jnl3kk3r','Netherlands','M', '1964-OCT-10'),
('someone@example.com', 'one', 'some', 'Creditcard', '012345678', 'Extra', '2017-OCT-17',
    NULL, 'someone', 'p@ssword1', 'United Kingdom', NULL, '2002-SEP-09'),
('julian_berends@gmail.com', 'Berends', 'Julian', 'I-Deal', '12345678', 'None', '2017-NOV-15',
 '2018-JAN-15', 'julber', 'SBKf;aeb fsf!', 'Germany', 'M', '1998-FEB-18'),
('knaake@kpnplanet.nl', 'Knaake', 'Rikie', 'Paypal', '23456789', 'Extra', '2017-AUG-07',
    NULL, 'Rikie', '@wofekjgrjgb@', 'Netherlands', 'F', '1973-JUL-14'),
('wesley@hotmail.nl', 'Jansen', 'Wesley', 'Creditcard', '34567890', 'Premium', '2017-NOV-17',
    NULL, 'wesley_Jansen', 'SDFBgFEF54F$', 'United States of America', 'M',  '1999-AUG-29'),
('JannieteVanDerHeijde@isselborgh.nl', 'van der Heijde', 'Janniete', 'I-Deal', '45678901', 'Standard', '2017-JAN-11',
    NULL, 'JannieteVanDerHeijde', 'Th!sP@sswordIstverySTRONX!', 'Netherlands', 'F', '1984-JUL-07');

/*******************************************************************************************
    WatchHistory, heeft een verwijzing vanuit person en kan nu gemaakt worden
*******************************************************************************************/

insert into WatchHistory(movie_id, customer_mail_address, watch_date, price, invoiced)
values(0, 'erikknaake@gmail.com', '2017-NOV-18', 9.99, 0),
(0, 'daansperling@hotmail.com', '2017-NOV-18', 9.99, 0),
(0, 'harlerein@han.nl', '2017-NOV-18', 9.99, 0),
(0, 'jacobdubbel@hotmail.com', '2017-NOV-18', 9.99, 0),
(0, 'robsperling@ziggo.nl', '2017-NOV-18', 9.99, 0),
(0,'someone@example.com', '2017-OCT-19', 9.99, 0),
(0, 'julian_berends@gmail.com', '2017-NOV-18', 9.99, 0),
(0, 'knaake@kpnplanet.nl', '2017-AUG-07', 9.99, 0),
(0, 'wesley@hotmail.nl', '2017-NOV-18', 9.99, 0),
(0, 'JannieteVanDerHeijde@isselborgh.nl', '2017-JAN-25', 9.99, 0);


/*******************************************************************************************
    Tests die de inhoud per tabel laten zien
*******************************************************************************************/
/*
select * from Movie_Cast
select * from Movie
select * from Movie_Directors
select * from Person
select * from Movie_Genre
select * from Country
select * from Contract_
select * from Customer
select * from Payment
select * from WatchHistory

SELECT Customer.subscription_start
    FROM Customer, WatchHistory
    WHERE Customer.customer_mail_address = WatchHistory.customer_mail_address
*/