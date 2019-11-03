USE FLETNIX_DOCENT
go

create view GenreHistory as
select m.title, W.invoiced, W.watch_date, W.price, MG.genre_name, c.country_name
from movie as m inner join Watchhistory as w on m.movie_id = w.movie_id
inner join Movie_Genre as MG on M.movie_id = MG.movie_id
inner join customer as c on C.customer_mail_address = w.customer_mail_address 
go
--select top 50 * from GenreHistory order by NEWID()

--drop view GenreHistory
go
create view groeiCustomers as
	select year(subscription_start) as year, country_name, contract_type/*, cout(*) werkt*/ from Customer
		group by year(subscription_start), country_name, contract_type
		--order by count(*) desc werkt
		--drop view groeiCustomers
go		