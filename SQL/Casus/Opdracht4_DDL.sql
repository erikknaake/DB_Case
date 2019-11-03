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
*******************************************************************************************/
use FletNix
go
--Verwijder de tabelen
drop table Uitslagen
go
drop table Location_
go
drop table Won_nom
go
/*******************************************************************************************
	Zie Normalisatie.xslx voor de tot stand koming van het ontwerp (blad: 3NV_Aangepst voor uiteindelijke ontwerp)
	Volgorde van aanmaken nieuwe tabellen die rekening houdt met de foreign keys:
	1. Location_
	2. Won_nom
	3. Uitslagen (referenced Location, Won_Nom, Person en Movie) Dus originele FletNix database moet al gecreate zijn.
*******************************************************************************************/


/*******************************************************************************************
	Location
*******************************************************************************************/

create table Location_ (
	awardType varchar(255) not null,
	year_ numeric(5) not null,
	country varchar(50) not null,

	constraint PK_Location primary key (awardType, year_),
	constraint FK_Location foreign key (country) references Country(country_name)
)


/*******************************************************************************************
	Won_Nom
*******************************************************************************************/

create table Won_nom(
	Afkorting char(1) not null,
	Voluit varchar(50) not null,
	
	constraint PK_Won_Nom primary key(Afkorting),
	constraint CHK_afkorting check(afkorting = 'W' or afkorting = 'N') --Alleen W of N
)


/*******************************************************************************************
	Uitslagen
*******************************************************************************************/

create table Uitslagen (
	awardType varchar(255) not null,
	year_ numeric(5) not null,
	category varchar(255) not null,
	movieId int not null,
	personId int not null, 
	uitslag char(1) not null,

	constraint PK_Uitslagen primary key (awardType, year_, category, movieId, personId),
	
	constraint FK_Uitslagen_Location foreign key (awardType, year_) references Location_(awardType, year_),
	constraint FK_Uitslagen_Won_Nom foreign key (uitslag) references Won_Nom(afkorting),

	--FKs naar Originele FletNix
	constraint FK_Uitslagen_Person foreign key (personId) references Person(person_id),
	constraint FK_Uitslagen_Movie foreign key (movieId) references Movie(movie_id)
)







/*******************************************************************************************
	Inserts
*******************************************************************************************/
--Won_Nom
insert into Won_nom values
	('W', 'Won'),
	('N', 'Nominated');

--Location
insert into Location_ values('Bafta',2000,'New Zealand'),
                            ('Acedemy', 2000, 'Netherlands')

--Person
--delete Person
insert into Person values
	(950001, 'Paul', 'Rubewel', NULL),
	(950002, 'Richard', 'Hymms', NULL),
	(950003, 'Dane', 'Davis', NULL),
	(950004, 'John', 'Gueta', NULL),
	(950005, 'Stece', 'Courtley', NULL),
	(950006, 'Jon', 'Thum', NULL),
	(950007, 'David', 'Lee', NULL),
	(950008, 'John', 'Reitz', NULL),
	(950009, 'Gegg', 'Rudloff', NULL),
	(950010, 'David', 'Champbell', NULL),
	(950011, 'Dane', 'Davis', NULL),
	(950012, 'Tom', 'Bellfort', NULL),
	(950013, 'Bob', 'Beemer', NULL),
	(950014, 'Bill', 'Pope', NULL),
	(950015, 'Conrad', 'Hall', NULL),
	(950016, 'Tariq', 'Anwer', NULL),
	(165453, 'Ben', 'Burtt', NULL)
--delete Location_
--Uitslagen
delete Uitslagen
insert into Uitslagen values
	('Acedemy', 2000, 'Best Film Editing', 207992, 550813, 'W'),
	('Acedemy', 2000, 'Best Film Editing', 160492, 276884, 'N'),
	('Acedemy', 2000, 'Best Film Editing', 160492, 950001, 'N'),
	('Acedemy', 2000, 'Best Film Editing', 160492, 68042, 'N'),
	('Acedemy', 2000, 'Best Film Editing', 303564, 54796, 'N'),
	('Acedemy', 2000, 'Best sounds effects editing', 112290, 351397, 'N'),
	('Acedemy', 2000, 'Best sounds effects editing', 112290, 950002, 'N'),
	('Acedemy', 2000, 'Best sounds effects editing', 207992, 950003, 'W'),
	('Acedemy', 2000, 'Best sounds effects editing', 313474, 165453, 'N'),
	('Acedemy', 2000, 'Best sounds effects editing', 313474, 351981, 'N'),
	('Acedemy', 2000, 'Best visual effects', 313474, 191712, 'N'),
	('Acedemy', 2000, 'Best visual effects', 207992, 950004, 'W'),
	('Acedemy', 2000, 'Best visual effects', 207992, 540853, 'W'),
	('Acedemy', 2000, 'Best visual effects', 207992, 950005, 'W'),
	('Acedemy', 2000, 'Best visual effects', 207992, 950006, 'W'),
	('BAFTA',2000, 'Best sound', 207992,950007,'W'),
    ('BAFTA',2000, 'Best sound', 207992,950006,'W'),
    ('BAFTA',2000, 'Best sound', 207992,950008,'W'),
    ('BAFTA',2000, 'Best sound', 207992,950010,'W'),
    ('BAFTA',2000, 'Best sound', 207992,950011,'W'),
    ('BAFTA',2000, 'Best sound', 313474,165453,'N'),
    ('BAFTA',2000, 'Best sound', 313474,950012,'N'),
    ('BAFTA',2000, 'Best sound', 13789,950013,'N'),
    ('BAFTA',2000, 'Best Cinematography',207992,950014,'N'),
    ('BAFTA',2000, 'Best Cinematography',13789,950015,'W'),
    ('BAFTA',2000, 'Best Production Design',207992,464716,'N'),
    ('BAFTA',2000, 'Best Production Design',304862,303143,'W'),
    ('BAFTA',2000, 'Best editing',207992,550813,'N'),
    ('BAFTA',2000, 'Best editing',13789,950016,'W'),
    ('BAFTA',2000, 'Best editing',13789,283753,'W');






/*******************************************************************************************
	Genereer het overzicht		
*******************************************************************************************/
select 
	--Awardtype
	awardType + ' Awards ' + 
	--Year
	cast(year_ as varchar(5)) + 
	--Country
	' in the '+ (select country from Location_ where awardType = U.awardType and year_ = U.year_) + 
	--category
	'   ' + category + ' ' +  
	--Movie
	(select title + ' (' + cast(movie_id as varchar(10)) + ') ' from Movie where movie_id = U.movieId) + 
	--Person
	'   ' + (select firstname + ' ' + lastname + ' (' + cast(person_id as varchar(10)) + ') ' from Person where person_id = U.personId) + 
	--uitslag
	'   ' + (select afkorting + ' ' + voluit from Won_Nom where Afkorting = U.uitslag)
	from Uitslagen as U

	--30 regels net zoals aangeleverde tabel
