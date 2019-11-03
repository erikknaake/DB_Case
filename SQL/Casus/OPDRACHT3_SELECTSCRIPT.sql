use FletNix

/*******************************************************************************************
    3A alle films naar genre gesorteerd
*******************************************************************************************/

select Movie.title, Movie.publication_year, Movie_Genre.genre_name-- We selecteren deze 3 gegevens omdat dit de meest relevante informatie is
    from Movie, Movie_Genre
    where Movie.movie_id = Movie_Genre.movie_id-- Deze tabellen inner joinen wij om de genres te zien die bij de films horen
    order by Movie_Genre.genre_name-- Als laatste wordt het geordend op genre om aan de vraag te voldoen



/*******************************************************************************************
    3B alle films tussen 1990 en 2010   
*******************************************************************************************/

select * -- Alle info vanuit Movie aangezien er geen specifieke vraag naar info is
    from Movie
    where Movie.publication_year >= 1990 AND Movie.publication_year <= 2010 -- Zo wordt alles voor 1990 en na 2010 er uit gefilterd
    


/*******************************************************************************************
        3C alle actieve klanten (subsricption end = NULL)
*******************************************************************************************/

select lastname, firstname, subscription_start -- Alle klanten geselecteerd met een gestart abbonnement
    from Customer
    where subscription_end IS NULL
    -- bij een NULL is er nog geen einde bekend en is de klant dus nog actief


/*******************************************************************************************
    3D cast van alle Terminator films uit 1991  
*******************************************************************************************/

select Movie_Cast.movie_id, Person.firstname, Person.lastname, Movie_Cast.role_ -- Alle namen, hun rol en het ID van de film worden geselecteerd
    from Movie_Cast, Movie, Person -- 3 tabellen krijgen een inner join
    where Movie_Cast.movie_id = Movie.movie_id AND -- Als eerste op Movie_id
        Person.person_id = Movie_Cast.person_id AND -- Daarna op Person_id
        Movie.title LIKE 'Terminator%' AND -- De titel moet een Terminator film zijn
        Movie.publication_year = 1991 -- Uit het jaar 1991

--select * from Movie where movie_id = 328277   werkt


/*******************************************************************************************
    3E Alle films waar Arnold Scharzenegger een rol speelt(movie title, publication year)
*******************************************************************************************/
select distinct Movie.title, publication_year-- Een select voor de gevraagde informatiebehoefte
    from Movie, Movie_Cast, Person -- 2 inner joins om de juiste info te krijgen
    where Movie.movie_id = Movie_Cast.movie_id AND -- Eerst op Movie_id
    Movie_Cast.person_id = Person.person_id AND -- Daarna Person_id
    Person.firstname = 'Arnold' AND -- Voornaam moet Arnold zijn
    Person.lastname = 'Schwarzenegger' -- Achternaam moet Schwarzenegger zijn
go
/*
select movie_id from Movie where title = 'Forsthaus Falkenau"'
select * from Person where firstname = 'Arnold' and lastname = 'Schwarzenegger'
insert into Movie_Cast values(389119, 515429, 'AAAA')
delete Movie_Cast where role_ = 'AAAA'
*/
/*******************************************************************************************
    3F view van alle klanten met opendstaande rekeningen
*******************************************************************************************/

go
create view OpenstaandeBetalingen as -- Als eerste maken we een View aan
    select C.lastname, C.firstname, sum(WH.price) as totalPrice -- Een select die de naam en zijn totale schuld pakt
    from WatchHistory as WH inner join Customer as C -- een inner join op beide tabellen
    on WH.customer_mail_address = C.customer_mail_address -- gematcht op de e-mail van de klant
    where WH.invoiced = 0 -- = 0 want 1 betekend geen schuld
    group by C.lastname, C.firstname -- gegroepeerd per klant
go
--drop view OpenstaandeBetalingen
select * from OpenstaandeBetalingen


/*******************************************************************************************
    3G Toon 100 movies die tot nu toe het minst bekeken zijn,
    gesorteerd naar het aantal keren dat ze gekeken werden.
    Dit houdt ook 0 keer in [movie title, number of times watched].
    Maak een View voor deze informatiebehoefte.
*******************************************************************************************/
--[movie title, number of times watched]
go
create view minstGekekenFilms as -- Als eerste, Een view maken voor de informatiebehoefte
select top 100 M.title, count(WH.movie_id) as aantalKeerGekeken -- De titel en een optelling van de movie_id's
from FletNix.dbo.Movie as M left join FletNix.dbo.WatchHistory as WH -- Een left join op movie zodat films die geen watch history hebben ook zichtbaar zijn 
on M.movie_id = WH.movie_id -- Een inner join op movie_id
group by M.movie_id, M.title 
go --drop minstGekekenFilms
--select statement om de view in te zien
--select * from minstGekekenFilms order by aantalKeerGekeken, title -- en groepering op titel om enkele dubbele notities tegen te gaan
/*
go
create view minstGekekenFilms as -- Als eerste, Een view maken voor de informatiebehoefte
select top 100 M.title, count(WH.movie_id) as aantalKeerGekeken -- De titel en een optelling van de movie_id's
from FletNix.dbo.Movie as M left join FletNix.dbo.WatchHistory as WH -- Een left join op movie zodat films die geen watch history hebben ook zichtbaar zijn 
on M.movie_id = WH.movie_id -- Een inner join op movie_id
where M.title like 'AA%'
group by M.movie_id, M.title 
order by aantalKeerGekeken, M.title -- en groepering op titel om enkele dubbele notities tegen te gaan
go
*/
/*--tests
insert into Movie values(999999, 'AAAA', 100, 'description of aaa', 1996, null, null, 5, null)
insert into Customer(customer_mail_address,lastname,firstname,payment_method,payment_card_number,contract_type,
subscription_start,subscription_end,user_name_,password_,country_name,gender,birth_date)
values('daansperling@hotmail.com','Sperling','Daan','type = 1','Classified','ctype = 2', '2017-NOV-17',
    NULL,'tokindforyou','P@ssW0rd','Netherlands','M', '1996-FEB-11');
insert into WatchHistory(movie_id,customer_mail_address,watch_date,price,invoiced)
values(999999, 'daansperling@hotmail.com','2017-09-12',11.99, 1)
delete Movie where movie_id = 999999 
insert into WatchHistory(movie_id,customer_mail_address,watch_date,price,invoiced)
values(5, 'daansperling@hotmail.com','2017-09-12',11.99, 1)
insert into WatchHistory(movie_id,customer_mail_address,watch_date,price,invoiced)
values(4, 'daansperling@hotmail.com','2017-09-12',11.99, 1)
insert into WatchHistory(movie_id,customer_mail_address,watch_date,price,invoiced)
values(4, 'daansperling@hotmail.com','2017-08-12',11.99, 1)
select * from Movie

select * from minstGekekenFilms
order by aantalKeerGekeken,title
*/--werkt
--drop view minstGekekenFilms

/*******************************************************************************************
    3H Alle movies die in de afgelopen twee maanden het meest bekeken zijn,
    gesorteerd naar het aantal keren dat ze gekeken werden. 
    Toon alleen movies die minimaal één keer bekeken zijn
    [movie title, publication_year, number of times watched].
    Maak een View voor deze informatiebehoefte.
    De sortering kun je niet binnen de view doen, laat die buiten de view.
*******************************************************************************************/
go
create view PopulaireFilms as -- Een view aanmaken voor de informatiebehoefte
    select M.title, M.publication_year, count(*) as aantalKeerBekeken -- een select van titel, publicatie jaar en een telling van movie_id's
    from WatchHistory as WH inner join Movie as M on WH.movie_id = M.movie_id -- een inner join op de Movie_id's
	where datediff(month,  WH.watch_date, getdate()) <= 2
    group by M.movie_id, M.title, M.publication_year -- Een groepering op titel en publicatie jaar voor een goede lijst
    having count(*) >= 1 -- zodat films die 0 keer gezien zijn er uit wordt gefilterd
go
    --drop view PopulaireFilms
--Test
--select * from PopulaireFilms order by aantalKeerBekeken desc
--select top 40 count(*) from WatchHistory where datediff(month,  WatchHistory.watch_date, getdate()) <= 2 group by movie_id order by count(*) desc;
--Werkt


/*******************************************************************************************
    3I Alle movies die meer dan 8 genres hebben [title, publication_year]
*******************************************************************************************/
select title, publication_year -- een select op titel en publicatie jaar
    from Movie as M inner join Movie_Genre as MG on M.movie_id = MG.movie_id -- een inner join op de movie_id's 
    group by M.movie_id, M.title, M.publication_year -- gegroepeerd op de id, de titel en de publicatie jaar. ze zijn alle 3 nodig om goede groepen te creëren
    having count(*) > 8 -- minstens 8 films omdat dit gevraagd wordt voor de informatiebehoefte

	/* met subquery
select title, publication_year
	from Movie as M
	where M.movie_id in (
		select MG.movie_id from Movie_Genre as MG 
			group by MG.movie_id
			having count(MG.genre_name) > 8
		)
		*/
/*--Bewijs
select title, publication_year, M.movie_id, count(*) as aantal
    from Movie as M inner join Movie_Genre as MG on M.movie_id = MG.movie_id 
    group by M.movie_id, M.title, M.publication_year
    having count(*) > 8
    order by count(*) desc --zelfde query met count en movie_id
select movie_id, count(*) as aantal
select * from Movie_Genre where movie_id = 37100
al
    from Movie_Genre
    group by movie_id
    having count(*) >= 8
    order by count(*) desc
	select MG.genre_name, M.title
		from Movie_Genre as MG inner join Movie as M on MG.movie_id = M.movie_id
		where MG.movie_id in (select M.movie_id
		from Movie as M inner join Movie_Genre as MG on M.movie_id = MG.movie_id 
		group by M.movie_id, M.title, M.publication_year
		having count(*) >= 8)
*/ --werkt


/*******************************************************************************************
    3J Alle vrouwen die in Horror movies en Family movies gespeeld hebben [firstname,lastname].
*******************************************************************************************/
select firstname, lastname -- een select op de naam
    from Person
    where person_id in ( -- een subquery die alleen mensen pakt die in horror films gespeeld hebben
        select MC.person_id 
        from Movie_Cast as MC inner join Movie as M on MC.movie_id = M.movie_id inner join Movie_Genre as MG on M.movie_id = MG.movie_id
        group by MC.person_id, MG.genre_name
        having MG.genre_name = 'Horror'
        )
        and person_id in ( -- vervolgd door een subquery die alleen mensen pakt die in family films gespeeld hebben
            select MC.person_id 
            from Movie_Cast as MC inner join Movie as M on MC.movie_id = M.movie_id inner join Movie_Genre as MG on M.movie_id = MG.movie_id
            group by MC.person_id, MG.genre_name
            having MG.genre_name = 'Family')
        and gender = 'F' --Als laatste alleen vrouwen
/*--Bewijs
select movie_cast.movie_id, movie_genre.genre_name
	from Movie_cast inner join movie_genre on Movie_cast.movie_id = Movie_genre.movie_id
	where genre_name = 'Horror' and person_id=617591
	--73410
	insert into movie_genre values(
	73410, 'Family')
	delete movie_genre where movie_id = 73410 and genre_name = 'Family'
select MG.genre_name, count(MG.genre_name) as aantalKeerGenre, MC.person_id
    from Movie_Genre as MG inner join Movie_Cast as MC on MG.movie_id = MC.movie_id
    where MC.person_id in(
        select person_id
        from Person
        where person_id in ( --oude query met select van person_id
            select MC.person_id 
            from Movie_Cast as MC inner join Movie as M on MC.movie_id = M.movie_id inner join Movie_Genre as MG on M.movie_id = MG.movie_id
            group by MC.person_id, MG.genre_name
            having MG.genre_name = 'Horror'
        ) 
        and person_id in (
            select MC.person_id 
            from Movie_Cast as MC inner join Movie as M on MC.movie_id = M.movie_id inner join Movie_Genre as MG on M.movie_id = MG.movie_id
            group by MC.person_id, MG.genre_name
            having MG.genre_name = 'Family')
        and gender = 'F' --einde oude query
        )
        and (MG.genre_name = 'Horror'
        or MG.genre_name = 'Family')
        group by MC.person_id, MG.genre_name
        order by MC.person_id
*/--werkt

/*******************************************************************************************
    3K    
	De director die tot nu toe de meeste films geproduceerd heeft [firstname, lastname].  
*******************************************************************************************/
select top 1 P.firstname, P.lastname --top 1, want alleen degene met de meeste Movies
    from Person as P inner join Movie_Directors as MD on P.person_id = MD.person_id --We moeten zijn naam uit Person halen, maar het moet een Movie_Director zijn
    group by MD.person_id, P.firstname, P.lastname
    order by count(*) desc --aantal films met het het hoogste bovenaan

/*--test
select P.firstname, P.lastname, count(*)
    from Person as P inner join Movie_Directors as MD on P.person_id = MD.person_id
    group by MD.person_id, P.firstname, P.lastname
    order by count(*) desc 
*/ --werkt

/*******************************************************************************************
    3L
	Alle Genres en het percentage dat de films uit het bepaalde genre uitmaken t.o.v. het totale aantal
	films [genre, percentage], gesorteerd op meest populaire genre.
	Maak een View voor deze informatiebehoefte. Je mag ook eerst één of meerdere (hulp-)views
	maken om de informatiebehoefte op te lossen.
*******************************************************************************************/
--Hulpview
go
create view aantalFilmsPerGenre as
    select count(*) as aantal, G.genre_name
    from Genre as G left join Movie_Genre as MG on G.genre_name = MG.genre_name--moeten het genre_name krijgen maar aantallen uit Movie
    group by G.genre_name --per genre
go
--drop view aantalFilmsPerGenre
--insert into Genre values ('TEST_Genre', 'een genre om te testen')
--delete Genre where genre_name = 'TEST_Genre'
--View voor de informatie behoefte
create view genrePercentages as 
    select genre_name, AFPG.aantal / cast((select count(*) from Movie) as float) * 100.0 as percentage --cast voor decimalen. deel delen door het geheel * 100 = percentage
    from aantalFilmsPerGenre as aFPG
go
--drop view genrePercentages

--Select statement voor de informatie behoefte met de juiste volgorde
select * 
    from genrePercentages
    order by percentage desc --populairste genre eerst

--test
--select * from genrePercentages
--select * from aantalFilms
--select * from aantalFilmsPerGenre
--select * from genrePercentages
/*
    Aantal films 388264
    Genre       | aantal    | met de hand uitgerekend percentage    | percentage volgens query
    __________________________________________________________________________________________
    Action      | 77662     | 20.002%                               | 20.002%
    Adventure   | 83286     | 21.451%                               | 21.451%
    Animation   | 24031     | 6.189%                                | 6.189%
    Comedy      | 177159    | 45.628%                               | 45.628%

    Films kunnen meer dan 1 gerne hebben, dus het kan dat het totale percentage boven de 100% komt.
    werkt
*/

/*******************************************************************************************
    3M
	Gebruikers [mail_adress] en het gemiddelde aantal films die elke gebruiker per dag kijkt. Toon
	alleen gebruikers die gemiddeld 2 of meer films per dag kijken, met het grootste gemiddelde
	bovenaan.
	Maak een View voor deze informatiebehoefte. Je mag ook eerst één of meerdere (hulp-)views
	maken om de informatiebehoefte op te lossen.
*******************************************************************************************/
--Hulp view
go
--cast naar numeric(10,2) om decimalen te krijgen voor het rekenen
create view aantalDagen as --aantal dagen dat een klant een abbonement heeft heeft (subscription_start tot nu)
    select cast(datediff(day, C.subscription_start, ISNULL(subscription_end, getdate())) + 1 as numeric(10,2)) as aantal, C.customer_mail_address
    from Customer as C
go --drop view aantalDagen
--Hulpview
go
create view aantalFilmsGezien as --Totaal aantal films dat een klant heeft gezien
    select cast(count(*) as numeric(10,2)) as aantal, WH.customer_mail_address --cast voor decimalen in de uiteindelijke view
	from WatchHistory as WH
    group by WH.customer_mail_address
go --drop view aantalFilmsGezien

create view gemAantalFilmsPerDag as --Deelt het aantal films door het aantal dagen
    select aF.aantal / aD.aantal as gemiddelde, aF.customer_mail_address
    from aantalDagen as aD inner join aantalFilmsGezien as aF on aD.customer_mail_address = aF.customer_mail_address --inner join van de hulpviews op het email_address
    group by aF.customer_mail_address, aF.aantal, aF.aantal / aD.aantal --Maar 1 row per customer
    having aF.aantal / aD.aantal >= 2 --alleen met gemiddeld 2 films per dag of meer
    --order by aF.aantal / aD.aantal desc
go --drop view gemAantalFilmsPerDag

--Select statement met de juiste volgorde voor de informatie behoefte
--select * from gemAantalFilmsPerDag order by gemiddelde desc

/*--test
insert into Customer values('erik2knaake@gmail.com', 'Knaake', 'Erik', 'type = 0', '02595423', 'ctype = 0', '12-08-2017', '12-09-2017', 'erik321123!', 'password!', 'Netherlands', 'M', '01-10-2000')
insert into WatchHistory values(10, 'erik2knaake@gmail.com', '12-08-2017', 5, 1), (100, 'erik2knaake@gmail.com', '12-08-2017', 5, 1), (1000, 'erik2knaake@gmail.com', '12-08-2017', 5, 1)
--delete WatchHistory where customer_mail_address = 'erik2knaake@gmail.com'
--delete Customer where customer_mail_address = 'erik2knaake@gmail.com'
select * from gemAantalFilmsPerDag order by gemiddelde desc
*/--werkt
