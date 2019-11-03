use FletNix

/*******************************************************************************************
	Test op constraint op gender van Person
*******************************************************************************************/

/*Faal scenario*/
--Geen M of F		test geslaagd: The INSERT statement conflicted with the CHECK constraint "CHK_Person". The conflict occurred in database "FletNix", table "dbo.Person", column 'gender'.
insert into Person(person_id, lastname, firstname, gender)
	values(0, 'Knaake', 'Rikie', 'V') 

/*succes scenario's*/
--F					test geslaagd
insert into Person(person_id, lastname, firstname, gender)
	values(0, 'Knaake', 'Rikie', 'F')
--M					test geslaagd
insert into Person(person_id, lastname, firstname, gender)
	values(1, 'Knaake', 'Erik', 'M')

--reset database
delete Person where person_id = 0 or person_id = 1

/*******************************************************************************************
	Test op constraint op publicatie jaar van Movie
*******************************************************************************************/

/*Faal scenario's*/
--jaar te vroeg			test geslaagd:		The INSERT statement conflicted with the CHECK constraint "CHK_Movie_publication_year". The conflict occurred in database "FletNix", table "dbo.Movie", column 'publication_year'.
insert into Movie(movie_id, title, duration, description_, publication_year, cover_image, previous_part, price, URL_)
	values(0, 'Matrix', 137, null, 1889, null, null, 9.99, null)
--Jaar te laat			test geslaagd:		The INSERT statement conflicted with the CHECK constraint "CHK_Movie_publication_year". The conflict occurred in database "FletNix", table "dbo.Movie", column 'publication_year'.
insert into Movie(movie_id, title, duration, description_, publication_year, cover_image, previous_part, price, URL_)
	values(1, 'Matrix', 137, null, 2018, null, null, 9.99, null)
/*Succes scenario's*/
--Onder grens			test geslaagd
insert into Movie(movie_id, title, duration, description_, publication_year, cover_image, previous_part, price, URL_)
	values(0, 'Matrix', 137, null, 1890, null, null, 9.99, null)
--Boven grens			test geslaagd
insert into Movie(movie_id, title, duration, description_, publication_year, cover_image, previous_part, price, URL_)
	values(1, 'Matrix', 137, null, 2017, null, null, 9.99, null)
delete Movie where movie_id = 0 or movie_id = 1


/*******************************************************************************************
	Test op aanmeld datum van Customer is voor subscription_end
*******************************************************************************************/

--Foreign key dependencies voor deze test
insert into Payment values('I-Deal')
insert into Contract_ values('Standard', 10, 0)
insert into Country values('Netherlands')

/* Faal scenario's*/
--Dag					test geslaagd:			The INSERT statement conflicted with the CHECK constraint "CHK_Customer_subscription". The conflict occurred in database "FletNix", table "dbo.Customer".
insert into Customer(customer_mail_address, lastname, firstname, payment_method, payment_card_number, contract_type, subscription_start, subscription_end, user_name_, password_, country_name, birth_date)
	values('erikknaake@gmail.com', 'Knaake', 'Erik','I-Deal', 0134567, 'Standard', '2017-NOV-11', '2017-NOV-10', 'erik3211123', 'wfEQWf3e$', 'Netherlands', '2000-JAN-18')
--Maand					test geslaagd:			The INSERT statement conflicted with the CHECK constraint "CHK_Customer_subscription". The conflict occurred in database "FletNix", table "dbo.Customer".
	insert into Customer(customer_mail_address, lastname, firstname, payment_method, payment_card_number, contract_type, subscription_start, subscription_end, user_name_, password_, country_name, birth_date)
	values('erikknaake@gmail.com', 'Knaake', 'Erik','I-Deal', 0134567, 'Standard', '2017-DEC-11', '2017-NOV-12', 'erik3211123', 'wfEQWf3e$', 'Netherlands', '2000-JAN-18')
--Jaar					test geslaagd:			The INSERT statement conflicted with the CHECK constraint "CHK_Customer_subscription". The conflict occurred in database "FletNix", table "dbo.Customer".
insert into Customer(customer_mail_address, lastname, firstname, payment_method, payment_card_number, contract_type, subscription_start, subscription_end, user_name_, password_, country_name, birth_date)
	values('erikknaake@gmail.com', 'Knaake', 'Erik','I-Deal', 0134567, 'Standard', '2018-NOV-10', '2017-NOV-10', 'erik3211123', 'wfEQWf3e$', 'Netherlands', '2000-JAN-18')

/*succes scenario's*/
--Dag					test geslaagd
insert into Customer(customer_mail_address, lastname, firstname, payment_method, payment_card_number, contract_type, subscription_start, subscription_end, user_name_, password_, country_name, birth_date)
	values('erikknaake@gmail.com', 'Knaake', 'Erik','I-Deal', 0134567, 'Standard', '2017-NOV-10', '2017-NOV-11', 'erik3211123', 'wfEQWf3e$', 'Netherlands', '2000-JAN-18')

--Maand					test geslaagd
insert into Customer(customer_mail_address, lastname, firstname, payment_method, payment_card_number, contract_type, subscription_start, subscription_end, user_name_, password_, country_name, birth_date)
	values('erikknaake@gmail.com', 'Knaake', 'Erik','I-Deal', 0134567, 'Standard', '2017-NOV-11', '2017-DEC-11', 'erik3211123', 'wfEQWf3e$', 'Netherlands', '2000-JAN-18')

--Jaar					test geslaagd
insert into Customer(customer_mail_address, lastname, firstname, payment_method, payment_card_number, contract_type, subscription_start, subscription_end, user_name_, password_, country_name, birth_date)
	values('erikknaake@gmail.com', 'Knaake', 'Erik','I-Deal', 0134567, 'Standard', '2017-NOV-10', '2018-NOV-10', 'erik3211123', 'wfEQWf3e$', 'Netherlands', '2000-JAN-18')

--reset database
delete Payment where payment_method = 'I-Deal'
delete Contract_ where contract_type = 'Standard'
delete Country where country_name = 'Netherlands'
delete Customer where customer_mail_address = 'erikknaake@gmail.com'


/*******************************************************************************************
	Test op mail adress, moet een @ en een punt bevatten
*******************************************************************************************/

--Foreign key dependencies voor deze test
insert into Payment values('I-Deal')
insert into Contract_ values('Extra', 10, 0)
insert into Country values('Netherlands')

--Faal scenario's
insert into Customer --geen @			test geslaagd:		The INSERT statement conflicted with the CHECK constraint "CHK_Customer_mail_address". The conflict occurred in database "FletNix", table "dbo.Customer", column 'customer_mail_address'.
	values('erikknaakegmail.com', 'Knaake', 'Erik', 'I-Deal', '01234567', 'Extra', '2017-11-20',NULL, 'erik321123', 'VeryST00000ngP@ss0w000rd!', 'Netherlands', 'M', '2000-01-18')
insert into Customer --geen .			test geslaagd:		The INSERT statement conflicted with the CHECK constraint "CHK_Customer_mail_address". The conflict occurred in database "FletNix", table "dbo.Customer", column 'customer_mail_address'.
	values('erikknaake@gmailcom', 'Knaake', 'Erik', 'I-Deal', '01234567', 'Extra', '2017-11-20',NULL, 'erik321123', 'VeryST00000ngP@ss0w000rd!', 'Netherlands', 'M', '2000-01-18')
insert into Customer --geen @ en geen .	test geslaagd:		The INSERT statement conflicted with the CHECK constraint "CHK_Customer_mail_address". The conflict occurred in database "FletNix", table "dbo.Customer", column 'customer_mail_address'.
	values('erikknaakegmailcom', 'Knaake', 'Erik', 'I-Deal', '01234567', 'Extra', '2017-11-20',NULL, 'erik321123', 'VeryST00000ngP@ss0w000rd!', 'Netherlands', 'M', '2000-01-18')
--success scenario's
insert into Customer -- @ en .			test geslaagd
	values('erikknaake@gmail.com', 'Knaake', 'Erik', 'I-Deal', '01234567', 'Extra', '2017-11-20',NULL, 'erik321123', 'VeryST00000ngP@ss0w000rd!', 'Netherlands', 'M', '2000-01-18')
--Reset database
delete Country where country_name = 'Netherlands'
delete Payment where payment_method = 'I-Deal'
delete Contract_ where contract_type = 'Standard'
delete Customer where customer_mail_address = 'erikknaake@gmail.com'

--Foreign key dependencies voor deze test
insert into Payment values('I-Deal')
insert into Contract_ values('Extra', 10, 0)
insert into Country values('Germany')

/* test: dubbele username. Test geslaagd*/
insert into Customer(customer_mail_address,lastname,firstname,payment_method,payment_card_number,contract_type,subscription_start,
subscription_end, user_name_,password_,country_name,gender,birth_date)
values('vage.hendrik@han.nl','vage','hendrik','I-Deal','classified','Extra', '2017-11-20',NULL,'tokindforyou','zilvermeeuw','Germany','M','1996-03-15')

--test geslaagd:			Violation of UNIQUE KEY constraint 'UQ__Customer__398346146FE9F9C8'. Cannot insert duplicate key in object 'dbo.Customer'. The duplicate key value is (tokindforyou).
insert into Customer(customer_mail_address,lastname,firstname,payment_method,payment_card_number,contract_type,subscription_start,
subscription_end, user_name_,password_,country_name,gender,birth_date)
values('vaag.hans@han.nl','vaag','hans','I-Deal','classified','Extra', '2017-11-20',NULL,'tokindforyou','zilvermeeuw','Germany','M','1996-03-15')

--Reset database
delete Country where country_name = 'Germany'
delete Payment where payment_method = 'I-Deal'
delete Contract_ where contract_type = 'Extra'


--test: prijs is 0. Test geslaagd:			The INSERT statement conflicted with the CHECK constraint "CHK_MOVIE_price". The conflict occurred in database "FletNix", table "dbo.Movie", column 'price'.
insert into Movie(movie_id,title,duration,description_,publication_year,cover_image,previous_part,price,URL_)
values(7,'Straar oorlog hoofdstuk 20: luke krijgt een hond',150,null,2017,null,null,0.00,null)

--test: prijs > 0. succes scenario
insert into Movie(movie_id,title,duration,description_,publication_year,cover_image,previous_part,price,URL_)
values(7,'Straar oorlog hoofdstuk 20: luke krijgt een hond',150,null,2017,null,null,0.01,null)
--reset database
delete movie where movie_id = 7


--dependecies
insert into Payment values('I-Deal')
insert into Contract_ values('Extra', 10, 0)
insert into Country values('Netherlands')

insert into Customer
	values('erikknaake1@gmail.com', 'Knaake', 'Erik', 'I-Deal', '01234567', 'Extra', '2017-11-20','2017-12-15', 'erik321123', 'VeryST00000ngP@ss0w000rd!', 'Netherlands', 'M', '2000-01-18'),
	('erikknaake@gmail2.com', 'Knaake', 'Erik', 'I-Deal', '01234567', 'Extra', '2017-11-20','2017-12-15', 'erik32123', 'VeryST00000ngP@ss0w000rd!', 'Netherlands', 'M', '2000-01-18'),
	('erikknaake@gmail3.com', 'Knaake', 'Erik', 'I-Deal', '01234567', 'Extra', '2017-11-20','2017-12-15', 'erik3223', 'VeryST00000ngP@ss0w000rd!', 'Netherlands', 'M', '2000-01-18'),
	('erikknaake@gmail4.com', 'Knaake', 'Erik', 'I-Deal', '01234567', 'Extra', '2017-11-20','2017-12-15', 'erik33', 'VeryST00000ngP@ss0w000rd!', 'Netherlands', 'M', '2000-01-18')

insert into WatchHistory values(0, 'erikknaake1@gmail.com', '2017-11-19', 9, 1) --moet te zien zijn in query
insert into WatchHistory values(1, 'erikknaake@gmail2.com', '2017-12-16', 9, 1) --moet te zien zijn in query
insert into WatchHistory values(2, 'erikknaake@gmail3.com', '2017-11-20', 9, 1) --moet niet te zien zijn in query
insert into WatchHistory values(3, 'erikknaake@gmail4.com', '2017-12-15', 9, 1) --moet niet te zien zijn in query




/*******************************************************************************************
	Test query die verkeerde watchistory verwijderd
*******************************************************************************************/
--watchdate tussen subscriptionstart en end test query
select WH.* 
	from WatchHistory as WH inner join Customer as C on WH.customer_mail_address = C.customer_mail_address
	where WH.watch_date < C.subscription_start or WH.watch_date > C.subscription_end
--select test geslaag
--reset database
delete WatchHistory where customer_mail_address like 'erikknaake%'
delete Customer where customer_mail_address LIKE 'erikknaake%'
delete Country where country_name = 'Germany'
delete Payment where payment_method = 'I-Deal'
delete Contract_ where contract_type = 'Extra'

delete WatchHistory
	from WatchHistory as WH inner join Customer as C on WH.customer_mail_address = C.customer_mail_address
	where WH.watch_date < C.subscription_start or WH.watch_date > C.subscription_end --test query hierboven bewijst werking


/*******************************************************************************************
	Test van WatchHistorie çonstraint op watchdate
*******************************************************************************************/
--select dbo.datumTussen('06-12-2017','08-12-2017','07-12-2017') --werkt 1
--select dbo.datumTussen('06-12-2017','08-12-2017','06-12-2017') --werkt 1
--select dbo.datumTussen('06-12-2017','08-12-2017','08-12-2017') --werkt 1
--select dbo.datumTussen('06-12-2017','08-12-2017','05-12-2017') --werkt 0
--select dbo.datumTussen('06-12-2017','08-12-2017','09-12-2017') --werkt 0
--test geslaagd
select * from Customer


--insert into WatchHistory values(0, '1@1.com', '06-12-2017', 5, 0)