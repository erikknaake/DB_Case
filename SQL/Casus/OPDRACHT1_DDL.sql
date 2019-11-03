create database FletNix

use FletNix

create table Movie_Genre (
	movie_id	int				not null, 
	genre_name	varchar(255)	not null
)

create table Genre	(
	genre_name		varchar(255)	not null,
	description_	varchar(255)	null
)

create table Movie	(
	movie_id		int				not null,
	title			varchar(255)	not null,
	duration		int				null,
	description_	varchar(255)	null,
	publication_year	int			null,
	cover_image		varchar(255)	null,
	previous_part	int				null,
	price			numeric(5, 2)	not null,
	URL_			varchar(255)	null
)


create table WatchHistory	(
	movie_id				int				not null,
	customer_mail_address	varchar(255)	not null,
	watch_date				date			not null,
	price					numeric(5, 2)	not null,
	invoiced				bit				not null
)

create table Customer(
	customer_mail_address	varchar(255)	not null,
	lastname				varchar(50)		not null,
	firstname				varchar(50)		not null,
	payment_method			varchar(10)		not null,
	payment_card_number		varchar(30)		not null,
	contract_type			varchar(10)		not null,
	subscription_start		date			not null,
	subscription_end		date			null,
	user_name				varchar(30)		not null,
	password_				varchar(50)		not null,
	country_name			varchar(50)		not null,
	gender					char(1)			null,
	birth_date				date			null
)

create table Payment	(
	payment_method		varchar(10)		not null
)

create table Contract_ (
	contract_type		varchar(10)		not null,
	price_per_month		numeric(5, 2)	not null,
	discount_percentage	numeric(2)		not null
)

create table Country (
	country_name	varchar(50)	not null
)

create table Movie_Cast (
	movie_id	int				not null,
	person_id	int				not null,
	role_		varchar(255)	not null
)

create table	Moevie_Directors (
	movie_id	int		not null,
	person_id	int		not null
)

create table Person (
	person_id	int				not null,
	lastname	varchar(50)		not null,
	firstname	varchar(50)		not null,
	gender		char(1)			null
)
