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

--Zorg ervoor dat we opnieuw beginnen, go's om te zorgen dat als
--de database niet bestaat er een error wordt gethrowd maar er wel een nieuwe database wordt gemaakt
use master
go

drop database FletNix
go

create database FletNix
go
--Werk vanuit de nieuwe database 'FletNix'
use FletNix
go

/*******************************************************************************************
	Genre
*******************************************************************************************/
create table Genre	(
	genre_name		varchar(255)	not null,
	description_	varchar(255)	null

	constraint PK_Genre primary key (genre_name)
)

/*******************************************************************************************
	Movie
*******************************************************************************************/

create table Movie	(
	movie_id		int				not null,
	title			varchar(255)	not null,
	duration		int				null,
	description_	varchar(255)	null,
	publication_year	int			null,
	cover_image		varchar(255)	null,
	previous_part	int				null,
	price			numeric(5, 2)	not null,
	URL_			varchar(255)	null,

	constraint PK_Movie primary key (movie_id),

	constraint CHK_Movie_publication_year check (publication_year >= 1890 and publication_year <= year(getdate())),
	constraint CHK_MOVIE_price check (price > 0), -- NOTHING FOR FREE
	constraint FK_Movie_previous_part 
		foreign key (previous_part) references Movie(movie_id) 
		on update no action 
		on delete no action
)

/*******************************************************************************************
	Movie_Genre
*******************************************************************************************/

create table Movie_Genre (
	movie_id	int				not null, 
	genre_name	varchar(255)	not null,

	constraint PK_Movie_Genre primary key (movie_id, genre_name),
	
	constraint FK_Movie_Genre_genre_name 
		foreign key (genre_name) references Genre(genre_name) 
		on update cascade 
		on delete cascade,

	constraint FK_Movie_Genre_movie_id 
		foreign key (movie_id) references Movie(movie_id) 
		on update cascade 
		on delete cascade
)

/*******************************************************************************************
	Payment	
*******************************************************************************************/

create table Payment	(
	payment_method		varchar(10)		not null,
	constraint PK_Payment primary key (payment_method)
)

/*******************************************************************************************
	Contract
*******************************************************************************************/

create table Contract_ (
	contract_type		varchar(10)		not null,
	price_per_month		numeric(5, 2)	not null,
	discount_percentage	numeric(2)		not null,

	constraint PK_Contract_ primary key (contract_type)
)

/*******************************************************************************************
	Country
*******************************************************************************************/

create table Country (
	country_name	varchar(50)	not null,
	constraint PK_Country primary key (country_name)
)

/*******************************************************************************************
	Person
*******************************************************************************************/

create table Person (
	person_id	int				not null,
	lastname	varchar(50)		not null,
	firstname	varchar(50)		not null,
	gender		char(1)			null

	constraint PK_Person primary key (person_id)

	constraint CHK_Person check (gender = 'F' or gender = 'M')
)

/*******************************************************************************************
	Movie_Cast
*******************************************************************************************/

create table Movie_Cast (
	movie_id	int				not null,
	person_id	int				not null,
	role_		varchar(255)	not null,

	constraint PK_Movie_Cast primary key (movie_id, person_id, role_),

	constraint FK_Movie_Cast_person_id 
		foreign key(person_id) references Person(person_id) 
		on update cascade 
		on delete cascade,

	constraint FK_Movie_Cast_movie_id 
		foreign key(movie_id) references Movie(movie_id) 
		on update cascade 
		on delete cascade
)

/*******************************************************************************************
	Movie_Directors
*******************************************************************************************/

create table	Movie_Directors (
	movie_id	int		not null,
	person_id	int		not null,

	constraint PK_Movie_Directors primary key (movie_id, person_id),

	constraint FK_Movie_directors_person_id 
		foreign key(person_id) references Person(person_id) 
		on update cascade 
		on delete cascade,

	constraint FK_Movie_Directors_movie_id 
		foreign key(movie_id) references Movie(movie_id) 
		on update cascade 
		on delete cascade
)

/*******************************************************************************************
	Customer
*******************************************************************************************/

create table Customer(
	customer_mail_address	varchar(255)	not null,
	lastname				varchar(50)		not null,
	firstname				varchar(50)		not null,
	payment_method			varchar(10)		not null,
	payment_card_number		varchar(30)		not null,
	contract_type			varchar(10)		not null,
	subscription_start		date			not null,
	subscription_end		date			null,
	user_name_				varchar(30)		not null	unique,
	password_				varchar(50)		not null,
	country_name			varchar(50)		not null,
	gender					char(1)			null,
	birth_date				date			null,

	constraint PK_Customer primary key (customer_mail_address),
	constraint CHK_Customer_subscription check (subscription_start < subscription_end), --Subscription end moet na de subscription start zijn
	constraint CHK_Customer_mail_address check (customer_mail_address LIKE '%@%.%'), --moet @ en . bevatten
	constraint CHK_Customer_password check (len(password_) >= 8), --password moet 8 tekens of langer zijn
	
	constraint FK_Customer_payment_method
		foreign key (payment_method) references Payment(payment_method)
		on update cascade 
		on delete cascade,

	constraint FK_Customer_contract_type 
		foreign key (contract_type) references Contract_(contract_type) 
		on update cascade 
		on delete cascade,

	constraint FK_Customer_country_name 
		foreign key (country_name) references Country(country_name) 
		on update cascade 
		on delete cascade
)

/*******************************************************************************************
	WatchHistory
*******************************************************************************************/

create table WatchHistory	(
	movie_id				int				not null,
	customer_mail_address	varchar(255)	not null,
	watch_date				date			not null,
	price					numeric(5, 2)	not null,
	invoiced				bit				not null,

	constraint PK_WatchHistory primary key (movie_id, customer_mail_address, watch_date),
	--constraint van watch_date staat in test script
	constraint FK_Watchhistory_movie_id 
		foreign key (movie_id) references Movie(movie_id)
		on update cascade
		on delete no action,

	constraint FK_WatchHistory_customer_mail_address
		foreign key (customer_mail_address) references Customer(customer_mail_address)
		on update cascade
		on delete no action
)

/*******************************************************************************************
	Functies die worden gebruikt in constraint van Watchhistorie
*******************************************************************************************/
go
create function datumTussen(@min date, @max date, @value date)
returns bit
begin
	return IIF(@value >= @min and @value <= @max, 1, 0) --als waar return 1, anders 0
end
go 

go
--Is watchdate tussen subsrctiption start en subscription end
create function isWatchDateValid(@watch_date date, @mail varchar(255))
returns bit
begin
	return dbo.datumTussen((select subscription_start from Customer where customer_mail_address = @mail), 
		(select subscription_end from Customer where customer_mail_address = @mail),
		@watch_date)
end
go
/*******************************************************************************************
	Voeg watchdate constraint toe aan watchHistory
*******************************************************************************************/
alter table WatchHistory
	add constraint chk_WatchHistory_watchDate check (dbo.isWatchDateValid(watch_date, customer_mail_address) = 1) 