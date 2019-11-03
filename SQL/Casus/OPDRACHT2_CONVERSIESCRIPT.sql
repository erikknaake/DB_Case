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

use master
go

/*******************************************************************************************
	Maak FletNix database leeg
*******************************************************************************************/

delete FletNix.dbo.Movie_Genre -- maakt het mogelijk Genre te verwijderen
delete FletNix.dbo.Genre

delete FletNix.dbo.Movie_Directors --maakt het met onderstaande mogelijk om Person te verwijderen
delete FletNix.dbo.Movie_Cast
delete FletNix.dbo.Person

delete FletNix.dbo.WatchHistory --maakt het mogelijk customer te verwijderen
delete FletNix.dbo.Customer --maakt verwijderen 3 onderstaande mogelijk
delete FletNix.dbo.Country
delete FletNix.dbo.Contract_
delete FletNix.dbo.Payment

delete FletNix.dbo.Movie
go

/*******************************************************************************************
	Movie
*******************************************************************************************/

--Insert Movie, standaard price op 5
--Nyr wordt als description geinsert
insert into FletNix.dbo.Movie (movie_id, title, publication_year, price, description_)
	select Imported_Movie.Id as movie_id, Imported_Movie.Name as title, Imported_Movie.Year as publication_year, 5, Nyr as description_
	from MYIMDB.dbo.Imported_Movie

/*--Test of het nog klopt
select TOP 20 *
	from MYIMDB.dbo.Imported_Movie
	order by Name desc

select TOP 20 *
	from FletNix.dbo.Movie
	order by title desc
--test is gelukt*/

/*******************************************************************************************
	Person
*******************************************************************************************/
--Id moet van varchar(10) naar int, dit wordt gedaan met behulp van een cast
--LName en FName moeten van varchar(4000) naar varchar(50), dit wordt gedaan met behulp van left
insert into FletNix.dbo.Person
	select cast(Id as int) as person_id,
		left(LName, 50) as lastname,
		left(FName, 50) as firstname,
		null as gender
	from MYIMDB.dbo.Imported_Directors

	/*
	select *
	from MYIMDB.dbo.Imported_Directors as ID
	where ID.FName IN (select IP.FName from MYIMDB.dbo.Imported_Person as IP) and
		ID.LName IN (select IP.LName from MYIMDB.dbo.Imported_Person as IP)
		*/

/*--test		Alleen goede test als imported_directors nog niet is geinsert
select TOP 40 * 
	from FletNix.dbo.Person
	order by firstname, lastname 

select TOP 40 *
	from MYIMDB.dbo.Imported_Directors
	order by FName, LName
--werkt
*/

go

/*******************************************************************************************
	Imported Person
*******************************************************************************************/
go
--Om deze persons te kunnen inserten moeten we ervoor zorgen dat de Ids niet al in person zitten (er zitten anders dubbele Ids bij)
--Om dit te bereiken berekenen we het hoogste id en tellen we dit getal op bij de nieuwe Ids
declare @maxId int;
select @maxId = max(cast(MYIMDB.dbo.Imported_Directors.Id as int)) from MYIMDB.dbo.Imported_Directors;
--Id moet van varchar(10) naar int, dit wordt gedaan met behulp van een cast
--LName en FName moeten van varchar(4000) naar varchar(50), dit wordt gedaan met behulp van left
insert into FletNix.dbo.Person (person_id, lastname, firstname, gender)
	select (cast(P.Id as int) + @maxId) as person_id,
	left(P.LName, 50) as lastname,
	left(P.FName, 50) as firstname,
	P.Gender as gender
	from MYIMDB.dbo.Imported_Person as P

	/*
	select top 20 * from FletNix.dbo.Person order by firstname, lastname 
	select top 20 * from MYIMDB.dbo.Imported_Person order by FName, LName 
	--werkt*/
go

--Distinct om aan de primary key te voldoen
insert into FletNix.dbo.Genre (genre_name)
	select distinct IG.Genre
	from MYIMDB.dbo.Imported_Genre as IG
/*
select * from FletNix.dbo.Movie_Genre
select distinct Genre from MYIMDB.dbo.Imported_Genre
--werkt*/


/*******************************************************************************************
	Payment, 15 getallen
*******************************************************************************************/
--Genereerd 15 payments door middel van een for loop
go
declare @i int = 0;
while @i < 15
begin
	insert into FletNix.dbo.Payment
		values('type = ' + cast(@i as varchar(2)));
	set @i = @i + 1;
end
go
--select * from FletNix.dbo.Payment --werkt


/*******************************************************************************************
	Contract, 12 getallen
*******************************************************************************************/
--Genereerd 12 Contract met behulp van een for loop
go
declare @i int = 0;
while @i < 12
begin
	insert into FletNix.dbo.Contract_
		values('ctype = ' + cast(@i as varchar(2)), 1.5 * @i + 2, @i);
	set @i = @i + 1;
end
go
--select * from FletNix.dbo.Contract_ --werkt

/*******************************************************************************************
	Landen
*******************************************************************************************/

--Credits voor landenlijst: https://andrewelkins.com/2013/01/17/query-to-insert-all-countries-into-database/
insert into FletNix.dbo.Country
values('Afghanistan'), ('Albania'),('Algeria'),('Andorra'),('Angola'),('Antigua and Barbuda'),('Argentina'),('Armenia'),('Australia'),('Austria'),('Azerbaijan'),('Bahamas, The'),
('Bahrain'),('Bangladesh'),('Barbados'),('Belarus'),('Belgium'),('Belize'),('Benin'),('Bhutan'),('Bolivia'),('Bosnia and Herzegovina'),('Botswana'),('Brazil'),('Brunei'),('Bulgaria'),('Burkina Faso'),('Burma'),('Burundi'),
('Cambodia'),('Cameroon'),('Canada'),('Cape Verde'),('Central Africa'),('Chad'),('Chile'),('China'),('Colombia'),('Comoros'),('Congo, Democratic Republic of the'),('Costa Rica'),('Cote dIvoire'),('Crete'),('Croatia'),('Cuba'),('Cyprus'),
('Czech Republic'),('Denmark'),('Djibouti'),('Dominican Republic'),('East Timor'),('Ecuador'),('Egypt'),('El Salvador'),('Equatorial Guinea'),('Eritrea'),('Estonia'),('Ethiopia'),('Fiji'),('Finland'),('France'),('Gabon'),('Gambia, The'),
('Georgia'),('Germany'),('Ghana'),('Greece'),('Grenada'),('Guadeloupe'),('Guatemala'),('Guinea'),('Guinea-Bissau'),('Guyana'),('Haiti'),('Holy See'),('Honduras'),('Hong Kong'),('Hungary'),('Iceland'),('India'),('Indonesia'),
('Iran'),('Iraq'),('Ireland'),('Israel'),('Italy'),('Ivory Coast'),('Jamaica'),('Japan'),('Jordan'),('Kazakhstan'),('Kenya'),('Kiribati'),('Korea, North'),('Korea, South'),('Kosovo'),('Kuwait'),('Kyrgyzstan'),('Laos'),('Latvia'),
('Lebanon'),('Lesotho'),('Liberia'),('Libya'),('Liechtenstein'),('Lithuania'),('Macau'),('Macedonia'),('Madagascar'),('Malawi'),('Malaysia'),('Maldives'),('Mali'),('Malta'),('Marshall Islands'),('Mauritania'),('Mauritius'),
('Mexico'),('Micronesia'),('Moldova'),('Monaco'),('Mongolia'),('Montenegro'),('Morocco'),('Mozambique'),('Namibia'),('Nauru'),('Nepal'),('Netherlands'),('New Zealand'),('Nicaragua'),('Niger'),('Nigeria'),('North Korea'),('Norway'),
('Oman'),('Pakistan'),('Palau'),('Panama'),('Papua New Guinea'),('Paraguay'),('Peru'),('Philippines'),('Poland'),('Portugal'),('Qatar'),('Romania'),('Russia'),('Rwanda'),('Saint Lucia'),('Saint Vincent and the Grenadines'),('Samoa'),('San Marino'),
('Sao Tome and Principe'),('Saudi Arabia'),('Scotland'),('Senegal'),('Serbia'),('Seychelles'),('Sierra Leone'),('Singapore'),('Slovakia'),('Slovenia'),('Solomon Islands'),('Somalia'),('South Africa'),('South Korea'),('Spain'),('Sri Lanka'),('Sudan'),
('Suriname'),('Swaziland'),('Sweden'),('Switzerland'),('Syria'),('Taiwan'),('Tajikistan'),('Tanzania'),('Thailand'),('Tibet'),('Timor-Leste'),('Togo'),('Tonga'),('Trinidad and Tobago'),('Tunisia'),('Turkey'),('Turkmenistan'),
('Tuvalu'),('Uganda'),('Ukraine'),('United Arab Emirates'),('United Kingdom'),('United States'),('Uruguay'),('Uzbekistan'),('Vanuatu'),('Venezuela'),('Vietnam'),('Yemen'),('Zambia'),('Zimbabwe');
--select * from FletNix.dbo.Country		werkt

/*******************************************************************************************
	Customer
*******************************************************************************************/
--Genereerd 225 Customers
--2 for loops in elkaar om meer variatie toe te brengen in het email address
-- select top 1 XXX from YYY order by NEWID() geeft een random regel uit een tabel
go
declare @prefix numeric(3) = 1;
declare @suffix numeric(3) = 1;
while @prefix < 16 begin
	set @suffix = 1;
	while @suffix < 16 begin
		insert into FletNix.dbo.Customer
			values(cast(@prefix as varchar(6)) + '@' + cast(@suffix as varchar(6)) + '.com', --mailadres		teller1 + '@' + teller2 + '.com'
			cast(@suffix * @prefix as varchar(20)),  --lastname		rekensommetje van twee telles
			cast(@prefix * (@suffix + 1) as varchar(20)), --firstname	rekensommetje van twee telles
			(select top 1 payment_method from FletNix.dbo.Payment order by NEWID()), --payment_type random row uit Payment
			cast(@suffix / @prefix as varchar(25)), --payment_card_number	rekensommetje van twee telles
			(select top 1 contract_type from FletNix.dbo.Contract_ order by NEWID()),  --contracttype random row uit Contract_
			dateadd(month, -1 * @prefix, getdate()),--subscription start rekensom met huidige datum en teller
			dateadd(year, @suffix, getdate()), --subscription end		rekensim met huidige datum en teller
			'username: ' + cast(@prefix as varchar(2)) + cast(@suffix as varchar(2)) + cast(@suffix as varchar(2)), --user name			string concat met tellers met een unieke uitkomst
			'password: ' + cast(@suffix * @prefix as varchar(35)), --password		rekensommetje met tellers
			(select top 1 country_name from FletNix.dbo.Country order by NEWID()), --country		random row uit country
			case when @suffix % 2 = 0 then 'M' else 'F' end, --gender	even: M oneven: F
			dateadd(month, -1 * @suffix * @prefix, getdate()));--birth_date		rekensom met huidige datum en tellers
		set @suffix = @suffix + 1;
	end
set @prefix = @prefix + 1;
end
go
--select * from FletNix.dbo.Customer --werkt
/*select top 20 count(*) 
from MYIMDB.dbo.Imported_Director_Genre as DG
group by DG.Did 
having count(*) > 1 */--er zijn films met meer dan 1 genre


/*******************************************************************************************
	Movie Genre
*******************************************************************************************/
/*insert into FletNix.dbo.Movie_Genre
	select MD.Mid as movie_id, DG.Genre as genre_name
	from MYIMDB.dbo.Imported_Movie_Directors as MD inner join --alleen films waarvan we genre en id hebben
	MYIMDB.dbo.Imported_Director_Genre as DG on MD.Did = DG.Did
	group by MD.Mid, DG.Genre --om aan de primary key te voldoen*/

insert into FletNix.dbo.Movie_Genre
	select distinct IG.Id, IG.Genre
	from MYIMDB.dbo.Imported_Genre as IG
/*
select top 20 * 
	from MYIMDB.dbo.Imported_Movie_Directors as MD inner join MYIMDB.dbo.Imported_Director_Genre as DG on MD.Did = DG.Did
	order by MD.Mid

select top 20 * 
	from FletNix.dbo.Movie_Genre as MG
	order by MG.movie_id */--werkt en heeft dubbele verwijderd

/*******************************************************************************************
	Movie_Cast	
*******************************************************************************************/
--Imported_Cast.Pid en Imported_Cast.Mid moeten van varchar(10) naar int, dit wordt gedaan met een cast
--Imported_Cast.Role moet van varchar(4000) naar varchar(255), dit wordt gedaan met een left.
insert into FletNix.dbo.Movie_Cast (person_id, movie_id, role_)
	select distinct cast(IC.Pid as int) as person_id,
	cast(IC.Mid as int) as movie_id,
	left(IC.Role, 255) as role_
	from MYIMDB.dbo.Imported_Cast as IC inner join FletNix.dbo.Person as P on IC.Pid = P.person_id inner join FletNix.dbo.Movie as M on IC.Mid = M.movie_id 
	/*
	select top 20 * from FletNix.dbo.Movie_Cast order by person_id desc
	select top 20 * from MYIMDB.dbo.Imported_Cast order by cast(Pid as int) desc --moet casten om alle Pids boven 99999 te krijgen
	 --werkt
	*/

/*******************************************************************************************
	WatchHistory, 1000 'random' gevallen
*******************************************************************************************/
--Genereer 1000 random WatchHistory met behulp van een for loop
--Door een random Movie te kiezen,
--een random Customer te kiezen,
--een random price te kiezen [2, 10>
--en random te bepalen of er al betaald is [0, 1]

go
declare @mail varchar(255);
declare @teller int = 0;
while @teller < 1000 begin 
set @mail = (select top 1 customer_mail_address from FletNix.dbo.Customer order by NEWID());
insert into FletNix.dbo.WatchHistory
	values((select top 1 movie_id from FletNix.dbo.Movie order by NEWID()),
		@mail,
		(select subscription_start from FletNix.dbo.Customer as C where @mail = C.customer_mail_address),
		rand() * 10 + 2, --price
		round(rand(), 0) --invoiced
	);
	set @teller = @teller + 1;
end 
go

-- select top 20 * from FletNix.dbo.WatchHistory	--werkt
/*select P.person_id, P.firstname, P.lastname, ID.FName, ID.LName
	from FletNix.dbo.Person as P inner join MYIMDB.dbo.Imported_Movie_Directors as IMD on P.person_id = IMD.Did inner join MYIMDB.dbo.Imported_Directors as ID on P.person_id = ID.Id

select FName, LName, firstname, lastname
	from MYIMDB.dbo.Imported_Directors, FletNix.dbo.Person
	order by FName, LName, firstname, lastname*/


/*******************************************************************************************
	Movie_Directors	
*******************************************************************************************/

--Directors worden als eerste personen geinsert, dus geen rekensom voor person_id nodig
insert into FletNix.dbo.Movie_Directors (person_id, movie_id)
	select Did as person_id, Mid as movie_id
	from MYIMDB.dbo.Imported_Movie_Directors
/*
--Tests
select FName, LName
	from MYIMDB.dbo.Imported_Directors
	order by FName, LName

select firstname, lastname
	from FletNix.dbo.Person
	where person_id in (select MD.person_id from FletNix.dbo.Movie_Directors as MD)
	order by firstname, lastname 
	--namen komen overeen

select count(*) 
	from MYIMDB.dbo.Imported_Movie_Directors
select count(*) 
	from FletNix.dbo.Movie_Directors
	--aantallen komen overeen
--werk
	*/

/*
	--Om een beeld te krijgen van de aantallen
select count(*)  as ContractAantal
    from FletNix.dbo.Contract_
select count(*) as CountryAantal
    from FletNix.dbo.Country
select count(*) as CustomerAantal
    from FletNix.dbo.Customer 
select count(*)  as GenreAantal
    from FletNix.dbo.Genre
select count(*) as MovieAantal
    from FletNix.dbo.Movie
select count(*) as MovieCastAantal
    from FletNix.dbo.Movie_Cast
select count(*) as MovieDirectorsAantal
    from FletNix.dbo.Movie_Directors
select count(*) as MovieGerneAantal
    from FletNix.dbo.Movie_Genre
select count(*) as PaymentAantal
    from FletNix.dbo.Payment 
select count(*) as PersonAantal
    from FletNix.dbo.Person
select count(*) as WatchHistoryAantal
    from FletNix.dbo.WatchHistory 
	--6569680 rows totaal
*/